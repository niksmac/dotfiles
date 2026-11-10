# Canvas recipes

The Design type's own instructions (returned when the canvas is created or read) are the authority for the `.dc.html` format; this file holds what worked for store sets on top of them.

## Canvas layout (`project/canvas.json`)

- Rows: iPhone 6.9" at `y: 0`; Play at `y: 3288`; iPad at `y: 5628`; shared parts (screens, art boards) at `y: 8800`; iPhone 6.3" at `y: 11400` (or below the last row). Rows need 120 px clear plus room for the row title.
- Columns: frame width + 80 px gap (iPhone 6.9" x step 1400, iPhone 6.3" 1286, Play 1160, iPad 2144, screens 470, art boards 1400).
- Board entry: `{"x","y","w","h","title"}`, title like `"Store 2 · Your life at a glance"`, `"Play 2 · …"`, `"iPad 2 · …"`. Every artboard is listed in `boards` and `order`, imported ones too.
- Row titles: a note with `"kind":"title1"`, `y` = row y − 300, `maxW` = the row's width. Never a title1 for one artboard.
- Stickies: a note with `w` and `fill`. Valid fills: gray, red, orange, green, teal, blue, purple, pink (**not** yellow). One sticky per row at the row's end: export size, policy reminders, how the row is built.
- Keep `v`, `createdOnFiles`, `attachments`, `designSystems`, `pages`, `launch` and `noteOrder` as read; change only your keys.

## Artboard skeleton (store frame)

```html
<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8">
<title>Store 4, your photos remembered</title>
<script src="./support.js"></script>
</head>
<body>
<x-dc>
<helmet>
<link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=DM+Serif+Display&amp;family=Inter:wght@400;500;600&amp;display=swap">
<style>
body{margin:0}
</style>
</helmet>
<div style="width: 1320px; height: 2868px; position: relative; overflow: hidden; box-sizing: border-box; background: {{bg}}; color: #201D22; font-family: Inter, -apple-system, 'Segoe UI', sans-serif;">
  <div style="position: absolute; left: 100px; right: 100px; top: 170px; display: flex; flex-direction: column; align-items: center; gap: 36px; text-align: center;">
    <h1 style="margin: 0; font-family: 'DM Serif Display', Georgia, serif; font-weight: 400; font-size: 140px; line-height: 148px; letter-spacing: -2px;">Your photos,<br><span style="background: #E2F68B; border-radius: 24px; padding: 0 18px;">remembered.</span></h1>
    <p style="margin: 0; max-width: 1060px; font-size: 54px; line-height: 66px; color: #5F5A60;">One short sub-line.</p>
  </div>
  <!-- lifted cards, photos, phone crop -->
</div>
</x-dc>
<script type="text/x-dc" data-dc-script data-props='{"bg":{"editor":"color","default":"#F2F0E8","options":["#F2F0E8","#E9E6DD","#D5DFDB","#E2F68B"]},"platform":{"editor":"enum","options":["ios","android"],"default":"ios"},"device":{"editor":"boolean","default":true},"$preview":{"width":1320,"height":2868}}'>
class Component extends DCLogic {
  renderVals() {
    const device = this.props.device ?? true;
    const android = (this.props.platform ?? 'ios') === 'android';
    return {
      bg: this.props.bg ?? '#F2F0E8',
      island: device && !android,
      hole: device && android,
      frameBorder: device ? '30px solid #201D22' : '0px solid transparent',
      frameRadius: device ? 168 : 0
    };
  }
}
</script>
</body>
</html>
```

Rules that bite (fail silently): keep the `support.js` head line exactly; `{{hole}}` is a lookup, never an expression (compute in `renderVals()`); inline `style` is what the panel edits; tweaks (`data-props`) are levers (background, platform, device), never copy; `<helmet>` holds only the font link and `body{margin:0}`-type basics; icons as inline stroke SVG with `aria-hidden="true"`; text that must stay editable is literal markup.

## Type and card scale

