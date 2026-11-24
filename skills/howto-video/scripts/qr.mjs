// A QR code as an SVG (dark modules on transparent), for the end card.
//   node <skill>/scripts/qr.mjs "https://example.com/guide" video/assets/<slug>/qr.svg [--dark "#2B231D"] [--ecl M]
// Uses the npm package qrcode@1.5.4, installed once into ~/.cache/howto-video.
import { writeFileSync, mkdirSync } from "node:fs";
import { dirname } from "node:path";
import { need } from "./deps.mjs";

const a = process.argv.slice(2);
const opt = (k, d) => { const i = a.indexOf(k); return i >= 0 ? a.splice(i, 2)[1] : d; };
const dark = opt("--dark", "#111111"), ecl = opt("--ecl", "M");
const [url, out] = a;
if (!url || !out) { console.error('usage: qr.mjs "<url>" out.svg [--dark #hex] [--ecl L|M|Q|H]'); process.exit(1); }
const QR = need("qrcode");
const svg = await QR.toString(url, { type: "svg", errorCorrectionLevel: ecl, margin: 0, color: { dark: dark.length === 7 ? dark + "FF" : dark, light: "#00000000" } });
mkdirSync(dirname(out), { recursive: true });
writeFileSync(out, svg);
const n = Number(svg.match(/viewBox="0 0 (\d+)/)?.[1]);
console.log(`${out}: ${n}×${n} modules for ${url.length} characters (shorter URLs make larger modules; show it at ≥ ${Math.max(360, n * 10)} px)`);
