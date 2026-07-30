function pattern = sampling_generator(type, window_size, BRIEF_n)
%SAMPLING_GENERATOR  Random intensity-pair pattern for BRIEF.
%
%   pattern = sampling_generator(type, window_size, BRIEF_n)
%
%   Draws BRIEF_n pairs of relative (y,x) offsets inside a square window
%   of odd size `window_size`. The same pattern is reused for every
%   keypoint so descriptors are comparable.
%
%   Inputs
%     type        - 'uniform' | 'gaussian' | 'gaussian_local'
%                   (paper uses 'gaussian')
%     window_size - odd integer patch size (paper uses 11)
%     BRIEF_n     - number of bit tests (paper uses 256)
%
%   Output
%     pattern - BRIEF_n-by-4 matrix [y1 x1 y2 x2] of sample offsets
%
%   See also BRIEF_descriptor.

x1 = zeros(BRIEF_n, 1);
x2 = zeros(BRIEF_n, 1);
y1 = zeros(BRIEF_n, 1);
y2 = zeros(BRIEF_n, 1);

if strcmp(type, 'uniform')
    % Independent uniform samples inside the window.
    x1 = floor(window_size * rand(BRIEF_n,1) - floor(window_size/2));
    y1 = floor(window_size * rand(BRIEF_n,1) - floor(window_size/2));
    x2 = floor(window_size * rand(BRIEF_n,1) - floor(window_size/2));
    y2 = floor(window_size * rand(BRIEF_n,1) - floor(window_size/2));

elseif strcmp(type, 'gaussian_local')
    % Second sample is drawn near the first (locally correlated pairs).
    for i = 1:BRIEF_n
        x1(i) = floor(normrnd(0, 0.04 * window_size^2));
        while x1(i) > floor(window_size/2) || x1(i) < ceil(-window_size/2)
             x1(i) = floor(normrnd(0, 0.04 * window_size^2));
        end
        x2(i) = floor(normrnd(x1(i), 0.01 * window_size^2));
        while x2(i) > floor(window_size/2) || x2(i) < ceil(-window_size/2)
             x2(i) = floor(normrnd(x1(i), 0.01 * window_size^2));
        end
        y1(i) = floor(normrnd(0, 0.04 * window_size^2));
        while y1(i) > floor(window_size/2) || y1(i) < ceil(-window_size/2)
             y1(i) = floor(normrnd(0, 0.04 * window_size^2));
        end
        y2(i) = floor(normrnd(y1(i), 0.01 * window_size^2));
        while y2(i) > floor(window_size/2) || y2(i) < ceil(-window_size/2)
             y2(i) = floor(normrnd(y1(i), 0.01 * window_size^2));
        end
    end

elseif strcmp(type, 'gaussian')
    % Independent isotropic Gaussians centred on the keypoint (default).
    for i = 1:BRIEF_n
        x1(i) = floor(normrnd(0, 0.04 * window_size^2));
        while x1(i) > floor(window_size/2) || x1(i) < ceil(-window_size/2)
             x1(i) = floor(normrnd(0, 0.04 * window_size^2));
        end
        x2(i) = floor(normrnd(0, 0.04 * window_size^2));
        while x2(i) > floor(window_size/2) || x2(i) < ceil(-window_size/2)
             x2(i) = floor(normrnd(0, 0.04 * window_size^2));
        end
        y1(i) = floor(normrnd(0, 0.04 * window_size^2));
        while y1(i) > floor(window_size/2) || y1(i) < ceil(-window_size/2)
             y1(i) = floor(normrnd(0, 0.04 * window_size^2));
        end
        y2(i) = floor(normrnd(0, 0.04 * window_size^2));
        while y2(i) > floor(window_size/2) || y2(i) < ceil(-window_size/2)
             y2(i) = floor(normrnd(0, 0.04 * window_size^2));
        end
    end
end

pattern = [y1 x1 y2 x2];
end
