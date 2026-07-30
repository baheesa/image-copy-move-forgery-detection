function n2 = dist2(x, c)
%DIST2  Squared Euclidean distances between two sets of vectors.
%
%   D = DIST2(X, C)
%
%   If X is M-by-N and C is L-by-N, the result D is M-by-L where
%   D(i,j) = || X(i,:) − C(j,:) ||².
%
%   Used by g2nn to build the pairwise descriptor distance matrix for
%   generalized 2nd nearest-neighbour matching.
%
%   Copyright (c) Christopher M. Bishop, Ian T. Nabney (1996, 1997)

    [ndata, dimx] = size(x);
    [ncentres, dimc] = size(c);
    if dimx ~= dimc
        error('Data dimension does not match dimension of centres')
    end

    n2 = (ones(ncentres, 1) * sum((x.^2)', 1))' + ...
          ones(ndata, 1) * sum((c.^2)', 1) - ...
          2 .* (x * (c'));
end
