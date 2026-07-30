<div align="center">

# 🔍 FAST · BRIEF · SIFT
### Image Copy-Move Forgery Detection

<p>
Official <b>MATLAB</b> code for our paper in<br/>
<em>Multimedia Tools and Applications</em> (Springer, 2022)
</p>

<p>
  <a href="https://link.springer.com/article/10.1007/s11042-022-12915-y"><img src="https://img.shields.io/badge/📄_Paper-Springer-0F4C81?style=for-the-badge" alt="Paper"/></a>
  <a href="https://doi.org/10.1007/s11042-022-12915-y"><img src="https://img.shields.io/badge/DOI-10.1007/s11042--022--12915--y-blue?style=for-the-badge" alt="DOI"/></a>
  <a href="https://www.mathworks.com/products/matlab.html"><img src="https://img.shields.io/badge/MATLAB-R2018b+-orange?style=for-the-badge&logo=mathworks&logoColor=white" alt="MATLAB"/></a>
  <a href="LICENSE"><img src="https://img.shields.io/badge/📜_License-MIT-green?style=for-the-badge" alt="License"/></a>
</p>

<p>
  <a href="https://www.linkedin.com/in/baheesafatima/"><img src="https://img.shields.io/badge/LinkedIn-Baheesa_Fatima-0A66C2?style=flat&logo=linkedin&logoColor=white" alt="LinkedIn"/></a>
  <a href="https://www.researchgate.net/profile/Baheesa-Fatima-2"><img src="https://img.shields.io/badge/ResearchGate-Baheesa_Fatima-00CCBB?style=flat&logo=researchgate&logoColor=white" alt="ResearchGate"/></a>
  <a href="https://orcid.org/0009-0003-2757-5672"><img src="https://img.shields.io/badge/ORCID-0009--0003--2757--5672-A6CE39?style=flat&logo=orcid&logoColor=white" alt="ORCID"/></a>
  <a href="mailto:baheesafatima@gmail.com"><img src="https://img.shields.io/badge/Email-baheesafatima@gmail.com-D14836?style=flat&logo=gmail&logoColor=white" alt="Email"/></a>
</p>

</div>

---

## 👋 What is this?

Copy-move forgery is when someone copies a patch from an image and pastes it elsewhere — often to hide or duplicate objects. It can be hard to spot by eye, especially after rotation, scaling, or JPEG compression.

This repository implements our published detector. In plain terms, it:

1. finds distinctive points in **smooth** areas with **SIFT**
2. finds corners in **textured** areas with **FAST + BRIEF**
3. matches duplicated regions (including **multiple pastes**) with **g2NN**
4. cleans the matches and **localizes** the forged region with morphology, **SSIM**, and **LSC**