| | iPhone 1320 | iPad 2064 |
|---|---|---|
| Headline (serif) | 140 / 148 px, −2 px tracking, top 170 | 170 / 178 px, −2.5 px, top 180 |
| Sub-line | 54 / 66 px, max-width ~1060 | 64 / 80 px, max-width ~1600 |
| Card | border 2 px #E0DCD1, radius 48–56, padding 40–56, shadow `0 30px 80px rgba(32,29,34,0.14)`, rotate ±1–3° | border 3 px, radius 56–64, shadow `0 36px 96px …` |
| Card text | 40–42 / 54–58 px; label 30–34 px 600 | 46–54 / 62–70 px |
| Fine print | 28–38 px, #6B656C | 34–44 px |

Highlighter word: `<span style="background: <accent>; border-radius: 24px; padding: 0 18px;">`.

App's own fonts (when the user asks for the repo's fonts): upload the font file as an asset and declare it in every artboard's `<helmet><style>`, imports included: `@font-face{font-family:'Fraunces';src:url('/_blob/<id>') format('truetype');font-weight:100 900;font-style:normal;font-display:block}`. A variable font keeps its axes (`font-variation-settings: 'SOFT' 100`); read them from the file's `fvar` table before using them.

## Shared screens and the phone (bezel on top, no clipping)

- App screens are their own 390 x 844 artboards (`ScreenChat`, `ScreenOffline`, …) in the shared row; frames mount them with `<dc-import name="ScreenChat" hint-size="390px,844px"></dc-import>`. Edit a screen once and every set follows.
- Never draw the phone as a rounded `overflow: hidden` box around the screen: the canvas exporter drops images inside rounded clipping (see Export-safe markup). Draw the screen underneath and the bezel as a border layer on top; the border paints over the screen's square corners.

```html
<div style="position: absolute; left: 142px; top: 880px; width: 1035px; height: 2170px; border-radius: {{frameRadius}}px; box-shadow: 0 50px 120px rgba(32,29,34,0.25);">
  <div style="position: absolute; left: 30px; top: 30px; width: 390px; height: 844px; transform: scale(2.5); transform-origin: 0 0;">
    <dc-import name="ScreenChat" hint-size="390px,844px"></dc-import>
    <sc-if value="{{island}}" hint-placeholder-val="{{true}}"><div style="position: absolute; left: 132px; top: 11px; width: 126px; height: 36px; border-radius: 18px; background: #000000;"></div></sc-if>
    <sc-if value="{{hole}}" hint-placeholder-val="{{false}}"><div style="position: absolute; left: 189px; top: 16px; width: 12px; height: 12px; border-radius: 50%; background: #000000;"></div></sc-if>
  </div>
  <div style="position: absolute; left: 0; top: 0; width: 1035px; height: 2170px; box-sizing: border-box; border: {{frameBorder}}; border-radius: {{frameRadius}}px;"></div>
</div>
```

- Sizes: screen 975 x 2110 (390 x 844 at 2.5x) plus a 30 px bezel = 1035 x 2170; centred at `left: 142px`, top ~880 so it bleeds off the bottom. Shift `left` to make room for lifted cards on one side.
- Notch in screen coordinates: island (left 132, top 11, 126 x 36, radius 18) on Apple frames, camera hole (left 189, top 16, 12 x 12) on Play frames only.
- `device` off: `frameBorder` `0px solid transparent`, `frameRadius` 0, a plain square screen.

## Shared art boards (one visual, every set)

- A frame's visual without a device (lifted cards, illustrations, photos) is its own artboard, 1320 x 2060, with a `bg` tweak that importers set to `transparent`. The iPhone frame holds only background, headline and sub-line and imports it at `left: 0; top: 808px`; the iPad frame imports the same board at `left: 372px; top: 720px` to `800px` and adds extra illustrations in the side space. Edit the visual once and both sets follow.
- Frames with a device (phone screens) stay bespoke per set, since iPad slots need an iPad.

## iPhone 6.3" frames (import the 6.9" frame)

App Store Connect requires the 6.3" slot (1206 x 2622) and rejects a 1320 x 2868 file there. Each 6.3" frame imports its 6.9" frame scaled by height:

