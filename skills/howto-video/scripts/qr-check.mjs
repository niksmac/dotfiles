// Decode the QR code in a PNG (e.g. a snapshot of the end card) and print the URL.
//   node <skill>/scripts/qr-check.mjs frame.png [expected-url]     exit 1 if not found or not the expected URL
// Uses jsqr@1.4.0 and pngjs@7.0.0, installed once into ~/.cache/howto-video.
import { readFileSync } from "node:fs";
import { need } from "./deps.mjs";

const [file, want] = process.argv.slice(2);
if (!file) { console.error("usage: qr-check.mjs frame.png [expected-url]"); process.exit(1); }
const { PNG } = need("pngjs"), jsQR = need("jsqr");
const png = PNG.sync.read(readFileSync(file));
const r = jsQR(new Uint8ClampedArray(png.data), png.width, png.height);
if (!r) { console.log(`${file}: no QR code decoded`); process.exit(1); }
console.log(`${file}: ${r.data}`);
if (want && r.data !== want) { console.log(`expected ${want}`); process.exit(1); }
