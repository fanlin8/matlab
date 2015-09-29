% This program will execute the Exhaustive Block Matching algorithm with
% integer pixel accuracy of motion estimations.
% Input two video frames, one is anchor frame and another is target frame,
% then the script will generate a predicted frame bases on EBMA.
% Also, the PSNR of predicted frame and anchor frame will be calculated,
% the computation time will be recorded.
% The motion filed will be save in "mvx.txt" and "mvy.txt" for part 3.
% At last, the predicton error image and motion field will be displayed.

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

% Input the search range.
R = input('Please Input the Search Range!');

% a timer to record time.
t0 = clock;

[height,width] = size(anchorFrame);
predictFrame = 0;
% Search block size N*N
N = 16;
mvx = 0;
mvy = 0;
% Step size for EBMA
moveStep = 1;

for i = 1:N:height-N+1
    display('Now Searching...')
    fprintf('%2.2f%% \n', i/height*100);
    for j = 1:N:width-N+1
        %disp(j);
        MAD = 0;
        % for MSE
        %MAD_min = (256*N*N)^2;
        % for MAD
        MAD_min = 256*N*N;
        hLowR = 0;
        hHighR = 0;
        wLowR = 0;
        wHighR = 0;
        
        % set up search range.
        % if reach the boundraries, the search range will be limited.
        if i < R+1
            hLowR = i-1;
        else
            hLowR = R;
        end
                        
        if j < R+1
            wLowR = j-1;
        else
            wLowR = R;
        end
        
        if i+R+N-1 > height
            hHighR = height-N-i+1;
        else
            hHighR = R;
        end

        if j+R+N-1 > width
            wHighR = width-N-j+1;
        else
            wHighR = R;
        end
        
        dx = 0;
        dy = 0;
        %disp(hLowR);disp(hHighR);
        %disp(wLowR);disp(wHighR);
        for k = -hLowR:moveStep:hHighR
            for l = -wLowR:moveStep:wHighR
                % for MSE
                %MAD = sum(sum(abs(anchorFrame(i:i+N-1, j:j+N-1)...
                %   - targetFrame(i+k:i+k+N-1, j+l:j+l+N-1))^2));
                % for MAD
                MAD = sum(sum(abs(anchorFrame(i:i+N-1, j:j+N-1)...
                    - targetFrame(i+k:i+k+N-1, j+l:j+l+N-1))));
                % Motion estimation criteria, least MAD or MSE
                if MAD < MAD_min
                   MAD_min = MAD;
                   dy = k;
                   dx = l;
                end
            end
        end
        % store the best match block to predicted frame
        predictFrame(i:i+N-1, j:j+N-1) = ...
            targetFrame(i+dy:i+dy+N-1, j+dx:j+dx+N-1);
        % the index for MVs
        iblk = floor((i-1)/N+1);
        jblk = floor((j-1)/N+1);
        mvx(iblk, jblk) = dx;
        mvy(iblk, jblk) = dy;
    end
end

% Get the running time for this program.
Elapsed_Time = etime(clock, t0);

% Save mvx and mvy for Part3
dlmwrite('mvx.txt', mvx, 'delimiter', '\t', 'precision', '%4.2f');
dlmwrite('mvy.txt', mvy, 'delimiter', '\t', 'precision', '%4.2f');

% Calculate the PSNR
PSNR = PSNR(predictFrame, anchorFrame);
display (PSNR);
display (Elapsed_Time);

% Get the prediction error image
diffFrame = abs(anchorFrame-predictFrame);

figure;
subplot(221);imshow(targetFrame.',[0,255]);
title('Target Frame');            
subplot(222);imshow(anchorFrame.',[0,255]);
title('Anchor Frame');
subplot(223);imshow(predictFrame.',[0,255]);
title('Predicted Frame'); 
subplot(224);imshow(diffFrame.',[0,255]);
title('Prediction Error Image');

% Plot the motion field 
figure;
quiver(mvx,mvy);
title('Motion Vectors');
