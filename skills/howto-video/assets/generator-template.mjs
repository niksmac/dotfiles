// howto-video generator template. Copy to tools/build-<slug>.mjs, set CONFIG, write SCENES, run:
//   node tools/build-<slug>.mjs
// Writes, from ONE scene list, both sizes:
//   video/compositions/<PREFIX>-NN-h.html / -v.html   one per scene (h = 1920×1080, v = 1080×1920)
//   video/compositions/cap-<PREFIX>-h.html / -v.html  captions from the voice's word timings
//   tools/roots/<SLUG>-h.html / -v.html              scene hosts + voice (track 7) + ducked music (8) ; SFX lanes 9+
//   tools/roots/<SLUG>-thumb.html                     the YouTube thumbnail (1920×1080 still)
//   tools/roots/<SLUG>.json                           scene starts and total length (for fit-music.py)
// Preview one: command cp -f tools/roots/<SLUG>-h.html video/index.html
// The example scenes (hook, section card, UI dialog, footage, end card) show every helper; replace them.
import { readFileSync, writeFileSync, existsSync, mkdirSync } from "node:fs";
import { execFileSync } from "node:child_process";

// ============================== CONFIG ==============================
const ROOT = new URL("..", import.meta.url).pathname; // repo root (this file lives in tools/)
const SLUG = "demo";                 // file names
const PREFIX = "dm";                 // composition ids (short, unique in the project)
const PROJECT = `${ROOT}video/`;     // the HyperFrames project
const ROOTS = `${ROOT}tools/roots/`;
const VO_DIR = "assets/vo";          // relative to PROJECT (tts.mjs --out)
const MUSIC = `assets/music/${SLUG}.wav`; // fit-music.py --out (relative to PROJECT)
const SFX_DIR = "assets/sfx";        // click.wav, key.wav, toggle.wav, pop.wav, swish.wav, whoosh.wav, tick.wav, chime.wav, slam.wav …
const ART = `assets/${SLUG}`;        // illustrations, screenshots, qr.svg for this video
const LOGO = "assets/brand/logo-anim"; // logo-sprite.sh output prefix (.png + .json); falls back to assets/brand/logo.png
// Wordmark (optional; falls back to BRAND.name in the heading font). aspect = width/height of the file.
// If the file includes the logo mark, set cropLeft to the mark's share of the width so the animated logo isn't shown twice.
const WORDMARK = { src: "assets/brand/wordmark.svg", aspect: 3.6, cropLeft: 0 };
const VO_AT = 0.15;                  // the voice starts this far into its scene

// Brand (video chrome): from the product's brand sheet
const BRAND = {
  name: "Product",
  grounds: { a: "#fde8b7", b: "#d5e9f7", c: "#fddbc5", d: "#d8efd5", e: "#e6dcf3", cream: "#fdf3e0", night: "#1C1714" },
  ink: "#2B231D", ink2: "#665C52", accent: "#FFAE1B", accentText: "#9A5B00",
  nightInk: "#F4EDE4", nightAccent: "#FFB52E",
  heading: { family: "Fraunces", file: "assets/fonts/Fraunces-Variable.ttf", weight: "100 900", vars: '"opsz" 144, "SOFT" 50' },
  body: { family: "Noto Sans", file: "assets/fonts/NotoSans-Variable.ttf", weight: "100 900" },
  label: { family: "Roboto", files: [["assets/fonts/Roboto-Bold.ttf", 700], ["assets/fonts/Roboto-Medium.ttf", 500]] },
};
// Product UI tokens (rebuilt screens): from tailwind.config / globals.css / the theme
const UI = { primary: "#AE562D", tertiary: "#F5D1AD", neutral: "#F8EBD3", ink: "#27272A", muted: "#71717A", border: "#E7E5E4", tint: "#EEAF9366", green: "#16A34A", greenBg: "rgba(74,222,128,.15)" };

const FMT = {
  h: { W: 1920, H: 1080, res: "landscape", align: "left", hl: { left: 100, width: 760, eyebrowTop: 300, top: 360, size: 80 }, stage: { left: 900, top: 160, scale: 1.08 }, cap: { top: 958, size: 44, max: 1500 } },
  v: { W: 1080, H: 1920, res: "portrait", align: "center", hl: { left: 64, width: 952, eyebrowTop: 180, top: 240, size: 84 }, stage: { left: 90, top: 500, scale: 1 }, cap: { top: 1215, size: 50, max: 900 } },
};
// ============================ END CONFIG ============================

const VO = JSON.parse(readFileSync(`${PROJECT}${VO_DIR}/manifest.json`, "utf8")).lines;
const esc = (s) => String(s).replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;").replace(/"/g, "&quot;");
const r3 = (n) => Math.round(n * 1000) / 1000;
const halfUp = (n) => Math.ceil(n * 2 - 1e-9) / 2;
const G = BRAND.grounds, INK = BRAND.ink;

// SFX: real lengths from the files; the peak offset lines the transient up with the action (override in sfx/peaks.json)
const SFX_PEAKS = existsSync(`${PROJECT}${SFX_DIR}/peaks.json`) ? JSON.parse(readFileSync(`${PROJECT}${SFX_DIR}/peaks.json`, "utf8")) : {};
const sfxLenCache = {};
function sfxLen(name) {
  if (!(name in sfxLenCache)) {
    const f = `${PROJECT}${SFX_DIR}/${name}.wav`;
    if (!existsSync(f)) throw new Error(`missing SFX ${f}`);
    sfxLenCache[name] = Number(execFileSync("ffprobe", ["-v", "error", "-show_entries", "format=duration", "-of", "csv=p=0", f], { encoding: "utf8" }).trim());
  }
  return sfxLenCache[name];
}

