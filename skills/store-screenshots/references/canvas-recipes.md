# Canvas recipes

The Design type's own instructions (returned when the canvas is created or read) are the authority for the `.dc.html` format; this file holds what worked for store sets on top of them.

## Canvas layout (`project/canvas.json`)

- Rows: iPhone at `y: 0`; Play at `y: 3288`; iPad at `y: 5628`; shared screens at `y: 8800`. Rows need 120 px clear plus room for the row title.
- Columns: frame width + 80 px gap (iPhone x step 1400, Play 1160, iPad 2144, screens 470).
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
      frameBorder: device ? '30px solid #201D22' : '4px solid #D9D4C8',
      frameRadius: device ? 168 : 112
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

## Shared screens and the phone crop

- App screens are their own 390 x 844 artboards (`ScreenChat`, `ScreenOffline`, …) in the screens row; frames mount them with `<dc-import name="ScreenChat" hint-size="390px,844px"></dc-import>`. Edit a screen once and every set follows.
- iPhone phone: outer `975 x 2110` box (`border: {{frameBorder}}; border-radius: {{frameRadius}}px; overflow: hidden`) centred with `left: 50%; transform: translateX(-50%)`, top ~780 so it bleeds off the bottom; inside, the 390 x 844 screen at `transform: scale(2.5); transform-origin: 0 0`.
- Notch: `<sc-if value="{{island}}" hint-placeholder-val="{{true}}">` pill (left 132, top 11, 126 x 36, radius 18) and `<sc-if value="{{hole}}" hint-placeholder-val="{{false}}">` dot (left 189, top 16, 12 x 12) in screen coordinates. Apple frames never show the hole.

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

- Draw an iPad: screen box `1380 x 1840`, centred, top ~820, `frameBorder: device ? '36px solid #201D22' : '5px solid #D9D4C8'`, `frameRadius: device ? 110 : 80`; a 12 px camera dot (#3A363D) on the bezel inside `<sc-if value="{{device}}">`. No `platform` tweak: iPad is Apple-only.
- Inside, the app as it really runs on iPad: the 390 x 844 screen scaled `2.1801` at `left: 265px` (390 × 2.1801 = 850; (1380 − 850) / 2 = 265; 844 × 2.1801 = 1840): a centred column with whitespace either side.
- Put the lifted cards in that side whitespace so they don't hide content. Frames without a phone get their own wider layout (wider cards, bigger photos).
- Copy is duplicated from the iPhone frames: edit both when copy changes.

## Play feature graphic (1024 x 500)

Mascot or logo, name, one tagline, one support line; brand background (not pure white, black or dark gray); nothing near the edges; no device, badges or "free".

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
