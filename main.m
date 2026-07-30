%%==========================================================================
%  FAST, BRIEF and SIFT based Image Copy-Move Forgery Detection
%  -------------------------------------------------------------------------
%  Copyright (c) 2022 Baheesa Fatima, Abdul Ghafoor, Syed Sohaib Ali,
%  and M. Mohsin Riaz. Released under the MIT License (see LICENSE).
%
%  Reference:
%    Fatima, B., Ghafoor, A., Ali, S.S. & Riaz, M.M. (2022).
%    "FAST, BRIEF and SIFT based image copy-move forgery detection technique"
%    Multimedia Tools and Applications, 81, 43805–43819.
%    https://doi.org/10.1007/s11042-022-12915-y
%
%  This script follows the paper pipeline (Section 2 / Fig. 1):
%
%    Section 2   Proposed technique (overview)
%    Sec. 2.1    Preprocessing          — separate prep for FAST and for SIFT
%    Sec. 2.2    Feature detection and description
%                  • FAST + BRIEF  → textured / corner regions
%                  • SIFT          → smooth / uniform regions
%    Sec. 2.3    Feature matching and post-processing
%                  • g2NN matching (both branches)
%                  • merge matched features
%                  • remove outliers (morphology + area filtering)
%                  • forgery localization
%                  • improve localization with LSC + SSIM (γ_s = 0.6)
%
%  Fig. 1 boxes (left = SIFT branch, right = FAST/BRIEF branch):
%    Input Image
%      ├─ Preprocessing for SIFT → SIFT Feature Detection
%      │                        → SIFT Feature Extraction
%      │                        → g2NN Feature Matching
%      └─ Preprocessing for FAST → FAST Feature Detection
%                               → BRIEF Feature Extraction
%                               → g2NN Feature Matching
%    → Matched Features
%    → Post Processing: Removing Outliers
%                     → Forgery Localization
%                     → Improving Localization using Segmentation
%
%  Usage: set img_name / gt_img, then run. See examples/README.md.
%==========================================================================

%% Initialization
clc; clear; close all;

%%--------------------------------------------------------------------------
%  INPUT IMAGE  (Fig. 1 — top box)
%  Load the forged image and its ground-truth mask for evaluation.
%--------------------------------------------------------------------------
addpath(fullfile('vlfeat-0.9.21', 'toolbox'));
vl_setup;   % VLFeat provides vl_sift used in Section 2.2 (SIFT branch)

% Change these paths to try other samples under examples/
img_name = 'examples/demo/img3.png';
gt_img   = 'examples/demo/img3_gt.png';

gt       = imread(gt_img);      % ground-truth forgery mask
filename = imread(img_name);    % input forged RGB / gray image

% Accumulators for matched source/target locations from each branch
BRIEF_target = []; BRIEF_source = [];
SIFT_target  = []; SIFT_source  = [];

tic;
[m, n] = size(filename); %#ok<ASGLU>


%%==========================================================================
%  SECTION 2.1 — PREPROCESSING
%  Paper: image is preprocessed separately for FAST and for SIFT because
%  noise / unsharp edges hurt keypoint detection. FAST needs a sharp view
%  of textured areas; SIFT needs a denoised view of smooth areas.
%==========================================================================

%%--------------------------------------------------------------------------
%  Fig. 1 — "Preprocessing for FAST"  (Sec. 2.1, FAST path)
%  Convert to a single channel and sharpen (unsharp masking) so corners in
%  textured regions stand out. Green channel is used for colour images.
%--------------------------------------------------------------------------
if length(size(filename)) == 3
    FAST_grayimage = imsharpen(uint8(filename(:,:,2)), 'Amount', 0.4);
else
    FAST_grayimage = imsharpen(uint8(filename), 'Amount', 0.4);
end

% Empty binary map — filled later with matched keypoint locations
BW = imbinarize(FAST_grayimage, 'adaptive');
BW(:) = 0;


