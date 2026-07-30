# Examples

Here are the sample images that ship with the code. For each case you’ll see the **forged photo on the left** and the **localized copy-move region on the right** (ground truth for the demo set; our detector output for the rest).

```text
examples/
├── demo/           # quick starters (image + ground truth)
├── translation/    # plain paste
├── rotation/       # rotated before paste
└── scaling/        # scaled before paste
```

---

## Demo — good place to start

These six pairs are ready to drop into `main.m`. The right-hand image is the ground-truth mask of where the edit actually is.

```matlab
img_name = 'examples/demo/img3.png';
gt_img   = 'examples/demo/img3_gt.png';
```

### Demo 1 — decorative facade
A close-up of ornate arches and tilework. Two matching tower-like motifs were cloned in the upper part of the scene; the mask marks both copies.

<p>
<img src="demo/img1.png" width="48%" alt="Demo 1 forged facade"/>
&nbsp;
<img src="demo/img1_gt.png" width="48%" alt="Demo 1 ground truth"/>
</p>
<sub>Left: forged image &nbsp;·&nbsp; Right: ground-truth localization</sub>

### Demo 2 — chili peppers
A market stall of red chilies around a handwritten sign. A small tied bunch of peppers was copied from one spot and pasted to fatten the display — a tough case because real peppers already look alike.

<p>
<img src="demo/img2.png" width="48%" alt="Demo 2 forged peppers"/>
&nbsp;
<img src="demo/img2_gt.png" width="48%" alt="Demo 2 ground truth"/>
</p>
<sub>Left: forged image &nbsp;·&nbsp; Right: ground-truth localization</sub>

### Demo 3 — palm against the dunes
Palm fronds on a warm sand-dune backdrop. Part of the canopy was duplicated so the foliage looks denser than it really is.

<p>
<img src="demo/img3.png" width="48%" alt="Demo 3 forged palm"/>
&nbsp;
<img src="demo/img3_gt.png" width="48%" alt="Demo 3 ground truth"/>
</p>
<sub>Left: forged image &nbsp;·&nbsp; Right: ground-truth localization</sub>

### Demo 4 — desert scrub
Orange dunes with sparse plants. A green bush (and nearby dry grass) was cloned into the foreground so the desert looks less empty.

<p>
<img src="demo/img4.png" width="48%" alt="Demo 4 forged desert"/>
&nbsp;
<img src="demo/img4_gt.png" width="48%" alt="Demo 4 ground truth"/>
</p>
<sub>Left: forged image &nbsp;·&nbsp; Right: ground-truth localization</sub>

### Demo 5 — neon night sign
The glowing Harrah’s neon lettering at night. High-contrast bulbs and palm fronds make a hard scene; the forgery sits in that busy, repetitive lighting.

<p>
<img src="demo/img5.png" width="48%" alt="Demo 5 forged neon sign"/>
&nbsp;
<img src="demo/img5_gt.png" width="48%" alt="Demo 5 ground truth"/>
</p>
<sub>Left: forged image &nbsp;·&nbsp; Right: ground-truth localization</sub>

### Demo 6 — balcony mural
A painted building facade with film characters on a balcony. The woman in the red dress appears twice in the same pose — a clean, obvious clone once you know to look.

<p>
<img src="demo/img6.png" width="48%" alt="Demo 6 forged mural"/>
&nbsp;
<img src="demo/img6_gt.png" width="48%" alt="Demo 6 ground truth"/>
</p>
<sub>Left: forged image &nbsp;·&nbsp; Right: ground-truth localization</sub>

---

## Translation — plain copy-move

Same idea as the demos, but from the Cozzolino / Lozzolino set: the patch is pasted without rotation or scaling. The yellow overlay is **our** localization.

```matlab
img_name = 'examples/translation/img2.jpg';
gt_img   = 'examples/translation/img2_gt.jpg';
```

### Example 1 — chili stall (`img2`)
Another chili display around a “Portafortuna” card. The detector highlights two matching pepper clusters near the bottom — source and paste.