/** scene time of the first word matching re in a voice line */
function wordAt(vo, re) {
  const w = VO[vo]?.words.find((x) => re.test(x.w));
  if (!w) throw new Error(`${vo}: no word ${re}`);
  return r3(VO_AT + w.s);
}

// ---------- helpers ----------
function lineHtml(id, li, text) {
  const parts = text.split(/(\*\*[^*]+\*\*)/).filter(Boolean);
  let out = "", wi = 0;
  for (const p of parts) {
    if (p.startsWith("**")) { out += `<span class="chip"><span class="chip-bg" id="${id}-cb${li}"></span><span class="chip-tx w">${esc(p.slice(2, -2))}</span></span> `; wi++; }
    else for (const w of p.trim().split(/\s+/).filter(Boolean)) { out += `<span class="w">${esc(w)}</span> `; wi++; }
  }
  return { html: out.trim(), words: wi };
}

/** eyebrow + headline; lines [{t, at}], at null = on screen at frame 0; "**phrase**" sits on the accent chip */
function headline(id, f, { eyebrow, lines, night }) {
  const c = f.hl;
  let html = eyebrow ? `<div class="eyebrow" id="${id}-eb" style="left:${c.left}px;width:${c.width}px;top:${c.eyebrowTop}px;text-align:${f.align};color:${night ? BRAND.nightAccent : BRAND.accentText}">${esc(eyebrow)}</div>` : "";
  html += `<div class="hl" style="left:${c.left}px;width:${c.width}px;top:${c.top}px;font-size:${lines.length > 2 ? c.size - 6 : c.size}px;text-align:${f.align};color:${night ? BRAND.nightInk : INK}">`;
  let js = "";
  const first = lines.find((l) => l.at != null);
  if (eyebrow && first) js += `gsap.set("#${id}-eb", { opacity: 0 });\ntl.fromTo("#${id}-eb", { opacity: 0, y: 12 }, { opacity: 1, y: 0, duration: 0.25, ease: "power2.out" }, ${r3(Math.max(0, first.at - 0.05))});\n`;
  lines.forEach((ln, li) => {
    const { html: h, words } = lineHtml(id, li, ln.t);
    html += `<div class="hl-line" id="${id}-l${li}">${h}</div>`;
    const chip = ln.t.includes("**");
    if (ln.at == null) { if (chip) js += `gsap.set("#${id}-cb${li}", { scaleX: 1 });\n`; return; }
    js += `gsap.set("#${id}-l${li} .w", { opacity: 0 });\n`;
    js += `tl.fromTo("#${id}-l${li} .w", { opacity: 0, filter: "blur(6px)", y: 8 }, { opacity: 1, filter: "blur(0px)", y: 0, duration: 0.14, ease: "power2.out", stagger: 0.067 }, ${ln.at});\n`;
    if (chip) js += `tl.fromTo("#${id}-cb${li}", { scaleX: 0 }, { scaleX: 1, duration: 0.32, ease: "expo.out" }, ${r3(ln.at + 0.067 * (words - 1) + 0.05)});\n`;
  });
  return { html: html + `</div>`, js };
}

/** typed text: characters appear in turn; keys = times for key SFX */
function typed(id, text, at, cps = 24) {
  const chars = [...text];
  const html = chars.map((ch, i) => `<span class="ty" id="${id}-${i}">${ch === " " ? "&nbsp;" : esc(ch)}</span>`).join("");
  let js = `gsap.set("#${id} .ty", { opacity: 0 });\n`;
  const keys = [];
  chars.forEach((_, i) => {
    const t = r3(at + i / cps);
    js += `tl.set("#${id}-${i}", { opacity: 1 }, ${t});\n`;
    if (i % 3 === 0) keys.push(t);
  });
  return { html: `<span id="${id}">${html}</span>`, js, end: r3(at + chars.length / cps), keys };
}

const pop = (sel, at, { from = 0.6, y = 24, dur = 0.42 } = {}) =>
  `gsap.set("${sel}", { opacity: 0 });\ntl.fromTo("${sel}", { opacity: 0, scale: ${from}, y: ${y} }, { opacity: 1, scale: 1, y: 0, duration: ${dur}, ease: "back.out(1.6)" }, ${r3(at)});\n`;
const fadeUp = (sel, at, { y = 30, dur = 0.35 } = {}) =>
  `gsap.set("${sel}", { opacity: 0 });\ntl.fromTo("${sel}", { opacity: 0, y: ${y}, filter: "blur(6px)" }, { opacity: 1, y: 0, filter: "blur(0px)", duration: ${dur}, ease: "power3.out" }, ${r3(at)});\n`;
const press = (sel, at) => `tl.to("${sel}", { scale: 0.94, duration: 0.07, yoyo: true, repeat: 1 }, ${r3(at)});\n`;

const CURSOR = `<svg viewBox="0 0 32 40" width="44" height="55"><path d="M3 2 L3 32 L11 25 L16.5 37 L21.5 34.8 L16.2 23.2 L27 23 Z" fill="#fff" stroke="${INK}" stroke-width="2.4" stroke-linejoin="round"/></svg>`;
const CHECK = (c = "#fff", s = 22) => `<svg viewBox="0 0 24 24" width="${s}" height="${s}"><path d="M5 12.5 L10 17.5 L19 7" fill="none" stroke="${c}" stroke-width="3.2" stroke-linecap="round" stroke-linejoin="round"/></svg>`;
/** cursor through points [[x, y, at, click?]] in the coordinates of the element that contains it; the tip is ~(4,3) px in */
function cursorPath(id, pts) {
  let js = `gsap.set("#${id}-cur", { opacity: 0, x: ${pts[0][0]}, y: ${pts[0][1]} });\ntl.to("#${id}-cur", { opacity: 1, duration: 0.15 }, ${r3(pts[0][2])});\n`;
  const clicks = [];
  for (let i = 1; i < pts.length; i++) {
    const [x, y, at, click] = pts[i];
    const dur = Math.min(0.55, Math.max(0.25, at - pts[i - 1][2] - 0.05));
    js += `tl.to("#${id}-cur", { x: ${x}, y: ${y}, duration: ${r3(dur)}, ease: "power3.inOut" }, ${r3(at - dur)});\n`;
    if (click) { js += `tl.to("#${id}-cur svg", { scale: 0.82, duration: 0.07, yoyo: true, repeat: 1, transformOrigin: "10% 10%" }, ${r3(at)});\n`; clicks.push(at); }
  }
  return { html: `<div class="cur" id="${id}-cur">${CURSOR}</div>`, js, clicks };
}

