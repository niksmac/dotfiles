#!/usr/bin/env bash
# Check a rendered video: duration vs the root, size, fps, loudness and true peak.
#   bash <skill>/scripts/check-render.sh deliver/<slug>/<slug>-16x9.mp4 [expected-seconds]
# Targets: duration = root (±0.05 s), integrated −14 to −16 LUFS, true peak ≤ −1 dBTP.
set -euo pipefail
f=$1; want=${2:-}
dur=$(ffprobe -v error -show_entries format=duration -of csv=p=0 "$f")
vid=$(ffprobe -v error -select_streams v:0 -show_entries stream=width,height,r_frame_rate -of csv=p=0 "$f")
aud=$(ffprobe -v error -select_streams a:0 -show_entries stream=codec_name,sample_rate -of csv=p=0 "$f" || true)
loud=$(ffmpeg -nostdin -i "$f" -af ebur128=peak=true -f null - 2>&1 | sed -n '/Summary:/,$p')
I=$(echo "$loud" | awk '/I:/{print $2; exit}'); TP=$(echo "$loud" | awk '/Peak:/{print $2; exit}')
echo "$f"
echo "  video $vid · audio ${aud:-none} · $(du -h "$f" | cut -f1)"
echo "  duration ${dur}s${want:+ (root ${want}s)}"
echo "  loudness ${I} LUFS · true peak ${TP} dBTP"
ok=1
if [ -n "$want" ] && ! python3 -c "import sys; sys.exit(0 if abs($dur-$want)<=0.05 else 1)"; then echo "  ✗ duration differs from the root"; ok=0; fi
python3 -c "import sys; sys.exit(0 if -16.5<=float('${I:-nan}')<=-13.5 else 1)" || { echo "  ✗ loudness outside −14…−16 LUFS"; ok=0; }
python3 -c "import sys; sys.exit(0 if float('${TP:-nan}')<=-0.9 else 1)" || { echo "  ✗ true peak above −1 dBTP"; ok=0; }
[ $ok = 1 ] && echo "  ✓ ok"