```html
<div style="width: 1206px; height: 2622px; position: relative; overflow: hidden; background: {{bg}};">
  <div style="position: absolute; left: -0.39px; top: 0; width: 1320px; height: 2868px; transform: scale(0.914226); transform-origin: 0 0;">
    <dc-import name="Ios2" platform="ios" bg="{{bg}}" device="{{device}}" hint-size="1320px,2868px"></dc-import>
  </div>
</div>
```

Scale = 2622 / 2868 = 0.914226; the 1320 px width becomes 1206.78, so `left: -0.39px` trims 0.4 px a side. Board title like `"iPhone 6.3 · 2 · …"`; give the row a red sticky saying it is the required slot.

## Play frames (import the iPhone frame)

```html
<div style="width: 1080px; height: 1920px; position: relative; overflow: hidden; background: {{bg}};">
  <div style="position: absolute; left: 98px; top: 0; width: 1320px; height: 2868px; transform: scale(0.6695); transform-origin: 0 0;">
    <dc-import name="IosImages" platform="android" bg="{{bg}}" device="{{device}}" hint-size="1320px,2868px"></dc-import>
  </div>
</div>
```

Scale = 1920 / 2868 = 0.6695; left = (1080 − 1320 × 0.6695) / 2 = 98. Play's own `bg` and `device` tweaks pass through. Edit the iPhone frame and Play follows; never hand-copy.

## iPad frames (bespoke)

- Draw the iPad the same way as the phone, bezel on top: a 1452 x 1912 wrapper centred (`left: 306px`, top ~790 to 820) holding a shadow layer, the 1380 x 1840 screen at `left: 36px; top: 36px` with the app's background colour, and a top layer with `border: {{frameBorder}}; border-radius: {{frameRadius}}px` (`device ? '36px solid #201D22' : '0px solid transparent'`, `device ? 110 : 0`). A 12 px camera dot (#3A363D) at `left: 720px; top: 12px`, after the bezel layer, inside `<sc-if value="{{device}}">`. No `platform` tweak: iPad is Apple-only.
- Inside the screen, the app as it really runs on iPad: the 390 x 844 screen scaled `2.1801` at `left: 265px` (390 × 2.1801 = 850; (1380 − 850) / 2 = 265; 844 × 2.1801 = 1840): a centred column with whitespace either side.
- Put the lifted cards in that side whitespace so they don't hide content. Frames without a device import the shared art board (above) and add illustrations in the side space.
- Headline 150 / 160 px for Fraunces-weight serifs (170 for lighter display serifs), two lines; leave about 100 px between the sub-line and the visual, which usually means starting the art board at 760 to 800.
- Copy is duplicated from the iPhone frames: edit both when copy changes.

## Play feature graphic (1024 x 500)

Mascot or logo, name, one tagline, one support line; brand background (not pure white, black or dark gray); nothing near the edges; no device, badges or "free".

## Export-safe markup (rules that fail silently in the export)

The canvas exporter copies the artboard into an SVG `foreignObject` and draws that to a PNG. Images inside rounded clipping come out blank with no warning on the frame (seen 2026-11-10: a picture positioned past its box inside a `border-radius` + `overflow: hidden` cover vanished, while an unclipped, rotated image on the same frame exported fine). So:

- No image inside a rounded `overflow: hidden` box. Draw the image at its box size with `object-fit: cover | contain`, its own `border-radius` and a `background` colour behind transparent pixels.
- Zoomed crops (a face from a big illustration): pre-crop the file locally (`magick in.png -crop WxH+X+Y +repage -background '#hex' -gravity northwest -extent WxH -alpha remove -alpha off -resize 1000x1000 -quality 90 out.jpg`), check it on a contact sheet, upload it, show it with `object-fit: cover`. Lighter files too.
- Mosaics (2 x 2 covers): a plain grid of images, each with its own corner radius (`34px 0 0 0`, `0 34px 0 0`, …), no clipping container.
- Devices: bezel on top, never a clipping box (recipe above).
- Rectangular `overflow: hidden` on an artboard root is fine; rotation and `scale()` wrappers are fine.
- Prefer opaque or light images; every image is downloaded and inlined at export, and a failed download also renders blank ("N images could not be embedded and render blank in the export").

