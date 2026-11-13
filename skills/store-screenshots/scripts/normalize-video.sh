#!/usr/bin/env bash
# Make a video upload-ready as an App Store app preview or creative asset.
#
# Usage: normalize-video.sh <kind> <input> [output.mp4]
#
# Kinds (verified 2026-11-11 against Apple's app preview and creative assets
# specifications):
#   preview-iphone  886 x 1920 portrait or 1920 x 886 landscape (every
#                   Dynamic Island, Face ID and iPhone Duo class), 15 to 30 s.
#   preview-ipad    1200 x 1600 portrait or 1600 x 1200 landscape, 15 to 30 s.
#   preview-mac     1920 x 1080 landscape (also Apple TV), 15 to 30 s.
#   asc-header      Product page header video, 21:9 3840 x 1646, 5 to 30 s.
#   asc-search      Search results video, 3:2, 3840 x 2560 (input at least
#                   3840 wide) or 1920 x 1280, 5 to 30 s.
#
# App previews: H.264 High Profile Level 4.0, constant 30 fps, ~11 Mbps,
# AAC 256 kbps stereo 48 kHz (a silent track is added when the input has no
# audio). Creative assets: H.264 High, 30 or 60 fps (60 when the input runs at
# 50 fps or more), audio kept when present (they play muted by default).
# Both: yuv420p, Rec. 709, +faststart MP4.
#
# It refuses, rather than crops or trims, an input whose aspect ratio is more
# than 1% off the target or whose length is out of range: re-export instead.
# Orientation follows the input (rotation metadata included).
#
# Needs ffmpeg and ffprobe with libx264.
set -euo pipefail

kind=${1:?usage: normalize-video.sh <kind> <input> [output.mp4]}
in=${2:?usage: normalize-video.sh <kind> <input> [output.mp4]}
out=${3:-"${in%.*}.$kind.mp4"}

probe() { ffprobe -v error "$@" -of default=nw=1:nk=1 "$in"; }

w=$(probe -select_streams v:0 -show_entries stream=width)
h=$(probe -select_streams v:0 -show_entries stream=height)
rot=$(probe -select_streams v:0 -show_entries stream_side_data=rotation | head -1)
rot=${rot:-0}
if (( ${rot#-} == 90 || ${rot#-} == 270 )); then
  t=$w; w=$h; h=$t
fi
dur=$(probe -show_entries format=duration)
fps=$(probe -select_streams v:0 -show_entries stream=avg_frame_rate)
fps=$(awk -v r="$fps" 'BEGIN { n = split(r, a, "/"); printf "%.3f", (n == 2 && a[2] > 0) ? a[1] / a[2] : r }')
has_audio=$(probe -select_streams a -show_entries stream=index | head -1)

portrait=0
(( h > w )) && portrait=1

case $kind in
  preview-iphone)
    if ((portrait)); then tw=886; th=1920; else tw=1920; th=886; fi
    min=15; preview=1 ;;
  preview-ipad)
    if ((portrait)); then tw=1200; th=1600; else tw=1600; th=1200; fi
    min=15; preview=1 ;;
  preview-mac)
    tw=1920; th=1080; min=15; preview=1 ;;
  asc-header)
    tw=3840; th=1646; min=5; preview=0 ;;
  asc-search)
    if (( w >= 3840 )); then tw=3840; th=2560; else tw=1920; th=1280; fi
    min=5; preview=0 ;;
  *)
    echo "Unknown kind: $kind (preview-iphone, preview-ipad, preview-mac, asc-header, asc-search)" >&2
    exit 2 ;;
esac

err=$(awk -v w="$w" -v h="$h" -v tw="$tw" -v th="$th" \
  'BEGIN { d = (w / h) / (tw / th); if (d < 1) d = 1 / d; printf "%.4f", d - 1 }')
if awk -v e="$err" 'BEGIN { exit !(e > 0.01) }'; then
  echo "FAIL  ${w}x${h} is not the ${tw}x${th} aspect ratio (off by $(awk -v e="$err" 'BEGIN { printf "%.1f", e * 100 }')%); re-export at that ratio" >&2
  exit 1
fi
if awk -v d="$dur" -v lo="$min" 'BEGIN { exit !(d < lo || d > 30) }'; then
  echo "FAIL  length $(printf %.1f "$dur") s is outside ${min} to 30 s; re-edit the video" >&2
  exit 1
fi

if ((preview)); then
  rate=30
else
  rate=$(awk -v f="$fps" 'BEGIN { print (f >= 50) ? 60 : 30 }')
fi

vf="scale=${tw}:${th}:flags=lanczos,setsar=1,fps=${rate},format=yuv420p"
video=(-c:v libx264 -profile:v high -pix_fmt yuv420p -r "$rate" -fps_mode cfr
  -color_primaries bt709 -color_trc bt709 -colorspace bt709)
if ((preview)); then
  video+=(-level:v 4.0 -b:v 11M -maxrate 12M -bufsize 24M -preset slow)
else
  video+=(-crf 16 -maxrate 40M -bufsize 80M -preset slow)
fi
audio=(-c:a aac -b:a 256k -ar 48000 -ac 2)

if [[ -n $has_audio ]]; then
  ffmpeg -v error -y -i "$in" -map 0:v:0 -map 0:a:0 -vf "$vf" "${video[@]}" "${audio[@]}" \
    -movflags +faststart "$out"
elif ((preview)); then
  ffmpeg -v error -y -i "$in" -f lavfi -i anullsrc=channel_layout=stereo:sample_rate=48000 \
    -map 0:v:0 -map 1:a:0 -shortest -vf "$vf" "${video[@]}" "${audio[@]}" \
    -movflags +faststart "$out"
else
  ffmpeg -v error -y -i "$in" -map 0:v:0 -vf "$vf" "${video[@]}" -movflags +faststart "$out"
fi

# Check what was written.
ow=$(ffprobe -v error -select_streams v:0 -show_entries stream=width -of default=nw=1:nk=1 "$out")
oh=$(ffprobe -v error -select_streams v:0 -show_entries stream=height -of default=nw=1:nk=1 "$out")
ofps=$(ffprobe -v error -select_streams v:0 -show_entries stream=avg_frame_rate -of default=nw=1:nk=1 "$out")
oprof=$(ffprobe -v error -select_streams v:0 -show_entries stream=profile -of default=nw=1:nk=1 "$out")
olevel=$(ffprobe -v error -select_streams v:0 -show_entries stream=level -of default=nw=1:nk=1 "$out")
odur=$(ffprobe -v error -show_entries format=duration -of default=nw=1:nk=1 "$out")
ach=$(ffprobe -v error -select_streams a:0 -show_entries stream=channels -of default=nw=1:nk=1 "$out")
size=$(wc -c <"$out")

ok=1
[[ $ow == "$tw" && $oh == "$th" ]] || ok=0
[[ $ofps == "$rate/1" ]] || ok=0
((size <= 500 * 1024 * 1024)) || ok=0
if ((preview)); then
  [[ $ach == 2 && $olevel -le 40 ]] || ok=0
fi
summary="${ow}x${oh} ${ofps%/1} fps ${oprof} L${olevel} $(printf '%.1f' "$odur")s audio=${ach:-none} $((size / 1024 / 1024)) MB"
if ((ok)); then
  echo "OK    $kind  $out  $summary"
else
  echo "FAIL  $kind  $out  $summary (expected ${tw}x${th} at ${rate} fps)" >&2
  exit 1
fi
