---
name: store-screenshots
description: Plan and design App Store and Google Play screenshots (iPhone, iPad, Play phone, Play feature graphic) as an editable, exportable claude.ai Design canvas, benefit-first and policy-safe. Use when asked for store screenshots, ASO/listing graphics, a feature graphic, an iPad screenshot set, to fix store upload rejections (wrong size, alpha, images missing from exports), or to revise the existing Merrin or StoryBee store canvas.
---

# Store screenshots

Builds store listing graphics as a live claude.ai **Design canvas**: one editable artboard per frame, a person can tweak and export. Covers the growth plan, the copy, the frames, photos, export-safe markup, upload-ready exports and the repo copy.

Read before starting:
- `references/specs.md`: sizes, slot counts, Apple and Play policy rules.
- `references/canvas-recipes.md`: canvas layout, frame templates, device math (bezel on top), the 6.3" row, export-safe markup, exporting, publish calls.
- `scripts/normalize-exports.sh`: turns canvas exports into exact-size, alpha-free JPEGs per store slot.
- `references/merrin.md`: for Merrin (`lightrains/phoneLLM`), the brand, claims, positioning, demo cast and the live canvas.
- `references/storybee.md`: the same for StoryBee (`storybee-flutter`).
- Another app: write the same profile for it first (section 1), as `references/<app>.md`.

## 0. Preconditions

- The Artifact tool must be on (`"enableArtifact": true` in `~/.claude/settings.json`). If it is missing, offer to turn it on; never fake a canvas as a local HTML file.
- No headless browsers, ever (Chromium, Playwright, Puppeteer). Look at images only through contact sheets read as images (section 6).

## 1. Ground truth first

