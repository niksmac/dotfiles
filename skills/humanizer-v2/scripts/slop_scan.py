#!/usr/bin/env python3
"""Scan prose for candidate AI-slop tells (humanizer-v2 skill).

Every hit is a lead to confirm in context, not a verdict. Literal and
technical uses, quotations, and deliberate style are not slop. Pattern IDs
match references/patterns.md. Standard library only.

  python3 slop_scan.py post.md             # text report
  python3 slop_scan.py --json post.md      # machine-readable
  pbpaste | python3 slop_scan.py           # stdin (or '-')
  python3 slop_scan.py --quotes post.md    # also scan blockquotes and "quoted" spans
"""

import argparse
import bisect
import json
import re
import statistics
import sys
from collections import Counter

HARD, STRONG, WEAK = "hard", "strong", "weak"
SIGNAL_ORDER = {HARD: 0, STRONG: 1, WEAK: 2}


def rx(*parts, flags=re.IGNORECASE):
    return re.compile("|".join(f"(?:{p})" for p in parts), flags)


def words_rx(words, flags=re.IGNORECASE):
    return re.compile(r"\b(?:" + "|".join(words) + r")\b", flags)


# (id, label, signal, regex). Ordered roughly by how certain the tell is.
PHRASES = [
    ("R1", "chatbot residue", HARD, rx(
        r"\bI hope this helps\b", r"\blet me know if\b", r"\bwould you like me to\b",
        r"\bwant me to\b[^.?!]*\?", r"\bshould I continue\b", r"\bhappy to help\b",
        r"\bI'?d be happy to\b", r"\bgreat question\b", r"(?:^|[.!?]\s+)(?:Certainly|Of course|Absolutely)!",
        r"\byou'?re absolutely right\b", r"\bas an AI\b", r"\bas a (?:large )?language model\b",
        r"\bhere(?:'s| is) (?:a|an|the|your) (?:revised|updated|rewritten|polished|draft|overview|summary|version|breakdown)\b",
    )),
    ("R2", "knowledge-limit disclaimer", HARD, rx(
        r"\bas of my (?:last|latest) (?:training|knowledge|update)\b", r"\bknowledge cut-?off\b",
        r"\bup to my last (?:training )?update\b", r"\bbased on (?:the )?available information\b",
        r"\bwhile (?:specific )?details (?:are|remain) (?:limited|scarce)\b",
        r"\bnot (?:widely|extensively|publicly|readily) (?:documented|available|disclosed)\b",
        r"\bin the (?:provided|available) sources\b", r"\bmaintains a low profile\b",
        r"\bI (?:don'?t|do not) have (?:access to )?real-time\b", r"\bit is believed that\b",
    )),
    ("R3", "placeholder or reasoning leak", HARD, rx(
        r"\[(?:insert|your|company|product|brand|name|date|link|url|author|topic|industry|number|client|customer|city)\b[^\]]*\](?!\()",
        r"\blorem ipsum\b", r"\blet me think (?:step by step|about this)\b",
        r"\bhere'?s my (?:thought|reasoning) process\b",
    )),
    ("R3", "placeholder in caps", HARD, re.compile(r"\[[A-Z][A-Z0-9 _/-]{2,}\](?!\()")),
    ("R4", "writing about the document", STRONG, rx(
        r"\bthe (?:table|list|chart|diagram|section)s? below (?:shows?|compares?|lists?|outlines?|summari[sz]es?)\b",
        r"\bthis (?:section|document|guide) is organi[sz]ed\b", r"\banything unconfirmed is flagged\b",
        r"\b(?:compiled|generated) from (?:the )?(?:provided|available)\b",
    )),
    ("T15", "cliched opening", HARD, rx(
        r"\bin today'?s (?:fast-paced|digital|ever-changing|rapidly (?:evolving|changing)|modern|competitive|hyper-connected|data-driven)\b",
        r"\bin the (?:dynamic|ever-evolving|ever-changing|fast-paced|rapidly evolving) (?:world|landscape|realm|field) of\b",
        r"\bas the world continues to (?:evolve|change)\b", r"\bin an (?:era|age) (?:defined by|of|where)\b",
        r"\bin today'?s world\b", r"\bit'?s no secret that\b", r"\bnow more than ever\b",
    )),
    ("T2", "negative listing (No X. No Y. Just Z.)", HARD, rx(
        r"\bNo [^.!?\n]{1,30}\.\s+No [^.!?\n]{1,30}\.\s+(?:Just|Only)\b",
        r"\bNot (?:a|an|for) [^.!?\n]{1,30}\.\s+Not (?:a|an|for) [^.!?\n]{1,30}\.",
    )),
    ("T6", "signposting or throat-clearing", STRONG, rx(
        r"\blet'?s (?:dive|delve|explore|unpack|break (?:this|it) down|take a (?:closer )?look|get started|be (?:honest|real))\b",
        r"\bhere'?s what you need to know\b", r"\bwithout further ado\b",
        r"\bhere'?s the (?:thing|deal|kicker|catch|truth)\b", r"\bthe (?:uncomfortable|hard|simple|honest) truth is\b",
        r"\blet me be clear\b", r"\bI'?ll be honest\b", r"\breal talk\b", r"\bhot take\b",
        r"\band honestly\?", r"\bthe thing is,", r"(?:^|[.!?]\s+)Look, ", r"\bheads up:", r"\bquick note:",
    )),
    ("T7", "faux-insight setup", STRONG, rx(
        r"\bwhat (?:most|many) people (?:get wrong|miss|don'?t (?:realize|know|understand|see))\b",
        r"\bhere'?s what (?:nobody|no one) (?:tells you|talks about)\b",
        r"\bthe part (?:most people|everyone) (?:skips?|miss(?:es)?)\b",
        r"\bthis is the part (?:most people|everyone)\b", r"\bmost people don'?t realize\b",
    )),
    ("T8", "emphasis crutch", STRONG, rx(
        r"\blet that sink in\b", r"\bread that again\b", r"\bfull stop\.", r"\bmake no mistake\b",
        r"\bthis cannot be overstated\b", r"\bthe stakes (?:are|have never been) (?:real|higher|high)\b",
        r"\bthe struggle is real\b", r"\bevery\. single\. \w+\.",
    )),
    ("T12", "interpretive metadiscourse", STRONG, rx(
        r"\bthis distinction matters\b", r"\bthat last part matters\b",
        r"\bthat'?s (?:the|what) (?:key|real|important|crucial) (?:point|part|win|unlock|lesson)\b",
        r"\bthe key (?:point|takeaway|insight|lesson) (?:is|here)\b", r"\bas you can see\b",
        r"\bit'?s worth (?:noting|mentioning|pointing out)\b", r"\bit is (?:important|worth) (?:to note|noting|mentioning)\b",
        r"\bit'?s important to (?:note|remember|understand)\b", r"\bit should be noted\b",
        r"\bneedless to say\b", r"\bit goes without saying\b",
    )),
    ("T9", "deep-sounding saying", STRONG, rx(
        r"\bthe real question is\b", r"\bat its core\b", r"\bwhat (?:really|truly) matters\b",
        r"\bthe (?:deeper|real) (?:issue|problem) is\b", r"\bthe heart of the matter\b",
        r"\bis not (?:a|just a) tool,? but a\b", r"\bthe (?:currency|language|architecture) of (?:trust|growth|change|success)\b",
    )),
    ("T10", "inspirational pivot", STRONG, rx(
        r"\b(?:this|it) (?:isn'?t|is not|wasn'?t) (?:just|only|really|merely) about\b",
        r"\bit'?s bigger than\b", r"\bwhat this is (?:really|truly) about\b",
    )),
    ("T11", "aphorism kicker", STRONG, rx(
        r"\bat the end of the day\b", r"\band that'?s (?:the point|what matters|the whole point)\b",
        r"\bthat'?s what (?:it'?s all about|really matters|matters most)\b", r"\bis what truly matters\b",
        r"\bbecause that'?s what [^.!?]{1,40} is (?:really|all) about\b", r"\bwhen all is said and done\b",
    )),
    ("T1", "not X but Y", STRONG, rx(
        r"\bnot (?:just|only|merely|simply) [^.;!?\n]{1,60}?,? but (?:also )?\b",
        r"\b(?:it'?s|this is|they'?re|that'?s) not (?:a |an |the |just |only |about )?[^.;!?\n]{1,40}?(?:[,;]| [—–-]{1,2}) ?(?:it'?s|they'?re|it is|but)\b",
        r"\b(?:isn'?t|aren'?t|wasn'?t) (?:just |only |about )?[^.;!?\n]{1,40}?\.\s+(?:It'?s|They'?re|It is|That'?s|It was)\b",
        r"\bnot because [^.!?\n]{1,60}\.\s+because\b", r"\bthis (?:doesn'?t|does not) mean [^.!?\n]{1,60}\.\s+it means\b",
        r"\bthe (?:question|problem|issue) isn'?t [^.!?\n]{1,40}\.\s+It'?s\b",
    )),
    ("T3", "arguing with no one", STRONG, rx(
        r"\bI'?m not saying\b", r"\bdon'?t get me wrong\b", r"(?:^|[.!?]\s+)To be clear,", r"\bthis is not to say\b",
        r"\b(?:some|many) (?:might|may|would) (?:say|argue|think)\b", r"\byou might (?:think|be tempted)\b",
        r"\bone might be tempted\b", r"\bit would be easy to (?:just )?\w+", r"\ba tempting approach\b",
    )),
    ("T5", "colon or question reveal", STRONG, rx(
        r"(?:^|[.!?]\s+)(?:The (?:result|best part|catch|kicker|answer|truth|twist|secret|upshot|verdict|difference|takeaway)|Here'?s (?:how|why|what|the thing)|Plot twist|Think about it|Sound familiar|Why does (?:this|that|it) matter|What changed|So what happened|The bottom line)\s*[:?]",
    )),
    ("T13", "hook formula", STRONG, rx(
        r"\b(?:picture|imagine) this\b", r"\bwe'?ve all been there\b", r"\braise your hand if\b",
        r"\bever wondered (?:why|how|what)\b", r"\bwhat if I told you\b",
    )),
    ("T14", "audience-range opener", STRONG, rx(r"\bwhether you'?re (?:a|an) [^,.;\n]{1,40}? or (?:a|an )?")),
    ("S1", "significance puffery", STRONG, rx(
        r"\bstands as\b", r"\bserves as a (?:testament|reminder|beacon)\b", r"\ba testament to\b",
        r"\b(?:a|the) (?:pivotal|crucial|key|vital|significant) (?:role|moment|turning point|step|milestone)\b",
        r"\bunderscores (?:its|the) (?:importance|significance)\b", r"\breflects (?:a )?broader\b",
        r"\b(?:enduring|lasting|indelible) (?:legacy|mark|impact)\b", r"\bsetting the stage for\b",
        r"\bmarking a (?:shift|turning point|new era)\b", r"\b(?:evolving|ever-evolving|changing) landscape\b",
        r"\bfocal point\b", r"\bdeeply rooted\b", r"\brich (?:tapestry|mosaic|heritage)\b", r"\bspeaks volumes\b",
        r"\bpav(?:es|ed|ing) the way\b", r"\bgame[- ]changer\b", r"\bthis changes everything\b",
        r"\braises the bar\b", r"\bat the forefront of\b", r"\bcornerstone of\b", r"\bshed(?:s|ding)? light on\b",
        r"\bparadigm shift\b", r"\bfundamental shift\b", r"\bnew era\b",
    )),
    ("S4", "promotional language", STRONG, words_rx([
        "nestled", r"in the heart of", r"boasts (?:a|an|over)", "breathtaking", "must-visit", "stunning",
        "world-class", "best-in-class", "state-of-the-art", "cutting-edge", "next-level", "groundbreaking",
        "renowned", "hidden gem", "bustling", "picturesque", r"seamless(?:ly)?", r"revolutioni[sz](?:e|es|ed|ing)",
        r"supercharg(?:e|es|ed|ing)", "unparalleled", "unmatched", "transformative", "game-changing",
    ])),
    ("S6", "artificial enthusiasm", STRONG, rx(
        r"\b(?:we'?re|I'?m|we are|I am) (?:so )?(?:thrilled|excited|delighted|proud) to (?:announce|share|introduce|unveil)\b",
        r"\b(?:exciting|incredible|amazing) (?:opportunity|developments|news|times)\b",
    )),
    ("I2", "vague attribution", STRONG, rx(
        r"\bstudies (?:show|suggest|have shown|prove)\b", r"\bresearch (?:shows|suggests|indicates|proves|has shown)\b",
        r"\bexperts (?:agree|argue|say|believe|warn)\b", r"\b(?:industry|recent) reports (?:suggest|show|indicate)\b",
        r"\b(?:observers|analysts|critics) (?:have )?(?:noted|cited|argue|predict|say)\b",
        r"\b(?:is |are )?widely (?:regarded|considered|believed|recognized)\b", r"\bmany (?:believe|argue|experts)\b",
        r"\baccording to (?:industry )?(?:insiders|experts)\b", r"\bdata shows\b(?! that \w+ \()",
    )),
    ("S5", "challenges-and-outlook formula", STRONG, rx(
        r"\bdespite (?:these|its|the|such) challenges\b", r"\bfaces? (?:several|many|numerous|significant) challenges\b",
        r"\bcontinues? to thrive\b", r"\bfuture (?:outlook|prospects)\b", r"\bchallenges and (?:legacy|opportunities)\b",
    )),
    ("Y8", "recap ending or bolted-on CTA", STRONG, rx(
        r"\bin conclusion\b", r"\bin summary\b", r"\bto summari[sz]e\b", r"\bto sum (?:it )?up\b",
        r"\bthe future (?:looks|is) bright\b", r"\bexciting times (?:lie )?ahead\b", r"\ba step in the right direction\b",
        r"\bready to (?:get started|transform|take|level up|unlock)[^?\n]*\?", r"\b(?:sign up|get started|try it|start) (?:today|now)!",
    )),
    ("Y7", "table-of-contents intro", STRONG, rx(
        r"\bin this (?:post|article|guide|blog post|tutorial),? (?:we'?ll|we will|I'?ll|I will|you'?ll)\b",
        r"\bby the end of this (?:post|article|guide)\b", r"\bhere'?s what we'?ll cover\b",
    )),
    ("W3", "copula avoidance", STRONG, rx(
        r"\b(?:serves|stands|functions|operates|acts) as (?:a|an|the)\b", r"\b(?:boasts|features) (?:a|an)\b",
    )),
    ("S3", "shallow -ing tail", STRONG, rx(
        r",\s+(?:highlighting|underscoring|emphasi[sz]ing|ensuring|reflecting|symboli[sz]ing|contributing to|cultivating|fostering|encompassing|showcasing|demonstrating|solidifying|cementing|paving the way|signal(?:l)?ing|making it|allowing for|enabling|empowering)\b",
    )),
    ("W1", "AI vocabulary (strong list)", STRONG, words_rx([
        r"delv(?:e|es|ed|ing)", "tapestry", "testament", "multifaceted", r"meticulous(?:ly)?", "intricate",
        "intricacies", "interplay", r"underscor(?:e|es|ed|ing)", r"garner(?:s|ed|ing)?", "paramount", "pivotal",
        "realm", "beacon", r"embark(?:s|ed|ing)?", r"elevat(?:e|es|ed|ing)", r"empower(?:s|ed|ing|ment)?",
        r"bolster(?:s|ed|ing)?", "burgeoning", "ever-evolving", r"showcas(?:e|es|ed|ing)",
        r"foster(?:s|ed|ing)?", r"resonat(?:e|es|ed|ing) with", "synergy", "synergies", "deep dive",
    ])),
    ("W1", "AI vocabulary (context list)", WEAK, words_rx([
        "crucial", "vital", "landscape", r"leverag(?:e|es|ed|ing)", "robust", "seamless", r"navigat(?:e|es|ing)",
        "journey", r"enhanc(?:e|es|ed|ing)", r"streamlin(?:e|es|ed|ing)", r"facilitat(?:e|es|ed|ing)",
        r"harness(?:es|ed|ing)?", "comprehensive", "holistic", "dynamic", "innovative", "nuanced", "myriad",
        "plethora", "moreover", "furthermore", "additionally", "ecosystem", "quietly", "vibrant", "valuable",
        "enduring", "profound", r"unlock(?:s|ed|ing)?", r"align(?:s|ed)? with", "actionable", "scalable",
    ])),
    ("W2", "business jargon or stock idiom", WEAK, rx(
        r"\bmove the needle\b", r"\blow-hanging fruit\b", r"\bcircle back\b", r"\btouch base\b",
        r"\b(?:stay|get) ahead of the curve\b", r"\bsecret sauce\b", r"\brecipe for disaster\b",
        r"\b(?:ship|build|scale|deploy) with confidence\b", r"\bpeace of mind\b", r"\bbest practices\b",
        r"\btake (?:it|your [\w-]+(?: [\w-]+)?) to the next level\b", r"\bdrive (?:growth|value|results|engagement)\b",
        r"\bunlock (?:value|potential|growth|new possibilities)\b", r"\bsynerg(?:y|ies|istic)\b", r"\bthought leadership\b",
        r"\bvalue proposition\b", r"\bend-to-end solution\b", r"\bsingle source of truth\b(?! for)",
    )),
    ("W8", "register mismatch word", STRONG, words_rx([
        "aforementioned", "henceforth", "whereby", "therein", "pertaining to", "notwithstanding",
        r"utili[sz](?:e|es|ed|ing|ation)", "in lieu of", "heretofore",
    ])),
    ("W4", "empty intensifier", WEAK, words_rx([
        "truly", "deeply", "fundamentally", "inherently", "incredibly", "literally", "essentially", "genuinely",
        "undeniably", "remarkably", "profoundly",
    ])),
    ("I5", "overclaim", WEAK, rx(
        r"\buniversally\b", r"\beveryone knows\b", r"\bwithout (?:a|any) doubt\b", r"\bunquestionably\b",
        r"\bit'?s clear that\b", r"\bthe only way\b", r"\bguarantee[sd]?\b", r"\bnever been (?:easier|more important)\b",
    )),
    ("W6", "opening hedge", STRONG, rx(
        r"(?:^|[.!?]\s+)(?:It should be noted that|It'?s worth mentioning that|Of course, |Naturally, |Generally speaking, |For the most part, )",
    )),
    ("W6", "stacked hedge", WEAK, rx(
        r"\bcould potentially\b", r"\bmight (?:possibly|arguably|potentially)\b", r"\bmay potentially\b",
        r"\bit could be argued\b", r"\bin some cases,? it may\b", r"\bto some extent\b",
        r"\bin (?:many|most) (?:cases|instances|scenarios)\b", r"\bthis may vary depending on\b",
    )),
    ("W5", "filler phrase", WEAK, rx(
        r"\bin order to\b", r"\bdue to the fact that\b", r"\bat this point in time\b", r"\bin the event that\b",
        r"\bha(?:s|ve) the ability to\b", r"\bwhen it comes to\b", r"\bin terms of\b", r"\bwith regards? to\b",
        r"\bgoing forward\b", r"\ba wide (?:range|variety|array) of\b", r"\bdiverse array\b",
    )),
    ("W7", "vague connection", WEAK, rx(
        r"\b(?:is|are|was|were) (?:closely )?(?:associated|connected|linked|tied) (?:with|to)\b", r"\bin (?:association|connection) with\b",
    )),
    ("W10", "double adjective", WEAK, rx(
        r"\b(?:seamless and intuitive|robust and scalable|clear and concise|fast and reliable|safe and secure|quick and easy|actionable and comprehensive|powerful and flexible|simple and intuitive|fast and efficient)\b",
        r"\b\w+ yet (?:powerful|elegant|effective|intuitive|flexible)\b",
    )),
    ("Y10", "subjectless fragment", WEAK, rx(r"(?:^|[.!?]\s+)No [\w-]+(?: [\w-]+)? (?:needed|required)\.")),
]

