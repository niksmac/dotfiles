// ElevenLabs helpers for the howto-video skill.
//   import { el } from "<skill>/scripts/el.mjs"           (used by tts.mjs and music.mjs)
//   node <skill>/scripts/el.mjs usage                      characters used / limit (if the key may read it)
//   node <skill>/scripts/el.mjs voices                     voice ids and names
// The key comes from $ELEVENLABS_API_KEY, else from ELEVENLABS_API_KEY=… in .env.local or .env in the
// current directory or any parent. It is never printed.
import { existsSync, readFileSync } from "node:fs";
import { dirname, join, resolve } from "node:path";

export function loadKey() {
  if (process.env.ELEVENLABS_API_KEY) return process.env.ELEVENLABS_API_KEY.trim();
  let dir = resolve(process.cwd());
  for (;;) {
    for (const name of [".env.local", ".env"]) {
      const f = join(dir, name);
      if (!existsSync(f)) continue;
      const m = readFileSync(f, "utf8").match(/^\s*(?:export\s+)?ELEVENLABS_API_KEY\s*=\s*(.*)$/m);
      if (m) {
        const v = m[1].trim().replace(/^["']|["']$/g, "").trim();
        if (v) return v;
      }
    }
    const up = dirname(dir);
    if (up === dir) break;
    dir = up;
  }
  throw new Error("No ELEVENLABS_API_KEY: set it in the environment or in .env.local / .env (this directory or a parent).");
}

export async function el(path, body, accept = "application/json", method = body ? "POST" : "GET") {
  const r = await fetch(`https://api.elevenlabs.io${path}`, {
    method,
    headers: { "xi-api-key": loadKey(), "Content-Type": "application/json", Accept: accept },
    body: body ? JSON.stringify(body) : undefined,
  });
  if (!r.ok) {
    const t = await r.text();
    const err = new Error(`${r.status} ${path}: ${t.slice(0, 400)}`);
    err.status = r.status;
    throw err;
  }
  return accept === "application/json" ? r.json() : Buffer.from(await r.arrayBuffer());
}

if (import.meta.url === `file://${process.argv[1]}`) {
  const cmd = process.argv[2];
  if (cmd === "usage") {
    try {
      const s = await el("/v1/user/subscription");
      console.log(`characters used ${s.character_count} of ${s.character_limit} (tier ${s.tier}); resets ${new Date(s.next_character_count_reset_unix * 1000).toISOString().slice(0, 10)}`);
    } catch (e) {
      // keys without user_read can still read usage stats
      const end = Date.now(), start = end - 30 * 864e5;
      const u = await el(`/v1/usage/character-stats?start_unix=${start}&end_unix=${end}`);
      const total = Object.values(u.usage || {}).flat().reduce((a, b) => a + (b || 0), 0);
      console.log(`characters used in the last 30 days: ${total} (subscription not readable with this key: ${e.status})`);
    }
  } else if (cmd === "voices") {
    const v = await el("/v1/voices");
    for (const x of v.voices) console.log(`${x.voice_id}  ${x.name}  ${Object.values(x.labels || {}).join(", ")}`);
  } else {
    console.log("usage: node el.mjs usage | voices");
  }
}
