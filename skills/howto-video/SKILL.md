---
name: howto-video
description: Make a how-to or explainer video for a product (a website, web app or mobile app) from its real UI, using HyperFrames for the picture and ElevenLabs for the voice, in 16:9 and 9:16. Reads the product's site, app code and screenshots, writes an ICP, plans the script and storyboard with costs, waits for confirmation, builds and checks, and renders only after approval. Use it whenever someone wants a product video, feature walkthrough, tutorial, explainer, onboarding video, "how it works" video, promo or launch reel, YouTube video or Short about their app, or wants to turn pages, docs or screenshots into a video, even if they don't name HyperFrames or ElevenLabs.
---

# How-to and explainer videos from a real product

This skill makes a short narrated video (usually 30–90 s) that shows how a product works or why it matters, built
from the product's **real** screens, copy and brand. Two masters come from one set of scenes: **16:9**
(YouTube, website) and **9:16** (Shorts, Reels, TikTok). HyperFrames renders HTML to video, ElevenLabs
provides the voice (and optionally music), and real UI is rebuilt from the product's code or cut from
screenshots and recordings.

The workflow has **three gates**, because the expensive or public steps can't be undone:

1. **The plan** (ICP, script, storyboard, costs). Nothing is spent before the user approves it.
2. **The look** (snapshots of every scene in both sizes), shown before rendering.
3. **The render**, run only when the user says so.

Say the cost before spending anything (ElevenLabs credits, long renders), and get the user's OK.

## 0 · Setup checks (first time in a project)

- **HyperFrames:** the skills `hyperframes`, `hyperframes-cli` and `media-use` should be installed in the
  project (`.claude/skills/hyperframes/…`). If they're missing, offer `npx skills add heygen-com/hyperframes`.
  The CLI runs as `node .claude/skills/hyperframes/scripts/plugin-cli.mjs <command>` from inside the
  HyperFrames project directory. Read the `hyperframes` skill before writing scenes: it has the render
  contract (clip classes, paused timelines, no `Math.random`, and so on).
- **Headless Chrome:** HyperFrames `snapshot`, `check` and `render` drive a headless Chrome. If the user's
  instructions (CLAUDE.md) forbid headless browsers, ask for an explicit exception for this project
  before the first snapshot, and record it in the project's memory or notes. Don't work around it.
- **ElevenLabs:** `scripts/el.mjs` finds `ELEVENLABS_API_KEY` in the environment or in `.env.local` or
  `.env` in the current directory and its parents. If there's none, ask where the key lives. Never
  print it. Check the balance with `node <skill>/scripts/el.mjs usage`.
- **Layout:** if the project has no video setup yet, use this one (existing projects keep theirs):

```
video/                    the HyperFrames project (index.html = whichever root is being previewed)
  compositions/  assets/{vo,music,sfx,fonts,brand,shots,ui}
tools/build-<slug>.mjs    the scene generator (from assets/generator-template.mjs)
tools/lines.json          voice lines (id, text) + voice and model
tools/roots/<slug>-h.html, <slug>-v.html, <slug>-thumb.html
ICP-<slug>.md  PLAN-<slug>.md
deliver/<slug>/           renders, thumbnail, youtube.md (keep it out of git)
```

`<skill>` below means this skill's base directory.

## 1 · Discover the product and write the ICP

Read the sources before writing a word of script; the video's credibility comes from using the product's
own claims, screens and words. Follow `references/discovery-and-icp.md`:

- **The pages the user gave you**, plus pricing, FAQ, help and landing pages. Fetch them as text:
  `curl -sL URL | pandoc -f html -t plain` (or `textutil` on macOS). Never paste raw HTML into the context.
- **The app's code** (web or mobile), if available: the components behind the flow you'll show (exact
  labels, states, colours, fonts, design tokens), and anything that contradicts the site.
- **Existing assets:** brand sheet, logo (and any **animated logo**), illustrations on the site, app
  screenshots, screen recordings, launch films, music the product owns.
- **The rules:** brand and claims docs (what may and may not be said).

Write `ICP-<slug>.md` (template in the reference): who the video is for, the moment they're in, what
they need to see, the objections to answer, the words they use, where they'll watch, and the one action
it asks for. Then list the **claims you may use** (each with its source), the **claims to avoid**, and the
**contradictions** you found between sources (site vs app vs docs). Contradictions become questions for
the user or wording that avoids the number.