<p>
<img src="translation/img2.jpg" width="48%" alt="Translation 1 forged"/>
&nbsp;
<img src="translation/img2result.jpg" width="48%" alt="Translation 1 localized"/>
</p>
<sub>Left: forged image &nbsp;·&nbsp; Right: proposed localization</sub>

### Example 2 — palm canopy (`img3`)
Same palm-and-dune theme. The yellow regions flag the duplicated frond patches in the foliage.

<p>
<img src="translation/img3.jpg" width="48%" alt="Translation 2 forged"/>
&nbsp;
<img src="translation/img3result.jpg" width="48%" alt="Translation 2 localized"/>
</p>
<sub>Left: forged image &nbsp;·&nbsp; Right: proposed localization</sub>

### Example 3 — mural with the red dress (`img6`)
Night mural under “GARE” and a clock. The cloned balcony figure is found on both sides of the window.

<p>
<img src="translation/img6.jpg" width="48%" alt="Translation 3 forged"/>
&nbsp;
<img src="translation/img6result.jpg" width="48%" alt="Translation 3 localized"/>
</p>
<sub>Left: forged image &nbsp;·&nbsp; Right: proposed localization</sub>

### Example 4 — two plates on a table (`img9`)
An indoor table on tatami flooring. One black plate with wrapped snacks was copied beside the other — small objects, easy to miss by eye.

<p>
<img src="translation/img9.jpg" width="48%" alt="Translation 4 forged"/>
&nbsp;
<img src="translation/img9result.jpg" width="48%" alt="Translation 4 localized"/>
</p>
<sub>Left: forged image &nbsp;·&nbsp; Right: proposed localization</sub>

### Example 5 — autumn maple leaves (`img12`)
Dense red maple foliage. A branch cluster was duplicated so the canopy looks fuller; the method has to separate real self-similarity from the clone.

<p>
<img src="translation/img12.jpg" width="48%" alt="Translation 5 forged"/>
&nbsp;
<img src="translation/img12result.jpg" width="48%" alt="Translation 5 localized"/>
</p>
<sub>Left: forged image &nbsp;·&nbsp; Right: proposed localization</sub>

### Example 6 — wooden deck and maples (`img14`)
A Japanese-style deck above autumn leaves. Part of the foliage band was pasted elsewhere in the scene.

<p>
<img src="translation/img14.jpg" width="48%" alt="Translation 6 forged"/>
&nbsp;
<img src="translation/img14result.jpg" width="48%" alt="Translation 6 localized"/>
</p>
<sub>Left: forged image &nbsp;·&nbsp; Right: proposed localization</sub>

You’ll also find `*_gt.jpg` and baseline outputs (`*PUN`, `*RYU`, `*CAO`) in these folders if you want to compare methods by eye.

---

## Rotation — pasted after a turn

From Ardizzone *et al.* (subset D1-2). The copied patch was **rotated** before pasting, so matching has to survive a change of orientation.

```matlab
img_name = 'examples/rotation/img16.jpg';
gt_img   = 'examples/rotation/img16_gt.jpg';
```

### Example 7 — parking bay numbers (`img16`)
Top-down view of numbered asphalt bays. An extra “4” was dropped into the lane after a slight twist — out of place once you notice it.

<p>
<img src="rotation/img16.jpg" width="48%" alt="Rotation 7 forged"/>
&nbsp;
<img src="rotation/img16result.jpg" width="48%" alt="Rotation 7 localized"/>
</p>
<sub>Left: forged image &nbsp;·&nbsp; Right: proposed localization</sub>

### Example 8 — another parking “4” (`img17`)
Same parking-lot setting. Here the painted “4” is cloned beside the real one; the detector should light up both digits.

<p>
<img src="rotation/img17.jpg" width="48%" alt="Rotation 8 forged"/>
&nbsp;
<img src="rotation/img17result.jpg" width="48%" alt="Rotation 8 localized"/>
</p>
<sub>Left: forged image &nbsp;·&nbsp; Right: proposed localization</sub>

