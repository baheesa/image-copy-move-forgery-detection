function descriptor = BRIEF_descriptor(img, feature, pattern, window_size, BRIEF_n)
%BRIEF_DESCRIPTOR  Binary Robust Independent Elementary Features.
%
%   descriptor = BRIEF_descriptor(img, feature, pattern, window_size, BRIEF_n)
%
%   Implements the BRIEF descriptor of Calonder et al. (ECCV 2010).
%   Around each FAST keypoint, BRIEF_n intensity pairs drawn from
%   `pattern` are compared; each comparison yields one bit of a binary
%   string that is fast to match with Hamming / Euclidean distance.
%
%   In the paper this branch covers textured regions that SIFT may miss,
%   complementing the SIFT smooth-region branch.
%
%   Inputs
%     img         - grayscale image
%     feature     - N-by-2 keypoint coordinates [row, col]
%     pattern     - BRIEF_n-by-4 sampling offsets [y1 x1 y2 x2]
%                   (from sampling_generator)
%     window_size - odd patch size used when generating the pattern
%     BRIEF_n     - descriptor length in bits (typically 128 or 256)
%
%   Output
%     descriptor  - N-by-BRIEF_n binary matrix (one row per keypoint)
%
%   See also sampling_generator, FAST_12, g2nn.

rows    = size(img,1);
columns = size(img,2);
im_corner = zeros(floor(window_size/2));
edge_ver  = zeros(rows, floor(window_size/2));
edge_hor  = zeros(floor(window_size/2), columns);

% Zero-pad so keypoints near the border still have a full comparison window.
img = [im_corner edge_hor im_corner; ...
       edge_ver  img      edge_ver;  ...
       im_corner edge_hor im_corner];

%% Smooth to reject high-frequency noise before pairwise tests
sigma = sqrt(2);
filter_size_gaussian = 9;
meu = floor(filter_size_gaussian / 2);
A = 1 / (2 * pi * sigma);
B = 2 * sigma^2;
gaussian_kernel = zeros(filter_size_gaussian);
for i = 1:filter_size_gaussian
    for j = 1:filter_size_gaussian
        temp = -((i - meu - 1)^2 + (j - meu - 1)^2) / B;
        gaussian_kernel(i,j) = A * exp(temp);
    end
end
gaussian_kernel = gaussian_kernel ./ sum(sum(gaussian_kernel));
img = conv2(img, gaussian_kernel, 'same');

%% Build the binary descriptor for every feature
y1 = pattern(:,1);
x1 = pattern(:,2);
y2 = pattern(:,3);
x2 = pattern(:,4);
descriptor = zeros(size(feature,1), BRIEF_n);
pad_x = size(im_corner, 1);
pad_y = size(im_corner, 2);

for i = 1:size(feature, 1)
    coord_x = feature(i,2) + pad_x;
    coord_y = feature(i,1) + pad_y;
    for j = 1:BRIEF_n
        % Bit = 1 iff the first sample is darker than the second.
        if img(coord_y + y1(j), coord_x + x1(j)) < img(coord_y + y2(j), coord_x + x2(j))
            descriptor(i,j) = 1;
        else
            descriptor(i,j) = 0;
        end
    end
end

end
