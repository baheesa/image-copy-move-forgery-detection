%%==========================================================================
%  FAST, BRIEF and SIFT based Image Copy-Move Forgery Detection
%  -------------------------------------------------------------------------
%  Reference implementation of:
%    Fatima, B., Ghafoor, A., Ali, S.S. & Riaz, M.M. (2022).
%    "FAST, BRIEF and SIFT based image copy-move forgery detection technique"
%    Multimedia Tools and Applications, 81, 43805–43819.
%    https://doi.org/10.1007/s11042-022-12915-y
%
%  Pipeline (matches the paper):
%    1. FAST corner detection + BRIEF descriptors  → textured / missing regions
%    2. SIFT keypoint detection + descriptors      → smooth regions
%    3. Generalized 2nd nearest-neighbour (g2NN) matching
%    4. Morphological refinement + SSIM verification
%    5. Linear Spectral Clustering (LSC) localization
%    6. Precision / Recall / F-measure vs. ground-truth mask
%
%  Usage:
%    Set img_name / gt_img below, then run this script in MATLAB.
%    Requires: Image Processing Toolbox, VLFeat 0.9.21, LSC_mex MEX file.
%==========================================================================

%% Initialization
clc; clear; close all;

%% Get image
% Add VLFeat to the MATLAB path (SIFT detection / description).
% Prefer forward slashes so the path works on Windows, macOS, and Linux.
addpath(fullfile('vlfeat-0.9.21', 'toolbox'));
vl_setup;

% --- Input / ground-truth pair (change these to evaluate other samples) ---
img_name = 'img3.png';
gt_img   = 'img3_gt.png';

gt       = imread(gt_img);
filename = imread(img_name);

%% Preprocessing for FAST
% Buffers that collect matched source/target locations from each branch.
BRIEF_target = []; BRIEF_source = [];
SIFT_target  = []; SIFT_source  = [];

tic;

[m, n] = size(filename);

% FAST works on a single-channel image. For colour inputs, use the green
% channel (often highest SNR for natural scenes) and lightly sharpen it so
% weak corners in textured regions become detectable.
if length(size(filename)) == 3
    FAST_grayimage = imsharpen(uint8(filename(:,:,2)), 'Amount', 0.4);
else
    FAST_grayimage = imsharpen(uint8(filename), 'Amount', 0.4);
end

% Binary canvas that will later mark matched keypoint locations.
BW = imbinarize(FAST_grayimage, 'adaptive');
BW(:) = 0;

%% FAST Feature Detection
% Detect corners with the FAST-12 circle test (Rosten & Drummond).
% Threshold is a fraction of the local pixel intensity.
corners1 = FAST_12(FAST_grayimage, 0.3);
FAST_Locations = FAST_non_max(FAST_grayimage, corners1, 0.5); % non-maxima suppression

% If the image is extremely textured, raise the threshold to keep the
% keypoint count tractable for pairwise matching.
if size(FAST_Locations, 1) > 15000
    corners1 = FAST_12(FAST_grayimage, 0.5);
    FAST_Locations = FAST_non_max(FAST_grayimage, corners1, 0.5);
end

if size(FAST_Locations, 1) > 2 && size(FAST_Locations, 1) < 15000
    %% BRIEF Feature Extraction
    % Binary Robust Independent Elementary Features (Calonder et al.).
    % A fixed Gaussian sampling pattern compares intensity pairs inside an
    % 11×11 window, producing a 256-bit binary descriptor per FAST keypoint.
    type        = 'gaussian';   % sampling pattern: 'uniform' | 'gaussian' | 'gaussian_local'
    BRIEF_n     = 256;          % descriptor length (bits)
    window_size = 11;           % patch size around each keypoint
    pattern     = sampling_generator(type, window_size, BRIEF_n);

    BRIEF_Descriptors = BRIEF_descriptor(FAST_grayimage, FAST_Locations, ...
                                         pattern, window_size, BRIEF_n);

    %% BRIEF Feature Matching
    % Self-matching with generalized 2NN (g2NN): keep neighbours whose
    % distance ratio is below the threshold (detects multiple copies).
    BRIEF_matches = g2nn(BRIEF_Descriptors, BRIEF_Descriptors, ...
                         FAST_Locations, FAST_Locations, 0.05);

    BRIEF_source = round(BRIEF_matches.source_loc);
    BRIEF_target = round(BRIEF_matches.target_loc);
else
    disp('No matched points in BRIEF');
end

%% Preprocessing for SIFT
% SIFT is more reliable in smooth / low-texture regions where FAST tends
% to fail. Denoise lightly with a Wiener filter before detection.
grayimage      = rgb2gray(filename);
SIFT_grayimage = wiener2(grayimage, [5 5]);