%%==========================================================================
%  SECTION 2.2 — FEATURE DETECTION AND DESCRIPTION
%  Paper: FAST finds keypoints in textured areas (corners/edges); BRIEF
%  builds binary descriptors on those points. SIFT finds keypoints and
%  descriptors in smooth / uniform areas that FAST tends to miss.
%==========================================================================

%%--------------------------------------------------------------------------
%  Fig. 1 — "FAST Feature Detection"  (Sec. 2.2)
%  FAST-12 circle test (Rosten & Drummond). Threshold γ_f = 0.3
%  (raised to 0.5 if too many corners). Non-maxima suppression follows.
%--------------------------------------------------------------------------
corners1 = FAST_12(FAST_grayimage, 0.3);
FAST_Locations = FAST_non_max(FAST_grayimage, corners1, 0.5);

if size(FAST_Locations, 1) > 15000
    corners1 = FAST_12(FAST_grayimage, 0.5);
    FAST_Locations = FAST_non_max(FAST_grayimage, corners1, 0.5);
end

if size(FAST_Locations, 1) > 2 && size(FAST_Locations, 1) < 15000
    %%----------------------------------------------------------------------
    %  Fig. 1 — "BRIEF Feature Extraction"  (Sec. 2.2)
    %  Paper: 256-D binary BRIEF descriptor at each FAST corner, after
    %  Gaussian smoothing. Sampling pattern is Gaussian inside an 11×11
    %  window (Calonder et al.).
    %----------------------------------------------------------------------
    type        = 'gaussian';
    BRIEF_n     = 256;     % descriptor length (bits), as in the paper
    window_size = 11;
    pattern     = sampling_generator(type, window_size, BRIEF_n);

    BRIEF_Descriptors = BRIEF_descriptor(FAST_grayimage, FAST_Locations, ...
                                         pattern, window_size, BRIEF_n);

    %%----------------------------------------------------------------------
    %  Fig. 1 — "g2NN Feature Matching" on BRIEF  (Sec. 2.3, start)
    %  Paper: generalized 2nd nearest neighbour (g2NN) so one keypoint can
    %  match multiple pasted copies. Matching threshold γ_m = 0.05.
    %----------------------------------------------------------------------
    BRIEF_matches = g2nn(BRIEF_Descriptors, BRIEF_Descriptors, ...
                         FAST_Locations, FAST_Locations, 0.05);

    BRIEF_source = round(BRIEF_matches.source_loc);
    BRIEF_target = round(BRIEF_matches.target_loc);
else
    disp('No matched points in BRIEF');
end

%%--------------------------------------------------------------------------
%  Fig. 1 — "Preprocessing for SIFT"  (Sec. 2.1, SIFT path)
%  Paper: convert RGB→grayscale and apply adaptive noise removal (Wiener)
%  so SIFT can detect features reliably in smooth regions.
%--------------------------------------------------------------------------
grayimage      = rgb2gray(filename);
SIFT_grayimage = wiener2(grayimage, [5 5]);

