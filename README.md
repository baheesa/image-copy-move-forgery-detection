<div align="center">

# FAST · BRIEF · SIFT
### Image Copy-Move Forgery Detection

**Official MATLAB implementation** of the paper published in  
*Multimedia Tools and Applications* (Springer, 2022)

[![Paper](https://img.shields.io/badge/Paper-Springer-0F4C81?style=for-the-badge&logo=springer&logoColor=white)](https://link.springer.com/article/10.1007/s11042-022-12915-y)
[![DOI](https://img.shields.io/badge/DOI-10.1007%2Fs11042--022--12915--y-blue?style=for-the-badge)](https://doi.org/10.1007/s11042-022-12915-y)
[![MATLAB](https://img.shields.io/badge/MATLAB-R2018b%2B-orange?style=for-the-badge&logo=mathworks&logoColor=white)](https://www.mathworks.com/products/matlab.html)
[![License](https://img.shields.io/badge/License-Research-lightgrey?style=for-the-badge)](#citation)

<br/>

> Easily accessible image-editing software has fueled the need for better forgery detection schemes that can overcome the limits of human vision. This repository releases the two-step keypoint pipeline that detects copy-move forgery in **smooth regions**, **textured regions**, and under **rotation, scaling, compression, and multiple pastes**.

</div>

---

## Abstract

Most existing copy-move forgery techniques fail on smooth areas, on regions pasted multiple times, or on patches that are rotated / scaled before pasting. This work presents a **two-branch keypoint** detector:

1. **SIFT** finds keypoints in smooth regions  
2. **FAST + BRIEF** recovers keypoints in textured / previously missed regions  

Keypoints are matched with **generalized 2<sup>nd</sup> nearest neighbour (g2NN)**. Matches are refined with **morphological processing** and the **structural similarity index (SSIM)**. **Linear Spectral Clustering (LSC)** then localizes the forged region. Experiments on three datasets (plain, compressed, rotated, scaled, and multiply-pasted forgeries) show improved **precision, recall, and F-measure** over prior art, with better visual localization and lower computational cost.

**Full paper:** [Springer Nature Link](https://link.springer.com/article/10.1007/s11042-022-12915-y) · [DOI 10.1007/s11042-022-12915-y](https://doi.org/10.1007/s11042-022-12915-y)

---

## Method at a glance

```text
 Input image
      │
      ├──────────────────────────────┐
      ▼                              ▼
 FAST-12 corners              Wiener + SIFT
      │                              │
 BRIEF (256-bit)              128-D descriptors
      │                              │
      └──────────┬───────────────────┘
                 ▼
           g2NN matching
                 │
     morphology + area filtering
                 │
        LSC superpixel voting
                 │
         SSIM duplicate check
                 │
        localized forgery mask
                 │
      Precision / Recall / F-measure
```

| Stage | Role in the paper |
|---|---|
| **FAST-12** | High-speed corner detection for textured regions |
| **BRIEF** | Compact binary descriptors around FAST keypoints |
| **SIFT** (VLFeat) | Scale-invariant keypoints for smooth regions |
| **g2NN** | Allows one keypoint to match multiple copies |
| **Morphology** | Grows sparse matches into candidate regions |
| **LSC** | Superpixel localization of the forged area |
| **SSIM** | Verifies that candidate blobs are near-duplicates |

---

## Highlights

- Robust to **plain, rotated, scaled, JPEG-compressed**, and **multiply-pasted** copy-move forgeries  
- Dual detector covers both **smooth** and **textured** content  
- g2NN matching handles **multiple** duplicated regions in one image  
- LSC + SSIM refine localization beyond sparse keypoints  
- Reports standard forensic metrics: **Precision · Recall · F-measure**

---

## Repository layout

```text
.
├── main.m                      # end-to-end pipeline (start here)
├── FAST_12.m                   # FAST-12 corner detector
├── FAST_non_max.m              # non-maxima suppression
├── BRIEF_descriptor.m          # binary BRIEF descriptors
├── sampling_generator.m        # BRIEF intensity-pair patterns
├── g2nn.m                      # generalized 2nd nearest neighbour
├── second_nearest_neighbour.m  # classic 2NN helper
├── dist2.m                     # squared Euclidean distances
├── getFmeasure.m               # Precision / Recall / F-measure
├── LSC_mex.mexw64              # Linear Spectral Clustering (Windows MEX)
├── vlfeat-0.9.21/              # VLFeat toolkit (SIFT)
├── img1.png … img6.png         # sample forged images
├── img1_gt.png … img6_gt.png   # corresponding ground-truth masks
├── examples/response_sheet/    # 14 extra journal-revision examples
│   ├── translation/            #   Images 1–6  (plain copy-move)
│   ├── rotation/               #   Images 7–10 (rotated paste)
│   ├── scaling/                #   Images 11–14 (scaled paste)
│   └── README.md
└── README.md
```

---

## Requirements

| Dependency | Notes |
|---|---|
| **MATLAB** R2018b or newer | Image Processing Toolbox required (`imsharpen`, `ssim`, `regionprops`, …) |
| **VLFeat 0.9.21** | Bundled under `vlfeat-0.9.21/` — run `vl_setup` (done automatically by `main.m`) |
| **LSC_mex** | Bundled `LSC_mex.mexw64` is a **64-bit Windows** MEX. On macOS / Linux, rebuild LSC from the [authors’ release](https://github.com/MingyuLiu/LSC) (or equivalent) for your platform and place the MEX on the MATLAB path. |

---

## Quick start

1. Clone this repository and open MATLAB in the project root.
2. Edit the input pair at the top of [`main.m`](main.m):

```matlab
img_name = 'img3.png';
gt_img   = 'img3_gt.png';
```

3. Run:

```matlab
main
```

4. The script displays:
   - matched keypoints (SIFT ∪ BRIEF)
   - correspondence lines
   - final localized forgery overlay
   - a `measure` struct with **FM, Precision (PPV), Recall (TPR)**, etc.

Swap `img_name` / `gt_img` for `img1`…`img6` to try the other bundled examples.

### Extra examples from the journal response sheet

Fourteen additional cases (translation, rotation, scaling) from the
13 July 2021 reviewer response, including ground truth, proposed outputs,
and comparisons against Pun / Ryu / Cao, live under
[`examples/response_sheet/`](examples/response_sheet/README.md).

```matlab
img_name = 'examples/response_sheet/translation/img2.jpg';
gt_img   = 'examples/response_sheet/translation/img2_gt.jpg';
```

---

## Algorithm parameters (as used in code)

| Parameter | Default | Meaning |
|---|---|---|
| FAST threshold | `0.3` (raises to `0.5` if >15k corners) | Relative intensity threshold |
| BRIEF length | `256` | Bits per descriptor |
| BRIEF window | `11` | Patch size |
| BRIEF pattern | `'gaussian'` | Sampling distribution |
| g2NN ratio | `0.05` | Distance-ratio cutoff |
| LSC superpixels | `200` | Over-segmentation density |
| LSC ratio | `0.015` | Compactness / colour weight |
| Segment vote | `≥ 0.6` | Keep segments with ≥60% of peak match density |
| SSIM accept | `≥ 0.60` | Confirm duplicate forged blobs |

---

## Evaluation protocol

Detection quality is measured at the **pixel level** against a binary ground-truth mask:

$$
\mathrm{Precision} = \frac{\mathrm{TP}}{\mathrm{TP}+\mathrm{FP}}, \quad
\mathrm{Recall} = \frac{\mathrm{TP}}{\mathrm{TP}+\mathrm{FN}}, \quad
F = \frac{2\cdot\mathrm{TP}}{2\cdot\mathrm{TP}+\mathrm{FP}+\mathrm{FN}}
$$

Implemented in [`getFmeasure.m`](getFmeasure.m). The paper evaluates plain and transformed copy-move cases (compression, rotation, scaling, multiple pastes) and compares against contemporary keypoint / block-based baselines, reporting gains in precision, recall, and F-measure together with improved visual localization.

---

## Citation

If you use this code, please cite the paper:

```bibtex
@article{Fatima2022CopyMove,
  title   = {{FAST}, {BRIEF} and {SIFT} based image copy-move forgery detection technique},
  author  = {Fatima, Baheesa and Ghafoor, Abdul and Ali, Syed Sohaib and Riaz, M. Mohsin},
  journal = {Multimedia Tools and Applications},
  volume  = {81},
  pages   = {43805--43819},
  year    = {2022},
  doi     = {10.1007/s11042-022-12915-y},
  url     = {https://link.springer.com/article/10.1007/s11042-022-12915-y}
}
```

---

## Authors

| Author | Affiliation |
|---|---|
| **Baheesa Fatima** *(corresponding)* | National University of Sciences and Technology (NUST), Islamabad, Pakistan |
| **Abdul Ghafoor** | National University of Sciences and Technology (NUST), Islamabad, Pakistan |
| **Syed Sohaib Ali** | COMSATS University, Islamabad, Pakistan |
| **M. Mohsin Riaz** | COMSATS University, Islamabad, Pakistan |

---

## Publication details

| | |
|---|---|
| **Journal** | Multimedia Tools and Applications |
| **Publisher** | Springer |
| **Received** | 20 October 2020 |
| **Revised** | 29 July 2021 |
| **Accepted** | 9 March 2022 |
| **Published** | 27 May 2022 |
| **Issue** | Volume 81, pages 43805–43819 (December 2022) |
| **Keywords** | Image copy-move forgery detection · Feature detection and matching · FAST · BRIEF · SIFT · Region duplication · Tampering detection |

---

## Acknowledgements & third-party code

- **VLFeat** ([vlfeat.org](http://www.vlfeat.org/)) — SIFT implementation  
- **LSC** — Linear Spectral Clustering superpixels (Li & Chen, CVPR 2015)  
- **dist2** — C. M. Bishop & I. T. Nabney  

---

<div align="center">

<sub>
Code released to accompany
<em>FAST, BRIEF and SIFT based image copy-move forgery detection technique</em>
· Multimed Tools Appl · 2022
</sub>

<br/><br/>

[Read the paper →](https://link.springer.com/article/10.1007/s11042-022-12915-y)

</div>