/** the animated logo (sprite from logo-sprite.sh), stepped at its own fps; static logo if there's no sprite */
const LOGO_META = existsSync(`${PROJECT}${LOGO}.json`) ? JSON.parse(readFileSync(`${PROJECT}${LOGO}.json`, "utf8")) : null;
function logoAnim(id, len, { size = 400, pad = 1.15 } = {}) {
  const inner = Math.round(size * pad), off = Math.round((size - inner) / 2);
  if (!LOGO_META) return { html: `<img src="assets/brand/logo.png" style="position:absolute;left:0;top:0;width:${size}px;height:${size}px" />`, js: "" };
  const { frames, fps, cols, rows } = LOGO_META;
  const pos = (fr) => `${cols > 1 ? r3((fr % cols) * (100 / (cols - 1))) : 0}% ${rows > 1 ? r3(Math.floor(fr / cols) * (100 / (rows - 1))) : 0}%`;
  let js = `gsap.set("#${id}-logo", { backgroundPosition: "${pos(0)}" });\n`;
  for (let k = 1, prev = 0; k / fps < len; k++) {
    const fr = k % frames;
    if (fr !== prev) js += `tl.set("#${id}-logo", { backgroundPosition: "${pos(fr)}" }, ${r3(k / fps)});\n`;
    prev = fr;
  }
  return { html: `<div id="${id}-logo" style="position:absolute;left:${off}px;top:${off}px;width:${inner}px;height:${inner}px;background:url(${LOGO}.png) 0% 0%/${cols * 100}% ${rows * 100}% no-repeat"></div>`, js };
}
const wordmark = (h) => existsSync(`${PROJECT}${WORDMARK.src}`)
  ? `<div style="position:relative;overflow:hidden;height:${h}px;width:${Math.round(h * WORDMARK.aspect * (1 - WORDMARK.cropLeft))}px"><img src="${WORDMARK.src}" style="position:absolute;top:0;left:${-Math.round(h * WORDMARK.aspect * WORDMARK.cropLeft)}px;height:${h}px;width:${Math.round(h * WORDMARK.aspect)}px" /></div>`
  : `<span style="font-family:'${BRAND.heading.family}';font-weight:800;font-size:${Math.round(h * 0.62)}px;line-height:${h}px;color:${INK}">${esc(BRAND.name)}</span>`;

