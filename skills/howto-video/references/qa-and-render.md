# QA, render and delivery

## Before showing the user (gate 2)

Run these from the HyperFrames project directory. `hf` below stands for
`node ../.claude/skills/hyperframes/scripts/plugin-cli.mjs` (adjust the path). Write the full command each
time: the shell may be zsh, where a command stored in a variable doesn't split into words.

1. `command cp -f ../tools/roots/<slug>-h.html index.html && hf lint`: **0 errors**. Warnings are fine
   only if they're understood (the CJK `font_face_local_only` warning, for example).
2. Snapshot every scene **near its end**, when all its elements are in, in both sizes:
   `hf snapshot --at 0,<start+len-0.5>,… --no-end -o ../work/snap-h`, then the same for `-v`. Read
   `contact-sheet-*.jpg` and look:
   - frame 0 reads alone (headline + visual);
   - nothing clipped (long URLs, the last button in a dialog, text in chips);
   - nothing overlapping (toasts over buttons, a big logo over the QR, captions over UI);
   - 9:16 text inside y 168–1330; captions don't hide anything that matters;
   - mid-action moments too (typing, a dialog mid-scroll, where the cursor is when it clicks): add
     times for scenes with interactions.
3. QR: `node <skill>/scripts/qr-check.mjs ../work/snap-h/frame-NN-at-….png` decodes the URL.
4. Voice: transcribe the joined lines and compare them with the script (see audio.md).
5. Fix, rebuild, re-snapshot only the times that changed (`--at` a few times, both sizes).

Then show the user the contact sheets (paths) and a short list of what changed. **Wait for approval to
render.**

## Render (gate 3)

```bash
command cp -f ../tools/roots/<slug>-h.html index.html && hf render --quality delivery -o ../deliver/<slug>/<slug>-16x9.mp4
command cp -f ../tools/roots/<slug>-v.html index.html && hf render --quality delivery -o ../deliver/<slug>/<slug>-9x16.mp4
bash <skill>/scripts/check-render.sh ../deliver/<slug>/<slug>-16x9.mp4 <root length>
bash <skill>/scripts/check-render.sh ../deliver/<slug>/<slug>-9x16.mp4 <root length>
```

Renders take about 1–3 minutes each; run them in the background. Afterwards, pull frames from the
**actual MP4s** (`ffmpeg -i x.mp4 -vf "select='eq(n\,0)+eq(n\,700)+…',scale=-2:360,tile=5x1" -frames:v 1
-fps_mode passthrough sheet.jpg`) and look at them.

## Thumbnail

Build it as its own composition (the template's `THUMB`): 1920×1080, a 130–150 px headline (at most
6 words, one chip), the hero visual, two pills with the paths or benefits, and the logo lockup top-left.
Keep the bottom-right corner empty (YouTube's duration badge sits there). Snapshot at 0.5 s and scale it
with `ffmpeg -vf scale=1280:720:flags=lanczos -q:v 2 thumbnail.jpg` (under 2 MB). Keep the owner's rules:
no banned numbers on the thumbnail either.

## youtube.md (write it next to the videos)

```markdown
# <Video>: YouTube copy

## 1 · <slug>-16x9.mp4 (YouTube video)
### Title (2–3 options, under 70 characters, recommended first; no banned words)
### Description
<hook line>
<one paragraph per path or step, each with its link + UTM: ?utm_source=youtube&utm_medium=video&utm_campaign=<slug>>
<the honest caveat>
Chapters            ← first at 0:00, at least 3, each at least 10 s (from the scene starts)
0:00 …
<CTA + link>
#Tag1 #Tag2 #Tag3   ← the first three show above the title
### Tags (comma list, ≤ 500 characters: count them)
### Upload settings (audience / made for kids, category, paid promotion, altered or synthetic content, thumbnail, end screen kept off the QR)
### Pinned comment

## 2 · <slug>-9x16.mp4 (Short)
Title with #Shorts (the first ~40 characters show), short description, utm_medium=shorts, the related-video link.

## Social captions (Instagram, TikTok, LinkedIn)
```

Check the copy with a script: title lengths, tag characters, banned words or symbols (`$`, "best",
"AI" in titles if the brand bans it), and that chapter times match the scene starts.

## Delivery checklist

- [ ] both MP4s: duration = root, −14 to −16 LUFS, peak ≤ −1 dBTP, frames checked
- [ ] the QR decodes to the right URL
- [ ] thumbnail.jpg 1280×720
- [ ] youtube.md with chapters, tags and settings
- [ ] the plan updated (status, actual credits spent, the commands to rebuild)
- [ ] commit (only when asked): the generator, lines, the voice manifest and audio, roots, assets;
      never `deliver/` or scratch folders
