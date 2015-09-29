% This program will generate a predicted frame based on the MV get from
% EBMA with half-integer pixel accuracy.
% Import data of motion field got in part 1. These vectors will be bilinear
% interpolated to a dense pixel-wise motion field, which indicts the motion
% of every pixel of target frame. Then the script will generate a
% predicted according to these two matrices. 
% Also, the PSNR of predicted frame and anchor frame will be calculated,
% the computation time will be recorded.
% At last, the prediciton error image will be displyed.

clear all;
close all;

% Read an anchor frame, a .Y file
[filename, pathname] = uigetfile( ...
{ '*.Y','Y-files (*.Y)';...
  '*.*','All Files (*.*)' }, ...
  'Select Anchor Frame');
fip = fopen([pathname filename]);
anchorFrame = fread(fip, [352,288]);
disp('Anchor Frame Read Complete!');
fclose(fip);

% Read a target frame, a .Y file
[filename, pathname] = uigetfile( ...
{ '*.Y','Y-files (*.Y)';...
  '*.*','All Files (*.*)' }, ...
  'Select Target Frame');
fip = fopen([pathname filename]);
targetFrame = fread(fip, [352,288]);
disp('Target Frame Read Complete!');
fclose(fip);

% a timer to record time.
t0 = clock;

% read mvx and mvy data from txt files
mvx = dlmread('mvx.txt', '\t');
mvy = dlmread('mvy.txt', '\t');

% Interpolate block motion field to pixel motion field.
pixelMV_x = MV_InterP(mvx);
pixelMV_y = MV_InterP(mvy);

% Generate the Predicted Frame based on motion matrices.
[height,width] = size(anchorFrame);
predictFrame = targetFrame;

for i = 1:height
    for j = 1:width
        dx = pixelMV_x(i,j);
        dy = pixelMV_y(i,j);
        predictFrame(i,j) = targetFrame(i+dy, j+dx);
    end
end

% Get the running time for this program.
Elapsed_Time = etime(clock, t0);

% Calculate the PSNR
PSNR = PSNR(predictFrame, anchorFrame);
display (PSNR);
display (Elapsed_Time);

% Get the prediction error image
diffFrame = abs(anchorFrame-predictFrame);

% Display figures
subplot(221);imshow(targetFrame.',[0,255]);
title('Target Frame');            
subplot(222);imshow(anchorFrame.',[0,255]);
title('Anchor Frame');
subplot(223);imshow(predictFrame.',[0,255]);
title('Predicted Frame'); 
subplot(224);imshow(diffFrame.',[0,255]);
title('Prediction Error Image');