TRIAD = re.compile(r"\b[\w'-]+(?:\s[\w'-]+){0,2},\s[\w'-]+(?:\s[\w'-]+){0,2},?\s(?:and|or)\s[\w'-]+")
EMOJI = re.compile("[\U0001F300-\U0001FAFF\U0001F000-\U0001F2FF☀-➿⭐⭕]")
SMALL_WORDS = set("a an the and but or nor for so yet of to in on at by with from as vs via into over per is are be".split())
HEADLINE = re.compile(
    r"^(?:unlock(?:ing)?|elevat(?:e|ing)|master(?:ing)?|supercharg(?:e|ing)|harness(?:ing)?|demystif(?:y|ying)|navigat(?:e|ing)|the ultimate guide|everything you need to know|the power of)\b"
    r"|:\s*from [^:]+ to |\bthe ultimate guide\b|\bunlocking the power\b", re.IGNORECASE)
GENERIC_HEADING = re.compile(
    r"^(?:introduction|conclusion|final thoughts|key takeaways|overview|summary|wrapping up|tl;?dr|in conclusion|closing thoughts)\s*:?$",
    re.IGNORECASE)
CONNECTIVES = {"additionally", "moreover", "furthermore", "ultimately", "importantly", "notably", "overall", "crucially", "interestingly"}
LIST_MARK = re.compile(r"^\s*(?:[-*+]|\d+[.)])\s+")
SENT_SPLIT = re.compile(r"(?<=[.!?])[\"'”’)\]]*\s+(?=[\"'“‘(\[]?[A-Z0-9])")


