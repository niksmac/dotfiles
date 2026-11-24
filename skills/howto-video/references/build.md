# Build: scenes, real UI, two sizes, logo, QR

Start from `<skill>/assets/generator-template.mjs` (copy it to `tools/build-<slug>.mjs`). It's a working
engine with example scenes. Read the `hyperframes` skill first for the render contract.

## How the generator works

- **One scene list, two sizes.** `FMT.h` is 1920×1080 and `FMT.v` is 1080×1920. Each scene draws its
  visual inside a fixed **900×700 stage**. 16:9 places the stage on the right with the headline in a
  left column; 9:16 places the headline on top and the stage below it. Design every stage once, at
  900×700.
- **Scene object:** `{ vo, minLen, ground, night?, eyebrow, lines:[{t, at}], build(id, len, f) → {html, css, js, sfx} }`.
  `lines` is the headline: `**phrase**` sits on a highlight chip; `at: null` means it's on screen at frame 0
  (use that for the hook). `build` returns stage markup, CSS, GSAP code on `tl`, and SFX
  `[name, time, volume]`. `f` is the format, for the rare scene that needs a different layout (the end card).
- **Lengths:** `max(minLen, ceil_to_0.5(0.15 + voice seconds + 0.35))`. The voice starts 0.15 s into its scene.
- **Word-timed motion:** `wordAt("EX05", /^tick$/i)` returns the scene time of a word in that voice
  line, so a click or pop lands as the word is said.
- **Outputs:** `compositions/<prefix>-NN-<h|v>.html` (one per scene per size), `cap-<prefix>-<h|v>.html`
  (captions), roots `tools/roots/<slug>-<h|v>.html` (scene hosts, voice on track 7, music on track 8 with
  a volume automation that ducks 0.6 → 0.15 under each line, SFX lanes 9+), plus `<slug>.json` (scene
  starts and total length, read by `fit-music.py`), and a thumbnail root.
- **Previewing a size:** HyperFrames allows one root per project, so copy it in:
  `cp tools/roots/<slug>-h.html video/index.html` (zsh may alias `cp` to `cp -i`; use `command cp -f`).
  Don't snapshot while a render runs, because both use `index.html`.

## Helpers in the template

| Helper | Use |
|---|---|
| `headline(id, f, {eyebrow, lines, night})` | eyebrow + word-by-word blur-in headline with one chip |
| `typed(id, text, at, cps)` | characters appear one by one; returns `{html, js, end, keys}` (`keys` = times for key SFX) |
| `cursorPath(id, [[x, y, at, click?], …])` | a pointer that glides between points and presses on clicks; returns the click times |
| `pop(sel, at)`, `fadeUp(sel, at)`, `press(sel, at)` | entrances (with `gsap.set` hiding at frame 0) and button presses |
| `CHECK()`, `CURSOR` | inline SVG check mark and pointer |
| `.wcard`, `.tag`, `.num`, `.frame`, `.panel` | a web card, a pill, a big step number, a framed illustration, a dark app panel for footage |

## Rebuilding real UI from code

1. Find the component behind the step (`grep -rn "Make this a Podcast" components`). Copy its **labels,
   field order, states and messages** exactly ("You have 0/2 podcasts", "Copied!", "Playlist created").
2. Take the tokens: primary colour, border, muted text, radius, shadow, heading and body fonts
   (`tailwind.config.*`, `globals.css`; shadcn HSL variables convert to hex). Add the fonts as
   `@font-face` files in `assets/fonts/`.
3. **Scale for video:** web UI at 1× is unreadable in a 1080p frame. Use about 1.5–1.7× the web sizes
   (16 px body → 24–27 px, 14 px → 21–22 px, headings 40–44 px), and keep cards 560–900 px wide.
4. **Animate the real interaction:** type into a field (`typed` + key SFX), move the cursor and click
   (`cursorPath` + click SFX), fill a checkbox (toggle SFX), expand a section, scroll the dialog content
   (`translateY` on an inner wrapper), show a toast. Each step needs a visual change and a sound.