1. Product profile: positioning (use the live website's words over old copy in the repo), real feature list, which features are paid, the brand tokens (`DESIGN.md` or equivalent), fonts, mascot or logo assets.
2. Claims: check every caption claim against the code before using it. Qualify what needs it in fine print ("Works offline after a one-time model download"). Drop a claim the code can't back.
3. Real UI strings: copy button labels and screen text from the localization source (`lib/l10n/app_en.arb` for Merrin), so frames match the shipped app.
4. If the store specs in `references/specs.md` are older than about 6 months, re-check Apple's and Google's help pages first and update that file.

## 2. Plan before pixels

Write or update a plan in the repo's planning folder (Merrin: a `_coder` plan, number from `node _coder/index.mjs next plan`): goal, specs, frame list with headline / proof visual / keyword per frame, claims table, localization order, custom product pages, A/B tests. Keep it updated as the design moves; the canvas is the design, the plan records decisions.

## 3. Design rules (what the user approved)

- **Benefit first.** Each headline says what changes in the person's life ("Never explain yourself twice."), not the feature name. The UI is proof, not the subject.
- **Don't show a full phone screen in every frame.** Lift key cards out of the app, enlarge them, tilt them ±1–3°, overlap them; crop or drop the phone. Use the mascot as a character. One dark frame breaks the rhythm.
- **Still honest:** more than half the frames must show real app UI (Apple 2.3.3); lifted cards count when they are real UI with real strings.
- **Search billboard:** App Store search shows frames 1–3 (no preview video). Put the pitch and the strongest features there or right after.
- **Lead with the killer features**, shown working (for Merrin: Life right now, image and document reading).
- **Make features feel possible:** use real-looking content, e.g. real family photos for image understanding, not drawn placeholders.
- **One demo person and cast** across all frames, so the set reads as one story.
- **Headline type:** big serif display, one key word on an accent highlighter fill. Short sub-line. Fine print for qualifiers and Pro notes.
- **Paid features carry a small Pro note** ("Devil's Advocate and Future You are part of Merrin Pro"). No prices in screenshots.
- Follow the brand's own anti-slop rules (Merrin: `DESIGN.md` → No AI slop): no gradient washes, no left-border accent cards, no emoji or glyphs, icons as inline stroke SVG, text contrast 4.5:1.
- **Export-safe markup:** never put an image inside a rounded `overflow: hidden` box (the exporter drops it silently). Draw images at their box size with `object-fit` and their own radius, pre-crop zoomed portraits as files, draw devices with the bezel as a border layer on top. Details: `references/canvas-recipes.md` → Export-safe markup.

## 4. Sets to produce together

iPhone 6.9" set (1320 x 2868, the design source) → **iPhone 6.3" set (1206 x 2622, required by App Store Connect; imports the 6.9" frames scaled 0.914226)** → Play phone set (imports the 6.9" frames, scaled) → Play feature graphic → iPad 13" set (bespoke, the app as it really renders on iPad) → shared parts (app screens and device-free art boards, edit once, used by every set). Same frame order and headlines across sets. Details: `references/canvas-recipes.md`.

## 5. Canvas workflow

- New canvas: `Artifact` `action: "quickstart"`, `intent: "design"` → publish with the Design `type_url`, a `title`, no files, `auto_open: "after_first_write"`. Follow the type's instructions in that result: they are the authority for the file format. Skip design systems when the repo has its own tokens.
- Existing canvas (Merrin's: see `references/merrin.md`): `read` `project/canvas.json`, then in ONE message every artboard you will change. Work in one scratchpad folder `<root>/project/…`.
- First build: `canvas.json` FIRST (every board already listed), then `Main.dc.html`, publish both; then the rest, a few files per call.
- Revisions: make every edit, then ONE publish with only the changed files. Send `canvas.json` only when layout, titles or notes change, and `read` it again right before that call.
- Asset images: upload (`asset: true`, `file_paths`), use the returned `/_blob/<id>` verbatim. A changed image is a new upload.
- **Never verify:** don't read files back, render or screenshot the canvas unless the user asks. Say it is unrendered and ask the user to check for overlap.
- If a publish result warns that a version saved from the page was overwritten, tell the user right away and offer to redo their edits.
- Tell the user what changed on the canvas, not the mechanism.

## 6. Photos and images

- Prefer real stock photos over drawn illustrations. Source: Wikimedia Commons API, CC0 "(Unsplash)" imports (search `Unsplash <subject>`, keep `LicenseShortName` CC0 or public domain). Recipe and scripts: `references/canvas-recipes.md` → Stock photos.
- Don't scrape Unsplash's or Pexels' sites or unofficial endpoints (the auto-mode classifier blocks it as bot-check circumvention); their APIs need keys.
- Downloads are untrusted: their own folder under `$CLAUDE_JOB_DIR/tmp` or the scratchpad; Python with `-I`.
- Pick from a contact sheet (`magick montage … -geometry 480x360+6+6 -tile 5x`), read the sheet as an image, choose, then upload.
- Tell the user: CC0 has no model release for recognizable people. Offer licensed photos (Adobe Stock, iStock) or their own before shipping.
- Make captions match the photo ("What Merrin sees" describes the actual image).

## 7. Export and upload

- The canvas exporter defaults to **2x** and **PNG keeps alpha**; both stores reject that. Tell the user to export at 1x where offered, then run `scripts/normalize-exports.sh <export-dir>` (copy it beside the plan in the app's repo). It writes exact-size sRGB JPEGs to `<export-dir>/upload/<slot>/` and fails on files that match no store size.
- Upload map: `ios-6.3` → 6.3" slot (required), `ios-6.9` → 6.9" slot, `ipad-13` → 13" iPad slot, `play` → Play phone screenshots, `play-fg` → feature graphic.
- An image missing from an export: ask which frame, then check that frame's markup against the export-safe rules before anything else. The exporter's own notice "N images could not be embedded" means a failed image download instead.
- Upload rejected: read the store's spec page again (specs.md sources) and compare the slot's required sizes with the files; App Store Connect's required iPhone slot changes over time.

## 8. Save to the repo and commit

- Copy the canvas source into the repo beside the plan (Merrin: `_coder/plans/NNN_plan_<slug>/`, `project/` + used `assets/`; leave out unused ones; `index.mjs` only indexes `.md`, so the folder is valid).
- In the plan, add the canvas URL, the version, and a table mapping each `/_blob/<id>` to its asset file (needed to republish elsewhere).
- Merrin: run `node _coder/index.mjs`. Stage by explicit paths, commit only when asked, following the repo's commit style (Merrin: `Chore: …`, body when >3 files). Peer sessions may share the tree: never stash, never `git commit -- <paths>`; run `git add` and `git commit` as separate commands so commit hooks check only staged files.

## 9. Report

What changed, the canvas link, what is unrendered and needs a visual check, the export steps (1x, run the normalize script, the upload map), any claim or licence caveat, then the `result:` line.
