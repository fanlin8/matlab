function [ IDCT_M ] = DCT_8( M )
% IDCT_8.m
% Do inverse DCT for an input 8*8 Matrix
% Input M must be an 8*8 Matrix

% Define the transform coefficient matrix
% almost the same as DCT_8.m

tempC = ones (8);
tempC (1,:) = sqrt(0.5);
m = 1;
for i = 1:2:15
    for j = 2:8
        tempC (j,m) = cos((1/16)*i*(j-1)*pi);
    end
    m = m+1;
end
C = 0.5*tempC;

transposeC = C.';

IDCT_M = transposeC*M*C;

