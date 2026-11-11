#!/usr/bin/env bash
# Make canvas exports upload-safe for App Store Connect and Google Play.
#
# Usage: normalize-exports.sh <export-dir> [out-dir]
#
# For every PNG/JPEG in <export-dir>, it works out which store slot the image
# belongs to from its aspect ratio and scale (a 2x or 3x export is detected),
# resizes it to the exact pixel size, removes the alpha channel (both stores
# reject alpha) and writes an sRGB JPEG to <out-dir>/<slot>/.
#
# Slots (verified 2026-11-10 against Apple's screenshot specifications and
# Play Console help 9866151). Every size Apple accepts is listed, so a file
# already at an accepted size keeps it instead of being stretched to another:
#   ios-6.3   1206 x 2622 or 1179 x 2556   iPhone, Dynamic Island (medium). Required.
#   ios-6.9   1320 x 2868, 1290 x 2796 or 1260 x 2736   iPhone, Dynamic Island (large).
#   ipad-13   2064 x 2752 or 2048 x 2732   iPad 13 inch. Required when the app runs on iPad.
#   mac       2880 x 1800, 2560 x 1600, 1440 x 900 or 1280 x 800   Mac (16:10).
#   play      1080 x 1920   Play phone screenshot (9:16, at least 1080 px).
#   play-fg   1024 x  500   Play feature graphic.
# A 2x or 3x export scales down to the largest size of its slot that it is a
# whole or half multiple of (5760 x 3600 becomes 2880 x 1800).
#
# Needs ImageMagick 7 (`magick`).
set -euo pipefail

in_dir=${1:?usage: normalize-exports.sh <export-dir> [out-dir]}
out_dir=${2:-"$in_dir/upload"}

# Largest size first: on a tie (2880 x 1800 is also 2x of 1440 x 900) the
# earlier entry wins.
slots=(
  "ios-6.3 1206 2622"
  "ios-6.3 1179 2556"
  "ios-6.9 1320 2868"
  "ios-6.9 1290 2796"
  "ios-6.9 1260 2736"
  "ipad-13 2064 2752"
  "ipad-13 2048 2732"
  "mac 2880 1800"
  "mac 2560 1600"
  "mac 1440 900"
  "mac 1280 800"
  "play 1080 1920"
  "play-fg 1024 500"
)

# Picks the slot whose aspect ratio matches (within 0.3%) and whose scale is
# closest to a whole or half step (1x, 1.5x, 2x, 3x...). Prints
# "<name> <w> <h>" or nothing.
pick_slot() {
  local w=$1 h=$2
  local best="" best_err=99
  for s in "${slots[@]}"; do
    read -r name sw sh <<<"$s"
    local res
    res=$(awk -v w="$w" -v h="$h" -v sw="$sw" -v sh="$sh" 'BEGIN {
      kx = w / sw; ky = h / sh
      if (kx <= 0 || ky <= 0) { print "x"; exit }
      d = kx / ky; if (d < 1) d = 1 / d
      if (d - 1 > 0.003) { print "x"; exit }
      k = (kx + ky) / 2
      step = int(k * 2 + 0.5) / 2
      if (step < 1) step = 1
      err = k - step; if (err < 0) err = -err
      printf "%.6f", err
    }')
    [[ $res == x ]] && continue
    if awk -v a="$res" -v b="$best_err" 'BEGIN { exit !(a < b) }'; then
      best="$name $sw $sh"
      best_err=$res
    fi
  done
  [[ -n $best ]] && echo "$best"
}

shopt -s nullglob nocaseglob
files=("$in_dir"/*.png "$in_dir"/*.jpg "$in_dir"/*.jpeg)
shopt -u nocaseglob
if ((${#files[@]} == 0)); then
  echo "No PNG or JPEG files in $in_dir" >&2
  exit 1
fi

fail=0
for f in "${files[@]}"; do
  read -r w h alpha < <(magick identify -format '%w %h %A\n' "$f[0]")
  slot=$(pick_slot "$w" "$h" || true)
  if [[ -z $slot ]]; then
    echo "SKIP  $(basename "$f"): ${w}x${h} matches no store size" >&2
    fail=1
    continue
  fi
  read -r name sw sh <<<"$slot"
  mkdir -p "$out_dir/$name"
  out="$out_dir/$name/$(basename "${f%.*}").jpg"
  magick "$f[0]" -colorspace sRGB -background white -alpha remove -alpha off \
    -filter Lanczos -resize "${sw}x${sh}!" -strip -quality 92 "$out"
  read -r ow oh oa < <(magick identify -format '%w %h %A\n' "$out")
  if [[ $ow != "$sw" || $oh != "$sh" ]]; then
    echo "FAIL  $(basename "$f"): wrote ${ow}x${oh}, expected ${sw}x${sh}" >&2
    fail=1
    continue
  fi
  note=""
  [[ $w != "$sw" || $h != "$sh" ]] && note=" (resized from ${w}x${h})"
  [[ $alpha != "False" && $alpha != "Undefined" ]] && note+=" (alpha removed)"
  echo "OK    $name  $(basename "$out")  ${ow}x${oh}${note}"
done

echo "Upload-ready files are in $out_dir"
exit $fail
