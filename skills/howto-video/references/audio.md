# Audio: voice, music, UI sounds, mix

## Voice (ElevenLabs)

- **Pick one voice** for the whole video. Use the brand's voice if it has one; otherwise list
  candidates with `node <skill>/scripts/el.mjs voices` and let the user choose (say the plan's
  choice in the plan). The model is in `lines.json` (`eleven_v4`, or `eleven_multilingual_v2` for
  non-English).
- `tools/lines.json`:

```json
{ "voice": "<voice_id>", "model": "eleven_v4",
  "lines": [ { "id": "EX01", "text": "Your bedtime stories can pay you back. Here are two ways." } ] }
```

- **Cost first:** `node <skill>/scripts/tts.mjs --lines tools/lines.json --dry-run EX01 EX02 …` prints the
  characters, which is roughly the credits (about 1 per character; check the plan). Say the figure in
  the plan; generate only after approval and only the ids you need (the script refuses to run with no
  ids unless you pass `--all`).
- Generate: `node <skill>/scripts/tts.mjs --lines tools/lines.json --out video/assets/vo EX01 …`. It writes
  `<id>.mp3`, `<id>.wav` (−16 LUFS, 48 kHz) and adds `{seconds, speechEnd, words:[{w,s,e}]}` to
  `manifest.json`. It runs one request at a time (many plans allow only 2 concurrent requests).
- **Reuse** existing lines where the words fit, instead of paying again.
- **Writing for the ear:** 12–15 characters per second; spell numbers as words when they're spoken
  ("twenty percent", "ten thousand"); the headline can show "20%". URLs read naturally ("example.app").
  Write plain sentences, no stage directions.
- **Check pronunciation:** concatenate the lines and transcribe locally
  (`node .claude/skills/hyperframes/scripts/plugin-cli.mjs transcribe all.wav --json` from the project).
  Brand names may come back misspelled ("StoryB"); listen for what matters: numbers, URLs and names.

## Music

In order of preference:

1. **Music the product owns** (a launch film score, a brand sting): free and on-brand. Find its sections
   and its final hit: `plugin-cli.mjs beats <file> --json` for the beat grid, and a 0.5 s loudness trace
   for the structure (`ffmpeg … -ac 1 -ar 8000 -f s16le -` and an RMS per window).
2. **A free library track** (the `media-use` skill: bundled or Openverse with credit).
3. **An ElevenLabs bed** (`node <skill>/scripts/music.mjs …`): about 1,100 credits for 40 s. Ask first. Use
   120 BPM so beats fall on the 0.5 s grid, instrumental, "one big final hit, then ring out".

**Fit it to the video** with `python3 <skill>/scripts/fit-music.py`. It takes the source, the video
length, the end-card length, the source's final-hit time and optional cut points, and writes a −16 LUFS
WAV whose final hit lands 1.5–2 s into the end card (where the logo settles). When the source is longer,
drop whole bars from a quiet section (cut on bar lines; beat detectors report onsets ~45 ms early, so
subtract the lead). Put the join on a scene cut.

## UI sounds

Every visible action gets a short sound at low volume (0.2–0.5): `key` while typing (every third
character), `click` on presses, `toggle` on checkboxes, `pop` on chips and cards, `swish`/`whoosh` on
scene entrances and section cards, `tick` on counters, `chime` on success (toast, "Copied!"),
`slam` on the logo's final hit. Use the project's library or the `media-use` bundled set; put the files
in `video/assets/sfx/` and give each one its peak offset (the generator lines the peak up with the
action).

## Mix targets

- The voice track at volume 1; the music at 0.6, ducked to 0.15 under each line (0.15 s before to
  0.3 s after); SFX 0.2–0.55.
- Final: integrated −14 to −16 LUFS, true peak ≤ −1 dBTP. Check with `scripts/check-render.sh`.