def mask(text, keep_quotes):
    """Return (prose, scan) lists of lines. Non-prose lines become ''.

    prose keeps quoted spans (for punctuation stats); scan also blanks
    "quoted" spans unless keep_quotes, so mentions of a phrase aren't hits.
    """
    prose, scan = [], []
    in_fm = in_code = in_comment = False
    fence = ""
    for i, line in enumerate(text.splitlines()):
        s = line.strip()
        blank = False
        if i == 0 and s == "---":
            in_fm = blank = True
        elif in_fm:
            in_fm = s not in ("---", "...")
            blank = True
        else:
            m = re.match(r"^\s*(`{3,}|~{3,})", line)
            if m and not in_code:
                in_code, fence, blank = True, m.group(1), True
            elif in_code:
                if s.startswith(fence) and set(s) <= set(fence[0]):
                    in_code = False
                blank = True
            elif in_comment:
                in_comment = "-->" not in line
                blank = True
            elif "<!--" in line and "-->" not in line:
                in_comment = blank = True
            elif re.match(r"^\s*(?:import|export)\s", line):
                blank = True
            elif not keep_quotes and re.match(r"^\s*>", line):
                blank = True
        if blank:
            prose.append("")
            scan.append("")
            continue
        line = re.sub(r"^\s*>\s?", "", line)
        line = re.sub(r"<!--.*?-->", "", line)
        line = re.sub(r"`[^`]*`", "CODE", line)
        line = re.sub(r"!\[[^\]]*\]\([^)]*\)", " ", line)
        line = re.sub(r"\]\([^)]*\)", "]", line)
        line = re.sub(r"<https?://[^>]+>|https?://\S+", "URL", line)
        line = re.sub(r"</?[A-Za-z][^>]*>", " ", line)
        prose.append(line)
        if not keep_quotes:
            line = re.sub(r"\"[^\"\n]{1,120}\"|“[^”\n]{1,120}”", lambda m: " " * len(m.group(0)), line)
        scan.append(line)
    return prose, scan


