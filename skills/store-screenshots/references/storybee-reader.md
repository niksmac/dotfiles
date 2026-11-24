# StoryBee Reader profile

## Live canvas and repo copy

- Canvas: https://claude.ai/artifact/99Jx4Vb6i9uV3xAqfNTz11 ("StoryBee Reader store screenshots", Design type). Revise this one; never create a second canvas. Version 7 = first full build; version 8 adds the progress frame (2026-11-12).
- Repo: `storybee_reader` (Flutter, branch `master`). Canvas source in `_coder/plans/026_plan_store-screenshots/project/`, published with `_coder/plans/026_plan_store-screenshots/` as `root` (the repo copy is the working copy). Plan, frames, claims table and `/_blob` map: `_coder/plans/026_plan_store-screenshots.md`. Export fixer: `_coder/plans/026_plan_store-screenshots/normalize-exports.sh`.
- Renders: `flutter test tool/screens/store_screens_test.dart` → `build/store-renders/store_<n>_<name>_<iphone|ipad|ipad-landscape>.png` (25 renders, about 30 s). It is built on the repo's own test support (`test/support/fakes.dart` `TestBackend`, `reader_seed.dart`), so it follows the app's providers without its own fakes.
- AGENTS.md there: plans in `_coder/plans` before the first code edit, `node _coder/index.mjs` after `_coder` changes; the ASO plan and listing are in `aso/` (`aso/plan.md` §4 = frames). Peer sessions share the tree: stage by explicit paths, commit only when asked.

## Product and positioning

- The third StoryBee app: children read their family's stories (made in the StoryBee creator app) and checked library stories on a calm, Kindle-like page. Words light up as the story is narrated, a tap on a word gives help, kept words come back for practice. Parents approve stories, set limits, see progress behind a grown-ups check. Spec: `_coder/specs/001_spec_storybee-reader.md` (read by heading only, it is ~54 KB).
- It sells nothing: it needs a StoryBee account; "Library books depend on your plan" (`aso/listing.md`). No prices, no "free", no "AI", no "for kids" until the Kids Category decision (D-2 in `aso/plan.md`).

## Claims (checked against the code 2026-11-12)

See the claims table in the plan. Qualifiers in fine print: highlighting needs read-along narration; meanings only on each book's marked words; family stories are made in the StoryBee app; account + plan.

## Brand

- Reader palettes (`lib/core/design/reader_colors.dart`): paper #FAF8F3 / ink #1F1F21, sepia #F2E8D5, night #161616; read-along highlight #F4DFA6 (paper). App icon: rust #B45309 book-stack "S" on cream #F5D1AE (`tool/app_icon/source.png`).
- Store look (shared with the creator app's listing, per `aso/plan.md`): honey #FFAE1B highlighter, Fraunces 750 SOFT 100 headlines (`assets/fonts/Fraunces-Variable.ttf`, same file as the creator app; canvas blob `026448333a3537dd26a3c9f356ab7868`), Noto Sans for sub-lines (the app's UI font), flat pastel grounds, one dark frame (Night).
- Different cast and frames from the creator app (Apple 4.3): Mia (4-6) and StoryBee library art from the API fixtures (`tool/screens/pictures/`), never the creator app's Leo / Biscuit / Grandma Rose.

## Frame order (9 per set: iPhone 6.9" and 6.3", iPad 13"; Play phone takes 1-8)

1 Words light up as it reads (read-along) · 2 Tap a word. Hear it. Keep it. · 3 Their stories, approved by you · 4 Books that work offline · 5 Paper, Sepia or Night (dark) · 6 New words, gently practised · 7 Watch their reading grow (a reader's week: minutes, books, words kept and learned) · 8 Grown-ups only · 9 The End. Read it again? Plus the Play feature graphic (icon, name, "Stories that read along", a lit word). Every frame is app in use in every set.

## Gotchas learned

- The iPad spread only renders in landscape (`ReaderGeometry`: tablet and landscape), so iPad frame 1 draws a landscape iPad inside the portrait slot.
- The golden font loader leaves out Atkinson, Lexend, Nunito and Noto Serif: the harness loads them, or the Aa panel shows grey boxes.
- Seeded shelf assets have no files: write real image bytes to each asset's `localPath` and mark it ready, or tiles show placeholders.
- `b.books.offline = true` keeps a shelf refresh from replacing the seeded shelf.
- The progress page uses the clock's current week: the harness pins the clock to a Sunday (`withClock`) so the chart is full. Don't claim cross-device totals until the report endpoint is live (its fixture is provisional).
- The child-mode section explains Android app pinning: never use it in Apple frames.
- Reader UI changes land often (e.g. `363aa22` removed the page border): check `git log` for `lib/features/reader` before an upload and re-render.