## Exporting for upload

- The exporter's default scale is **2x** (a 1320 x 2868 frame exports as 2640 x 5736) and **PNG keeps alpha**. App Store Connect and Play reject both. Tell the user to export at 1x where the dialog offers it, then always run `scripts/normalize-exports.sh <export-dir> [out-dir]` from this skill (copy it beside the plan in the app's repo). It detects each file's slot from its aspect ratio (6.3" and 6.9" iPhone, iPad 13", Play phone, feature graphic), scales 2x or 3x exports to the exact size, flattens alpha, writes sRGB JPEGs to `<out-dir>/<slot>/` and exits non-zero for a file that matches no store size.
- Upload map: `ios-6.3` to the 6.3" slot (required), `ios-6.9` to the 6.9" slot, `ipad-13` to the 13" iPad slot, `play` and `play-fg` to Play Console.
- Ask which frame is wrong if an image is missing; check its markup against the rules above before anything else.

## Publish calls

```text
create:   {action:"quickstart", intent:"design"} -> {type_url:<Design>, title:"<App> store screenshots", auto_open:"after_first_write"}
assets:   {action:"publish", url, asset:true, file_paths:[...]}  -> /_blob/<id> each (one approval for up to 25)
files:    {url, root:"<scratch>/store-canvas", file_path:"<root>/project/canvas.json", files:{"project/X.dc.html":"project/X.dc.html", ...}, label:"Short change name"}
remove:   files:{"project/Old.dc.html": null} plus drop it from boards and order
re-read:  {action:"read", url, path:"project/canvas.json"} (or paths:[...]) before a layout publish
```

`file_path` must be one of the files sent; when `canvas.json` is not changing, use one changed artboard as `file_path`.

## Stock photos (Wikimedia Commons)

Search (official API, generic User-Agent, no personal email):

```python
import json,sys,urllib.request,urllib.parse
UA={'User-Agent':'StoreDesign/1.0 (store screenshot mockups)'}
q=sys.argv[1]   # e.g. "Unsplash family"
u='https://commons.wikimedia.org/w/api.php?'+urllib.parse.urlencode(dict(format='json',action='query',generator='search',
  gsrsearch=q+' filetype:bitmap',gsrnamespace=6,gsrlimit=40,prop='imageinfo',iiprop='url|size|extmetadata',iiurlwidth=1600))
for p in json.load(urllib.request.urlopen(urllib.request.Request(u,headers=UA)))['query']['pages'].values():
    ii=p['imageinfo'][0]; lic=ii['extmetadata'].get('LicenseShortName',{}).get('value','')
    if 'cc0' in lic.lower() or 'public domain' in lic.lower(): print(lic, ii['width'], ii['height'], p['title'], ii['thumburl'])
```

- `Unsplash <subject>` finds modern stock-style CC0 imports; plain searches return mostly archival or government photos.
- Commons rate-limits (HTTP 429) quickly: few queries, `time.sleep(3)` between downloads, honour `Retry-After`, and run the download with `run_in_background` and backoff.
- Download 1280 px thumbs (`iiurlwidth=1280`) for the shortlist into their own folder, build a sheet with `magick montage c*.jpg -geometry 480x360+6+6 -tile 5x sheet.jpg`, Read it, pick.
- In the frame: `<img src="/_blob/<id>" alt="…" style="object-fit: cover; object-position: 45% 50%; box-sizing: content-box; border: 18px solid #FFFFFF; border-radius: 20px; transform: rotate(-4deg); …">` (a white-bordered print). Note the source page per photo in the plan.

## Local previews (only for picking assets, never to verify the canvas)

- PIL is not installed; use ImageMagick `magick`. For several images per sheet use `montage`, or per-image `\( … \)` groups with `+append` (not `-flatten`, which merges them).
- ImageMagick renders SVG gradients wrong (black blobs). Rasterize SVGs with librsvg through the system Python: `/usr/bin/python3` with `gi` (`GdkPixbuf.Pixbuf.new_from_file_at_size`). Homebrew python lacks `gi`.
