#!/usr/bin/env python3
"""Create the store listing Markdown (aso/listing.md) from a metadata JSON.

Usage:
  aso-render.py metadata.json > aso/listing.md
  aso-lint.py --template > t.json && aso-render.py t.json   (blank skeleton)

aso/listing.md is the file people read, paste from and edit; aso-lint.py
checks it directly (--write refreshes the counts). Use this script once, to
turn a script-generated JSON draft or the template into that file; after
that, edit the Markdown and don't keep a JSON copy that can drift.

Writes every text field the stores ask for, per store and locale, in the
order App Store Connect and Play Console show them: each field as a
fenced block with its character (or byte) count against the limit. Also
renders the text fields of the optional "submission" block (URLs,
copyright, categories, App Review notes, subscription and IAP text,
release notes), and the competitor and trademark names the linter must
reject. Limits come from aso-lint.py, so both scripts agree. Stdlib only.
"""
import importlib.util
import json
import os
import sys

_here = os.path.dirname(os.path.abspath(__file__))
_spec = importlib.util.spec_from_file_location("aso_lint", os.path.join(_here, "aso-lint.py"))
_lint = importlib.util.module_from_spec(_spec)
_spec.loader.exec_module(_lint)
LIMITS = _lint.LIMITS
SUB_LIMITS = _lint.SUBMISSION_LIMITS

IOS_FIELDS = [
    ("name", "App name", "App Information (localized)"),
    ("subtitle", "Subtitle", "App Information (localized)"),
    ("promotional_text", "Promotional text", "Version page; not indexed; editable without a build"),
    ("description", "Description", "Version page; not indexed"),
    ("keywords", "Keywords", "Version page; comma-separated, no spaces"),
    ("whats_new", "What's New", "Version page; not shown on a first version"),
]
PLAY_FIELDS = [
    ("title", "App name", "Main store listing"),
    ("short_description", "Short description", "Main store listing"),
    ("full_description", "Full description", "Main store listing"),
    ("release_notes", "Release notes", "Release > release notes"),
]
LOCALE_NAMES = {
    "en-US": "English (U.S.)", "en-GB": "English (U.K.)", "en-AU": "English (Australia)",
    "en-CA": "English (Canada)", "en-IN": "English (India)", "es-MX": "Spanish (Mexico)",
    "es-ES": "Spanish (Spain)", "es-419": "Spanish (Latin America)", "fr-FR": "French",
    "fr-CA": "French (Canada)", "de-DE": "German", "it": "Italian", "ja": "Japanese",
    "ko": "Korean", "pt-BR": "Portuguese (Brazil)", "zh-Hans": "Chinese (Simplified)",
    "zh-Hant": "Chinese (Traditional)", "hi": "Hindi", "hi-IN": "Hindi", "ar-SA": "Arabic",
}

out = []


def w(line=""):
    out.append(line)


def count(field, text):
    if field == "keywords":
        return len(text.encode("utf-8")), "bytes"
    return len(text), "chars"


def block(title, text, limit=None, note=None, field=None, unit_bytes=False):
    if text is None or text == "":
        return
    n, unit = count(field, text) if field else (len(text.encode("utf-8")) if unit_bytes else len(text),
                                                "bytes" if unit_bytes else "chars")
    size = f"{n}/{limit} {unit}" if limit else f"{n} {unit}"
    flag = "  **OVER LIMIT**" if limit and n > limit else ""
    w(f"**{title}** · {size}{flag}" + (f" · _{note}_" if note else ""))
    w()
    w("```text")
    w(text.rstrip("\n"))
    w("```")
    w()


def kv_table(rows):
    rows = [(k, v) for k, v in rows if v not in (None, "", [])]
    if not rows:
        return
    w("| Field | Value |")
    w("|---|---|")
    for k, v in rows:
        if isinstance(v, bool):
            v = "Yes" if v else "No"
        elif isinstance(v, list):
            v = ", ".join(str(x) for x in v)
        w(f"| {k} | {str(v).replace('|', '/').replace(chr(10), ' ')} |")
    w()


def loc_title(loc):
    name = LOCALE_NAMES.get(loc)
    return f"{loc} · {name}" if name else loc