def blocks(lines):
    """Group lines into blocks: heading, item, table or para.

    Each block: {kind, line, text, offsets} where offsets[i] is the char
    offset in text at which source line lines_[i] starts.
    """
    out, cur = [], None

    def flush():
        nonlocal cur
        if cur:
            out.append(cur)
        cur = None

    for n, raw in enumerate(lines, 1):
        s = raw.strip()
        if not s:
            flush()
            continue
        if re.match(r"^#{1,6}\s", s):
            flush()
            out.append({"kind": "heading", "line": n, "text": re.sub(r"^#{1,6}\s+", "", s).strip("# "), "offsets": [(0, n)]})
            continue
        if s.startswith("|"):
            flush()
            if not re.match(r"^\|[\s:|-]+\|?$", s):
                out.append({"kind": "table", "line": n, "text": s.strip("|"), "offsets": [(0, n)]})
            continue
        if re.match(r"^(?:-{3,}|\*{3,}|_{3,})$", s):
            flush()
            out.append({"kind": "rule", "line": n, "text": "", "offsets": [(0, n)]})
            continue
        if LIST_MARK.match(raw):
            flush()
            cur = {"kind": "item", "line": n, "text": LIST_MARK.sub("", raw).strip(), "offsets": [(0, n)]}
            continue
        if cur is None:
            cur = {"kind": "para", "line": n, "text": s, "offsets": [(0, n)]}
        else:
            cur["offsets"].append((len(cur["text"]) + 1, n))
            cur["text"] += " " + s
    flush()
    return out


