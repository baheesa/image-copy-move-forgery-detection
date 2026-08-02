<div align="center">

# FAST, BRIEF and SIFT based image copy-move forgery detection technique
### FAST · BRIEF · SIFT

MATLAB code from our Springer paper (*Multimedia Tools and Applications*, 2022)

<br/>

[![Paper](https://img.shields.io/badge/Paper-Springer-0F4C81?style=flat-square)](https://link.springer.com/article/10.1007/s11042-022-12915-y)
[![PDF](https://img.shields.io/badge/PDF-Download-C41E3A?style=flat-square)](https://link.springer.com/content/pdf/10.1007/s11042-022-12915-y.pdf)
[![DOI](https://img.shields.io/badge/DOI-10.1007/s11042--022--12915--y-blue?style=flat-square)](https://doi.org/10.1007/s11042-022-12915-y)
[![License](https://img.shields.io/badge/License-MIT-22c55e?style=flat-square)](LICENSE)
[![MATLAB](https://img.shields.io/badge/MATLAB-R2018b+-orange?style=flat-square)](https://www.mathworks.com/products/matlab.html)

Easily accessible image-editing softwares have fueled the need for better forgery detection schemes that can overcome the limitedness of human vision to determine image authenticity. Most of the existing copy-move forgery techniques fail to detect forgery in smooth areas, forgery regions which are pasted multiple times or pasted after rotation and scaling. To solve these issues, the paper presents a two step keypoint based forgery detection technique. First, SIFT is used to detect keypoints in smooth regions. Second, BRIEF features with FAST descriptors are used to detect keypoints from missing regions (i.e. texture areas). Afterwards, keypoints are matched using generalized 2nd nearest neighbour. Then, morphological processing and structural similarity index are used to refine matches. Afterwards, linear spectral clustering is applied for better forgery localization. Simulations are performed on images taken from three datasets in which copy-move area was plain,compressed, rotated, scaled and pasted multiple times. Comparison of the simulation results with the state-of-the-art techniques shows improved precision, recall, and F-Measure values for the proposed technique. The technique also gives better visual results and reduces computational complexity.

<br/>

[LinkedIn](https://www.linkedin.com/in/baheesafatima/)
·
[ResearchGate](https://www.researchgate.net/profile/Baheesa-Fatima-2)
·
[ORCID](https://orcid.org/0009-0003-2757-5672)
·
[Email](mailto:baheesafatima@gmail.com)

</div>

**Keywords:** copy-move forgery detection · FAST · BRIEF · SIFT

---

## What this is

Sometimes people hide or invent content in a photo by copying a patch and pasting it somewhere else in the *same* image. That’s **copy-move forgery**. After a bit of rotation, scaling, or JPEG compression, you often can’t see the edit.

This repo is the MATLAB code behind our paper:

> Fatima, B., Ghafoor, A., Ali, S.S. & Riaz, M.M. (2022).  
> *FAST, BRIEF and SIFT based image copy-move forgery detection technique.*  
> Multimedia Tools and Applications, 81, 43805–43819.

We don’t only say “forged / not forged.” We also try to **paint where** the duplicated region is.

How it works, in plain words:

1. **SIFT** picks up points in smooth areas (where plain corner detectors struggle).
2. **FAST + BRIEF** picks up corners in textured areas.
3. **g2NN** matches those points — including when something was pasted more than once.
4. Morphology, **SSIM**, and **LSC** clean the matches and tighten the final mask.

- Paper: [Springer](https://link.springer.com/article/10.1007/s11042-022-12915-y)
- PDF: [download](https://link.springer.com/content/pdf/10.1007/s11042-022-12915-y.pdf) *(access may need a library login)*
- DOI: [10.1007/s11042-022-12915-y](https://doi.org/10.1007/s11042-022-12915-y)
- Cite the code: [`CITATION.cff`](CITATION.cff)

If you use this in your own work, a citation means a lot — thank you.

---

## Why bother with two detectors?

Most older keypoint methods lean on textured corners and quietly fail on smooth patches (sky, walls, skin). Block methods can be slow and brittle under rotation or scale. We run **two branches in parallel**, merge their matches, then localize — so both kinds of content get a chance.

| Strength | In practice |
|---|---|
| Smooth + textured | SIFT and FAST+BRIEF cover different parts of the image |
| Multiple pastes | g2NN can link one point to several copies |
| Geometric attacks | Tested with rotated and scaled pastes |
| Compression | Includes JPEG cases |
| Localization | You get a mask, not only a yes/no label |
| Cost | Meant to run on a normal MATLAB laptop |

---

## Method diagram

This is Fig. 1 from the paper — the full pipeline at a glance.

<div align="center">
  <img src="docs/figures/fig1_proposed_method.png" alt="Method diagram for FAST BRIEF SIFT copy-move image forgery detection" width="720"/>
</div>

| Stage | What happens |
|---|---|
| Input | Forged photo |
| SIFT branch | Denoise → detect → describe → g2NN (smooth regions) |
| FAST + BRIEF branch | Sharpen → FAST corners → BRIEF bits → g2NN (texture) |
| Matched features | Merge both branches |
| Post-processing | Drop outliers → localize → refine with LSC + SSIM |

Comments in [`main.m`](main.m) point to the same section numbers (2.1–2.3) if you want to read code and paper side by side.

---

## Quick start

You’ll need MATLAB R2018b+ with the Image Processing Toolbox.

```bash
git clone https://github.com/baheesa/image-copy-move-forgery-detection.git
cd image-copy-move-forgery-detection
```

Open MATLAB in this folder, then in [`main.m`](main.m) set a pair like:

```matlab
img_name = 'examples/demo/img3.png';
gt_img   = 'examples/demo/img3_gt.png';
```

Run:

```matlab
main
```

You should get matched points, link lines, a yellow localization overlay, and Precision / Recall / F-measure against the ground truth.

Browse more scenes (with short notes under each pair) in [`examples/`](examples/README.md):

```matlab
img_name = 'examples/translation/img2.jpg';
gt_img   = 'examples/translation/img2_gt.jpg';
```

> **Note:** `LSC_mex.mexw64` is a Windows build. On Mac or Linux, compile LSC for your machine and put that MEX on the path.

---

## What’s in the repo

```text
.
├── main.m                 # run this
├── FAST_*.m, BRIEF_*.m    # textured branch
├── g2nn.m, dist2.m        # matching helpers
├── getFmeasure.m          # Precision / Recall / F-measure
├── LSC_mex.mexw64         # localization (Windows)
├── vlfeat-0.9.21/         # SIFT
├── examples/              # demo + translation / rotation / scaling
├── docs/figures/          # paper Fig. 1
├── CITATION.cff
├── LICENSE
└── README.md
```

---

## Default parameters

These are the values we use in the script (same spirit as the paper):

| Parameter | Default | Role |
|---|---|---|
| FAST threshold γ<sub>f</sub> | `0.3` (→ `0.5` if too many corners) | How sensitive FAST is |
| BRIEF length | `256` | Bits per descriptor |
| BRIEF window | `11` | Patch size |
| BRIEF pattern | `'gaussian'` | How sample pairs are drawn |
| g2NN ratio γ<sub>m</sub> | `0.05` | Match strictness |
| LSC superpixels | `200` | How fine the segments are |
| LSC ratio | `0.015` | Segment compactness |
| Segment vote | `≥ 0.6` | Keep strong forged segments |
| SSIM γ<sub>s</sub> | `≥ 0.60` | Are the two blobs near-duplicates? |

---

## How we score

We compare the predicted mask to the ground-truth mask pixel by pixel ([`getFmeasure.m`](getFmeasure.m)):

$$
\mathrm{Precision} = \frac{\mathrm{TP}}{\mathrm{TP}+\mathrm{FP}}, \quad
\mathrm{Recall} = \frac{\mathrm{TP}}{\mathrm{TP}+\mathrm{FN}}, \quad
F = \frac{2\cdot\mathrm{TP}}{2\cdot\mathrm{TP}+\mathrm{FP}+\mathrm{FN}}
$$

The paper reports these against other keypoint and block methods on plain and attacked copy-move cases.

---

## Examples

Side-by-side forged vs localized images (with a short note for each scene) live in [`examples/README.md`](examples/README.md):

- `demo/` — six starter images + ground truth  
- `translation/` — plain paste + our yellow overlays  
- `rotation/` — rotated paste  
- `scaling/` — scaled paste  

---

## Citation

Please cite the paper. GitHub’s **Cite this repository** button also works via [`CITATION.cff`](CITATION.cff).

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

## Authors & contact

| Author | Affiliation |
|---|---|
| **Baheesa Fatima** *(corresponding)* | NUST, Islamabad, Pakistan |
| **Abdul Ghafoor** | NUST, Islamabad, Pakistan |
| **Syed Sohaib Ali** | COMSATS University, Islamabad, Pakistan |
| **M. Mohsin Riaz** | COMSATS University, Islamabad, Pakistan |

Questions or issues? Email is easiest: [baheesafatima@gmail.com](mailto:baheesafatima@gmail.com)

- [LinkedIn](https://www.linkedin.com/in/baheesafatima/)
- [ResearchGate](https://www.researchgate.net/profile/Baheesa-Fatima-2)
- [ORCID](https://orcid.org/0009-0003-2757-5672)

---

## Publication

| | |
|---|---|
| Journal | Multimedia Tools and Applications (Springer) |
| Received | 20 October 2020 |
| Revised | 29 July 2021 |
| Accepted | 9 March 2022 |
| Published | 27 May 2022 |
| Pages | Vol. 81, 43805–43819 |

---

## Copyright

**© 2022 Baheesa Fatima, Abdul Ghafoor, Syed Sohaib Ali, and M. Mohsin Riaz.**

- The **MATLAB code** here is ours and released under the [MIT License](LICENSE).
- The **published article / publisher PDF** stays under Springer’s copyright — use the PDF link to read it, don’t treat it as open data unless their terms say so.
- **Example photos** are for demo; cite Cozzolino *et al.* (2015) and Ardizzone *et al.* (2015) if you use those datasets more broadly.
- VLFeat, LSC, and `dist2` keep their own licenses.

---

## Why MIT?

MIT is short, familiar to universities, and easy to reuse in other research code — while still requiring the copyright notice to travel with the files. It does **not** replace citing the paper. If you publish with this code, please cite the MTAP 2022 article and keep the header.

Provided as is, no warranty.

---

## Thanks

| | |
|---|---|
| [VLFeat](http://www.vlfeat.org/) | SIFT |
| LSC (Li & Chen, CVPR 2015) | Superpixels for localization |
| Bishop & Nabney (`dist2`) | Distance helper |
| Cozzolino *et al.*, Ardizzone *et al.* | Example imagery |
| Springer MTAP + reviewers | Venue and feedback that led to the extra examples |

---

<div align="center">

<sub>
© 2022 Baheesa Fatima et al. · MIT License
</sub>

<br/><br/>

[PDF](https://link.springer.com/content/pdf/10.1007/s11042-022-12915-y.pdf)
·
[Paper](https://link.springer.com/article/10.1007/s11042-022-12915-y)
·
[Contact](mailto:baheesafatima@gmail.com)
·
[LinkedIn](https://www.linkedin.com/in/baheesafatima/)

</div>