%% SIFT Feature Detection and Extraction
% VLFeat SIFT: loc = [x; y; scale; orientation], des = 128-D descriptors.
[loc, des] = vl_sift(single(SIFT_grayimage));
SIFT_Locations = round(loc([2 1], :)');   % store as [row, col]

if size(SIFT_Locations, 1) > 3 && size(SIFT_Locations, 1) < 15000
    % Union of SIFT and FAST locations — used later for LSC segment voting.
    all_Locations    = unique([SIFT_Locations; FAST_Locations], 'rows');
    SIFT_Descriptors = double(des');

    %% SIFT Feature Matching
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

%% Combining Matching points from SIFT and BRIEF
% Merge both branches so forged regions found by either detector survive.
source_locs = [BRIEF_source; SIFT_source];
target_locs = [BRIEF_target; SIFT_target];
k = [source_locs, target_locs];

%% Post Processing
if size(k, 1) > 0
    location   = unique(k, 'rows');
    source     = location(:, [1 2]);
    target     = location(:, [3 4]);
    final_locs = [source; target];

    % Visualise all surviving matched keypoints.
    imshow(filename)
    title('Final Matched Feature Points (SIFT & BRIEF)')
    hold on
    scatter(final_locs(:,2), final_locs(:,1), 'r');
    hold off

    %% Plotting Matched Features Points
    % Draw correspondence lines between each source ↔ target pair.
    imshow(filename);
    hold on;
    title('Match Keypoints');
    plot(final_locs(:,2), final_locs(:,1), 'ro', 'MarkerSize', 4);
    temp      = [target, source, nan(size(source,1), 4)]';
    plot_locs = reshape(temp(:), 4, []);
    plot([plot_locs(2,:); plot_locs(4,:)], ...
         [plot_locs(1,:); plot_locs(3,:)], 'b-');
    hold off;

    % Rasterise matched points onto the binary mask.
    for r = 1:size(final_locs, 1)
        BW(final_locs(r,1), final_locs(r,2)) = 1;
    end

    % Morphological closing / dilation grows sparse keypoints into
    % contiguous candidate forgery regions (paper post-processing step).
    BW1 = imclose(imdilate(BW, strel('disk', 11, 0)), strel('disk', 5, 0));
    BW2 = imclose(imdilate(BW1, strel('disk', 6, 0)), strel('disk', 3, 0));

    %% Removing Outliers based on area
    % Discard tiny blobs; keep components that are a substantial fraction
    % of the largest detected region (filters noise matches).
    stats = regionprops(BW2, 'Area');
    areas = [stats.Area];
    maxi  = max(areas(:));
    area  = areas / maxi;

    if maxi > 1500
        bigObjects = bwareaopen(BW2, round(maxi * 0.4));
        final_B    = medfilt2(bigObjects, [12 12]);
        final_BW   = imfill(final_B, 'holes');

        [row, col]       = find(final_BW ~= 0);
        [row_gt, col_gt] = find(gt ~= 0);

        if size(row, 1) > 0
            [r1, c1] = find(final_BW == 1);
            locs = [r1 c1];

            %% Forgery Region Localization using LSC
            % Linear Spectral Clustering (Li & Chen, CVPR 2015) over-
            % segments the image into superpixels. Segments that contain a
            % high density of matched keypoints are labelled as forged.
            gaus         = fspecial('gaussian', 3);
            filteredImg  = imfilter(filename, gaus);
            superpixelNum = 200;
            ratio         = 0.015;
            segments = LSC_mex(imsharpen(filteredImg), superpixelNum, ratio);

            num_keypoint     = size(all_Locations, 1);
            keypoint_segment = zeros(num_keypoint, 1);

            num_matches       = size(locs, 1);
            matched_segments  = zeros(num_matches, 1);

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

            %% Removing segments containing less than 60% matching points
            % Relative vote count: keep only segments whose match density
            % is at least 60% of the densest forged segment.
            segCount = [matching_segments(:) count count / max(count(:))];
            segTot   = segCount;
            indices  = find(segCount(:,3) <= 0.6);
            segCount(indices, :) = [];

            segment_BW    = [];
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

            %% SSIM
            % Structural Similarity Index between the two largest candidate
            % blobs. A high SSIM (≥ 0.60) confirms they are near-duplicates
            % (true copy-move); otherwise fall back to the morphology mask.
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
                result_BW = my_BW;
            else
                result_BW = final_BW;
            end

            % Overlay the final detected forgery region.
            [row_result, col_result] = find(result_BW == 1);
            imshow(filename)
            title('FINAL IMAGE')
            hold on
            scatter(col_result, row_result, 'yellow');
            hold off

            % Pixel-level Precision / Recall / F-measure against GT mask.
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
