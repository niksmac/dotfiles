#!/usr/bin/env python3
"""Lint App Store and Google Play listing metadata before submission.

Usage:
  aso-lint.py metadata.json          check a metadata file
  aso-lint.py --template             print an example metadata file

Checks character/byte limits, iOS keyword-field hygiene (spaces, repeats,
words already in name/subtitle, plural pairs, stop words, auto-indexed
words, short tokens, unused bytes), policy-risky terms (rankings, prices,
"free", CTAs, emoji, ALL CAPS, other platforms, competitor names) and
Play description keyword density. Exit code 1 if any ERROR.

Limits and rules: references/metadata-specs.md and policy-legal.md.
Stdlib only; runs on macOS and Linux.
"""
import json
import re
import sys
import unicodedata
from collections import Counter

LIMITS = {
    "ios": {
        "name": 30, "subtitle": 30, "keywords": 100,  # keywords in bytes
        "promotional_text": 170, "description": 4000, "whats_new": 4000,
    },
    "android": {
        "title": 30, "short_description": 80, "full_description": 4000,
        "release_notes": 500,
    },
}

# Ranking, performance, price and promo terms that stores reject in
# names, titles, subtitles, short descriptions and developer names.
RISKY_TERMS = [
    r"#\s?1", r"no\.?\s?1", r"number one", r"\bbest\b", r"\btop\b", r"\bfree\b",
    r"\bsale\b", r"\bdiscount\b", r"\b\d+\s?% off\b", r"\bnew\b", r"\bpopular\b",
    r"\bapp of the (day|year)\b", r"\beditor'?s'? choice\b", r"\bmillion downloads\b",
    r"\bcheap(est)?\b", r"\bdeal\b", r"[$€£₹¥]\s?\d",
]
CTA_TERMS = [r"\bdownload now\b", r"\binstall now\b", r"\bplay now\b",
             r"\btry now\b", r"\bget it now\b"]
NOT_ON_IOS = [r"\bandroid\b", r"\bgoogle play\b", r"\bplay store\b"]
NOT_ON_PLAY = [r"\biphone\b", r"\bipad\b", r"\bios\b", r"\bapp store\b", r"\bapple\b"]
# Apple indexes these already, or they never help in the keyword field.
AUTO_INDEXED = {"app", "apps", "free", "iphone", "ipad", "ios", "apple"}
STOP_WORDS = {"a", "an", "and", "the", "of", "for", "to", "with", "in", "on",
              "or", "by", "my", "your", "de", "la", "le", "el", "et", "und", "die"}

EMOJI_RE = re.compile(
    "[\U0001F000-\U0001FAFF\U00002600-\U000027BF\U0001F1E6-\U0001F1FF⭐⬆↔-⇿]")
REPEAT_SYMBOL_RE = re.compile(r"([!?*★☆♥✓✔•|~=+_-])\1{1,}")

TEMPLATE = {
    "competitors": ["ExampleRival", "OtherBrand"],
    "ios": {
        "en-US": {
            "name": "Penny: Budget Planner",
            "subtitle": "Track spending with a partner",
            "keywords": "money,expense,tracker,couples,bills,savings,finance,goals,shared,household,debt,cash,wallet,split",
            "promotional_text": "New: split bills in two taps.",
            "description": "Penny helps couples plan a budget together...",
            "whats_new": "Split bills in two taps. Faster sync.",
        },
        "es-MX": {"name": "Penny: Presupuesto en pareja", "subtitle": "Gastos y ahorro compartidos",
                  "keywords": "dinero,finanzas,cuentas,deudas,metas,hogar,familia,quincena,control,cartera,deuda,tarjetas,ingresos"},
    },
    "android": {
        "en-US": {
            "title": "Penny: Budget Planner",
            "short_description": "Plan a shared budget, track expenses and reach savings goals together.",
            "full_description": "Penny is a budget planner for couples...",
            "release_notes": "Split bills in two taps.",
        }
    },
}

findings = []


def report(level, where, msg):
    findings.append((level, where, msg))


def words(text):
    return [w for w in re.findall(r"[^\W_]+(?:'[^\W_]+)?", text.lower(), re.UNICODE)]


def check_common(store, loc, field, text, competitors, strict):
    where = f"{store}/{loc}/{field}"
    limit = LIMITS[store].get(field)
    if limit is not None:
        n = len(text.encode("utf-8")) if field == "keywords" else len(text)
        unit = "bytes" if field == "keywords" else "chars"
        if n > limit:
            report("ERROR", where, f"{n} {unit}, limit {limit}")
    if EMOJI_RE.search(text) and strict:
        report("ERROR", where, "emoji or pictographic symbols")
    if REPEAT_SYMBOL_RE.search(text):
        report("WARN", where, "repeated special characters")
    low = text.lower()
    for c in competitors:
        if re.search(r"\b" + re.escape(c.lower()) + r"\b", low):
            report("ERROR", where, f"competitor / third-party name '{c}'")
    platform = NOT_ON_IOS if store == "ios" else NOT_ON_PLAY
    for pat in platform:
        m = re.search(pat, low)
        if m:
            level = "ERROR" if store == "ios" else "WARN"
            report(level, where, f"other platform '{m.group(0)}' "
                   + ("(Guideline 2.3.10)" if store == "ios" else "(confusing on Play)"))
    if strict:
        for pat in RISKY_TERMS:
            m = re.search(pat, low)
            if m:
                report("ERROR", where, f"ranking/price/promo term '{m.group(0).strip()}'")
        caps = [w for w in re.findall(r"\b[A-Z]{4,}\b", text) if w not in {"HIIT", "NASA"}]
        if caps:
            report("WARN", where, f"ALL CAPS words {caps} (allowed only for brand names)")
    for pat in CTA_TERMS:
        m = re.search(pat, low)
        if m:
            report("WARN" if not strict else "ERROR", where, f"call to action '{m.group(0)}'")


