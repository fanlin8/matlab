# EBMA Motion Estimation Algorithm
One of the video motion estimation algorithm, exhaustive block matching algorithm is implemented. And both the integer-pel accuracy EBMA and the half-pel EBMA for two given video frames are realized by MATLAB. As a plus, a pixel-based motion filed is generated upon a block-based motion filed, and a predicted frame is constructed with it. 

#	Program Listing
## `EBMA_IntP.m` 
This script will execute the Exhaustive Block Matching algorithm with integer pixel accuracy. Input two video frames, one is anchor frame and another is target frame, then a predicted frame will be generated. The motion filed will be save in "mvx.txt" and "mvy.txt" for part 3 in current directory. Also, the PSNR of predicted frame and anchor frame will be calculated, and the computation time will be recorded.
## `EBMA_HalfIntP.m` 
This program will generate a predicted frame with half-accuracy EBMA. The searching manner is the same as the Integer-pel EBMA. But the target frame needs to be interpolated first. Note an optional algorithm with down sampling could be chosen.
## `Pixel_MEst.m` 
This program will generate a predicted frame based on the MVs get from EBMA with half-integer pixel accuracy. Import data of motion fields stored in file “mvx.txt” and ”mvy.txt”. These matrices will be bilinear interpolated to two dense pixel-wise motion fields, which indict the motion of every pixel of target frame. Then the script will generate a predicted according to these two matrices. 
## `Bilinear_InterP.m` 
Interpolating a frame by factor 2 with a Bilinear Manner. 
## `MV_InterP.m` 
Interpolating a block by factor 16 with a Bilinear Manner. All value is decided by the value at the block center. In this program, the center is set as (8, 8) of each 16×16 block. 
## `PSNR.m` 
This Function will compute and return the PSNR between two input frames.
## `Down_Sample.m` 
NOTE this function is optional. Down sampling an interpolated frame by factor 2. 