### Example 9 — coffee sack on tiles (`img18`)
A “CAFÉ DO BRASIL” burlap bag on terracotta tiles. A stamp (and some sack edge texture) was copied onto another part of the bag.

<p>
<img src="rotation/img18.jpg" width="48%" alt="Rotation 9 forged"/>
&nbsp;
<img src="rotation/img18result.jpg" width="48%" alt="Rotation 9 localized"/>
</p>
<sub>Left: forged image &nbsp;·&nbsp; Right: proposed localization</sub>

### Example 10 — parking lot again (`img20`)
One more asphalt scene with lane numbers and a parked car. The clone is among the painted markings; rotation makes it a fair stress test.

<p>
<img src="rotation/img20.jpg" width="48%" alt="Rotation 10 forged"/>
&nbsp;
<img src="rotation/img20result.jpg" width="48%" alt="Rotation 10 localized"/>
</p>
<sub>Left: forged image &nbsp;·&nbsp; Right: proposed localization</sub>

---

## Scaling — pasted after a resize

Also from Ardizzone D1-2, but the copied patch was **scaled** before pasting.

```matlab
img_name = 'examples/scaling/img22.jpg';
gt_img   = 'examples/scaling/img22_gt.jpg';
```

### Example 11 — two egrets (`img22`)
Two white birds in flight on a blank sky. They share the same wing pose and beak angle — one bird was cloned (and often resized) to invent a second.

<p>
<img src="scaling/img22.jpg" width="48%" alt="Scaling 11 forged"/>
&nbsp;
<img src="scaling/img22result.jpg" width="48%" alt="Scaling 11 localized"/>
</p>
<sub>Left: forged image &nbsp;·&nbsp; Right: proposed localization</sub>

### Example 12 — ant on rocky soil (`img28`)
Close-up of red earth, pebbles, and a small ant. A pebble cluster (or similar patch) was duplicated on this busy textured ground.

<p>
<img src="scaling/img28.jpg" width="48%" alt="Scaling 12 forged"/>
&nbsp;
<img src="scaling/img28result.jpg" width="48%" alt="Scaling 12 localized"/>
</p>
<sub>Left: forged image &nbsp;·&nbsp; Right: proposed localization</sub>

### Example 13 — soil detail (`img29`)
Another ground-level texture shot. Scaling the pasted patch makes the match harder than a plain translation.

<p>
<img src="scaling/img29.jpg" width="48%" alt="Scaling 13 forged"/>
&nbsp;
<img src="scaling/img29result.jpg" width="48%" alt="Scaling 13 localized"/>
</p>
<sub>Left: forged image &nbsp;·&nbsp; Right: proposed localization</sub>

### Example 14 — coffee sack seals (`img30`)
Same style of “CAFÉ DO BRASIL” sack. The circular stamp appears twice at the bottom — a classic scaled/copy-move seal clone.

<p>
<img src="scaling/img30.jpg" width="48%" alt="Scaling 14 forged"/>
&nbsp;
<img src="scaling/img30result.jpg" width="48%" alt="Scaling 14 localized"/>
</p>
<sub>Left: forged image &nbsp;·&nbsp; Right: proposed localization</sub>

---

## What the file names mean

| File | What it is |
|---|---|
| `imgN.jpg` / `.png` | forged test image |
| `imgN_gt.*` | ground-truth mask |
| `imgNresult.jpg` | our localization overlay |
| `imgNPUN.jpg` | Pun *et al.* (2015) |
| `imgNRYU.jpg` | Ryu *et al.* (2010) |
| `imgNCAO.jpg` | Cao *et al.* (2012) |

---

## Dataset credits

- D. Cozzolino, G. Poggi, L. Verdoliva. *Efficient dense-field copy–move forgery detection.* IEEE TIFS, 2015.
- E. Ardizzone, A. Bruno, G. Mazzola. *Copy–move forgery detection by matching triangles of keypoints.* IEEE TIFS, 2015.