def line_at(block, pos):
    starts = [o for o, _ in block["offsets"]]
    return block["offsets"][max(0, bisect.bisect_right(starts, pos) - 1)][1]


def snippet(text, start, end, width=90):
    a = max(0, start - 20)
    b = min(len(text), max(end + 20, a + 40))
    s = text[a:b].strip()
    if len(s) > width:
        s = s[: width - 1] + "…"
    return ("…" if a > 0 else "") + s + ("…" if b < len(text) else "")


def sentences(text):
    return [s.strip() for s in SENT_SPLIT.split(text) if s.strip()]


def wc(text):
    return len(re.findall(r"[A-Za-z0-9][\w'’-]*", text))


def is_title_case(h):
    words = re.findall(r"[A-Za-z][A-Za-z'’-]*", h)
    big = [w for w in words if w.lower() not in SMALL_WORDS]
    if len(big) < 3 or all(w.isupper() for w in big):
        return False
    return all(w[0].isupper() for w in big)


def scan(text, keep_quotes=False):
    prose_lines, scan_lines = mask(text, keep_quotes)
    pblocks, sblocks = blocks(prose_lines), blocks(scan_lines)
    hits = []

    def add(pid, label, signal, line, match, detail=""):
        hits.append({"id": pid, "label": label, "signal": signal, "line": line, "match": match, "detail": detail})

    # Phrase patterns.
    for b in sblocks:
        if b["kind"] == "rule":
            continue
        for pid, label, signal, pat in PHRASES:
            for m in pat.finditer(b["text"]):
                add(pid, label, signal, line_at(b, m.start()), snippet(b["text"], m.start(), m.end()))

    # Document statistics from prose (quotes kept).
    paras = [b for b in pblocks if b["kind"] == "para"]
    body = [b for b in pblocks if b["kind"] in ("para", "item", "table")]
    words = sum(wc(b["text"]) for b in body)
    sents = []  # (block, sentence)
    for b in pblocks:
        if b["kind"] in ("para", "item"):
            sents.extend((b, s) for s in sentences(b["text"]))
    lengths = [wc(s) for _, s in sents if wc(s) > 0]
    per_k = (lambda n: round(n * 1000 / words, 1)) if words else (lambda n: 0.0)
    stats = {"words": words, "sentences": len(lengths), "paragraphs": len(paras)}

    # F1 em dashes.
    dash_re = re.compile(r"—|\s–\s|\s--\s")
    dashes = 0
    for b in body:
        n = len(dash_re.findall(b["text"]))
        dashes += n
        if n >= 2:
            add("F1", "em dash cluster", WEAK, b["line"], snippet(b["text"], 0, 60), f"{n} dashes in one paragraph")
    stats["em_dashes"] = dashes
    stats["em_dashes_per_1000"] = per_k(dashes)
    for b in body:
        for m in re.finditer(r"\b(?:isn'?t|not|aren'?t)\b[^—.!?]{1,40}\s?—\s?(?:it'?s|they'?re|it is)\b", b["text"], re.IGNORECASE):
            add("F1", "reveal dash (not X — it's Y)", STRONG, line_at(b, m.start()), snippet(b["text"], m.start(), m.end()))

    # F7 curly quotes, F8 exclamations, F6 emoji, F2/F3 bold, headings.
    curly = sum(len(re.findall("[“”]", b["text"])) for b in pblocks)
    straight = sum(b["text"].count('"') for b in pblocks)
    stats["curly_quotes"], stats["straight_quotes"] = curly, straight
    if curly and straight:
        add("F7", "mixed curly and straight quotes", WEAK, 0, f"{curly} curly, {straight} straight")
    for b in pblocks:
        if b["kind"] in ("para", "item") and re.search(r"!(?![=\[])", b["text"]):
            add("F8", "exclamation mark in body", WEAK, b["line"], snippet(b["text"], b["text"].index("!"), b["text"].index("!") + 1))
        for m in EMOJI.finditer(b["text"]):
            sig = STRONG if b["kind"] in ("heading", "item") else WEAK
            add("F6", f"emoji in {b['kind']}", sig, line_at(b, m.start()), snippet(b["text"], m.start(), m.end()))
            break
    bold_items = []
    bold_total = 0
    lead_bold = re.compile(r"^\s*(?:(?:[-*+]|\d+[.)])\s+)?(?:\*\*|__)[^*_\n]+?(?:\*\*|__)")
    for n, raw in enumerate(prose_lines, 1):
        if re.match(r"^\s*(?:[-*+]|\d+[.)])\s+(?:\*\*|__)[^*_]+?(?::(?:\*\*|__)|(?:\*\*|__)\s*[:—–-])", raw):
            bold_items.append(n)
        if not raw.lstrip().startswith("#"):
            bold_total += len(re.findall(r"\*\*[^*\n]+\*\*|__[^_\n]+__", lead_bold.sub("", raw)))
    if len(bold_items) >= 3:
        add("F3", "bold-label list items", WEAK, bold_items[0], f"{len(bold_items)} items",
            "fine in reference lists; a tell when each item is a sentence restating its label")
    stats["bold_label_items"] = len(bold_items)
    stats["bold_spans_mid_text"] = bold_total
    if words and bold_total * 100 / words > 1.5:
        add("F2", "dense mid-text boldface", WEAK, 0, f"{bold_total} bold spans in {words} words")
    for b in pblocks:
        if b["kind"] != "heading":
            continue
        h = re.sub(r"\*\*|__", "", b["text"])
        if is_title_case(h):
            add("F4", "title case heading", WEAK, b["line"], h)
        if HEADLINE.search(h):
            add("F5", "headline formula", STRONG, b["line"], h)
        if GENERIC_HEADING.match(h.strip()):
            add("F5", "furniture heading", WEAK, b["line"], h)

    # Y6 heading restated in a one-line paragraph before the real content.
    for i, b in enumerate(pblocks[:-2]):
        nxt, after = pblocks[i + 1], pblocks[i + 2]
        if b["kind"] == "heading" and nxt["kind"] == "para" and after["kind"] in ("para", "item"):
            ss = sentences(nxt["text"])
            hw = {w.lower()[:5] for w in re.findall(r"[A-Za-z]{4,}", b["text"])}
            pw = {w.lower()[:5] for w in re.findall(r"[A-Za-z]{4,}", nxt["text"])}
            if len(ss) == 1 and not nxt["text"].rstrip().endswith(":") and wc(nxt["text"]) <= 8 and (wc(nxt["text"]) <= 4 or hw & pw):
                add("Y6", "one-line warm-up after heading", STRONG, nxt["line"], nxt["text"][:80])

    # Y4 one-line paragraph stacks and staccato fragments.
    run = []
    for b in pblocks + [{"kind": "end"}]:
        if b["kind"] == "para" and len(sentences(b["text"])) == 1 and wc(b["text"]) <= 15:
            run.append(b)
            continue
        if b["kind"] == "rule":
            continue
        if len(run) >= 3:
            add("Y4", "one-line paragraph stack", STRONG, run[0]["line"], " / ".join(r["text"][:30] for r in run[:4]), f"{len(run)} in a row")
        run = []
    for b in pblocks:
        if b["kind"] not in ("para", "item"):
            continue
        ss, streak = sentences(b["text"]), 0
        for s in ss:
            streak = streak + 1 if 0 < wc(s) <= 4 else 0
            if streak == 3:
                add("Y4", "staccato fragments", STRONG, b["line"], snippet(b["text"], 0, 80))
                break

    # T4 question answered at once.
    for b in sblocks:
        if b["kind"] not in ("para", "item"):
            continue
        ss = sentences(b["text"])
        for a, c in zip(ss, ss[1:]):
            if a.endswith("?") and not c.endswith("?") and wc(c) <= 8 and wc(a) <= 12:
                pos = b["text"].find(a)
                add("T4", "question asked and answered", STRONG, line_at(b, max(pos, 0)), f"{a} {c}"[:90])

    # Y1 triads.
    triads = []
    for b in sblocks:
        if b["kind"] in ("para", "item"):
            triads.extend((line_at(b, m.start()), m.group(0)) for m in TRIAD.finditer(b["text"]))
    stats["triads"] = len(triads)
    stats["triads_per_1000"] = per_k(len(triads))
    if len(triads) >= 3 and per_k(len(triads)) > 6:
        add("Y1", "many lists of three", WEAK, 0, f"{len(triads)} triads, e.g. L{triads[0][0]}: {triads[0][1][:50]}",
            "flag only triads padded to three or made of abstract nouns")

    # Y2 uniform sentence length.
    if len(lengths) >= 2:
        sd = statistics.pstdev(lengths)
        mean = statistics.mean(lengths)
        stats["sentence_mean"] = round(mean, 1)
        stats["sentence_stdev"] = round(sd, 1)
        if len(lengths) >= 10 and (sd < 5 or sd / mean < 0.35):
            add("Y2", "uniform sentence length", WEAK, 0, f"mean {mean:.1f} words, stdev {sd:.1f}")

    # Y3 repeated sentence openers; Y11 connective paragraph openers.
    openers = [(b, (re.findall(r"[A-Za-z']+", s) or [""])[0].lower()) for b, s in sents if b["kind"] == "para"]
    openers = [(b, "" if o in ("code", "url") else o) for b, o in openers]
    if len(openers) >= 8:
        top, count = Counter(o for _, o in openers if o).most_common(1)[0] if any(o for _, o in openers) else ("", 0)
        stats["top_opener"] = f"{top} ({round(100 * count / len(openers))}%)"
    streak, prev = 1, None
    for b, o in openers:
        streak = streak + 1 if o and o == prev else 1
        prev = o
        if streak == 3:
            add("Y3", "same sentence opener 3x in a row", STRONG, b["line"], f"'{o.capitalize()} …' x3")
    conn = [b for b in paras if (re.findall(r"[A-Za-z]+", b["text"]) or [""])[0].lower() in CONNECTIVES]
    if len(conn) >= 2:
        for b in conn:
            add("Y11", "connective paragraph opener", WEAK, b["line"], b["text"][:60])

    # Y5 equal-length sections.
    sections, cur = [], None
    for b in pblocks:
        if b["kind"] == "heading":
            if cur is not None:
                sections.append(cur)
            cur = 0
        elif cur is not None and b["kind"] in ("para", "item", "table"):
            cur += wc(b["text"])
    if cur is not None:
        sections.append(cur)
    sections = [s for s in sections if s > 0]
    if len(sections) >= 4 and statistics.mean(sections) > 40:
        cv = statistics.pstdev(sections) / statistics.mean(sections)
        stats["section_length_cv"] = round(cv, 2)
        if cv < 0.2:
            add("Y5", "sections nearly equal length", WEAK, 0, f"{len(sections)} sections, cv {cv:.2f}")

    # Paragraph shape.
    plen = [wc(b["text"]) for b in paras]
    if len(plen) >= 2:
        stats["paragraph_stdev"] = round(statistics.pstdev(plen), 1)
    if paras:
        stats["one_sentence_paragraph_share"] = round(sum(1 for b in paras if len(sentences(b["text"])) == 1) / len(paras), 2)

    hits.sort(key=lambda h: (SIGNAL_ORDER[h["signal"]], h["line"], h["id"]))
    strong = sum(1 for h in hits if h["signal"] in (HARD, STRONG))
    stats["hard"] = sum(1 for h in hits if h["signal"] == HARD)
    stats["strong"] = sum(1 for h in hits if h["signal"] == STRONG)
    stats["weak"] = sum(1 for h in hits if h["signal"] == WEAK)
    stats["hard_strong_per_1000"] = per_k(strong)
    rate = stats["hard_strong_per_1000"] if words >= 300 else strong
    stats["lead"] = "low" if rate < 3 else "moderate" if rate <= 8 else "high"
    return hits, stats