// ---------- scenes ----------
// Each: { vo, minLen, ground, night?, eyebrow, lines, build(id, len, f) -> { html, css, js, sfx:[[name, t, vol]] } }
// html is placed in a 900×700 stage (16:9: right of the headline; 9:16: under it). f = FMT entry, for per-size tweaks.
const SCENES = [
  // 1 · hook: frame 0 must read alone (headline at frame 0 + the hero visual); two tags pop as the line says "two"
  {
    vo: "L01", minLen: 5, ground: G.a, eyebrow: "How it works",
    lines: [{ t: "Your stories can", at: null }, { t: "**pay you back.**", at: null }],
    build(id, len) {
      const two = wordAt("L01", /^two$/i);
      const html = `<div class="disc" style="left:110px;top:20px;width:680px;height:680px;background:${UI.tertiary}"></div>
        <img class="art" id="${id}-art" src="${ART}/hero.webp" style="left:130px;top:40px;width:640px;height:640px;object-fit:contain" />
        <div class="tag" id="${id}-t1" style="left:0;top:560px"><b>1</b>First way</div>
        <div class="tag" id="${id}-t2" style="left:470px;top:600px"><b>2</b>Second way</div>`;
      const js = `tl.fromTo("#${id}-art", { scale: 1, y: 0 }, { scale: 1.05, y: -10, duration: ${len}, ease: "sine.inOut" }, 0);\n` + pop(`#${id}-t1`, two + 0.05) + pop(`#${id}-t2`, two + 0.4);
      return { html, js, sfx: [["pop", two + 0.05, 0.45], ["pop", two + 0.4, 0.45]] };
    },
  },
  // 2 · section card (dark ground): big step number + a framed illustration with a slow push-in
  {
    vo: "L02", minLen: 3.5, ground: G.night, night: true, eyebrow: "Way 1",
    lines: [{ t: "Start a", at: 0.1 }, { t: "**story podcast.**", at: 0.35 }],
    build(id, len) {
      const html = `<div class="frame" id="${id}-f" style="left:60px;top:40px;width:780px;height:600px"><img src="${ART}/section-1.webp" style="width:100%;height:100%;object-fit:cover" /></div>
        <div class="num" id="${id}-n" style="left:10px;top:0">1</div>`;
      const js = `gsap.set("#${id}-f", { opacity: 0 });\ntl.fromTo("#${id}-f", { opacity: 0, scale: 0.9, rotate: -3 }, { opacity: 1, scale: 1, rotate: 0, duration: 0.5, ease: "expo.out" }, 0.05);\ntl.to("#${id}-f img", { scale: 1.08, duration: ${len}, ease: "none" }, 0);\n` + pop(`#${id}-n`, 0.3, { from: 0.3, y: 0 });
      return { html, js, sfx: [["whoosh", 0.05, 0.4], ["pop", 0.3, 0.4]] };
    },
  },
  // 3 · rebuilt UI: a dialog (labels copied from the product's component) — type a name, tick a box,
  //     the section expands and the content scrolls, tick terms, press the button, toast.
  //     The cursor lives INSIDE the scrolling content, in its coordinates.
  {
    vo: "L03", minLen: 6, ground: G.c, eyebrow: "Step 1 · Create it",
    lines: [{ t: "One tick,", at: 0.1 }, { t: "**and it's live.**", at: 2.6 }],
    build(id) {
      const tick = wordAt("L03", /^tick/i) + 0.25;
      const name = typed(`${id}-nm`, "Bedtime Stories", 0.55, 26);
      const desc = typed(`${id}-ds`, "Cosy stories, read by me.", r3(tick + 0.9), 30);
      const terms = r3(desc.end + 0.15), create = r3(terms + 0.45);
      const SCROLL = 470; // how far the content scrolls after expanding: content height − dialog height (check in a snapshot)
      const cur = cursorPath(id, [[560, 330, r3(name.end + 0.05)], [58, 424, tick, true], [55, 966, terms, true], [330, 1056, create, true]]);
      const html = `<div class="wcard dlg" id="${id}-d" style="left:120px;top:0;width:660px;height:700px">
          <div class="dlg-in" id="${id}-di">
            <div class="dt">Create a new playlist</div>
            <div class="lb">Name</div><div class="fld">${name.html}</div>
            <div class="row2"><div><div class="lb">Genre</div><div class="fld sel">Mixed<i>⌄</i></div></div><div><div class="lb">Visibility</div><div class="fld sel">Public<i>⌄</i></div></div></div>
            <div class="cbrow"><span class="cb" id="${id}-cb"><span id="${id}-ck">${CHECK()}</span></span><div><div class="lb0">Make this a Podcast</div><div class="sm">You have 0/2 podcasts</div></div></div>
            <div class="more" id="${id}-more">
              <div class="lb">Thumbnail <span style="opacity:.5">(optional)</span></div>
              <div class="thumbbox"><img id="${id}-pt" src="${ART}/thumb.webp" /></div>
              <div class="lb">Description</div><div class="fld ta">${desc.html}</div>
              <div class="cbrow sm2"><span class="cb" id="${id}-cb2"><span id="${id}-ck2">${CHECK("#fff", 18)}</span></span><div class="sm">I agree to the <u>terms and conditions</u></div></div>
              <div class="cta" id="${id}-cr">Create</div>
            </div>
            ${cur.html}
          </div>
        </div>
        <div class="toast" id="${id}-toast">${CHECK(UI.green, 26)} Created</div>`;
      let js = `gsap.set("#${id}-d", { opacity: 0 });\ntl.fromTo("#${id}-d", { opacity: 0, scale: 0.92, y: 30 }, { opacity: 1, scale: 1, y: 0, duration: 0.4, ease: "expo.out" }, 0.05);\n`;
      js += name.js + desc.js + cur.js;
      js += `gsap.set("#${id}-ck", { opacity: 0 });\ngsap.set("#${id}-ck2", { opacity: 0 });\ngsap.set("#${id}-more", { height: 0, opacity: 0 });\ngsap.set("#${id}-pt", { opacity: 0 });\ngsap.set("#${id}-toast", { opacity: 0 });\n`;
      js += `tl.to("#${id}-cb", { backgroundColor: "${UI.primary}", duration: 0.12 }, ${r3(tick + 0.02)});\ntl.to("#${id}-ck", { opacity: 1, duration: 0.12 }, ${r3(tick + 0.02)});\n`;
      js += `tl.to("#${id}-more", { height: 640, opacity: 1, duration: 0.5, ease: "expo.out" }, ${r3(tick + 0.2)});\ntl.to("#${id}-di", { y: -${SCROLL}, duration: 0.6, ease: "power3.inOut" }, ${r3(tick + 0.3)});\n`;
      js += `tl.fromTo("#${id}-pt", { opacity: 0, scale: 1.15 }, { opacity: 1, scale: 1, duration: 0.35, ease: "power2.out" }, ${r3(tick + 0.6)});\n`;
      js += `tl.to("#${id}-cb2", { backgroundColor: "${UI.primary}", duration: 0.12 }, ${terms});\ntl.to("#${id}-ck2", { opacity: 1, duration: 0.12 }, ${terms});\n` + press(`#${id}-cr`, create);
      js += `tl.fromTo("#${id}-toast", { opacity: 0, y: 30 }, { opacity: 1, y: 0, duration: 0.3, ease: "back.out(1.6)" }, ${r3(create + 0.25)});\n`;
      return {
        html, js,
        css: `#root .dlg{overflow:hidden;padding:0}
          #root .dlg-in{position:absolute;left:0;top:0;width:100%;padding:40px 44px}
          #root .dt{font-family:"${BRAND.heading.family}";font-weight:600;font-size:42px;text-align:center;color:${UI.ink};margin-bottom:30px}
          #root .lb{font-size:24px;font-weight:600;color:${UI.ink};margin:0 0 10px}
          #root .lb0{font-size:26px;font-weight:600;color:${UI.ink}}
          #root .fld{height:66px;border:2px solid ${UI.border};border-radius:10px;padding:0 20px;display:flex;align-items:center;font-size:26px;color:${UI.ink};margin-bottom:26px;position:relative}
          #root .sel i{position:absolute;right:18px;top:12px;font-style:normal;color:${UI.muted}}
          #root .row2{display:grid;grid-template-columns:1fr 1fr;gap:22px}
          #root .cbrow{display:flex;align-items:center;gap:18px;margin:4px 0 26px}
          #root .cb{flex:0 0 auto;width:36px;height:36px;border:2.5px solid ${UI.primary};border-radius:7px;display:grid;place-items:center;background:#fff}
          #root .sm2 .cb{width:30px;height:30px}
          #root .sm{font-size:21px;color:${UI.muted};line-height:1.35}
          #root .more{overflow:hidden}
          #root .thumbbox{width:100%;height:220px;border:2px dashed ${UI.border};border-radius:12px;overflow:hidden;margin-bottom:24px}
          #root .thumbbox img{width:100%;height:100%;object-fit:cover}
          #root .ta{height:96px;align-items:flex-start;padding-top:14px}
          #root .cta{height:70px;border-radius:10px;background:${UI.primary};color:#fff;font-size:27px;font-weight:600;display:grid;place-items:center}
          #root .toast{position:absolute;left:250px;top:-36px;z-index:5;padding:18px 30px;border-radius:14px;background:#fff;box-shadow:0 14px 40px rgba(0,0,0,.18);font-size:28px;font-weight:600;color:${UI.ink};display:flex;gap:12px;align-items:center}`,
        sfx: [["swish", 0.05, 0.3], ...name.keys.map((t) => ["key", t, 0.2]), ["click", tick, 0.55], ["toggle", tick + 0.02, 0.5], ...desc.keys.map((t) => ["key", t, 0.18]), ["click", terms, 0.5], ["toggle", terms + 0.02, 0.4], ["click", create, 0.55], ["chime", create + 0.25, 0.3]],
      };
    },
  },
  // 4 · real footage: part of a 1080×1920 screen recording in a rounded panel (crop out burned-in titles),
  //     beside an illustration. Time the <video>, never its wrapper.
  {
    vo: "L04", minLen: 6, ground: G.e, eyebrow: "Step 2 · Your voice",
    lines: [{ t: "One short passage.", at: 0.1 }, { t: "**Your voice.**", at: 2.6 }],
    build(id, len) {
      const k = 420 / 1080, cropTop = 560; // show the recording from y 560 down
      const html = `<img class="art" id="${id}-art" src="${ART}/step-2.webp" style="left:-10px;top:190px;width:500px;height:500px;object-fit:contain" />
        <div class="panel" id="${id}-p" style="left:470px;top:20px;width:420px;height:${Math.round((1920 - cropTop) * k)}px">
          <video id="${id}-v" class="clip" src="${ART}/recording.mp4" data-start="0" data-duration="${len}" data-track-index="0" muted playsinline style="position:absolute;left:0;top:${Math.round(-cropTop * k)}px;width:420px;height:${Math.round(1920 * k)}px"></video>
        </div>`;
      return { html, js: fadeUp(`#${id}-p`, 0.05, { y: 60 }) + fadeUp(`#${id}-art`, 0.25), sfx: [["swish", 0.05, 0.25]] };
    },
  },
];

