# Response-sheet examples (14 images)

Extra qualitative results submitted with the journal revision response
(`13 July 2021`). Each figure compares the **test image**, **ground truth**,
three baselines, and the **proposed** FAST–BRIEF–SIFT detection.

Baselines shown alongside each example:

| Label | Method |
|---|---|
| `*PUN.jpg` | Pun et al. (2015) — SIFT + adaptive oversegmentation |
| `*RYU.jpg` | Ryu et al. (2010) — Zernike moments |
| `*CAO.jpg` | Cao et al. (2012) — DCT coefficients |
| `*result.jpg` | **Proposed** method |

---

## Layout

```text
examples/response_sheet/
├── translation/   # Images 1–6   — plain copy-move (translation)
├── rotation/      # Images 7–10  — rotated before paste
└── scaling/       # Images 11–14 — scaled before paste
```

For every `imgN` the folder contains:

| File | Content |
|---|---|
| `imgN.jpg` | forged test image |
| `imgN_gt.jpg` | ground-truth mask |
| `imgNresult.jpg` | proposed localization |
| `imgNPUN.jpg` | Pun et al. result |
| `imgNRYU.jpg` | Ryu et al. result |
| `imgNCAO.jpg` | Cao et al. result |

---

## Catalogue

### Translation — Cozzolino / Lozzolino *et al.*

Plain copy-move (translated paste). Source: dense-field CMFD dataset of
Cozzolino et al. (2015).

| # | Files | Attack |
|---|---|---|
| 1 | `img2.*` | translation |
| 2 | `img3.*` | translation |
| 3 | `img6.*` | translation |
| 4 | `img9.*` | translation |
| 5 | `img12.*` | translation |
| 6 | `img14.*` | translation |

### Rotation — Ardizzone *et al.* subset D1-2

Copied region rotated before pasting.

| # | Files | Attack |
|---|---|---|
| 7 | `img16.*` | rotation |
| 8 | `img17.*` | rotation |
| 9 | `img18.*` | rotation |
| 10 | `img20.*` | rotation |

### Scaling — Ardizzone *et al.* subset D1-2

Copied region scaled before pasting.

| # | Files | Attack |
|---|---|---|
| 11 | `img22.*` | scaling |
| 12 | `img28.*` | scaling |
| 13 | `img29.*` | scaling |
| 14 | `img30.*` | scaling |

---

## Run the detector on these inputs

From the repository root in MATLAB, point `main.m` at any pair, for example:

```matlab
img_name = 'examples/response_sheet/translation/img2.jpg';
gt_img   = 'examples/response_sheet/translation/img2_gt.jpg';
```

Then run:

```matlab
main
```

> **Note:** `LSC_mex.mexw64` is a Windows MEX. On macOS/Linux you need a
> platform-matched LSC MEX for the localization stage.

---

## References (datasets & baselines)

- D. Cozzolino, G. Poggi, L. Verdoliva. *Efficient dense-field copy–move forgery detection.* IEEE TIFS, 2015.
- E. Ardizzone, A. Bruno, G. Mazzola. *Copy–move forgery detection by matching triangles of keypoints.* IEEE TIFS, 2015.
- C. M. Pun, X. C. Yuan, X. L. Bi. *Image forgery detection using adaptive oversegmentation and feature point matching.* IEEE TIFS, 2015.
- S. J. Ryu, M. J. Lee, H. K. Lee. *Detection of copy-rotate-move forgery using Zernike moments.* IH 2010.
- Y. Cao, T. Gao, L. Fan, Q. Yang. *A robust detection algorithm for copy-move forgery in digital images.* Forensic Sci. Int., 2012.
