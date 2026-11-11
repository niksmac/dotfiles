#!/usr/bin/env python3
"""Lint App Store and Google Play listing metadata before submission.

Usage:
  aso-lint.py aso/listing.md         check the listing (the file people edit)
  aso-lint.py --write aso/listing.md check it and refresh the character counts
  aso-lint.py metadata.json          check a JSON file (script-generated drafts)
  aso-lint.py --template             print an example metadata JSON

The listing Markdown is the format aso-render.py writes: "## App Store" /
"## Google Play" sections, a "### <locale> · <language>" heading per locale,
and each field as a bold title line followed by a ```text block. People edit
the text blocks; --write updates the "N/limit chars" counts after edits.

Checks character/byte limits, iOS keyword-field hygiene (spaces, repeats,
words already in name/subtitle, plural pairs, stop words, auto-indexed
words, short tokens, unused bytes), policy-risky terms (rankings, prices,
"free", CTAs, emoji, ALL CAPS, other platforms, competitor names) and
Play description keyword density. With a "submission" block it also checks
that every console field is present (App Store Connect app info, version,
App Review, App Privacy, export compliance, IAP / subscription text; Play
store settings, App content declarations, subscriptions), text limits,
https URLs, unfilled TODOs and secrets. Exit code 1 if any ERROR.

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

# Submission block: required keys per section (references/submission-fields.md).
SUBMISSION_REQUIRED = {
    "ios": {
        "app_info": ["bundle_id", "sku", "primary_language", "primary_category",
                     "content_rights", "age_rating", "privacy_policy_url"],
        "version": ["version", "copyright", "support_url"],
        "review": ["sign_in_required", "contact_first_name", "contact_last_name",
                   "contact_phone", "contact_email", "notes"],
        "privacy": ["tracking", "data"],
        "export_compliance": ["uses_non_exempt_encryption"],
        "pricing": ["price", "availability"],
    },
    "android": {
        "store_settings": ["package", "app_or_game", "category", "contact_email"],
        "app_content": ["privacy_policy_url", "app_access", "ads", "content_rating",
                        "target_audience", "data_safety", "advertising_id",
                        "government_app", "financial_features", "health", "news_app"],
        "release": ["countries"],
    },
}
SUBMISSION_LIMITS = {
    # (field path, limit) - text limits from the consoles, verified in
    # references/submission-fields.md.
    "ios.review.notes": 4000,          # bytes
    "ios.iap.reference_name": 64,
    "ios.iap.product_id": 100,
    "ios.iap.display_name": 30,        # IAP page: 2-30; subscriptions unstated, use the same
    "ios.iap.description": 45,         # IAP page: 45; subscriptions unstated, use the same
    "android.subscriptions.product_id": 40,
    "android.subscriptions.name": 55,
    "android.subscriptions.benefit": 40,
}
ANDROID_MAX_BENEFITS = 4
URL_KEYS = ("_url", "website")
SECRET_KEYS = ("password", "passcode", "api_key", "secret", "token")
SECRET_OK = {"", "todo", "in console", "<in console>", "provided in console"}

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
    "submission": {
        "ios": {
            "app_info": {"bundle_id": "com.example.penny", "sku": "penny-ios", "primary_language": "en-US",
                         "primary_category": "Finance", "secondary_category": "Lifestyle",
                         "content_rights": "No third-party content", "age_rating": "4+ (see submission.md)",
                         "privacy_policy_url": "https://example.com/privacy", "license_agreement": "Standard Apple EULA"},
            "version": {"version": "1.0.0", "copyright": "2026 Example Inc.", "support_url": "https://example.com/help",
                        "marketing_url": "https://example.com", "release": "manual"},
            "review": {"sign_in_required": True, "username": "TODO", "password": "in console",
                       "contact_first_name": "TODO", "contact_last_name": "TODO", "contact_phone": "TODO",
                       "contact_email": "TODO", "notes": "How to reach the main features..."},
            "privacy": {"tracking": False, "data": [
                {"type": "Email Address", "linked": True, "tracking": False, "purposes": ["App Functionality"]}]},
            "export_compliance": {"uses_non_exempt_encryption": False},
            "pricing": {"price": "Free", "availability": "All countries"},
            "subscription_group": {"reference_name": "Penny Plus", "display_name": {"en-US": "Penny Plus"}},
            "iap": [{"product_id": "penny_plus_monthly", "reference_name": "Penny Plus monthly",
                     "type": "auto-renewable", "duration": "1 month",
                     "display_name": {"en-US": "Penny Plus"},
                     "description": {"en-US": "Shared budgets and unlimited goals"}}],
        },
        "android": {
            "store_settings": {"package": "com.example.penny", "app_or_game": "App", "category": "Finance",
                               "tags": ["Budgeting"], "contact_email": "help@example.com",
                               "website": "https://example.com"},
            "app_content": {"privacy_policy_url": "https://example.com/privacy", "app_access": "Login required: TODO",
                            "ads": False, "content_rating": "Everyone (IARC, see submission.md)",
                            "target_audience": ["18+"], "data_safety": "see submission.md", "advertising_id": False,
                            "government_app": False, "financial_features": "Budgeting only", "health": "None",
                            "news_app": False, "account_deletion_url": "https://example.com/delete-account"},
            "release": {"countries": "All", "release_notes": {"en-US": "First release."}},
            "subscriptions": [{"product_id": "penny_plus", "name": {"en-US": "Penny Plus"},
                               "benefits": {"en-US": ["Shared budgets", "Unlimited goals"]},
                               "description": {"en-US": "Plan money together."},
                               "base_plan_id": "monthly", "billing_period": "P1M"}],
        },
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


def _check_text(where, text, limit, policy=True):
    """Length check; with policy=True also store-facing term checks."""
    if not isinstance(text, str):
        return
    if limit is not None and len(text) > limit:
        report("ERROR", where, f"{len(text)} chars, limit {limit}")
    if not policy:
        return
    low = text.lower()
    for pat in RISKY_TERMS:
        m = re.search(pat, low)
        if m:
            report("ERROR", where, f"ranking/price/promo term '{m.group(0).strip()}'")
    if EMOJI_RE.search(text):
        report("ERROR", where, "emoji or pictographic symbols")


def _walk(prefix, node):
    """Yield (path, key, value) for every scalar in a nested dict/list."""
    if isinstance(node, dict):
        for k, v in node.items():
            yield from _walk(f"{prefix}.{k}", v) if isinstance(v, (dict, list)) else [(f"{prefix}.{k}", k, v)]
    elif isinstance(node, list):
        for i, v in enumerate(node):
            yield from _walk(f"{prefix}[{i}]", v) if isinstance(v, (dict, list)) else [(f"{prefix}[{i}]", "", v)]


def check_submission(sub, required=True):
    for store, sections in (SUBMISSION_REQUIRED.items() if required else []):
        block = sub.get(store)
        if block is None:
            report("WARN", f"submission/{store}", "missing (no console answers for this store)")
            continue
        for section, keys in sections.items():
            sec = block.get(section)
            if not isinstance(sec, dict):
                report("ERROR", f"submission/{store}/{section}", "missing section")
                continue
            for k in keys:
                if k not in sec or sec[k] in ("", None, []):
                    report("ERROR", f"submission/{store}/{section}", f"missing '{k}'")
    for path, key, val in _walk("submission", sub):
        where = path.replace(".", "/")
        k = key.lower()
        if isinstance(val, str):
            v = val.strip()
            if "todo" in v.lower() and not any(s in k for s in SECRET_KEYS):
                report("WARN", where, f"unfilled: {v[:60]}")
            if k.endswith(URL_KEYS) and v and "todo" not in v.lower() and not v.startswith("https://"):
                report("ERROR", where, "URL must be a full https:// link")
            if any(s in k for s in SECRET_KEYS) and v.lower() not in SECRET_OK:
                report("ERROR", where, "looks like a real secret: keep it in the console, not in the repo")
    ios = sub.get("ios") or {}
    review = ios.get("review") or {}
    # Review notes are private to App Review: length only, no store-facing term checks.
    notes = review.get("notes")
    if isinstance(notes, str) and len(notes.encode("utf-8")) > SUBMISSION_LIMITS["ios.review.notes"]:
        report("ERROR", "submission/ios/review/notes",
               f"{len(notes.encode('utf-8'))} bytes, limit {SUBMISSION_LIMITS['ios.review.notes']}")
    group = ios.get("subscription_group") or {}
    for loc, txt in (group.get("display_name") or {}).items():
        where = f"submission/ios/subscription_group/display_name/{loc}"
        _check_text(where, txt, None)
        if isinstance(txt, str) and (re.search(r"<[^>]+>", txt) or any(
                unicodedata.combining(ch) for ch in unicodedata.normalize("NFD", txt))):
            report("ERROR", where, "no markup, emoji or diacritics allowed in the group display name")
    for i, p in enumerate(ios.get("iap") or []):
        pid = p.get("product_id", i)
        if len(p.get("reference_name", "")) > SUBMISSION_LIMITS["ios.iap.reference_name"]:
            report("ERROR", f"submission/ios/iap/{pid}/reference_name", "over 64 chars")
        if len(str(pid)) > SUBMISSION_LIMITS["ios.iap.product_id"] or not re.fullmatch(r"[A-Za-z0-9._-]+", str(pid)):
            report("ERROR", f"submission/ios/iap/{pid}/product_id", "max 100 chars: letters, digits, . _ -")
        for field in ("display_name", "description"):
            locs = p.get(field) or {}
            if not locs:
                report("ERROR", f"submission/ios/iap/{pid}", f"missing localized {field}")
            for loc, txt in locs.items():
                _check_text(f"submission/ios/iap/{pid}/{field}/{loc}", txt, SUBMISSION_LIMITS[f"ios.iap.{field}"])
    android = sub.get("android") or {}
    for i, p in enumerate(android.get("subscriptions") or []):
        pid = p.get("product_id", i)
        for loc, txt in (p.get("name") or {}).items():
            _check_text(f"submission/android/subscriptions/{pid}/name/{loc}", txt,
                        SUBMISSION_LIMITS["android.subscriptions.name"])
        if len(str(pid)) > SUBMISSION_LIMITS["android.subscriptions.product_id"] or not re.fullmatch(
                r"[0-9a-z][0-9a-z._]*", str(pid)):
            report("ERROR", f"submission/android/subscriptions/{pid}/product_id",
                   "max 40 chars, starts with a digit or lowercase letter; lowercase, digits, _ and . only")
        bp = p.get("base_plan_id", "")
        if bp and not re.fullmatch(r"[0-9a-z][0-9a-z-]*", bp):
            report("ERROR", f"submission/android/subscriptions/{pid}/base_plan_id",
                   "starts with a digit or lowercase letter; lowercase, digits and hyphens only")
        for loc, txt in (p.get("description") or {}).items():
            _check_text(f"submission/android/subscriptions/{pid}/description/{loc}", txt, None)
        for loc, items in (p.get("benefits") or {}).items():
            if len(items) > ANDROID_MAX_BENEFITS:
                report("ERROR", f"submission/android/subscriptions/{pid}/benefits/{loc}",
                       f"{len(items)} benefits, max {ANDROID_MAX_BENEFITS}")
            for j, txt in enumerate(items):
                where = f"submission/android/subscriptions/{pid}/benefits/{loc}[{j}]"
                _check_text(where, txt, SUBMISSION_LIMITS["android.subscriptions.benefit"])
                if re.search(r"\btrial\b|[$€£₹¥]\s?\d|\bprice\b", txt.lower()):
                    report("ERROR", where, "benefits can't mention free trials or prices")
    rel = (android.get("release") or {}).get("release_notes") or {}
    for loc, txt in rel.items():
        if isinstance(txt, str) and len(txt) > LIMITS["android"]["release_notes"]:
            report("ERROR", f"submission/android/release/release_notes/{loc}",
                   f"{len(txt)} chars, limit {LIMITS['android']['release_notes']}")


# ---------------------------------------------------------------------------
# Listing Markdown (the human-edited source; see aso-render.py)

LOCALE_RE = re.compile(r"^([a-z]{2,3}(?:-[A-Za-z0-9]{2,4})?)(?:\s|$)")
BOLD_RE = re.compile(r"^\*\*(.+?)\*\*(.*)$")
COUNT_RE = re.compile(r"· (\d+)(?:/(\d+))? (chars|bytes)(?:  \*\*OVER LIMIT\*\*)?")
IOS_TITLES = {"app name": "name", "subtitle": "subtitle", "promotional text": "promotional_text",
              "description": "description", "keywords": "keywords", "what's new": "whats_new"}
PLAY_TITLES = {"app name": "title", "short description": "short_description",
               "full description": "full_description", "release notes": "release_notes"}


def _key(title):
    return re.sub(r"[^a-z0-9]+", "_", title.lower()).strip("_")


def parse_listing_md(text):
    """Turn listing Markdown into the metadata dict the checks use.

    Returns (data, blocks, kv): blocks are (bold_line_index, text) pairs for
    count refresh; kv are (where, field, value) rows of the key/value tables.
    """
    lines = text.split("\n")
    data = {"competitors": [], "ios": {}, "android": {},
            "submission": {"ios": {}, "android": {}}}
    blocks, kv = [], []
    store = section = loc = None
    product = None
    title, title_idx = None, None
    i = 0
    while i < len(lines):
        line = lines[i]
        if line.startswith("## "):
            h = line[3:].lower()
            store = ("ios" if "app store" in h else "android" if "google play" in h
                     else "settings" if "lint" in h else None)
            section = loc = product = None
        elif line.startswith("### "):
            h = line[4:].strip()
            m = LOCALE_RE.match(h)
            section, loc = ("locale", m.group(1)) if m else (h.lower(), None)
            product = None
        elif line.startswith("#### "):
            h = line[5:].strip()
            pid = h.split("·")[0].strip().strip("`")
            if store == "ios":
                product = {"product_id": pid, "reference_name": h.split("·", 1)[1].strip() if "·" in h else ""}
                data["submission"]["ios"].setdefault("iap", []).append(product)
            elif store == "android":
                bp = re.search(r"base plan `([^`]*)`", h)
                product = {"product_id": pid, "base_plan_id": bp.group(1) if bp else ""}
                data["submission"]["android"].setdefault("subscriptions", []).append(product)
        elif BOLD_RE.match(line):
            title, title_idx = BOLD_RE.match(line).group(1).strip(), i
        elif line.strip() == "```text" and title is not None:
            j = i + 1
            while j < len(lines) and lines[j].strip() != "```":
                j += 1
            body = "\n".join(lines[i + 1:j])
            blocks.append((title_idx, body))
            _assign(data, store, section, loc, product, title, body)
            title, i = None, j
        elif line.startswith("|") and section and section != "locale":
            cells = [c.strip() for c in line.strip().strip("|").split("|")]
            if len(cells) >= 2 and cells[0] not in ("Field", "") and not set(cells[0]) <= set("-: "):
                kv.append((f"{store}/{section}", cells[0], cells[1]))
        i += 1
    return data, blocks, kv


def _assign(data, store, section, loc, product, title, body):
    t = title.lower().replace("\u2019", "'")
    if store == "settings":
        if "competitor" in t or "trademark" in t:
            data["competitors"] = [c.strip() for c in re.split(r"[,\n]", body) if c.strip()]
        return
    if store not in ("ios", "android"):
        return
    if section == "locale" and loc:
        names = IOS_TITLES if store == "ios" else PLAY_TITLES
        data[store].setdefault(loc, {})[names.get(t, _key(title))] = body
        return
    sub = data["submission"][store]
    m = re.match(r"(.+?),\s*([A-Za-z0-9-]+)$", title)
    field, floc = (m.group(1).lower(), m.group(2)) if m else (t, None)
    if store == "ios":
        if field == "group display name" and floc:
            sub.setdefault("subscription_group", {}).setdefault("display_name", {})[floc] = body
        elif product is not None and floc and field in ("display name", "description"):
            product.setdefault(field.replace(" ", "_"), {})[floc] = body
        elif "review" in (section or "") and field == "notes":
            sub.setdefault("review", {})["notes"] = body
    else:
        if product is not None and floc:
            if field == "name":
                product.setdefault("name", {})[floc] = body
            elif field.startswith("benefit"):
                product.setdefault("benefits", {}).setdefault(floc, []).append(body)
            elif field == "description":
                product.setdefault("description", {})[floc] = body


def refresh_counts(lines, blocks, write):
    """Check (and with write=True fix) the 'N/limit chars' counts in titles."""
    changed = 0
    for idx, body in blocks:
        m = COUNT_RE.search(lines[idx])
        if not m:
            continue
        unit = m.group(3)
        n = len(body.encode("utf-8")) if unit == "bytes" else len(body)
        limit = int(m.group(2)) if m.group(2) else None
        new = f"· {n}" + (f"/{limit}" if limit else "") + f" {unit}" + (
            "  **OVER LIMIT**" if limit and n > limit else "")
        if m.group(0) != new:
            if write:
                lines[idx] = lines[idx][:m.start()] + new + lines[idx][m.end():]
                changed += 1
            else:
                title = BOLD_RE.match(lines[idx]).group(1)
                report("WARN", f"listing line {idx + 1}", f"'{title}' count says {m.group(1)}, text is {n} {unit}: "
                       "run with --write")
    return changed


def check_kv(kv):
    for where, field, value in kv:
        f, v = field.lower(), value.strip()
        if "todo" in v.lower():
            report("WARN", f"{where}/{field}", f"unfilled: {v[:60]}")
        elif ("url" in f or f == "website") and v and not v.startswith("https://"):
            report("ERROR", f"{where}/{field}", "URL must be a full https:// link")


def main(argv):
    args = argv[1:]
    write = "--write" in args
    args = [a for a in args if a != "--write"]
    if args == ["--template"]:
        print(json.dumps(TEMPLATE, indent=2, ensure_ascii=False))
        return 0
    if len(args) != 1:
        print(__doc__.strip(), file=sys.stderr)
        return 2
    path = args[0]
    with open(path, encoding="utf-8") as fh:
        raw = fh.read()
    is_md = path.lower().endswith((".md", ".markdown"))
    if is_md:
        data, blocks, kv = parse_listing_md(raw)
        lines = raw.split("\n")
        changed = refresh_counts(lines, blocks, write)
        if write and changed:
            with open(path, "w", encoding="utf-8") as fh:
                fh.write("\n".join(lines))
            print(f"Updated {changed} count(s) in {path}")
        check_kv(kv)
        if not data["ios"] and not data["android"]:
            report("ERROR", path, "no '## App Store' or '## Google Play' locale sections found")
    else:
        if write:
            print("--write only applies to a listing .md file", file=sys.stderr)
            return 2
        data = json.loads(raw)
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
    if isinstance(data.get("submission"), dict):
        # Console answers (privacy, age rating, ...) live in submission.md when
        # the source is Markdown, so only the JSON form checks required keys.
        check_submission(data["submission"], required=not is_md)
    order = {"ERROR": 0, "WARN": 1, "INFO": 2}
    for level, where, msg in sorted(findings, key=lambda f: (order[f[0]], f[1])):
        print(f"{level:5} {where}: {msg}")
    errors = sum(1 for f in findings if f[0] == "ERROR")
    warns = sum(1 for f in findings if f[0] == "WARN")
    print(f"\n{errors} error(s), {warns} warning(s)")
    return 1 if errors else 0


if __name__ == "__main__":
    sys.exit(main(sys.argv))