// End card: the brand's animated logo flies in big, hovers, settles into the lockup on the music's final hit
// (t ≈ 2.0); QR to the landing page; URL + CTA. Own layout per size; nothing under the big logo in 9:16.
const END = {
  vo: "L05", minLen: 6, ground: G.a, nocap: true,
  build(id, len, f) {
    const h = f.W > f.H;
    const L = h
      ? { hl: { left: 100, top: 170, width: 900, size: 80, align: "left" }, logo: [230, 470], wm: [470, 600], cta: [100, 770, 900, "left"], qr: [1180, 190, 560], qrAt: 0.6 }
      : { hl: { left: 64, top: 200, width: 952, size: 84, align: "center" }, logo: [240, 925], wm: [470, 1060], cta: [0, 1222, 1080, "center"], qr: [310, 400, 460], qrAt: 2.25 };
    const hd = headline(id, { ...f, align: L.hl.align, hl: { ...f.hl, ...L.hl, eyebrowTop: 0 } }, { lines: [{ t: "Scan for the", at: 0.1 }, { t: "**full guide.**", at: 0.4 }] });
    const lg = logoAnim(id, len);
    const [qx, qy, qs] = L.qr;
    const html = `${hd.html}
      <div class="qr" id="${id}-qr" style="left:${qx}px;top:${qy}px;width:${qs}px;height:${qs + 90}px"><img src="${ART}/qr.svg" style="width:${qs - 80}px;height:${qs - 80}px" /><span>Scan for the guide</span></div>
      <div class="logo" id="${id}-lg" style="left:${L.logo[0]}px;top:${L.logo[1]}px">${lg.html}</div>
      <div class="wm" id="${id}-wm" style="left:${L.wm[0]}px;top:${L.wm[1]}px">${wordmark(120)}</div>
      <div class="cta" id="${id}-cta" style="left:${L.cta[0]}px;top:${L.cta[1]}px;width:${L.cta[2]}px;text-align:${L.cta[3]}"><b>example.com</b><span>Start free today</span></div>`;
    let js = hd.js + lg.js;
    js += `gsap.set("#${id}-lg", { opacity: 0, scale: 1.5, x: 0, y: 360 });
      tl.to("#${id}-lg", { opacity: 1, y: 0, duration: 0.7, ease: "back.out(1.4)" }, 0.05);
      tl.to("#${id}-lg", { y: -18, duration: 0.55, ease: "sine.inOut", yoyo: true, repeat: 1 }, 0.8);
      tl.to("#${id}-lg", { scale: 0.45, x: -110, y: 0, duration: 0.5, ease: "expo.inOut" }, 1.9);
      tl.to("#${id}-lg", { y: -6, duration: 0.8, ease: "sine.inOut", yoyo: true, repeat: 3 }, 2.5);
      tl.fromTo("#${id}-wm", { clipPath: "inset(0 100% 0 0)" }, { clipPath: "inset(0 0% 0 0)", duration: 0.4, ease: "power3.out" }, 2.15);\n`;
    js += pop(`#${id}-qr`, L.qrAt, { from: 0.7, y: 40 }) + fadeUp(`#${id}-cta`, 2.6);
    return {
      html, js,
      css: `#root .logo{position:absolute;width:400px;height:400px;transform-origin:50% 50%}
        #root .wm{position:absolute}
        #root .cta{position:absolute;font-family:"${BRAND.label.family}";color:${INK}}
        #root .cta b{display:block;font-weight:700;font-size:64px}
        #root .cta span{display:block;margin-top:10px;font-weight:500;font-size:40px;color:${BRAND.accentText}}
        #root .qr{position:absolute;border-radius:36px;background:#fff;border:6px solid ${INK};box-shadow:0 12px 0 ${BRAND.accent};display:flex;flex-direction:column;align-items:center;justify-content:center;gap:18px}
        #root .qr span{font-family:"${BRAND.label.family}";font-weight:700;font-size:28px;color:${INK}}`,
      sfx: [["whoosh", 0.05, 0.3], ["pop", L.qrAt, 0.35], ["slam", 1.95, 0.4], ["swish", 2.15, 0.2]],
    };
  },
};
SCENES.push(END);

