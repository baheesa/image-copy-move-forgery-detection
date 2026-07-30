function output = g2nn(descriptors1, descriptors2, locations1, locations2, nn_threshold)
%G2NN  Generalized 2nd Nearest-Neighbour matching for copy-move detection.
%
%   output = g2nn(descriptors1, descriptors2, locations1, locations2, nn_threshold)
%
%   Extends Lowe's ratio test so that a single keypoint may match several
%   others — required when a forged patch is pasted multiple times.
%   While (d_k / d_{k+1}) ≤ nn_threshold, the k-th neighbour is accepted
%   and the search continues to the next nearest neighbour.
%
%   Self-matches (identical pixel indices) are forbidden by setting the
%   diagonal of the distance matrix to Inf. Matches are also restricted
%   to i < j to avoid reporting each pair twice.
%
%   Inputs
%     descriptors1, descriptors2 - feature matrices (rows = keypoints)
%     locations1, locations2     - corresponding [row, col] coordinates
%     nn_threshold               - distance-ratio cutoff (paper uses 0.05)
%
%   Output (struct)
%     .source / .target         - matched descriptor rows
%     .source_loc / .target_loc - matched [row, col] coordinates
%
%   See also dist2, second_nearest_neighbour.

    % Pairwise squared Euclidean distances between all descriptors.
    distances = dist2(descriptors1, descriptors2);

    % Ban matching a keypoint to itself (same image, same index).
    for i = 1:size(distances, 1)
        distances(i, i) = Inf;
    end

    corresponding1 = []; corresponding2 = [];
    loc1 = []; loc2 = [];
    c = 1;

    for i = 1:size(distances, 1)
        ds = distances(i, :);

        % Nearest neighbour (NN1).
        nn1 = min(ds);
        matching_indices = find(ds == nn1);
        j = matching_indices(1);

        % Remove NN1 so the next min is NN2.
        ds(matching_indices) = [];
        nn2 = min(ds);

        % Accept successive neighbours while the g2NN ratio test holds.
        % numel(matching_indices)==1 avoids ambiguous exact ties;
        % i < j reports each unordered pair once.
        while ((nn1 / nn2) <= nn_threshold) && numel(matching_indices) == 1 && i < j
            corresponding1(c, :) = descriptors1(i, :); %#ok<AGROW>
            corresponding2(c, :) = descriptors2(j, :); %#ok<AGROW>
            loc1(c, :) = locations1(i, :); %#ok<AGROW>
            loc2(c, :) = locations2(j, :); %#ok<AGROW>
            c = c + 1;

            % Promote NN2 → NN1 and look for the next neighbour.
            nn1 = nn2;
            matching_indices = find(ds == nn1);
            j = matching_indices(1);
            ds(matching_indices) = [];
            nn2 = min(ds);
        end
    end

    output = struct('source', corresponding1, 'target', corresponding2, ...
                    'source_loc', loc1, 'target_loc', loc2);
end