def check_ios_keywords(loc, meta):
    where = f"ios/{loc}/keywords"
    kw = meta.get("keywords", "")
    if not kw:
        report("WARN", where, "empty keyword field")
        return
    nbytes = len(kw.encode("utf-8"))
    if ", " in kw or " ," in kw:
        report("ERROR", where, "spaces around commas waste bytes; use a,b,c")
    tokens = [t.strip() for t in kw.split(",") if t.strip()]
    if len(tokens) != len(kw.split(",")):
        report("WARN", where, "empty entries (double or trailing commas)")
    flat = []
    for t in tokens:
        if " " in t:
            report("WARN", where, f"phrase '{t}': single words combine on their own; split it")
        flat.extend(t.lower().split())
    counts = Counter(flat)
    dups = sorted(w for w, c in counts.items() if c > 1)
    if dups:
        report("ERROR", where, f"repeated words {dups}")
    title_words = set(words(meta.get("name", "")) + words(meta.get("subtitle", "")))
    in_title = sorted(set(flat) & title_words)
    if in_title:
        report("ERROR", where, f"already in name/subtitle {in_title}")
    auto = sorted(set(flat) & AUTO_INDEXED)
    if auto:
        report("WARN", where, f"auto-indexed or useless words {auto}")
    stops = sorted(set(flat) & STOP_WORDS)
    if stops:
        report("WARN", where, f"stop words {stops}")
    short = sorted(w for w in set(flat) if len(w) <= 2)
    if short:
        report("WARN", where, f"keywords of 2 characters or fewer {short} (App Store Connect requires >2)")
    vocab = set(flat) | title_words
    plural_pairs = sorted(w for w in vocab if len(w) > 3 and w.endswith("s") and w[:-1] in vocab)
    if plural_pairs and loc.lower().startswith("en"):
        report("WARN", where, f"singular and plural both present {plural_pairs} (English matches both)")
    if nbytes <= 100 and 100 - nbytes >= 8:
        report("WARN", where, f"{100 - nbytes} bytes unused")
    for t in flat:
        if any(unicodedata.combining(ch) for ch in unicodedata.normalize("NFD", t)):
            report("INFO", where, f"'{t}' has diacritics: check the unaccented form's traffic")
            break


def check_ios_title(loc, meta):
    name, sub = meta.get("name", ""), meta.get("subtitle", "")
    overlap = sorted((set(words(name)) & set(words(sub))) - STOP_WORDS)
    if overlap:
        report("WARN", f"ios/{loc}/subtitle", f"repeats name words {overlap}")


def check_play_desc(loc, meta):
    where = f"android/{loc}/full_description"
    full = meta.get("full_description", "")
    short = meta.get("short_description", "").strip()
    if short and short.lower() in full.lower():
        report("WARN", where, "contains the short description verbatim (Play best practice: don't repeat it)")
    ws = [w for w in words(full) if w not in STOP_WORDS and len(w) > 2]
    if len(ws) >= 80:
        for w, c in Counter(ws).most_common(5):
            share = c / len(ws)
            if share > 0.035 and c >= 6:
                report("WARN", where, f"'{w}' is {share:.1%} of words ({c}x): reads as stuffing")
    lines = [l for l in full.splitlines() if l.strip()]
    for l in lines:
        if l.count(",") >= 8 and len(words(l)) <= l.count(",") * 2 + 2:
            report("ERROR", where, "looks like a keyword list (Metadata policy)")
            break
    if re.search(r"\"[^\"]{10,}\"\s*[-–—]\s*(?:user|customer|anonymous)?\s*$", full, re.I | re.M):
        report("WARN", where, "testimonial without a named source? Play bans unattributed testimonials")


def main(argv):
    if len(argv) == 2 and argv[1] == "--template":
        print(json.dumps(TEMPLATE, indent=2, ensure_ascii=False))
        return 0
    if len(argv) != 2:
        print(__doc__.strip(), file=sys.stderr)
        return 2
    with open(argv[1], encoding="utf-8") as fh:
        data = json.load(fh)
    competitors = data.get("competitors", [])
    strict_fields = {"ios": {"name", "subtitle", "keywords"},
                     "android": {"title", "short_description", "developer_name"}}
    for store in ("ios", "android"):
        for loc, meta in (data.get(store) or {}).items():
            for field, text in meta.items():
                if not isinstance(text, str):
                    continue
                check_common(store, loc, field, text, competitors,
                             strict=field in strict_fields[store])
            if store == "ios":
                check_ios_keywords(loc, meta)
                check_ios_title(loc, meta)
            else:
                check_play_desc(loc, meta)
    order = {"ERROR": 0, "WARN": 1, "INFO": 2}
    for level, where, msg in sorted(findings, key=lambda f: (order[f[0]], f[1])):
        print(f"{level:5} {where}: {msg}")
    errors = sum(1 for f in findings if f[0] == "ERROR")
    warns = sum(1 for f in findings if f[0] == "WARN")
    print(f"\n{errors} error(s), {warns} warning(s)")
    return 1 if errors else 0


if __name__ == "__main__":
    sys.exit(main(sys.argv))