// YouTube thumbnail (1920×1080 still): ≤ 6 words at 130–150 px, one chip, hero visual, two pills, logo lockup.
// Keep the bottom-right corner clear (YouTube's duration badge).
const THUMB = {
  ground: G.a,
  html: () => `<div class="disc" style="position:absolute;left:1010px;top:70px;width:940px;height:940px;background:${UI.tertiary}"></div>
    <img src="${ART}/hero.webp" style="position:absolute;left:1010px;top:110px;width:900px;height:900px;object-fit:contain" />
    <div style="position:absolute;left:70px;top:70px;display:flex;align-items:center;gap:16px"><div style="position:relative;width:130px;height:130px">${logoAnim("th", 0, { size: 130 }).html}</div>${wordmark(110)}</div>
    <div class="big"><div>Your stories can</div><div><span class="chip"><span class="chip-bg" style="transform:rotate(-2deg) scaleX(1)"></span><span class="chip-tx">pay you back.</span></span></div></div>
    <div class="pills"><div class="tag"><b>1</b>First way</div><div class="tag"><b>2</b>Second way</div></div>`,
  css: `#root .big{position:absolute;left:90px;top:250px;width:980px;font-family:"${BRAND.heading.family}";font-weight:800;font-size:150px;line-height:1.0;letter-spacing:-0.03em;color:${INK};font-variation-settings:${BRAND.heading.vars ?? "normal"}}
    #root .pills{position:absolute;left:90px;top:740px;display:flex;gap:24px}
    #root .pills .tag{position:relative;font-size:44px;padding:18px 34px}
    #root .pills .tag b{width:60px;height:60px;font-size:36px}`,
};

// ---------- files ----------
const FONTFACES = `
  @font-face { font-family: "${BRAND.heading.family}"; src: url("${BRAND.heading.file}"); font-weight: ${BRAND.heading.weight}; }
  @font-face { font-family: "${BRAND.body.family}"; src: url("${BRAND.body.file}"); font-weight: ${BRAND.body.weight}; }
  ${BRAND.label.files.map(([f, w]) => `@font-face { font-family: "${BRAND.label.family}"; src: url("${f}"); font-weight: ${w}; }`).join("\n  ")}`;

const BASE_CSS = (ground) => `
  #root { position: absolute; inset: 0; overflow: hidden; background: ${ground}; font-family: "${BRAND.body.family}"; }
  #root .hl { position: absolute; font-family: "${BRAND.heading.family}"; font-weight: 800; line-height: 1.04; letter-spacing: -0.02em; font-variation-settings: ${BRAND.heading.vars ?? "normal"}; }
  #root .hl-line { display: block; }
  #root .w { display: inline-block; }
  #root .chip { position: relative; display: inline-block; white-space: nowrap; padding: 0 0.12em; }
  #root .chip-bg { position: absolute; left: 0; right: 0; top: 0.1em; bottom: 0; background: ${BRAND.accent}; border-radius: 0.16em; transform: rotate(-1.5deg) scaleX(0); transform-origin: left center; }
  #root .chip-tx { position: relative; color: ${INK}; }
  #root .eyebrow { position: absolute; font-family: "${BRAND.label.family}"; font-weight: 700; font-size: 34px; letter-spacing: 0.12em; text-transform: uppercase; }
  #root .stage { position: absolute; width: 900px; height: 700px; transform-origin: 0 0; }
  #root .stage > * { position: absolute; }
  #root .art { display: block; }
  #root .disc { border-radius: 50%; }
  #root .wcard { background: #fff; border-radius: 18px; box-shadow: 0 18px 50px rgba(20,16,13,.14), 0 2px 6px rgba(20,16,13,.06); color: ${UI.ink}; }
  #root .frame { border-radius: 36px; overflow: hidden; box-shadow: 0 24px 60px rgba(0,0,0,.35); }
  #root .panel { border-radius: 36px; overflow: hidden; background: #14100d; box-shadow: 0 24px 60px rgba(20,16,13,.3); }
  #root .num { width: 150px; height: 150px; border-radius: 40px; background: ${BRAND.accent}; border: 7px solid ${INK}; font-family: "${BRAND.heading.family}"; font-weight: 900; font-size: 116px; line-height: 132px; text-align: center; color: ${INK}; z-index: 2; }
  #root .tag { padding: 16px 30px; border-radius: 999px; background: #fff; border: 4px solid ${INK}; font-family: "${BRAND.label.family}"; font-weight: 700; font-size: 34px; color: ${INK}; display: flex; align-items: center; gap: 14px; box-shadow: 0 8px 0 ${BRAND.accent}; white-space: nowrap; }
  #root .tag b { width: 48px; height: 48px; border-radius: 50%; background: ${BRAND.accent}; display: grid; place-items: center; font-family: "${BRAND.heading.family}"; font-weight: 900; font-size: 30px; }
  #root .cur { position: absolute; left: 0; top: 0; z-index: 10; }
  #root .cur svg { display: block; filter: drop-shadow(0 4px 6px rgba(0,0,0,.25)); }`;