5. **Containers:** never give an expanding section a fixed height smaller than its content; compute it,
   or snapshot after the expansion to check the last control is visible.
6. **Cursor in scrolling content:** put the cursor element inside the scrolling wrapper and use that
   wrapper's coordinates. The SVG tip sits about (4, 3) px from its corner.
7. Use a placeholder only where a real value is private (`yourname`, `…/podcast/<name>`). Never invent
   a URL format, price or number.

## Screenshots and recordings

- **Screenshots** (`assets/shots/`): put them in a device or browser frame (`.frame`), use slow push-ins,
  and point at the action with a highlight ring or cursor. Crop to the region that matters.
- **Recordings:** `<video class="clip" … muted>` inside a rounded `.panel`. To show part of a 9:16
  recording, size the video to the panel's scale and offset it with `top`/`left` inside an
  `overflow:hidden` wrapper (time the `<video>`, never its wrapper). Keep any text burned into the footage
  from clashing with your headline (crop it out).
- Footage that is **sped up** needs a small "Sped up for the video" note.

## Illustrations from the product's site

Page illustrations (hero art, step images) are on-brand and free. Copy them to `assets/<slug>/`, check
the size (a 480 px image upscaled to 900 px is soft, which is fine in motion and on a thumbnail), and use
transparent cut-outs over a soft circle (`.disc`) on the scene ground.

## Logo animation

- **Use the brand's own animated logo** when there is one (ask if you can't find it). A home-made
  animation of their mark is likely to be rejected.
- **GIF:** `bash <skill>/scripts/logo-sprite.sh logo.gif video/assets/brand/logo-anim` → a keyed PNG sprite and
  `logo-anim.json` (frames, fps, grid). Step `background-position` on the timeline at the GIF's fps
  (frame `k % frames`), as the template's end card does. A GIF `<img>` plays on wall-clock time and
  won't be frame-accurate in a render.
- **Video logo** (MP4/WebM): use it as a timed `<video>`; key out a solid background with ffmpeg first
  if needed.
- **Static logo only:** a simple scale-and-settle on the music's final hit, and ask the user if they
  have an animated version.
- **Wordmark:** if the wordmark file already includes the mark, set `WORDMARK.cropLeft` (the mark's share of
  the width) so the lockup doesn't show the logo twice.
- The mark usually appears **once, on the end card** (check the brand rules). Pattern: it flies in big,
  hovers, and settles into the lockup next to the wordmark on the final hit. Keep the area under its big
  pose clear in **both** sizes; in 9:16 bring the QR or CTA in after it settles.

## End card and QR

- `node <skill>/scripts/qr.mjs "<url>" video/assets/<slug>/qr.svg`: an ink-on-transparent SVG, error
  correction M. Put it on a white card with a dark border; at least 420 px in 16:9 and 460 px in 9:16.
- Point it at the landing page or guide the video is about (add UTM parameters to description links,
  but keep the QR URL short, because a shorter URL makes a less dense code).
- After the first snapshot, decode it: `node <skill>/scripts/qr-check.mjs frame.png`.

## Layout rules that held up

- **9:16:** text stays between y 168 and 1330 (platform UI covers the rest); captions at y ≈ 1215,
  50 px. Eyebrow at 180, headline at 240 (84 px), stage top at 500.
- **16:9:** headline column x 100–860 at 80 px, stage at x 900, y 160, scaled 1.08; captions at y ≈ 958, 44 px.
- One highlight chip per headline. Keep chip phrases to ~19 characters or they overflow in 16:9.
- Grounds: the brand's flat colours, one per scene, alternated; a dark ground for "night" or
  section cards.
- Hide anything that enters later with `gsap.set` at frame 0 (the lint checks this). No `Math.random`;
  if you need scatter, seed it at build time.
- The same image twice in one scene triggers a lint warning: use `background-image` for one of them.
