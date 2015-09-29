clear all;
clc;    

% Read the original .bmp file
[filename, pathname] = uigetfile( ...
{ '*.bmp','BMP-files (*.bmp)';...
  '*.pgm','PGM-files (*.pgm)';...
  '*.*','All Files (*.*)' }, ...
  'Select Original Picture');
originPic = double(imread([pathname filename]));
disp('Original Image Read Complete!');
imwrite(uint8(originPic), 'temp.jpg', 'jpg', 'Quality', 5);
imwrite(uint8(originPic), 'temp1.jpg', 'jpg', 'Quality', 80);

% Read the JPG files
jpgPic1 = imread('temp1.jpg');
jpgPic2 = imread('temp.jpg');

% add noise to original picture
gaussianPic = imnoise(uint8(originPic),'gaussian');
saltPic = imnoise(uint8(originPic),'salt & pepper');

% add blur to original picture
m = fspecial('gaussian', [3 3], 2);
gblurPic = imfilter(originPic, m);
m = fspecial('motion');
mblurPic = imfilter(originPic, m);

% contrast adjust
adjustPic = imadjust(uint8(originPic));
histAdjPic = histeq(uint8(originPic));

% calculate PSNR
disp('Now Caculating PSNR...');
data(1,1) = PSNR(jpgPic1, originPic);
data(2,1) = PSNR(jpgPic2, originPic);
data(3,1) = PSNR(gaussianPic, originPic);
data(4,1) = PSNR(saltPic, originPic);
data(5,1) = PSNR(gblurPic, originPic);
data(6,1) = PSNR(mblurPic, originPic);
data(7,1) = PSNR(adjustPic, originPic);
data(8,1) = PSNR(histAdjPic, originPic);

% calculate SSIM
disp('Now Caculating SSIM...');
data(1,2) = SSIM(jpgPic1, originPic);
data(2,2) = SSIM(jpgPic2, originPic);
data(3,2) = SSIM(gaussianPic, originPic);
data(4,2) = SSIM(saltPic, originPic);
data(5,2) = SSIM(gblurPic, originPic);
data(6,2) = SSIM(mblurPic, originPic);
data(7,2) = SSIM(adjustPic, originPic);
data(8,2) = SSIM(histAdjPic, originPic);

% calculate the covariance of two images
disp('Now Caculating COV...');
co1 = cov(double(jpgPic1), originPic);
co2 = cov(double(jpgPic2), originPic);
co3 = cov(double(gaussianPic), originPic);
co4 = cov(double(saltPic), originPic);
co5 = cov(gblurPic, originPic);
co6 = cov(mblurPic, originPic);
co7 = cov(double(adjustPic), originPic);
co8 = cov(double(histAdjPic), originPic);

data(1,3) = co1(1,2);
data(2,3) = co2(1,2);
data(3,3) = co3(1,2);
data(4,3) = co4(1,2);
data(5,3) = co5(1,2);
data(6,3) = co6(1,2);
data(7,3) = co7(1,2);
data(8,3) = co8(1,2);
disp('Caculating Complete!');



f = figure('Position',[400 500 450 240]);
cnames = {'PSNR', 'SSIM', 'COV'};
rnames = {'High Quality JPEG','Low Quality JPEG','Gaussian Noise',...
    'Salt&Pepper Noise','Gaussian Blur','Motion Blur',...
    'Contrast Increasing','Histogram Enhancement'};
t = uitable('Parent',f,'Data',data,'ColumnName',cnames,... 
            'RowName',rnames, 'Position',[20 30 400 190]);

figure;
subplot(331);imshow(originPic,[0,255]);
title('Original Image');            
subplot(332);imshow(jpgPic1,[0,255]);
title('Compressed JPEG with High Quality');
subplot(333);imshow(jpgPic2,[0,255]);
title('Compressed JPEG with Low Quality'); 
subplot(334);imshow(gaussianPic,[0,255]);
title('Image with Gaussian Noise');
subplot(335);imshow(saltPic,[0,255]);
title('Image with Salt&Pepper Noise');            
subplot(336);imshow(gblurPic,[0,255]);
title('Image with Gaussian Blur');
subplot(337);imshow(mblurPic,[0,255]);
title('Image with Motion Blur'); 
subplot(338);imshow(adjustPic,[0,255]);
title('Image with Contrast Increasing');
subplot(339);imshow(histAdjPic,[0,255]);
title('Image with Histogram Contrast Enhancement');
