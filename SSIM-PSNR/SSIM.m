function [ MSSIM ] = SSIM( img1, img2 )


%This is an implementation of the algorithm for calculating the
%Structural SIMilarity (SSIM) index between two images.
%
%Input two images for comparision. The function will return the SSIM index
% value.
%


if (size(img1) ~= size(img2))
   MSSIM = 'Inputs Must have Same Size';
   ssim_map = 'Inputs Must have Same Size';
   return;
end

[height,width] = size(img1);

if ((height < 11) || (width < 11))
    MSSIM = 'Inputs Must be larger than 11*11';
	ssim_map = 'Inputs Must be larger than 11*11';
    return
end

img1 = double(img1);
img2 = double(img2);

% locak window
window = fspecial('gaussian', 11, 1.5);
% pre-defined values
K_1 = 0.01;                             
K_2 = 0.03;                             
L = 255;                                

C_1 = (K_1*L)^2;
C_2 = (K_2*L)^2;

% normalized the window
window = window/sum(sum(window));

% generate the local window weighted matrix of input image
% also could return the average value if input is a single matrix
E_1 = WeightedMatrix(window, img1);
E_2 = WeightedMatrix(window, img2);

E_1_SQ = E_1.*E_1;
E_2_SQ = E_2.*E_2;
E_12 = E_1.*E_2;

% standard deviation
D_1_SQ = WeightedMatrix(window, img1.*img1) - E_1_SQ;
D_2_SQ = WeightedMatrix(window, img2.*img2) - E_2_SQ;
D_12 = WeightedMatrix(window, img1.*img2) - E_12;                          

ssim_map = ((2*E_12 + C_1).*(2*D_12 + C_2))...
    ./((E_1_SQ + E_2_SQ + C_1).*(D_1_SQ + D_2_SQ + C_2));

MSSIM = mean2(ssim_map);

end

