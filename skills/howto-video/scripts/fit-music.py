"""Fit a music track to a video so its final hit lands on the end card.

    python3 <skill>/scripts/fit-music.py --src score.wav --out video/assets/music/bed.wav \
        --length 66.5 --end 6 --hit 70 [--land 2.0] [--start 1.5] [--cut-at 16] [--bar 2.0] [--lead 0.045]

--length  video length (s)          --end   end-card length (s)
--hit     time of the track's final hit (s), measured with `plugin-cli.mjs beats` and a loudness trace
--land    how far into the end card the hit lands (default 1.5; 2.0 if the logo settles at 2 s)
--start   where in the track the video should begin (default 0)
--cut-at  track time where whole bars may be dropped (a quiet or repeated section). Without it the
          track simply starts later (H - reel_hit), skipping part of its intro.
--bar     bar length in seconds (2.0 at 120 BPM, 4/4)
--lead    beat detectors report onsets slightly early; all track times are shifted by this (default 0.045)

The output is −16 LUFS, 48 kHz, exactly --length long, with a 0.6 s fade at the end. It prints where the
join is in the video, so you can put it on a scene cut.
"""
import argparse, math, subprocess

p = argparse.ArgumentParser()
p.add_argument("--src", required=True); p.add_argument("--out", required=True)
p.add_argument("--length", type=float, required=True); p.add_argument("--end", type=float, required=True)
p.add_argument("--hit", type=float, required=True); p.add_argument("--land", type=float, default=1.5)
p.add_argument("--start", type=float, default=0.0); p.add_argument("--cut-at", type=float)
p.add_argument("--bar", type=float, default=2.0); p.add_argument("--lead", type=float, default=0.045)
o = p.parse_args()

L = o.length
reel_hit = L - o.end + o.land                      # video time of the final hit
span = o.hit - o.start                             # track time from --start to the hit
excess = span - reel_hit
if excess < -1e-6:
    raise SystemExit(f"track too short: {span:.2f} s from --start to the hit, need {reel_hit:.2f} s (start earlier, loop a section, or use a longer bed)")

parts = []                                         # (track start, duration)
if o.cut_at is None or excess < o.bar:
    s0 = o.hit - reel_hit
    parts.append((s0, L))
    msg = f"no cut; track starts at {s0:.3f} s"
else:
    k = math.floor(excess / o.bar)                 # whole bars dropped at --cut-at
    s0 = o.hit - reel_hit - k * o.bar              # = start + (excess - k·bar): within one bar of --start
    join = o.cut_at - s0
    if not (0 < join < reel_hit):
        raise SystemExit(f"--cut-at {o.cut_at} is outside the part of the track that plays ({s0:.2f}–{o.hit:.2f})")
    parts.append((s0, join)); parts.append((o.cut_at + k * o.bar, L - join))
    msg = f"track starts at {s0:.3f} s; drops {k} bar(s) at {o.cut_at:.3f} s; join at video {join:.3f} s"

xf = 0.02
chains, labels = [], []
for i, (s, d) in enumerate(parts):
    st = max(0.0, s - o.lead - (xf if i else 0))
    chains.append(f"[0:a]atrim=start={st:.3f}:duration={d + xf:.3f},asetpts=PTS-STARTPTS[p{i}]")
    labels.append(f"[p{i}]")
mix = labels[0] if len(labels) == 1 else f"{labels[0]}{labels[1]}acrossfade=d={xf}:c1=tri:c2=tri"
flt = ";".join(chains) + f";{mix},atrim=duration={L:.3f},afade=t=in:d=0.05,afade=t=out:st={L - 0.6:.3f}:d=0.6,loudnorm=I=-16:TP=-1.5:LRA=11,aresample=48000[o]"
subprocess.run(["ffmpeg", "-nostdin", "-v", "error", "-y", "-i", o.src, "-filter_complex", flt, "-map", "[o]", "-ar", "48000", o.out], check=True)
d = subprocess.run(["ffprobe", "-v", "error", "-show_entries", "format=duration", "-of", "csv=p=0", o.out], capture_output=True, text=True).stdout.strip()
print(f"{o.out}: {float(d):.3f} s; final hit at video {reel_hit:.3f} s; {msg}")
