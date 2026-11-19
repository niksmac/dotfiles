// An instrumental music bed with ElevenLabs Music (ask first: roughly 1,100 credits for 40 s).
//   node <skill>/scripts/music.mjs --out video/assets/music/bed-a.mp3 --plan bed.json [--dry-run]
//   node <skill>/scripts/music.mjs --out video/assets/music/bed-a.mp3 --prompt "playful pizzicato pop, 120 BPM, C major, instrumental, ends on one big final hit" --seconds 40
// A --plan file is an ElevenLabs composition plan; this one gives a groove, a lift and a clean ending:
// { "positive_global_styles": ["playful bouncy pop for a product explainer", "120 BPM, steady tempo, 4/4, C major", "instrumental"],
//   "negative_global_styles": ["vocals", "spoken words", "tempo changes", "fade in"],
//   "sections": [
//     { "section_name": "Groove", "duration_ms": 16000, "lines": [], "positive_local_styles": ["catchy hook from the first downbeat"], "negative_local_styles": ["intro", "silence"] },
//     { "section_name": "Lift", "duration_ms": 16000, "lines": [], "positive_local_styles": ["same hook, fuller"], "negative_local_styles": ["breakdown"] },
//     { "section_name": "Ending", "duration_ms": 8000, "lines": [], "positive_local_styles": ["hook once more for two bars", "then one big final hit on the next downbeat", "the final chord rings out for three seconds"], "negative_local_styles": ["abrupt cut", "long fade"] } ] }
// 120 BPM keeps beats on the 0.5 s grid that the scenes use. Then measure the final hit (plugin-cli beats + a
// loudness trace) and fit it with fit-music.py.
import { writeFileSync, readFileSync, mkdirSync } from "node:fs";
import { dirname } from "node:path";
import { el } from "./el.mjs";

const a = process.argv.slice(2);
const opt = (k) => { const i = a.indexOf(k); return i >= 0 ? a[i + 1] : null; };
const out = opt("--out"), planPath = opt("--plan"), prompt = opt("--prompt"), secs = Number(opt("--seconds") ?? 40);
if (!out || (!planPath && !prompt)) { console.error("need --out and --plan <file> or --prompt <text> [--seconds N]"); process.exit(1); }
const plan = planPath ? JSON.parse(readFileSync(planPath, "utf8")) : null;
const ms = plan ? plan.sections.reduce((n, s) => n + s.duration_ms, 0) : secs * 1000;
console.log(`${(ms / 1000).toFixed(0)} s of music ≈ ${Math.round((ms / 1000) * 27.5)} credits (estimate; check your plan)`);
if (a.includes("--dry-run")) process.exit(0);
const body = plan
  ? { composition_plan: plan, model_id: "music_v1", respect_sections_durations: true }
  : { prompt, music_length_ms: ms, model_id: "music_v1" };
const buf = await el("/v1/music?output_format=mp3_44100_192", body, "audio/mpeg");
mkdirSync(dirname(out), { recursive: true });
writeFileSync(out, buf);
if (plan) writeFileSync(out.replace(/\.mp3$/, ".plan.json"), JSON.stringify(plan, null, 1));
console.log(`wrote ${out} (${buf.length} bytes)`);