function sceneFile(cid, scene, len, f) {
  const b = scene.build(cid, len, f);
  let body;
  if (scene === END) body = b.html;
  else {
    const hd = headline(cid, f, { eyebrow: scene.eyebrow, lines: scene.lines, night: !!scene.night });
    const s = f.stage;
    body = `${hd.html}\n    <div class="stage" id="${cid}-stage" style="left:${s.left}px;top:${s.top}px;transform:scale(${s.scale})">${b.html}</div>`;
    b.js = hd.js + b.js;
  }
  let sfx = "";
  const laneEnd = [];
  (b.sfx || []).forEach(([name, t, vol], i) => {
    const start = Math.max(0, r3(t + 1 / 30 - (SFX_PEAKS[name] ?? 0.01)));
    const dur = r3(Math.min(sfxLen(name), len - start));
    if (dur <= 0.02) return;
    let lane = laneEnd.findIndex((e) => e <= start);
    if (lane < 0) lane = laneEnd.length;
    laneEnd[lane] = start + dur;
    sfx += `\n    <audio id="${cid}-sfx${i}" class="clip" src="${SFX_DIR}/${name}.wav" data-start="${start}" data-duration="${dur}" data-track-index="${9 + lane}" data-volume="${vol}" data-hf-media-start-basis="local"></audio>`;
  });
  return `<template>
  <style>${FONTFACES}${BASE_CSS(scene.ground)}
  ${b.css || ""}
  </style>
  <div id="root" data-composition-id="${cid}" data-width="${f.W}" data-height="${f.H}">
    ${body.trim()}${sfx}
  </div>
  <script>
    (function () {
      const tl = gsap.timeline({ paused: true });
      ${b.js.trim().replace(/\n\s*/g, "\n      ")}
      tl.set({}, {}, ${len});
      window.__timelines["${cid}"] = tl;
    })();
  </script>
</template>
`;
}

