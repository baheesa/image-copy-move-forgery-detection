# Examples

All test images live here. Below, each **forged image** is shown next to its **localized copy-move region** (our detection, or ground truth for the demo set).

```text
examples/
├── demo/           # starter pairs (image + ground truth)
├── translation/    # plain copy-move
├── rotation/       # rotated paste
└── scaling/        # scaled paste
```

---

## `demo/` — start here

Six forged images with ground-truth masks. Run these first in `main.m`.

```matlab
img_name = 'examples/demo/img3.png';
gt_img   = 'examples/demo/img3_gt.png';
```

| # | Forged image | Ground-truth localization |
|:-:|:---:|:---:|
| 1 | <img src="demo/img1.png" width="280" alt="Demo 1 forged"/> | <img src="demo/img1_gt.png" width="280" alt="Demo 1 ground truth"/> |
| 2 | <img src="demo/img2.png" width="280" alt="Demo 2 forged"/> | <img src="demo/img2_gt.png" width="280" alt="Demo 2 ground truth"/> |
| 3 | <img src="demo/img3.png" width="280" alt="Demo 3 forged"/> | <img src="demo/img3_gt.png" width="280" alt="Demo 3 ground truth"/> |
| 4 | <img src="demo/img4.png" width="280" alt="Demo 4 forged"/> | <img src="demo/img4_gt.png" width="280" alt="Demo 4 ground truth"/> |
| 5 | <img src="demo/img5.png" width="280" alt="Demo 5 forged"/> | <img src="demo/img5_gt.png" width="280" alt="Demo 5 ground truth"/> |
| 6 | <img src="demo/img6.png" width="280" alt="Demo 6 forged"/> | <img src="demo/img6_gt.png" width="280" alt="Demo 6 ground truth"/> |

---

## `translation/` — plain copy-move

Copied region pasted with translation only (Cozzolino / Lozzolino *et al.*, 2015).  
Right column = **proposed localization** (`*result.jpg`).

```matlab
img_name = 'examples/translation/img2.jpg';
gt_img   = 'examples/translation/img2_gt.jpg';
```

| # | Forged image | Localized result (proposed) |
|:-:|:---:|:---:|
| 1 | <img src="translation/img2.jpg" width="280" alt="Translation 1 forged"/> | <img src="translation/img2result.jpg" width="280" alt="Translation 1 localized"/> |
| 2 | <img src="translation/img3.jpg" width="280" alt="Translation 2 forged"/> | <img src="translation/img3result.jpg" width="280" alt="Translation 2 localized"/> |
| 3 | <img src="translation/img6.jpg" width="280" alt="Translation 3 forged"/> | <img src="translation/img6result.jpg" width="280" alt="Translation 3 localized"/> |
| 4 | <img src="translation/img9.jpg" width="280" alt="Translation 4 forged"/> | <img src="translation/img9result.jpg" width="280" alt="Translation 4 localized"/> |
| 5 | <img src="translation/img12.jpg" width="280" alt="Translation 5 forged"/> | <img src="translation/img12result.jpg" width="280" alt="Translation 5 localized"/> |
| 6 | <img src="translation/img14.jpg" width="280" alt="Translation 6 forged"/> | <img src="translation/img14result.jpg" width="280" alt="Translation 6 localized"/> |

Each folder also includes ground truth (`*_gt.jpg`) and baseline visuals (`*PUN.jpg`, `*RYU.jpg`, `*CAO.jpg`).

---

## `rotation/` — rotated paste

Copied region rotated before pasting (Ardizzone *et al.*, 2015, subset D1-2).

```matlab
img_name = 'examples/rotation/img16.jpg';
gt_img   = 'examples/rotation/img16_gt.jpg';
```

| # | Forged image | Localized result (proposed) |
|:-:|:---:|:---:|
| 7 | <img src="rotation/img16.jpg" width="280" alt="Rotation 7 forged"/> | <img src="rotation/img16result.jpg" width="280" alt="Rotation 7 localized"/> |
| 8 | <img src="rotation/img17.jpg" width="280" alt="Rotation 8 forged"/> | <img src="rotation/img17result.jpg" width="280" alt="Rotation 8 localized"/> |
| 9 | <img src="rotation/img18.jpg" width="280" alt="Rotation 9 forged"/> | <img src="rotation/img18result.jpg" width="280" alt="Rotation 9 localized"/> |
| 10 | <img src="rotation/img20.jpg" width="280" alt="Rotation 10 forged"/> | <img src="rotation/img20result.jpg" width="280" alt="Rotation 10 localized"/> |

---

## `scaling/` — scaled paste

Copied region scaled before pasting (Ardizzone *et al.*, 2015, subset D1-2).

```matlab
img_name = 'examples/scaling/img22.jpg';
gt_img   = 'examples/scaling/img22_gt.jpg';
```

| # | Forged image | Localized result (proposed) |
|:-:|:---:|:---:|
| 11 | <img src="scaling/img22.jpg" width="280" alt="Scaling 11 forged"/> | <img src="scaling/img22result.jpg" width="280" alt="Scaling 11 localized"/> |
| 12 | <img src="scaling/img28.jpg" width="280" alt="Scaling 12 forged"/> | <img src="scaling/img28result.jpg" width="280" alt="Scaling 12 localized"/> |
| 13 | <img src="scaling/img29.jpg" width="280" alt="Scaling 13 forged"/> | <img src="scaling/img29result.jpg" width="280" alt="Scaling 13 localized"/> |
| 14 | <img src="scaling/img30.jpg" width="280" alt="Scaling 14 forged"/> | <img src="scaling/img30result.jpg" width="280" alt="Scaling 14 localized"/> |

---

## File naming

| File | Meaning |
|---|---|
| `imgN.jpg` / `imgN.png` | forged test image |
| `imgN_gt.jpg` / `imgN_gt.png` | ground-truth mask |
| `imgNresult.jpg` | **proposed** localization |
| `imgNPUN.jpg` | Pun *et al.* (2015) |
| `imgNRYU.jpg` | Ryu *et al.* (2010) |
| `imgNCAO.jpg` | Cao *et al.* (2012) |

---

## Baselines

| Tag | Method |
|---|---|
| `PUN` | Pun *et al.* — SIFT + adaptive oversegmentation (IEEE TIFS, 2015) |
| `RYU` | Ryu *et al.* — Zernike moments (IH, 2010) |
| `CAO` | Cao *et al.* — DCT coefficients (Forensic Sci. Int., 2012) |
| `result` | **Proposed** FAST + BRIEF + SIFT pipeline |

---

## Dataset references

- D. Cozzolino, G. Poggi, L. Verdoliva. *Efficient dense-field copy–move forgery detection.* IEEE TIFS, 2015.
- E. Ardizzone, A. Bruno, G. Mazzola. *Copy–move forgery detection by matching triangles of keypoints.* IEEE TIFS, 2015.
