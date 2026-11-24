// Small npm dependencies for the helper scripts, installed once (pinned) into ~/.cache/howto-video.
import { createRequire } from "node:module";
import { execFileSync } from "node:child_process";
import { existsSync, mkdirSync, writeFileSync } from "node:fs";
import { homedir } from "node:os";
import { join } from "node:path";

const DIR = join(process.env.XDG_CACHE_HOME || join(homedir(), ".cache"), "howto-video");
const PINS = { qrcode: "1.5.4", jsqr: "1.4.0", pngjs: "7.0.0" };

// Loaded by absolute path, so a module installed during this run is found (lookups by name are cached).
export function need(name) {
  const req = createRequire(join(DIR, "package.json"));
  const path = join(DIR, "node_modules", name);
  if (!existsSync(join(path, "package.json"))) {
    mkdirSync(DIR, { recursive: true });
    if (!existsSync(join(DIR, "package.json"))) writeFileSync(join(DIR, "package.json"), '{ "private": true }\n');
    const all = Object.entries(PINS).map(([n, v]) => `${n}@${v}`);
    console.error(`installing ${all.join(" ")} into ${DIR} (once)…`);
    execFileSync("npm", ["install", "--silent", "--no-audit", "--no-fund", "--prefix", DIR, ...all], { stdio: "inherit" });
  }
  return req(path);
}