def report(name, hits, stats):
    out = [f"slop_scan: {name}  ({stats['words']} words, {stats['sentences']} sentences, {stats['paragraphs']} paragraphs)",
           "Candidates are leads, not verdicts. Confirm each in context; weak hits count only in clusters.", ""]
    for sig in (HARD, STRONG, WEAK):
        group = [h for h in hits if h["signal"] == sig]
        if not group:
            continue
        out.append(sig.upper())
        for h in group:
            loc = f"L{h['line']}" if h["line"] else "doc"
            detail = f"  [{h['detail']}]" if h["detail"] else ""
            out.append(f"  {loc:<6}{h['id']:<5}{h['label']}: {h['match']}{detail}")
        out.append("")
    keys = ["em_dashes", "em_dashes_per_1000", "triads", "triads_per_1000", "sentence_mean", "sentence_stdev",
            "paragraph_stdev", "one_sentence_paragraph_share", "top_opener", "section_length_cv",
            "bold_label_items", "bold_spans_mid_text",
            "curly_quotes", "straight_quotes"]
    out.append("STRUCTURE")
    out.extend(f"  {k}: {stats[k]}" for k in keys if k in stats)
    out.append("")
    basis = "per 1000 words" if stats["words"] >= 300 else "total (short text)"
    out.append(f"SUMMARY  hard {stats['hard']} · strong {stats['strong']} · weak {stats['weak']} · "
               f"hard+strong {stats['hard_strong_per_1000'] if stats['words'] >= 300 else stats['hard'] + stats['strong']} {basis} · "
               f"scanner lead: {stats['lead']} (not a verdict)")
    return "\n".join(out)


def main():
    ap = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    ap.add_argument("files", nargs="*", help="files to scan ('-' or none for stdin)")
    ap.add_argument("--json", action="store_true", help="print JSON")
    ap.add_argument("--quotes", action="store_true", help="also scan blockquotes and quoted spans")
    args = ap.parse_args()
    results = []
    for f in args.files or ["-"]:
        text = sys.stdin.read() if f == "-" else open(f, encoding="utf-8").read()
        hits, stats = scan(text, args.quotes)
        results.append({"file": "stdin" if f == "-" else f, "stats": stats, "hits": hits})
    if args.json:
        print(json.dumps(results if len(results) > 1 else results[0], indent=2, ensure_ascii=False))
    else:
        print("\n\n".join(report(r["file"], r["hits"], r["stats"]) for r in results))


if __name__ == "__main__":
    main()
