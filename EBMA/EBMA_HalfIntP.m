% This program will execute the Exhaustive Block Matching algorithm with
% half-integer pixel accuracy.
% Input two video frames, one is anchor frame and another is target frame,
% and these frames will be interpolated to a two times large with Bilinear
% Interpolation. Then the script will generate a predicted frame bases on
% the EBMA.
% Also, the PSNR of predicted frame and anchor frame will be calculated,
% the computation time will be recorded.
% At last, the predicton error image will be displayed.

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
% Two frames will be extended for search.
exTargetFrame = Bilinear_InterP(targetFrame);
N = 16;
mvx = 0;
mvy = 0;
moveStep = 0.5;

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
        %disp(hLowR);disp(hHighR);
        %disp(wLowR);disp(wHighR);
                
        dx = 0;
        dy = 0;
        % The search range also will be scaled by 2.
        for k = -hLowR:moveStep:hHighR
            for l = -wLowR:moveStep:wHighR
                
                % The search block size also will be scaled by 2.
                tempFrame = exTargetFrame(2*(i+k)-1:2:2*(i+k+N-1), ...
                    2*(j+l)-1:2:2*(j+l+N-1));
                % Try a down sampling metod, needs a lot more computations.
                %tempFrame = Down_Sampling(tempFrame);
                % for MSE
                %MAD = sum(sum(abs(anchorFrame(i:i+N-1, j:j+N-1)...
                %   - tempFrame))^2));
                % for MAD
                MAD = sum(sum(abs(anchorFrame(i:i+N-1, j:j+N-1)...
                    - tempFrame)));
                if MAD < MAD_min
                   MAD_min = MAD;
                   % store the best match block to predicted frame
                   dy = k;
                   dx = l;
                end
            end
        end
        % store the best match block directly to predicted frame
        predictFrame(i:i+N-1, j:j+N-1) = ...
            exTargetFrame(2*(i+dy)-1:2:2*(i+dy+N-1), ...
                    2*(j+dx)-1:2:2*(j+dx+N-1));
        
        % store the best match block directly to a extended predicted frame
        % by factor 2, which could increase the accuracy a little.
        % THIS STEP is NOT NEEDED, you could store the frame directly!!!
        %predictFrame(2*i-1:2*(i+N-1), 2*j-1:2*(j+N-1)) = ...
        %    exTargetFrame(2*(i+dy)-1:2*(i+dy+N-1), ...
        %            2*(j+dx)-1:2*(j+dx+N-1));      
        % the index for MVs
        iblk = floor((i-1)/N+1);
        jblk = floor((j-1)/N+1);
        mvx(iblk, jblk) = dx;
        mvy(iblk, jblk) = dy;
    end
end

% Down sampling the predicted size to original size.
% THIS STEP is NOT NEEDED if the frame is saved directly!!!
%predictFrame = Down_Sampling( predictFrame);

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
