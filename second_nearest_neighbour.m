function [newSourcePoints, newTargetPoints] = second_nearest_neighbour(sourceFeatures, targetFeatures, loc, threshold)
%SECOND_NEAREST_NEIGHBOUR  Classic 2NN ratio-style matching via knnsearch.
%
%   [newSourcePoints, newTargetPoints] = ...
%       second_nearest_neighbour(sourceFeatures, targetFeatures, loc, threshold)
%
%   For each source descriptor, finds its two nearest neighbours in the
%   target set and keeps the *second* neighbour when its distance is below
%   `threshold`. Useful as a lighter alternative / diagnostic to g2nn when
%   only a single duplicate is expected.
%
%   Inputs
%     sourceFeatures - source descriptor matrix
%     targetFeatures - target descriptor matrix
%     loc            - keypoint coordinates aligned with sourceFeatures
%     threshold      - maximum accepted distance to the 2nd neighbour
%
%   Outputs
%     newSourcePoints, newTargetPoints - matched [row, col] pairs
%
%   See also g2nn, knnsearch.

[mIdx, mD] = knnsearch(targetFeatures, sourceFeatures, 'K', 2);
mIdx = mIdx(:, 2:end);   % keep 2nd nearest only
mD   = mD(:, 2:end);

newSourcePoints = [];
newTargetPoints = [];
numPoints = size(mIdx, 1);
indexList = []; %#ok<NASGU>

for i = 1:numPoints
    if (mD(i,1) < threshold)
        newSourcePoints = [newSourcePoints; loc(i, :)]; %#ok<AGROW>
        newTargetPoints = [newTargetPoints; loc(mIdx(i,1), :)]; %#ok<AGROW>
    end
end
end
