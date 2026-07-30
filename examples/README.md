# 🖼️ Examples

All test images for this project live here — demos from the paper and the
extra cases we shared with the journal during revision.

```text
examples/
├── demo/           # 6 quick starter pairs (image + ground truth)
├── translation/    # plain copy-move (translated paste)
├── rotation/       # copied region rotated before paste
└── scaling/        # copied region scaled before paste
```

---

## 🟢 `demo/` — start here

Six forged images with matching ground-truth masks. Good for a first run.

| Image | Ground truth |
|---|---|
| `img1.png` … `img6.png` | `img1_gt.png` … `img6_gt.png` |

```matlab
img_name = 'examples/demo/img3.png';
gt_img   = 'examples/demo/img3_gt.png';
```

---

## 🔵 `translation/` — plain copy-move

Six cases where the copied patch is pasted with translation only  
(source: Cozzolino / Lozzolino *et al.*, 2015).

Each case includes:

| File | Meaning |
|---|---|
| `imgN.jpg` | forged test image |
| `imgN_gt.jpg` | ground-truth mask |
| `imgNresult.jpg` | **our** detection |
| `imgNPUN.jpg` | Pun *et al.* (2015) |
| `imgNRYU.jpg` | Ryu *et al.* (2010) |
| `imgNCAO.jpg` | Cao *et al.* (2012) |

| # | Files |
|---|---|
| 1 | `img2.*` |
| 2 | `img3.*` |
| 3 | `img6.*` |
| 4 | `img9.*` |
| 5 | `img12.*` |
| 6 | `img14.*` |

```matlab
img_name = 'examples/translation/img2.jpg';
gt_img   = 'examples/translation/img2_gt.jpg';
```

---

## 🟠 `rotation/` — rotated paste

Four cases from Ardizzone *et al.* (2015), subset **D1-2**.

| # | Files |
|---|---|
| 7 | `img16.*` |
| 8 | `img17.*` |
| 9 | `img18.*` |
| 10 | `img20.*` |

```matlab
img_name = 'examples/rotation/img16.jpg';
gt_img   = 'examples/rotation/img16_gt.jpg';
```

---

## 🟣 `scaling/` — scaled paste

Four cases from Ardizzone *et al.* (2015), subset **D1-2**.

| # | Files |
|---|---|
| 11 | `img22.*` |
| 12 | `img28.*` |
| 13 | `img29.*` |
| 14 | `img30.*` |

```matlab
img_name = 'examples/scaling/img22.jpg';
gt_img   = 'examples/scaling/img22_gt.jpg';
```

---

## 📎 Baselines shown in the comparison images

| Tag | Method |
|---|---|
| `PUN` | Pun *et al.* — SIFT + adaptive oversegmentation (IEEE TIFS, 2015) |
| `RYU` | Ryu *et al.* — Zernike moments (IH, 2010) |
| `CAO` | Cao *et al.* — DCT coefficients (Forensic Sci. Int., 2012) |
| `result` | **Proposed** FAST + BRIEF + SIFT pipeline |

---

## 📚 Dataset references

- D. Cozzolino, G. Poggi, L. Verdoliva. *Efficient dense-field copy–move forgery detection.* IEEE TIFS, 2015.
- E. Ardizzone, A. Bruno, G. Mazzola. *Copy–move forgery detection by matching triangles of keypoints.* IEEE TIFS, 2015.
