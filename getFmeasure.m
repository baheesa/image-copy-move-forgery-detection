function [FM, measure] = getFmeasure(value, gt)
%GETFMEASURE  Pixel-level Precision, Recall and F-measure vs. ground truth.
%
%   [FM, measure] = getFmeasure(value, gt)
%
%   Compares a binary detection map against a ground-truth forgery mask
%   and returns the forensic metrics reported in the paper:
%     Precision (PPV), Recall / TPR, F-measure, specificity, etc.
%
%   Inputs
%     value - predicted binary mask (or path to an image)
%     gt    - ground-truth mask (or path); non-zero = forged pixels
%
%   Outputs
%     FM      - scalar F-measure = 2·TP / (2·TP + FP + FN)
%     measure - struct with N_TP, N_TN, N_FP, N_FN, FM, TPR, TNR, …
%
%   See also main.

    if ischar(value), value = imread(value) > 0; end
    if ischar(gt),    gt    = imread(gt);       end

    gt    = gt(:);
    value = value(:);
    gt1   = (gt == max(gt));   % forged pixels
    gt0   = (gt == 0);         % authentic pixels

    measure = struct();
    measure.N_TP = sum(    value  & gt1);
    measure.N_TN = sum(not(value) & gt0);
    measure.N_FP = sum(    value  & gt0);
    measure.N_FN = sum(not(value) & gt1);

    measure.FM  = 2 * measure.N_TP ./ (measure.N_TP + measure.N_FP + measure.N_TP + measure.N_FN);
    measure.TPR = measure.N_TP ./ (measure.N_TP + measure.N_FN); % recall / sensitivity
    measure.TNR = measure.N_TN ./ (measure.N_TN + measure.N_FP); % specificity
    measure.FNR = measure.N_FN ./ (measure.N_TP + measure.N_FN);
    measure.FPR = measure.N_FP ./ (measure.N_TN + measure.N_FP);
    measure.PPV = measure.N_TP ./ (measure.N_TP + measure.N_FP); % precision
    measure.NPV = measure.N_TN ./ (measure.N_TN + measure.N_FN);

    FM = measure.FM;
end