## 2 · Plan, and stop for confirmation

Write `PLAN-<slug>.md` from `references/plan-template.md`, then present a short summary in chat:

- the message in one line, the formats and the length;
- a scene-by-scene storyboard: each scene's length, visual (and its source: rebuilt UI from `file.jsx`,
  screenshot, footage, illustration), the voice line, on-screen headline and sounds;
- audio: voice (ElevenLabs voice and model), music (owned or free first, a generated bed only if it's
  worth the cost), UI sounds;
- **costs:** TTS characters ≈ credits (from `node <skill>/scripts/tts.mjs --dry-run`), music, renders;
- the truth checks applied, and **open decisions** for the user (numbers on screen, which screens,
  the CTA and QR target, end card text).

Then **stop and wait**. Don't generate voice or build scenes until the user approves; fold their
answers into the plan (an "Owner decisions" section) so later sessions keep them.

## 3 · Build

Follow `references/build.md` and `references/audio.md`. In short:

1. **Voice:** add lines to `tools/lines.json`, then `node <skill>/scripts/tts.mjs --lines tools/lines.json --out video/assets/vo <ids…>`.
   It writes `.mp3`, a −16 LUFS 48 kHz `.wav` and word timings to `manifest.json`. Scene lengths come
   from the measured lines, rounded up to the beat grid.
2. **Generator:** copy `<skill>/assets/generator-template.mjs` to `tools/build-<slug>.mjs` and write the
   scenes. One generator writes every scene in both sizes, the captions (from word timings), the
   voice track, the ducked music and the SFX lanes, plus a root per size and a thumbnail root.
3. **Real UI:** rebuild product screens in HTML from the app's components and tokens (crisp at any
   size, and animatable: typing, cursor clicks, toggles, toasts). Use screenshots or recordings where
   the code isn't available. Never invent UI the product doesn't have.
4. **Logo:** if the product has an animated logo (GIF, video, Lottie), use it, never a home-made
   substitute. A GIF becomes a keyed sprite stepped on the timeline (`scripts/logo-sprite.sh`), because a
   GIF `<img>` plays on wall-clock time and isn't frame-accurate in a render.
5. **End card:** the logo, the URL, the CTA, and a **QR code** to the landing page (`scripts/qr.mjs`).
   Give it ~6 s so people can scan.
6. **Music:** fit a bed so its final hit lands on the end card (`scripts/fit-music.py`).

## 4 · Check, then show the user (gate 2)

Follow `references/qa-and-render.md`: lint (0 errors), snapshot every scene near its end **in both
sizes**, and LOOK at each sheet. Check frame 0 (it's the thumbnail), clipped or overlapping elements,
text inside the safe areas, and captions not covering UI. Decode the QR from a snapshot
(`scripts/qr-check.mjs`), and transcribe the voice locally to catch mispronunciations. Fix what you find,
re-snapshot, then show the user the contact sheets and say what's ready. **Wait for "render".**

## 5 · Render and deliver (gate 3)

Render both sizes, then run `scripts/check-render.sh` on each file (the duration matches the root;
loudness is about −14 to −16 LUFS with true peak ≤ −1 dBTP). Pull a few frames from the actual MP4s and
look at them. Deliver to `deliver/<slug>/`: the two MP4s, a thumbnail (1280×720 JPG built as its own
composition, not just frame 0) and `youtube.md` (titles, description with chapters, tags, hashtags,
upload settings, a pinned comment, a Shorts variant and social captions). Templates are in the QA
reference. Commit only when the user asks; keep `deliver/` out of git.

## Things that went wrong before (and the fix)

- A user rejected a home-made logo animation: **use their own animated logo** whenever one exists, and
  ask for it if you can't find one.
- An expanding dialog section had a fixed height and clipped the last button. Size containers to their
  content, and snapshot after every expand or scroll.
- A cursor positioned in page coordinates drifted when its dialog scrolled. Put the cursor inside the
  scrolling container and give its coordinates in that box.
- In 9:16, a big hovering logo covered the QR card. Stagger entrances per format.
- Lint warned about the same image used twice in one scene. Make one copy a CSS `background-image`.
- Site and app disagreed on a number (seconds, language counts). Leave the number out, or ask.
- A plan was approved with an extra rule ("percentages are fine, never dollar amounts"). Write the
  owner's rules into the plan and follow them in every later artifact (thumbnail, YouTube copy).