%%--------------------------------------------------------------------------
%  Fig. 1 — "SIFT Feature Detection" + "SIFT Feature Extraction" (Sec. 2.2)
%  Paper: SIFT on the preprocessed image yields scale/rotation-invariant
%  keypoints and 128-D descriptors (VLFeat implementation of Lowe).
%--------------------------------------------------------------------------
[loc, des] = vl_sift(single(SIFT_grayimage));
SIFT_Locations = round(loc([2 1], :)');   % [row, col]

if size(SIFT_Locations, 1) > 3 && size(SIFT_Locations, 1) < 15000
    % All keypoints (SIFT ∪ FAST) — used later when voting LSC segments
    all_Locations    = unique([SIFT_Locations; FAST_Locations], 'rows');
    SIFT_Descriptors = double(des');

    %%----------------------------------------------------------------------
    %  Fig. 1 — "g2NN Feature Matching" on SIFT  (Sec. 2.3)
    %  Same g2NN ratio test (γ_m = 0.05) as the BRIEF branch.
    %----------------------------------------------------------------------
    SIFT_matches = g2nn(SIFT_Descriptors, SIFT_Descriptors, ...
                        SIFT_Locations, SIFT_Locations, 0.05);
    SIFT_source = SIFT_matches.source_loc;
    SIFT_target = SIFT_matches.target_loc;

    if size(SIFT_source, 1) < 1
        disp('No matched points in SIFT');
    end
else
    disp('No detected points in SIFT');
end


%%==========================================================================
%  SECTION 2.3 — FEATURE MATCHING AND POST-PROCESSING
%  Paper: after g2NN on both branches, matches are merged, outliers are
%  removed, the forgery is localized, and localization is improved with
%  LSC segmentation; SSIM (γ_s = 0.6) checks structural similarity of
%  the duplicated regions.
%==========================================================================

%%--------------------------------------------------------------------------
%  Fig. 1 — "Matched Features"
%  Combine BRIEF and SIFT correspondences into one set of source/target
%  pairs (paper: both branches contribute to the final match set).
%--------------------------------------------------------------------------
source_locs = [BRIEF_source; SIFT_source];
target_locs = [BRIEF_target; SIFT_target];
k = [source_locs, target_locs];

%%--------------------------------------------------------------------------
%  Fig. 1 — "Post Processing"
%--------------------------------------------------------------------------
if size(k, 1) > 0
    location   = unique(k, 'rows');
    source     = location(:, [1 2]);
    target     = location(:, [3 4]);
    final_locs = [source; target];

    % Visual check — overall matched points (cf. Fig. 2i in the paper)
    imshow(filename)
    title('Final Matched Feature Points (SIFT & BRIEF)')
    hold on
    scatter(final_locs(:,2), final_locs(:,1), 'r');
    hold off

    % Correspondence lines between each matched pair
    imshow(filename);
    hold on;
    title('Match Keypoints');
    plot(final_locs(:,2), final_locs(:,1), 'ro', 'MarkerSize', 4);
    temp      = [target, source, nan(size(source,1), 4)]';
    plot_locs = reshape(temp(:), 4, []);
    plot([plot_locs(2,:); plot_locs(4,:)], ...
         [plot_locs(1,:); plot_locs(3,:)], 'b-');
    hold off;

    % Mark matched keypoints on a binary map for morphological growth
    for r = 1:size(final_locs, 1)
        BW(final_locs(r,1), final_locs(r,2)) = 1;
    end

    %%----------------------------------------------------------------------
    %  Fig. 1 — "Removing Outliers"  (Sec. 2.3, morphological processing)
    %  Paper: morphological operations grow sparse matches into candidate
    %  regions; small / weak components are discarded as false matches.
    %----------------------------------------------------------------------
    BW1 = imclose(imdilate(BW, strel('disk', 11, 0)), strel('disk', 5, 0));
    BW2 = imclose(imdilate(BW1, strel('disk', 6, 0)), strel('disk', 3, 0));

    stats = regionprops(BW2, 'Area');
    areas = [stats.Area];
    maxi  = max(areas(:));
    area  = areas / maxi; %#ok<NASGU>

    if maxi > 1500
        % Keep only large components (relative to the biggest blob)
        bigObjects = bwareaopen(BW2, round(maxi * 0.4));
        final_B    = medfilt2(bigObjects, [12 12]);
        final_BW   = imfill(final_B, 'holes');

        [row, col] = find(final_BW ~= 0); %#ok<ASGLU>

        if size(row, 1) > 0
            [r1, c1] = find(final_BW == 1);
            locs = [r1 c1];   % candidate forged pixels after morphology

            %%--------------------------------------------------------------
            %  Fig. 1 — "Forgery Localization"
            %            + "Improving Localization using Segmentation"
            %  (Sec. 2.3)
            %  Paper: Linear Spectral Clustering (LSC) [Li & Chen, CVPR
            %  2015] over-segments the image. Segments that contain a high
            %  density of matched points are kept as the forged region
            %  (Fig. 2k–l).
            %--------------------------------------------------------------
            gaus          = fspecial('gaussian', 3);
            filteredImg   = imfilter(filename, gaus);
            superpixelNum = 200;
            ratio         = 0.015;
            segments = LSC_mex(imsharpen(filteredImg), superpixelNum, ratio);

            num_keypoint     = size(all_Locations, 1);
            keypoint_segment = zeros(num_keypoint, 1);
            num_matches      = size(locs, 1);
            matched_segments = zeros(num_matches, 1);

            for k = 1:num_keypoint
                keypoint_segment(k) = segments(all_Locations(k,1), all_Locations(k,2));
            end
            for k = 1:num_matches
                matched_segments(k) = segments(locs(k,1), locs(k,2));
            end

            matching_segments = unique(matched_segments);
            N     = numel(matching_segments);
            count = zeros(N, 1);
            for k = 1:N
                count(k) = sum(matched_segments == matching_segments(k));
            end

            % Keep segments whose match density is ≥ 60% of the peak
            % (paper post-processing vote / density filter)
            segCount = [matching_segments(:) count count / max(count(:))];
            segTot   = segCount; %#ok<NASGU>
            indices  = find(segCount(:,3) <= 0.6);
            segCount(indices, :) = [];

            segment_BW     = [];
            final_segments = segCount(:,1);
            for matching = 1:length(segCount(:,3))
                [r, c] = find(segments == uint16(final_segments(matching)));
                segment_BW = [segment_BW; [r c]]; %#ok<AGROW>
            end

            my_BW = final_BW;
            my_BW(:) = 0;
            for r = 1:size(segment_BW, 1)
                my_BW(segment_BW(r,1), segment_BW(r,2)) = 1;
            end
            my_BW = imfill(my_BW, 'holes');

            %%--------------------------------------------------------------
            %  Sec. 2.3 — Structural Similarity Index (SSIM), γ_s = 0.6
            %  Paper: SSIM of localized areas checks shape similarity of
            %  the duplicated regions. If SSIM ≥ 0.6 (and >1 blob), accept
            %  the LSC mask; otherwise fall back to the morphology mask.
            %--------------------------------------------------------------
            [binaryimage, num] = bwlabel(my_BW);
            thisBlob1 = ismember(binaryimage, 1);
            [labeledImage1, numRegions1] = bwlabel(thisBlob1); %#ok<ASGLU>
            props1    = regionprops(labeledImage1, 'BoundingBox');
            subImage1 = imcrop(thisBlob1, props1.BoundingBox);
            [mm, nn]  = size(subImage1);
            ssimval   = 1;
            k = 2;

            while k <= num && ssimval >= 0.63 && num > 1
                thisBlob2 = ismember(binaryimage, k);
                [labeledImage2, numRegions2] = bwlabel(thisBlob2); %#ok<ASGLU>
                props2    = regionprops(labeledImage2, 'BoundingBox');
                image2    = imcrop(thisBlob2, props2.BoundingBox);
                subImage2 = imresize(image2, [mm nn]);
                ssimval   = ssim(single(subImage2), single(subImage1));
                k = k + 1;
            end

            if ssimval >= 0.60 && num > 1
                result_BW = my_BW;      % LSC-refined localization
            else
                result_BW = final_BW;   % morphology-only fallback
            end

            % Final detected forgery region (cf. Fig. 2l)
            [row_result, col_result] = find(result_BW == 1);
            imshow(filename)
            title('FINAL IMAGE')
            hold on
            scatter(col_result, row_result, 'yellow');
            hold off

            % Evaluation vs. ground truth (Precision / Recall / F-measure)
            [FM, measure] = getFmeasure(result_BW, gt); %#ok<ASGLU>
            disp(measure);
        else
            disp('Unforged/Original Image');
        end
    else
        disp('Unforged/Original Image');
    end
end
toc;
