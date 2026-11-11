# StoryBee profile

## Live canvas and repo copy

- Canvas: https://claude.ai/artifact/3p7Gzbm25c65dnycx57doe ("StoryBee store screenshots", Design type). Revise this one; never create a second canvas. Version 32 = the export-safe build (no rounded clipping, iPhone 6.3" row).
- Repo: `storybee-flutter` (Flutter, branch `develop`). Canvas source lives in `_coder/plans/002_plan_store-screenshots/project/` and is published with that folder as `root`, so the repo copy is the working copy. Plan, claims table and `/_blob` asset map: `_coder/plans/002_plan_store-screenshots.md`. Export fixer: `_coder/plans/002_plan_store-screenshots/normalize-exports.sh` (a copy of this skill's script; recopy after the skill's script changes). Pre-cropped portraits: `_coder/plans/002_plan_store-screenshots/assets/`.
- AGENTS.md there: no worktrees, no new branches unless asked; commit only when asked, imperative sentence-case subject, body, `Co-Authored-By` trailer.

## Product and positioning

- AI-written, illustrated children's stories (ages 2 to 13) with narration. Parent operates, child is the hero and the audience. Source: `_coder/PRODUCT.md`.
- Brand voice: warm, playful, never AI-forward. Keep "AI" out of headlines. Human-sounding copy (the user asked for it explicitly).

## Claims (checked against the code 2026-11-10)

| Use | Evidence |
|---|---|
| Ten art styles | `ArtStyle` enum / `StoryOptions.imageStyles` |
| Seven story languages (English, Hindi, Spanish, French, Arabic, German, Chinese) | `languageOptions` in `story_pickers.dart` (not the 5-item `StoryOptions.languages`, which is for Discover filters) |
| Your own voice from one read-aloud passage | `voice_recording_screen.dart`, `voice_passages.dart` ("The Fox and the Silver Key") |
| Type or dictate the idea, Surprise me | `createDictate`, `createSurprise` |
| Characters from a photo; the child leads | `characterFormIntro`, `characterFormKindChildHelper`, `characterFormPhotoHelper` |
| Playlists play back to back | `playlistsEmptyBody` |
| Educational mode: STEAM, STREAM, eSTEM, STEMM | `story_mode_toggle.dart`, `createFramework*` |
| **Never** generation time in minutes, voice counts as a selling number, "best", prices, "free" | |

Premium (fine print, no prices): narration, your own voice, longer stories ("Narration and your own voice are part of StoryBee Premium.").

## Brand

- Tokens `lib/core/design/app_colors.dart`: canvas #FFFCF7, sunken #F6F0E7, selected #FFEDC7, honey accent #FFAE1B (fills, highlighter), accent text #9A5B00, accent strong #C27400, ink #2B231D, secondary #665C52, tertiary #74695F, border #E8DFD3 / #CFC3B4. Dark: #1C1714 ground, #F4EDE4 / #BCB0A3 text, #FFB52E accent.
- Fonts: Fraunces from the repo (`assets/fonts/Fraunces-Variable.ttf`, uploaded `/_blob/1b380815dc0a7033d71adffd1820440f`; axes opsz, wght, SOFT, WONK). Headlines Fraunces 750 with `SOFT` 100; story titles Fraunces 600; UI text the platform sans stack, as in the app.
- Visuals: the app's transparent illustrations `assets/images/content/*.png` (1520 px), the ten style samples `assets/images/styles/*.png` (only 252 x 455, they soften when enlarged), bee logo `assets/images/logos/logo.png`. Flat pastel grounds per frame (honey #FFE9B8, sky #D6EAF8, peach #FFDCC8, mint #D9EFD8, dark #1C1714, lilac #E7DEF6, rose #FCE3EC), white sparkles, one tilted honey highlight word per headline.
- Real UI: buttons are honey stadiums; recipe tokens are #FFEDC7 pills with #9A5B00 text and a chevron; Create has no bottom nav; covers 4:3 radius 16.

## Demo cast

Leo, 5 (My child; the boy under the yellow blanket, `content/1-1.png`), Biscuit (his toy pup, `content/2-1.png`), Grandma Rose (`content/5.png`), Mum (records her voice). Stories: "Leo and the Moon Library", "Biscuit and the Tiny Door", "The Night the Stars Got Lost", "Why Leaves Turn Orange". Playlist "Bedtime favourites". Narrators Mimi, Grandpa, Captain (real built-in voices).

## Frame order (7 per set: iPhone 6.3" and 6.9", Play, iPad)

| # | Headline | Proof |
|---|---|---|
| 1 | Tonight's story stars **your kid.** | Story card (cover, title, meta, Listen, Narrations), "Written for Leo / Drawn page by page / Read aloud" pills, chapter snippet, boy under blanket. No phone. |
| 2 | One sentence in. **A whole book** out. | Create screen in a phone, Surprise me and Listening chips, lifted recipe card. |
| 3 | Same story. **Ten ways** to draw it. | Pick a look sheet (6 styles) plus 4 tilted prints: all ten. |
| 4 | Put your kid **in the story.** | New character form, portrait tiles Leo, Biscuit, Grandma Rose. |
| 5 | Away tonight? **Your voice** still reads. | Dark: Record a voice card (recording state), "Mum · Ready to use", mum-with-mic illustration. Premium note. |
| 6 | Lights off. **Story on.** | Player in a phone, Narration card, Bedtime favourites mosaic, girl in headphones. Premium note. |
| 7 | Big questions **become stories.** | Educational switch, "Why do leaves change colour in autumn?", four approaches, seven language chips. |

Plus the Play feature graphic: bee logo, "StoryBee", "Bedtime stories starring your kid", Leo under his blanket.

## How the user steered it

1. References: pastel finance-app cards, a playful kids' learning app with big illustrated children, a warm illustrated kids' app. Lots of visuals, the repo's fonts, human copy.
2. App Store Connect rejected the sizes: add the required 6.3" set; exports come out 2x with alpha, so run the normalize script.
3. The frame 1 cover image was missing from the export: no images inside rounded clipping, pre-crop portraits, bezel on top.
4. Commit when asked; keep the skill updated with what was learned.

## Before the next upload

- **2.3.3 (2026-11-11, canvas v36):** iPhone, 6.3" and Play frames are 7 of 7 app in use, each a real render from `tool/screens/store_screens_test.dart` (`flutter test tool/screens/store_screens_test.dart`, about 45 s, output `build/store-renders`; screens: story page, Create, Pick a look, New character, Record a voice dark, player, Educational + Learning approach) in a device under the headline. iPad 1, 2, 3, 6 use iPad renders (4 of 7); 4, 5, 7 still use Art boards: add iPad renders of character, voice and Educational and convert them. Renders use Roboto as the UI sans, not SF Pro.
