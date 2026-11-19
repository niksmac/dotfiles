#!/usr/bin/env bash
# Turn an animated logo (GIF, or a short MP4/WebM) into a keyed PNG sprite sheet for frame-accurate playback.
#   bash <skill>/scripts/logo-sprite.sh logo.gif video/assets/brand/logo-anim [--key 0xFFFFFF] [--sim 0.25] [--blend 0.15] [--no-key] [--size 512]
# Writes <prefix>.png (a grid of frames) and <prefix>.json { frames, fps, cols, rows, size }.
# In a scene: background: url(<prefix>.png) 0% 0% / (cols*100)% (rows*100)%, then step background-position
# at fps: frame f → x = (f % cols) * 100/(cols-1) %, y = floor(f / cols) * 100/(rows-1) %  (see the template's end card).
# A GIF in an <img> plays on wall-clock time and is not frame-accurate in a render; this is why the sprite exists.
set -euo pipefail
src=$1; prefix=$2; shift 2
key=0xFFFFFF; sim=0.25; blend=0.15; dokey=1; size=512
while [ $# -gt 0 ]; do
  case $1 in
    --key) key=$2; shift 2 ;; --sim) sim=$2; shift 2 ;; --blend) blend=$2; shift 2 ;;
    --no-key) dokey=0; shift ;; --size) size=$2; shift 2 ;; *) echo "unknown option $1"; exit 1 ;;
  esac
done
frames=$(ffprobe -v error -count_frames -select_streams v:0 -show_entries stream=nb_read_frames -of csv=p=0 "$src")
rate=$(ffprobe -v error -select_streams v:0 -show_entries stream=avg_frame_rate -of csv=p=0 "$src")
fps=$(python3 -c "n,d='$rate'.split('/');print(round(float(n)/float(d or 1),3))")
cols=$(( frames < 6 ? frames : 6 )); rows=$(( (frames + cols - 1) / cols ))
mkdir -p "$(dirname "$prefix")"
vf="format=rgba"
[ $dokey = 1 ] && vf="$vf,colorkey=$key:$sim:$blend"
ffmpeg -nostdin -v error -y -i "$src" -vf "$vf,scale=$size:$size:flags=lanczos:force_original_aspect_ratio=decrease,pad=$size:$size:(ow-iw)/2:(oh-ih)/2:color=0x00000000,tile=${cols}x${rows}:color=0x00000000" -frames:v 1 -pix_fmt rgba "$prefix.png"
printf '{ "frames": %s, "fps": %s, "cols": %s, "rows": %s, "size": %s, "source": "%s" }\n' "$frames" "$fps" "$cols" "$rows" "$size" "$(basename "$src")" > "$prefix.json"
echo "$prefix.png: $frames frames at $fps fps in a ${cols}x${rows} grid of ${size}px ($(du -h "$prefix.png" | cut -f1)); loop $(python3 -c "print(round($frames/$fps,2))") s"
echo "check the key on the scene ground before using it (a light logo needs --no-key or a different --key)"
