# Merrin profile

## Live canvas and repo copy

- **iOS app (iPhone, 6.3", iPad, App Store header + search): v2 canvas https://claude.ai/artifact/4Ng47sXFVpw93UGnYvd4z5** ("Merrin iOS store screenshots v2", built 2026-11-25). Revise this one for anything iOS; never go back to the v1 iOS frames. Plan + repo copy: `_coder/plans/124_plan_store-screenshots-v2-conversion.md` (section 0 = current design, asset URL table) and `_coder/plans/124_plan_store-screenshots-v2-conversion/` (`project/` + `assets/`). Fonts: Allo Bold headlines (`/_blob/b96b8ea9cf52686e1832bd9e82cc46f0`, OFL, github.com/joshpuckett/allo v1.1.0), Nunito for all other text. Listing it serves (doc 020): iOS "Merrin: Offline Personal AI" / "Private chat, voice & memory"; Play title "Merrin: Offline Personal AI", short description "Private chat, voice & memory, on your phone. Works offline, no account needed."
- **Google Play (phone set + feature graphic) is on the v2 canvas too** (row at y 12482, 2026-11-25): Play frames import the iPhone frames with `platform="android"` (camera hole, "phone"). Plan 124 section 0.1.
- **v1 canvas (Mac row only):** https://claude.ai/artifact/YAkCQkaGhpbP5guxeounN8 ("Merrin store screenshots", Design type). Its iPhone, 6.3", iPad, creative-asset and Play rows are superseded by v2; don't upload them. Version 29 = the repo copy (real app renders as flat JPEG screens in every phone and iPad frame, 6.3" row; PNG export checked by the user 2026-11-11).
- Repo copy: `_coder/plans/067_plan_store-screenshots-growth/` (`project/` + `assets/`); plan `_coder/plans/067_plan_store-screenshots-growth.md` (section 0 = current design, asset URL table). After a canvas change, refresh the copy and the plan's version line.
- Uploaded assets: mascot idle `/_blob/e9c782274fccf9854d7192f1d8131179`, happy `/_blob/1095cf6555b27a6fe47309b0afd52948`, listening `/_blob/4d4d947e3565c8fec5e29cbbecc7b0e0` (from `assets/merrin/*.svg`); photos mom and baby `/_blob/c6b4d7566dd43246b149274fcd72579c`, piggy-back `/_blob/812b7dc6a8549d0d48397db2d715de0d`. Real renders (iPhone / iPad, from `tool/screens/store_screens_test.dart`, files `assets/render-*.png`): the table in plan 067 section 0.
- Older reference designs and graphics: `_coder/logs/graphics/` (gitignored).
- **Before the next upload:** the phone, 6.3" and iPad frames use the bezel-on-top recipe (2026-11-11). The Mac row still predates the export fixes: convert it to bezel on top and check for images inside rounded `overflow: hidden` boxes; then export through `scripts/normalize-exports.sh`.
- **2.3.3 (2026-11-11):** iPhone, 6.3", Play and iPad frames are 7 of 7 app in use: each shows a real render (`tool/screens/store_screens_test.dart`: Today, You/Life right now, offline chat dark, image detail, remembering chat, Coach chat, Insights) in a device under the headline, with lifted cards and bubbles in the margins or over empty screen areas. Re-render and re-upload when the UI changes. **Mac row still 3 of 7** (1, 3, 5 show the window): add real desktop renders (`desktop_chat`/`desktop_shell` harnesses) to at least one more frame, ideally all.

## Positioning (follow https://merrin.xyz/, not old repo copy)

- "Your personal intelligence." Private and memory-aware, conversation first.
- **Never "journal"** in captions, keywords or the feature graphic (the app still has an Entries tab; marketing doesn't lead with it). Never "friend", "companion" (as a claim), "therapy", "therapist".
- Line that tested well with the user: "Private, even from us."

## Claims (checked against the code; add new ones only after checking the same way)

| Use | Note |
|---|---|
| Runs on your phone / no cloud AI | inference is on device |
| Works offline | always qualify: "after a one-time model download" |
| No account | no sign-in in the app |
| No ads | no ad SDK |
| Private, even from us | no account, no readable server copy, sync end-to-end encrypted |
| Read on your phone, not in the cloud | image reading is on device; images aren't synced |
| Languages | English, Español, Français, Deutsch, Português |
| **Never** "Nothing leaves your phone" | model downloads, opt-in sync and the relay exist |
| **Never** numbers (accuracy, speed, users), scores, streaks, minutes spoken | DESIGN.md *Numbers*: counts and dates only |

Pro (note it in fine print on the frame): Devil's Advocate and Future You perspectives, weekly reflections, Gemma 4 E4B, away-from-home sync. No prices.

## Brand (DESIGN.md "Ether Moss")

- Ivory #F2F0E8 (default ground), Ink #201D22, Lumen #E2F68B (accent: fills and highlighter only, never text on light), #E9E6DD, mist #D5DFDB, copperSoft #E8D9D2.
- Text greys: #5F5A60 (sub-lines), #6B656C (fine print), #7D5E53 (card labels). Card border #E0DCD1. Dark frame ground Ink with #A9B8B2 secondary text.
- Fonts: **store art for iOS (v2): Allo Bold headlines + Nunito text** (the user chose them 2026-11-25). The app UI itself and the v1 Mac/Play rows use DM Serif Display (headlines) + Inter; Caveat only for handwritten props (a recipe card).
- Persona colours (bg / fg): listener #EDE3EC / #7A5675, coach #E6ECCB / #56622A, advocate #F0DCD8 / #9A4A45, future #E8D9D2 / #6E5248.
- Mascot: idle, happy, listening SVGs; used as a character, not a logo stamp.

## Demo cast

Maya: new job, training for a 10K, considering a new role. Leah: her sister, into pottery. Claire: her new manager (the render fixtures renamed Priya to Claire; follow the renders). Recurring items: "Book the pottery class", "Finish the 10K under an hour", "Settle into the new job", "Speaking up at work". Relative dates ("Tomorrow", "Yesterday", weekday names), never dates that age the set. No real brands, people or readable personal data.

## Frame order, iOS v2 (7 per set; iPhone 6.9", 6.3", iPad), 2026-11-25

| # | Headline / sub | Proof (real render) | Ground |
|---|---|---|---|
| 1 | Personal AI with memory. Zero cloud. (user's line, 2026-11-25) / Runs on your iPhone. No account. (fine: The AI runs offline after a one-time model download; always keep it with "Zero cloud") | Remembering chat + Remembered and Claire cards | Lumen |
| 2 | Private, even from us. / No cloud AI. No ads. Nothing to sign up for. | Offline dark chat + lifted offline pill; fine print one-time download | Ink |
| 3 | Just talk. Merrin listens. / Speak or type. Merrin can answer out loud. | Today screen + speech bubbles; 5 languages fine print | Ivory |
| 4 | Knows the people in your life. / People and plans, from your chats. | Life right now + plan card | Mist |
| 5 | Ask about your photos. / Photos, notes and receipts, read on your phone. | Image detail + What Merrin sees card | Ivory |
| 6 | Decide with clarity. / Ask a listener, a coach or a devil's advocate. | Coach chat + Devil's Advocate / Future You (Pro) | Copper |
| 7 | See your week in one read. / A weekly reflection and the threads that keep coming back. | Insights (Pro) | #E9E6DD |

Frames 1-3 = search billboard: what it is, why it's different, how you use it. Device 1200 px wide (1.17x v1) so app text reads on the product page. Research and test roadmap: plan 124.

## Frame order, v1 (superseded; Mac row kept)

| # | Headline / sub | Proof |
|---|---|---|
| 1 | Think out loud. Find clarity. / Talk or type. Merrin helps you sort it out. | Maya's thoughts as floating bubbles, listening mascot, enlarged "Tell Merrin anything" input, the 5 languages. No phone. |
| 2 | Your life, at a glance. / Merrin maps the people and plans shaping your days. | The real "Life right now" card enlarged (dark), mascot with lines to five items; item sheet with "Ask Merrin about this"; fine print "Built from your chats. Edit or forget anything." |
| 3 | Private, even from us. / No account. No cloud AI. Works offline. | Dark frame, offline chat screen, "Offline — working as usual" pill, "Offline after a one-time model download". |
| 4 | Your photos, remembered. / Merrin reads photos, notes and receipts, and finds them when you ask. | Two family photo prints, "What Merrin sees" card (caption of the real photo, tags, "Read by Merrin, may contain mistakes"), Nana's handwritten apple cake recipe, the question and Merrin's answer with an image chip, "Read on your phone, not in the cloud." |
| 5 | Never explain yourself twice. / Merrin remembers people, plans and what you said last week. | Chat screen in a phone with lifted memory, person and reminder cards. |
| 6 | See it from another angle. / Ask for a listener, a coach or a devil's advocate. | Persona replies to "Should I take the new role?"; Pro note for Devil's Advocate and Future You. |
| 7 | Get to know yourself / A weekly reflection and the threads that keep coming back. | Weekly reflection card, topic threads, open to-dos; Pro note. |

v1 note: frames 1 to 3 were the App Store search billboard, killer features at 2 and 4. Play uses 7 of 8 slots. Play now uses the v2 frames. v2 feature graphic: lime, "Personal AI with memory." / "Runs on your phone. No cloud AI. No account.", text only.

## Mac App Store set (separate listing, `merrin-origin`)

2880 x 1800 (16:10), 7 frames in the canvas's Mac row (y 10200), plan 067 section 10. Shared `MacChat` artboard (screens row) draws the real desktop window at 1440 x 900: title bar with window buttons, sidebar (Merrin, Journal, You, Insights, Devices, Models, Activity, Settings), today's chats, chat, "In this chat" pane; tweaks `offline`, `syncing`. Order: 1 Never explain twice (window), 2 Life at a glance, 3 Private (dark, window offline), 4 Photos, 5 Pick up where you left off (iPhone + Mac, syncing), 6 More room to think (Solace models; 16 GB fine print), 7 Another angle. Mac claims: "on your Mac", Solace 12 needs 16 GB, longer chats (8K context), sync end-to-end encrypted and optional, away-from-home sync Pro. Never Windows, Linux, Android or license keys.

## How the user steered it (keep doing this)

1. A growth plan first (specs, ASO levers), then the canvas.
2. "True to the code" was not enough: people want to see how the app improves their life. Benefit-first, creative layouts after the user's references (Joe & the Juice, ElevenLabs, a to-do planner app): big headline, lifted cards, cropped or no phone.
3. Asked for the Play feature graphic and iPad set: make every set together.
4. Dropped "journal" and followed merrin.xyz.
5. Showcase Life right now and image/document understanding as killer features.
6. Image frame must make photos feel possible: a family angle, then real stock photos instead of drawn illustrations.
7. Save the designs into `_coder` with the plan; commit when asked.