If you use the code, please [cite the paper](#-citation) — thank you!

📖 **Read the paper:** [Springer](https://link.springer.com/article/10.1007/s11042-022-12915-y) · [DOI](https://doi.org/10.1007/s11042-022-12915-y)

---

## ✨ Why it helps

| | |
|---|---|
| 🧩 | Works on **smooth and textured** regions (many methods miss one of the two) |
| 🔁 | Handles **multiple** pasted copies in the same image |
| 🔄 | Robust to **rotation**, **scaling**, and **JPEG compression** |
| 🎯 | Localizes the forged area, not only a yes/no decision |
| ⚡ | Lighter than several earlier keypoint / block pipelines |

---

## 🧠 Method diagram

Figure from the paper — *Fig. 1 Proposed improved copy-move image forgery detection technique*:

<div align="center">
  <img src="docs/figures/fig1_proposed_method.png" alt="Fig. 1 Proposed improved copy-move image forgery detection technique" width="720"/>
  <p><sub>Dual branch: SIFT (smooth) ∥ FAST + BRIEF (texture) → g2NN matching → post-processing & localization</sub></p>
</div>

### Quick walkthrough

| Step | What happens |
|---|---|
| 🖼️ **Input** | Forged RGB image |
| 🔵 **SIFT branch** | Preprocess → detect → extract → g2NN match (smooth regions) |
| 🟢 **FAST + BRIEF branch** | Preprocess → FAST corners → BRIEF bits → g2NN match (texture) |
| 🔗 **Matched features** | Merge both branches |
| 🧹 **Post-processing** | Remove outliers → localize forgery → refine with LSC segmentation |

---

## 🚀 Quick start

**You need:** MATLAB (R2018b+) with the Image Processing Toolbox.

```bash
git clone <this-repo-url>
cd <repo-folder>
```

Open MATLAB in the project folder, then in [`main.m`](main.m) set your image pair:

```matlab
img_name = 'img3.png';
gt_img   = 'img3_gt.png';
```

Run:

```matlab
main
```

You will see matched keypoints, correspondence lines, the final forgery overlay, and metrics (`precision`, `recall`, `F-measure`).

> 💡 Tip: try `img1` … `img6` for the bundled samples, or any pair under [`examples/response_sheet/`](examples/response_sheet/README.md).

```matlab
img_name = 'examples/response_sheet/translation/img2.jpg';
gt_img   = 'examples/response_sheet/translation/img2_gt.jpg';
```

---

## 📦 What’s inside

```text
.
├── main.m                         # ▶️ start here
├── FAST_12.m / FAST_non_max.m     # corner detection
├── BRIEF_descriptor.m             # binary descriptors
├── sampling_generator.m           # BRIEF sampling pattern
├── g2nn.m                         # generalized 2nd NN matching
├── getFmeasure.m                  # Precision / Recall / F-measure
├── LSC_mex.mexw64                 # localization (Windows MEX)
├── vlfeat-0.9.21/                 # SIFT (VLFeat)
├── img1.png … img6.png            # demo images + GT masks
├── examples/response_sheet/       # 14 journal-revision examples
├── docs/figures/                  # paper method diagram
├── LICENSE
└── README.md
```

---

## 🧰 Requirements

| Dependency | Notes |
|---|---|
| 🧮 **MATLAB** R2018b+ | Needs Image Processing Toolbox |
| 📚 **VLFeat 0.9.21** | Included — `main.m` calls `vl_setup` for you |
| 🪟 **LSC MEX** | `LSC_mex.mexw64` is for **Windows**. On macOS/Linux, build LSC for your OS and put the MEX on the MATLAB path |

---

## 🎛️ Default parameters

| Parameter | Default | Role |
|---|---|---|
| FAST threshold | `0.3` (→ `0.5` if too many corners) | Corner sensitivity |
| BRIEF length | `256` | Descriptor bits |
| BRIEF window | `11` | Patch size |
| BRIEF pattern | `'gaussian'` | Sampling style |
| g2NN ratio | `0.05` | Match strictness |
| LSC superpixels | `200` | Localization granularity |
| Segment vote | `≥ 0.6` | Keep strong forged segments |
| SSIM accept | `≥ 0.60` | Confirm duplicate regions |

---

## 📊 How we score results

Pixel-level comparison against a ground-truth mask ([`getFmeasure.m`](getFmeasure.m)):

$$
\mathrm{Precision} = \frac{\mathrm{TP}}{\mathrm{TP}+\mathrm{FP}}, \quad
\mathrm{Recall} = \frac{\mathrm{TP}}{\mathrm{TP}+\mathrm{FN}}, \quad
F = \frac{2\cdot\mathrm{TP}}{2\cdot\mathrm{TP}+\mathrm{FP}+\mathrm{FN}}
$$

The paper reports these on plain and attacked copy-move cases (compression, rotation, scaling, multiple pastes).

---

## 🖼️ Extra examples (journal response)

Fourteen more cases from our July 2021 reviewer response — translation, rotation, and scaling — with ground truth, our results, and comparisons to Pun / Ryu / Cao:

📂 [`examples/response_sheet/`](examples/response_sheet/README.md)

---

## 📚 Citation

If this code helps your work, please cite:

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

## 👩‍💻 Authors & contact

| Author | Affiliation |
|---|---|
| **Baheesa Fatima** *(corresponding)* | NUST, Islamabad, Pakistan |
| **Abdul Ghafoor** | NUST, Islamabad, Pakistan |
| **Syed Sohaib Ali** | COMSATS University, Islamabad, Pakistan |
| **M. Mohsin Riaz** | COMSATS University, Islamabad, Pakistan |

**Corresponding author — Baheesa Fatima**

- ✉️ [baheesafatima@gmail.com](mailto:baheesafatima@gmail.com)
- 💼 [LinkedIn](https://www.linkedin.com/in/baheesafatima/)
- 🔬 [ResearchGate](https://www.researchgate.net/profile/Baheesa-Fatima-2)
- 🆔 [ORCID `0009-0003-2757-5672`](https://orcid.org/0009-0003-2757-5672)

Questions, bugs, or collaboration ideas? Email is the fastest way to reach me.

---

## 📰 Publication

| | |
|---|---|
| Journal | Multimedia Tools and Applications (Springer) |
| Received | 20 Oct 2020 |
| Revised | 29 Jul 2021 |
| Accepted | 9 Mar 2022 |
| Published | 27 May 2022 |
| Pages | 43805–43819 (Vol. 81, Dec 2022) |
| Keywords | Copy-move forgery · FAST · BRIEF · SIFT · Region duplication · Tampering detection |

---

## 📜 License

This project is released under the **[MIT License](LICENSE)**.

You are free to use, modify, and share the code for research and other purposes. If you build on it in a publication or product, please:

1. keep the copyright / license notice, and  
2. **cite the paper** above so others can find the original work.

The software is provided **as is**, without warranty.

---

## 🙏 Acknowledgements

Thank you to everyone whose tools and datasets made this work possible:

| Project | Role in this repo |
|---|---|
| [**VLFeat**](http://www.vlfeat.org/) (A. Vedaldi & B. Fulkerson) | SIFT feature detection & description |
| **LSC** — Li & Chen, CVPR 2015 | Linear Spectral Clustering for forgery localization |
| **dist2** — C. M. Bishop & I. T. Nabney | Pairwise squared distances used in matching |
| **Cozzolino et al.** (2015) & **Ardizzone et al.** (2015) | Example images used in the response-sheet demos |
| Springer / *Multimedia Tools and Applications* | Venue that published the paper |
| Reviewers of the original submission | Feedback that led to the extra examples in `examples/response_sheet/` |

Sample images and ground-truth masks are included for demonstration. Please respect the licenses of any external datasets if you download full benchmarks yourself.

---

<div align="center">

<br/>

<sub>
Made with care for the research community ·
<em>FAST, BRIEF and SIFT based image copy-move forgery detection technique</em>
· 2022
</sub>

<br/><br/>

<a href="https://link.springer.com/article/10.1007/s11042-022-12915-y">📖 Read the paper</a>
&nbsp;·&nbsp;
<a href="mailto:baheesafatima@gmail.com">✉️ Contact</a>
&nbsp;·&nbsp;
<a href="https://www.linkedin.com/in/baheesafatima/">💼 LinkedIn</a>

</div>
