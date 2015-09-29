function [ DCT_M ] = DCT_8( M )
% DCT_8.m
% Do DCT for an input 8*8 Matrix, return an 8*8 matrix
% Input M must be an 8*8 Matrix

% Define the transform coefficient matrix
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

% The matrix form of DCT
transposeC = C.';

DCT_M = C*M*transposeC;
