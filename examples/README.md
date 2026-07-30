# Examples

All test images live here. Each pair below shows the **forged image** (left) next to its **localized copy-move region** (right).

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

### Demo 1
<p>
<img src="demo/img1.png" width="48%" alt="Demo 1 forged image"/>
&nbsp;
<img src="demo/img1_gt.png" width="48%" alt="Demo 1 ground-truth localization"/>
</p>
<sub>Left: forged image &nbsp;·&nbsp; Right: ground-truth localization</sub>

### Demo 2
<p>
<img src="demo/img2.png" width="48%" alt="Demo 2 forged image"/>
&nbsp;
<img src="demo/img2_gt.png" width="48%" alt="Demo 2 ground-truth localization"/>
</p>
<sub>Left: forged image &nbsp;·&nbsp; Right: ground-truth localization</sub>

### Demo 3
<p>
<img src="demo/img3.png" width="48%" alt="Demo 3 forged image"/>
&nbsp;
<img src="demo/img3_gt.png" width="48%" alt="Demo 3 ground-truth localization"/>
</p>
<sub>Left: forged image &nbsp;·&nbsp; Right: ground-truth localization</sub>

### Demo 4
<p>
<img src="demo/img4.png" width="48%" alt="Demo 4 forged image"/>
&nbsp;
<img src="demo/img4_gt.png" width="48%" alt="Demo 4 ground-truth localization"/>
</p>
<sub>Left: forged image &nbsp;·&nbsp; Right: ground-truth localization</sub>

### Demo 5
<p>
<img src="demo/img5.png" width="48%" alt="Demo 5 forged image"/>
&nbsp;
<img src="demo/img5_gt.png" width="48%" alt="Demo 5 ground-truth localization"/>
</p>
<sub>Left: forged image &nbsp;·&nbsp; Right: ground-truth localization</sub>

### Demo 6
<p>
<img src="demo/img6.png" width="48%" alt="Demo 6 forged image"/>
&nbsp;
<img src="demo/img6_gt.png" width="48%" alt="Demo 6 ground-truth localization"/>
</p>
<sub>Left: forged image &nbsp;·&nbsp; Right: ground-truth localization</sub>

---

## `translation/` — plain copy-move

Copied region pasted with translation only (Cozzolino / Lozzolino *et al.*, 2015).  
Right image = **proposed localization**.

```matlab
img_name = 'examples/translation/img2.jpg';
gt_img   = 'examples/translation/img2_gt.jpg';
```

### Example 1 (`img2`)
<p>
<img src="translation/img2.jpg" width="48%" alt="Translation example 1 forged"/>
&nbsp;
<img src="translation/img2result.jpg" width="48%" alt="Translation example 1 localized"/>
</p>
<sub>Left: forged image &nbsp;·&nbsp; Right: proposed localization</sub>

### Example 2 (`img3`)
<p>
<img src="translation/img3.jpg" width="48%" alt="Translation example 2 forged"/>
&nbsp;
<img src="translation/img3result.jpg" width="48%" alt="Translation example 2 localized"/>
</p>
<sub>Left: forged image &nbsp;·&nbsp; Right: proposed localization</sub>

### Example 3 (`img6`)
<p>
<img src="translation/img6.jpg" width="48%" alt="Translation example 3 forged"/>
&nbsp;
<img src="translation/img6result.jpg" width="48%" alt="Translation example 3 localized"/>
</p>
<sub>Left: forged image &nbsp;·&nbsp; Right: proposed localization</sub>

### Example 4 (`img9`)
<p>
<img src="translation/img9.jpg" width="48%" alt="Translation example 4 forged"/>
&nbsp;
<img src="translation/img9result.jpg" width="48%" alt="Translation example 4 localized"/>
</p>
<sub>Left: forged image &nbsp;·&nbsp; Right: proposed localization</sub>

### Example 5 (`img12`)
<p>
<img src="translation/img12.jpg" width="48%" alt="Translation example 5 forged"/>
&nbsp;
<img src="translation/img12result.jpg" width="48%" alt="Translation example 5 localized"/>
</p>
<sub>Left: forged image &nbsp;·&nbsp; Right: proposed localization</sub>

