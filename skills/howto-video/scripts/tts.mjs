// Voice lines with ElevenLabs, with word timings for captions and word-timed motion.
//   node <skill>/scripts/tts.mjs --lines tools/lines.json --dry-run [ids…]      characters ≈ credits, spends nothing
//   node <skill>/scripts/tts.mjs --lines tools/lines.json --out video/assets/vo EX01 EX02 …
//   (--all generates every line; without ids or --all it refuses, so credits are never spent by accident)
// lines.json: { "voice": "<voice_id>", "model": "eleven_v4", "lines": [{ "id": "EX01", "text": "…", "style": "read"? }] }
// Writes <out>/<id>.mp3, <out>/<id>.wav (−16 LUFS, 48 kHz) and <out>/manifest.json:
//   { lines: { <id>: { id, text, file, seconds, speechStart, speechEnd, words: [{ w, s, e }] } } }
// One request at a time (many plans allow 2 concurrent requests).
import { execFileSync } from "node:child_process";
import { mkdirSync, readFileSync, writeFileSync, existsSync } from "node:fs";
import { el } from "./el.mjs";

const a = process.argv.slice(2);
const opt = (k) => { const i = a.indexOf(k); return i >= 0 ? a.splice(i, 2)[1] : null; };
const flag = (k) => { const i = a.indexOf(k); return i >= 0 ? (a.splice(i, 1), true) : false; };
const linesPath = opt("--lines") ?? "tools/lines.json";
const out = (opt("--out") ?? "video/assets/vo").replace(/\/?$/, "/");
const dry = flag("--dry-run"), all = flag("--all");
const cfg = JSON.parse(readFileSync(linesPath, "utf8"));
const pick = cfg.lines.filter((l) => all || a.includes(l.id));
const unknown = a.filter((id) => !cfg.lines.some((l) => l.id === id));
if (unknown.length) { console.error(`unknown ids: ${unknown.join(" ")}`); process.exit(1); }
const chars = pick.reduce((n, l) => n + l.text.length, 0);

if (dry || (!a.length && !all)) {
  const list = a.length || all ? pick : cfg.lines;
  for (const l of list) console.log(`${l.id.padEnd(8)} ${String(l.text.length).padStart(4)}  ${l.text}`);
  const n = list.reduce((s, l) => s + l.text.length, 0);
  console.log(`\n${list.length} lines, ${n} characters ≈ ${n} credits (about 1 per character; check your plan). Voice ${cfg.voice}, model ${cfg.model}.`);
  if (!dry) console.log("Nothing generated: pass the ids to generate, or --all.");
  process.exit(0);
}

function words(al) {
  const res = [];
  let cur = null;
  for (let i = 0; i < al.characters.length; i++) {
    const ch = al.characters[i];
    if (/\s/.test(ch)) { if (cur) res.push(cur), (cur = null); continue; }
    if (!cur) cur = { w: "", s: al.character_start_times_seconds[i], e: 0 };
    cur.w += ch;
    cur.e = al.character_end_times_seconds[i];
  }
  if (cur) res.push(cur);
  return res;
}

mkdirSync(out, { recursive: true });
const manPath = `${out}manifest.json`;
const man = existsSync(manPath) ? JSON.parse(readFileSync(manPath, "utf8")) : { lines: {} };
man.voice = cfg.voice; man.model = cfg.model;
console.log(`generating ${pick.length} lines, ${chars} characters…`);
for (const line of pick) {
  const read = line.style === "read";
  const j = await el(`/v1/text-to-speech/${cfg.voice}/with-timestamps?output_format=mp3_44100_128`, {
    text: line.text,
    model_id: cfg.model,
    voice_settings: read
      ? { stability: 0.6, similarity_boost: 0.8, style: 0.2, use_speaker_boost: false, speed: 0.95 }
      : { stability: 0.45, similarity_boost: 0.8, style: 0.25, use_speaker_boost: false, speed: 1.05 },
  });
  const mp3 = `${out}${line.id}.mp3`;
  writeFileSync(mp3, Buffer.from(j.audio_base64, "base64"));
  execFileSync("ffmpeg", ["-nostdin", "-v", "error", "-y", "-i", mp3, "-af", "loudnorm=I=-16:TP=-1.5:LRA=11,aresample=48000", "-ar", "48000", "-c:a", "pcm_s16le", mp3.replace(/\.mp3$/, ".wav")]);
  const seconds = Number(execFileSync("ffprobe", ["-v", "error", "-show_entries", "format=duration", "-of", "csv=p=0", mp3], { encoding: "utf8" }).trim());
  const w = words(j.normalized_alignment ?? j.alignment);
  man.lines[line.id] = { id: line.id, text: line.text, file: `${line.id}.mp3`, seconds, speechStart: w[0]?.s ?? 0, speechEnd: w.at(-1)?.e ?? seconds, words: w };
  writeFileSync(manPath, JSON.stringify(man, null, 1)); // after every line, so a failure keeps what was paid for
  console.log(`OK ${line.id.padEnd(6)} ${seconds.toFixed(2)}s  "${line.text}"`);
}