def render(data, src):
    sub = data.get("submission") or {}
    w("# Store listing copy")
    w()
    w("Every text field App Store Connect and Play Console ask for, per store and language. "
      "**This file is the source:** copy each grey block into the console field named above it, "
      "and make copy changes here.")
    w()
    w("Counts are characters (bytes for the iOS keyword field) against the store limit. After editing, run "
      "`python3 ~/.claude/skills/app-store-optimization/scripts/aso-lint.py --write aso/listing.md` "
      "to refresh the counts and check limits and store policy.")
    w()

    ios = data.get("ios") or {}
    if ios:
        w("## App Store (App Store Connect)")
        w()
        s_ios = sub.get("ios") or {}
        info, ver = s_ios.get("app_info") or {}, s_ios.get("version") or {}
        if info or ver:
            w("### App-level fields")
            w()
            kv_table([
                ("Bundle ID", info.get("bundle_id")), ("Primary language", info.get("primary_language")),
                ("Primary category", info.get("primary_category")),
                ("Secondary category", info.get("secondary_category")),
                ("Privacy Policy URL", info.get("privacy_policy_url")),
                ("Privacy Choices URL", info.get("privacy_choices_url")),
                ("License agreement", info.get("license_agreement")),
                ("Version", ver.get("version")), ("Copyright", ver.get("copyright")),
                ("Support URL (all locales)", ver.get("support_url")),
                ("Marketing URL (all locales)", ver.get("marketing_url")),
                ("Release", ver.get("release")),
            ])
        for loc, meta in ios.items():
            w(f"### {loc_title(loc)}")
            w()
            for key, title, note in IOS_FIELDS:
                block(title, meta.get(key), LIMITS["ios"].get(key), note, field=key)
            for key in sorted(set(meta) - {k for k, _, _ in IOS_FIELDS}):
                if isinstance(meta[key], str):
                    block(key.replace("_", " ").capitalize(), meta[key])
        group = s_ios.get("subscription_group") or {}
        iaps = s_ios.get("iap") or []
        if group or iaps:
            w("### Subscriptions and in-app purchases")
            w()
            if group:
                w(f"Subscription group reference name: `{group.get('reference_name', '')}`")
                w()
                for loc, txt in (group.get("display_name") or {}).items():
                    block(f"Group display name, {loc}", txt, None, "no emoji, markup or diacritics")
            for p in iaps:
                w(f"#### {p.get('product_id')} · {p.get('reference_name', '')}")
                w()
                kv_table([("Type", p.get("type")), ("Duration", p.get("duration")), ("Level", p.get("level"))])
                for loc in (p.get("display_name") or {}):
                    block(f"Display name, {loc}", p["display_name"][loc], SUB_LIMITS["ios.iap.display_name"])
                    block(f"Description, {loc}", (p.get("description") or {}).get(loc),
                          SUB_LIMITS["ios.iap.description"])
        notes = (s_ios.get("review") or {}).get("notes")
        if notes:
            w("### App Review notes")
            w()
            block("Notes", notes, SUB_LIMITS["ios.review.notes"], "private to App Review; limit in bytes",
                  unit_bytes=True)

    play = data.get("android") or {}
    if play:
        w("## Google Play (Play Console)")
        w()
        s_and = sub.get("android") or {}
        st, ac = s_and.get("store_settings") or {}, s_and.get("app_content") or {}
        if st or ac:
            w("### Store settings")
            w()
            kv_table([
                ("Package", st.get("package")), ("App or game", st.get("app_or_game")),
                ("Category", st.get("category")), ("Tags", st.get("tags")),
                ("Contact email", st.get("contact_email")), ("Contact phone", st.get("contact_phone")),
                ("Website", st.get("website")), ("Privacy policy", ac.get("privacy_policy_url")),
                ("Account deletion URL", ac.get("account_deletion_url")),
            ])
        for loc, meta in play.items():
            w(f"### {loc_title(loc)}")
            w()
            for key, title, note in PLAY_FIELDS:
                block(title, meta.get(key), LIMITS["android"].get(key), note, field=key)
        subs = s_and.get("subscriptions") or []
        if subs:
            w("### Subscriptions")
            w()
            for p in subs:
                w(f"#### {p.get('product_id')} · base plan `{p.get('base_plan_id', '')}` "
                  f"({p.get('billing_period', '')})")
                w()
                for loc, txt in (p.get("name") or {}).items():
                    block(f"Name, {loc}", txt, SUB_LIMITS["android.subscriptions.name"])
                for loc, items in (p.get("benefits") or {}).items():
                    for i, txt in enumerate(items, 1):
                        block(f"Benefit {i}, {loc}", txt, SUB_LIMITS["android.subscriptions.benefit"])
                for loc, txt in (p.get("description") or {}).items():
                    block(f"Description, {loc}", txt)
    comps = data.get("competitors") or []
    w("## Lint settings")
    w()
    w("Not store text. Names that must never appear in any field (competitors, trademarks, vendors); "
      "the linter rejects them. One per line or comma-separated.")
    w()
    block("Competitor and trademark names", ", ".join(comps) if comps else "TODO")
    return "\n".join(out).rstrip() + "\n"


def main(argv):
    if len(argv) != 2:
        print(__doc__.strip(), file=sys.stderr)
        return 2
    with open(argv[1], encoding="utf-8") as fh:
        data = json.load(fh)
    sys.stdout.write(render(data, argv[1]))
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv))