### Example 6 (`img14`)
<p>
<img src="translation/img14.jpg" width="48%" alt="Translation example 6 forged"/>
&nbsp;
<img src="translation/img14result.jpg" width="48%" alt="Translation example 6 localized"/>
</p>
<sub>Left: forged image &nbsp;·&nbsp; Right: proposed localization</sub>

Folders also include ground truth (`*_gt.jpg`) and baselines (`*PUN.jpg`, `*RYU.jpg`, `*CAO.jpg`).

---

## `rotation/` — rotated paste

Copied region rotated before pasting (Ardizzone *et al.*, 2015, subset D1-2).

```matlab
img_name = 'examples/rotation/img16.jpg';
gt_img   = 'examples/rotation/img16_gt.jpg';
```

### Example 7 (`img16`)
<p>
<img src="rotation/img16.jpg" width="48%" alt="Rotation example 7 forged"/>
&nbsp;
<img src="rotation/img16result.jpg" width="48%" alt="Rotation example 7 localized"/>
</p>
<sub>Left: forged image &nbsp;·&nbsp; Right: proposed localization</sub>

### Example 8 (`img17`)
<p>
<img src="rotation/img17.jpg" width="48%" alt="Rotation example 8 forged"/>
&nbsp;
<img src="rotation/img17result.jpg" width="48%" alt="Rotation example 8 localized"/>
</p>
<sub>Left: forged image &nbsp;·&nbsp; Right: proposed localization</sub>

### Example 9 (`img18`)
<p>
<img src="rotation/img18.jpg" width="48%" alt="Rotation example 9 forged"/>
&nbsp;
<img src="rotation/img18result.jpg" width="48%" alt="Rotation example 9 localized"/>
</p>
<sub>Left: forged image &nbsp;·&nbsp; Right: proposed localization</sub>

### Example 10 (`img20`)
<p>
<img src="rotation/img20.jpg" width="48%" alt="Rotation example 10 forged"/>
&nbsp;
<img src="rotation/img20result.jpg" width="48%" alt="Rotation example 10 localized"/>
</p>
<sub>Left: forged image &nbsp;·&nbsp; Right: proposed localization</sub>

---

## `scaling/` — scaled paste

Copied region scaled before pasting (Ardizzone *et al.*, 2015, subset D1-2).

```matlab
img_name = 'examples/scaling/img22.jpg';
gt_img   = 'examples/scaling/img22_gt.jpg';
```

### Example 11 (`img22`)
<p>
<img src="scaling/img22.jpg" width="48%" alt="Scaling example 11 forged"/>
&nbsp;
<img src="scaling/img22result.jpg" width="48%" alt="Scaling example 11 localized"/>
</p>
<sub>Left: forged image &nbsp;·&nbsp; Right: proposed localization</sub>

### Example 12 (`img28`)
<p>
<img src="scaling/img28.jpg" width="48%" alt="Scaling example 12 forged"/>
&nbsp;
<img src="scaling/img28result.jpg" width="48%" alt="Scaling example 12 localized"/>
</p>
<sub>Left: forged image &nbsp;·&nbsp; Right: proposed localization</sub>

### Example 13 (`img29`)
<p>
<img src="scaling/img29.jpg" width="48%" alt="Scaling example 13 forged"/>
&nbsp;
<img src="scaling/img29result.jpg" width="48%" alt="Scaling example 13 localized"/>
</p>
<sub>Left: forged image &nbsp;·&nbsp; Right: proposed localization</sub>

### Example 14 (`img30`)
<p>
<img src="scaling/img30.jpg" width="48%" alt="Scaling example 14 forged"/>
&nbsp;
<img src="scaling/img30result.jpg" width="48%" alt="Scaling example 14 localized"/>
</p>
<sub>Left: forged image &nbsp;·&nbsp; Right: proposed localization</sub>

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