function groups(words) {
  const out = [];
  let cur = [];
  for (const w of words) {
    cur.push(w);
    if (cur.length >= 4 || /[.,?!:;]["”’]?$/.test(w.w)) out.push(cur), (cur = []);
  }
  if (cur.length) out.push(cur);
  for (let i = out.length - 1; i > 0; i--) if (out[i].length === 1 && out[i - 1].length < 4) out[i - 1].push(...out.splice(i, 1)[0]);
  return out;
}

const HEAD = (f, title, bg) => `<!doctype html>
<html lang="en" data-resolution="${f.res}">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=${f.W}, height=${f.H}" />
    <title>${esc(title)}</title>
    <script src="https://cdn.jsdelivr.net/npm/gsap@3.15.0/dist/gsap.min.js"></script>
    <style>* { margin: 0; padding: 0; box-sizing: border-box; } html, body { margin: 0; width: ${f.W}px; height: ${f.H}px; overflow: hidden; background: ${bg}; }</style>
  </head>`;

mkdirSync(`${PROJECT}compositions`, { recursive: true });
mkdirSync(ROOTS, { recursive: true });
const layout = [];
let t = 0;
for (const [i, s] of SCENES.entries()) {
  const v = VO[s.vo];
  if (!v) throw new Error(`no voice line ${s.vo} in ${VO_DIR}/manifest.json (run tts.mjs)`);
  const len = Math.max(s.minLen, halfUp(VO_AT + v.seconds + 0.35));
  layout.push({ n: String(i + 1).padStart(2, "0"), scene: s, start: r3(t), len });
  t += len;
}
const TOTAL = r3(t);

for (const [k, f] of Object.entries(FMT)) {
  const hosts = [], vo = [], duck = [];
  let caps = "", cjs = "", gi = 0;
  for (const it of layout) {
    const cid = `${PREFIX}-${it.n}-${k}`;
    writeFileSync(`${PROJECT}compositions/${cid}.html`, sceneFile(cid, it.scene, it.len, f));
    hosts.push(`<div id="${cid}" data-composition-id="${cid}" data-composition-src="compositions/${cid}.html" data-start="${it.start}" data-duration="${it.len}" data-track-index="1" data-track-kind="graphics" data-width="${f.W}" data-height="${f.H}"></div>`);
    const v = VO[it.scene.vo];
    const s = r3(it.start + VO_AT);
    vo.push(`<audio id="vo-${it.n}-${k}" class="clip" src="${VO_DIR}/${v.id}.wav" data-start="${s}" data-duration="${r3(Math.min(v.seconds, it.len - VO_AT))}" data-track-index="7" data-volume="1"></audio>`);
    duck.push([s, r3(s + v.speechEnd)]);
    if (it.scene.nocap) continue;
    const gs = groups(v.words).map((g) => ({ g, s: r3(s + g[0].s - 0.05), e: r3(Math.min(s + g.at(-1).e + 0.12, it.start + it.len - 0.02)) }));
    gs.forEach((x, i) => { if (gs[i + 1]) x.e = r3(Math.max(x.s + 0.2, Math.min(x.e, gs[i + 1].s))); });
    for (const { g, s: a, e } of gs) {
      caps += `\n    <div class="cg" id="c${PREFIX}${k}-${gi}"><span>${esc(g.map((w) => w.w).join(" "))}</span></div>`;
      cjs += `tl.fromTo("#c${PREFIX}${k}-${gi}", { opacity: 0, y: 10 }, { opacity: 1, y: 0, duration: 0.1, ease: "power2.out" }, ${a});\n`;
      cjs += `tl.to("#c${PREFIX}${k}-${gi}", { opacity: 0, duration: 0.08, ease: "power2.in" }, ${r3(e - 0.08)});\n`;
      cjs += `tl.set("#c${PREFIX}${k}-${gi}", { opacity: 0, visibility: "hidden" }, ${e});\n`;
      gi++;
    }
  }
  const c = f.cap, capId = `cap-${PREFIX}-${k}`;
  writeFileSync(`${PROJECT}compositions/${capId}.html`, `<template>
  <style>
  ${BRAND.label.files.map(([ff, w]) => `@font-face { font-family: "${BRAND.label.family}"; src: url("${ff}"); font-weight: ${w}; }`).join("\n  ")}
  #root { position: absolute; inset: 0; pointer-events: none; }
  #root .cg { position: absolute; left: 60px; right: 60px; top: ${c.top}px; text-align: center; opacity: 0; }
  #root .cg span { display: inline-block; max-width: ${c.max}px; padding: 12px 28px 14px; border-radius: 22px; background: rgba(43, 35, 29, 0.92); color: #FFFCF7; font-family: "${BRAND.label.family}"; font-weight: 700; font-size: ${c.size}px; line-height: 1.15; }
  </style>
  <div id="root" data-composition-id="${capId}" data-width="${f.W}" data-height="${f.H}" data-layout-allow-occlusion>${caps}
  </div>
  <script>
    (function () {
      const tl = gsap.timeline({ paused: true });
      ${cjs.trim().replace(/\n/g, "\n      ")}
      tl.set({}, {}, ${TOTAL});
      window.__timelines["${capId}"] = tl;
    })();
  </script>
</template>
`);
  // music ducks 0.6 → 0.15 under each voice line
  const pts = [{ t: 0, v: 0.6 }];
  for (const [a, b] of duck) pts.push({ t: r3(Math.max(0, a - 0.15)), v: 0.6 }, { t: r3(a), v: 0.15 }, { t: r3(b), v: 0.15 }, { t: r3(b + 0.3), v: 0.6 });
  pts.sort((x, y) => x.t - y.t);
  const auto = JSON.stringify({ version: 1, lanes: [{ target: "volume", points: pts }] });
  const music = existsSync(`${PROJECT}${MUSIC}`) ? `<audio id="music-${PREFIX}-${k}" class="clip" src="${MUSIC}" data-start="0" data-duration="${TOTAL}" data-track-index="8" data-volume="1" data-timeline-role="music" data-automation='${auto}'></audio>` : "<!-- no music yet: run fit-music.py -->";
  writeFileSync(`${ROOTS}${SLUG}-${k}.html`, `${HEAD(f, `${BRAND.name}: ${SLUG} (${k === "h" ? "16:9" : "9:16"})`, G.cream)}
  <body>
    <div id="root" data-composition-id="main" data-start="0" data-duration="${TOTAL}" data-width="${f.W}" data-height="${f.H}">
      ${hosts.join("\n      ")}
      <div id="${capId}" data-composition-id="${capId}" data-composition-src="compositions/${capId}.html" data-start="0" data-duration="${TOTAL}" data-track-index="3" data-track-kind="captions" data-width="${f.W}" data-height="${f.H}" style="z-index:6"></div>
      ${vo.join("\n      ")}
      ${music}
    </div>
    <script>window.__timelines["main"] = gsap.timeline({ paused: true });</script>
  </body>
</html>
`);
}

// thumbnail
{
  const id = `${PREFIX}-thumb`, f = FMT.h;
  writeFileSync(`${PROJECT}compositions/${id}.html`, `<template>
  <style>${FONTFACES}${BASE_CSS(THUMB.ground)}
  ${THUMB.css}
  </style>
  <div id="root" data-composition-id="${id}" data-width="1920" data-height="1080">
    ${THUMB.html()}
  </div>
  <script>(function () { const tl = gsap.timeline({ paused: true }); tl.set({}, {}, 1); window.__timelines["${id}"] = tl; })();</script>
</template>
`);
  writeFileSync(`${ROOTS}${SLUG}-thumb.html`, `${HEAD(f, `${BRAND.name}: ${SLUG} thumbnail`, THUMB.ground)}
  <body>
    <div id="root" data-composition-id="main" data-start="0" data-duration="1" data-width="1920" data-height="1080">
      <div id="${id}" data-composition-id="${id}" data-composition-src="compositions/${id}.html" data-start="0" data-duration="1" data-track-index="1" data-track-kind="graphics" data-width="1920" data-height="1080"></div>
    </div>
    <script>window.__timelines["main"] = gsap.timeline({ paused: true });</script>
  </body>
</html>
`);
}

writeFileSync(`${ROOTS}${SLUG}.json`, JSON.stringify({ length: TOTAL, end: layout.at(-1).len, scenes: layout.map((it) => ({ n: it.n, vo: it.scene.vo, start: it.start, len: it.len })) }, null, 1));
console.log(`${SLUG}: ${TOTAL} s · ${layout.map((it) => `${it.n}@${it.start}(${it.len})`).join(" ")}`);
console.log(`roots: tools/roots/${SLUG}-h.html, ${SLUG}-v.html, ${SLUG}-thumb.html`);
