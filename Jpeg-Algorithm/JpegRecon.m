% This program read an input bin data stream and reconstruct the JPEG
%      picture.
% Based on the Baseline algorithm
% The AC and DC Huffman table will be rebuilt according the table
%     specifications
% the LQ table will as well be rebuilt
% Also calculate the PSNR

clear;
clc;

% Read the stream data
fr = fopen('JpegStream.txt','r');
jpegStream = fgetl(fr);

% Remove EOI
if bin2dec(jpegStream(length(jpegStream)-15:length(jpegStream)-8)) == 255 ...
       && bin2dec(jpegStream(length(jpegStream)-7:length(jpegStream))) == 217
   jpegStream = jpegStream(1:length(jpegStream)-16);
else
    disp ('End DATA ERROR!!!');
end

% Remove SOI
if bin2dec(jpegStream(1:8)) == 255 ...
       && bin2dec(jpegStream(9:16)) == 216
   jpegStream = jpegStream(17:length(jpegStream));
else
    disp ('Start DATA ERROR!!!');
end

% Read quantization data and DC&AC table specifications
while (length (jpegStream)>8)
    
    fsrtByte = bin2dec(jpegStream(1:8));
    secdByte = bin2dec(jpegStream(9:16));
    thrdByte = bin2dec(jpegStream(17:24));
    fothByte = bin2dec(jpegStream(25:32));
    fithByte = bin2dec(jpegStream(33:40));
    
    if fsrtByte == 255 && secdByte == 219 && fithByte == 0
        l = thrdByte + fothByte;
        dqtEND = l*8+16;
        zzDQT =  jpegStream(41:dqtEND);
        jpegStream = jpegStream(dqtEND+1:length(jpegStream));
    elseif fsrtByte == 255 && secdByte == 196 && fithByte == 0
        l = thrdByte + fothByte;
        dhtDCEND = l*8+16;
        dcBITS = jpegStream(41:21*8);
        dcVAL = jpegStream(21*8+1:dhtDCEND);
        jpegStream = jpegStream(dhtDCEND+1:length(jpegStream));
    elseif fsrtByte == 255 && secdByte == 196 && fithByte == 1
        l = thrdByte + fothByte;
        dhtACEND = l*8+16;
        acBITS = jpegStream(41:21*8);
        acVAL = jpegStream(21*8+1:dhtACEND);
        jpegStream = jpegStream(dhtACEND+1:length(jpegStream));
    elseif fsrtByte == 255 && secdByte == 192
        jpegStream = jpegStream(17:length(jpegStream));
        break
    else
        disp ('Header DATA ERROR!!!');
        break
    end
    
end

% Rebuild the Luminance quantization table
zzDQT = Bin2Dec(zzDQT);
LQTable = IZig_Zag(zzDQT);

% Generate DC Huffman size table and code word table
dcBITS = Bin2Dec(dcBITS);
dcVAL = Bin2Dec(dcVAL); 
[dSize, k] = HUFFSIZE(dcBITS);
dLength = HUFFCODE(dSize);
% Sort them in a correct sequence
[dcTable, dcSize] = ORDERCODE(k, dSize, dLength, dcVAL);
% Generate the encoding Huffman Table
dcTable = Table_Build(dcSize, dcTable);

% Generate the encoding AC Huffman Table
acBITS = Bin2Dec(acBITS);
acVAL = Bin2Dec(acVAL); 
[aSize, k] = HUFFSIZE(acBITS);
aLength = HUFFCODE(aSize);
[tempTable, acSize] = ORDERCODE(k, aSize, aLength, acVAL);
tempTable = Table_Build(acSize, tempTable);

% remove EOB and ZRL
[row col]=find(cellfun(@(x) strcmp(x,'1010'),tempTable));
tempTable(col) = [];
[row col]=find(cellfun(@(x) strcmp(x,'11111111001'),tempTable));
tempTable(col) = [];
acTable = [];

for i=1:16
    acTable = [acTable; tempTable(10*i-9:10*i)];
end

% remove empty elements
acSize(acSize==0) = [];

% build AC code length table
% remove EOB and ZRL length
acSize(1) = [];
acSize(151) = [];
tempTable = acSize;
acSize = [];
for i=1:16
    acSize = [acSize; tempTable(10*i-9:10*i)];
end

% Until now all tables have been rebuilt
tLength = length (jpegStream);
sLength = length (jpegStream);
preD = 0;
subM = [];

while (sLength>0)
    temp = [];
    zList = [];
    
    % Decoding the DC coefficient for an 8*8 block
    for i=1:9
        temp = [temp jpegStream(i)];
        if ismember(temp,dcTable)
            break
        end
    end
    
    if ismember(temp,dcTable)
        if strcmp(temp, '00')
            jpegStream = jpegStream(length(temp)+1:length(jpegStream));
            zList(1) = preD + bin2dec(jpegStream(1));
            preD = zList(1);
            jpegStream = jpegStream(2:length(jpegStream));
        else
            [row col]=find(cellfun(@(x) strcmp(x,temp),dcTable));
            dL = col - 1;
            jpegStream = jpegStream(length(temp)+1:length(jpegStream));
            asbD = bin2dec(jpegStream(1:dL));
            if asbD >= 2^(dL-1) && asbD < 2^dL
                zList(1) = preD + asbD;
            else
                for j = 1:dL
                    if jpegStream(j) == '0'
                        jpegStream(j) = '1';
                    else
                        jpegStream(j) = '0';
                    end
                    asbD = bin2dec(jpegStream(1:dL));
                    zList(1) = preD - asbD;
                end
            end
            preD = zList(1);
            jpegStream = jpegStream(dL+1:length(jpegStream));
        end
    else
        disp ('DC DATA ERROR!!!');
    end
    
    % Decoding the AC coefficients for an 8*8 block
    while (true)
        temp = [];
        for k=1:16
            temp = [temp jpegStream(k)];
            if ismember(temp,acTable) || strcmp(temp, '11111111001') || strcmp(temp, '1010')
                break
            end
        end
        
        if ismember(temp,acTable)
            [row col]=find(cellfun(@(x) strcmp(x,temp),acTable));
            rL = row - 1;
            jpegStream = jpegStream(length(temp)+1:length(jpegStream));
            asbA = bin2dec(jpegStream(1:col));
            
            for j=1:rL
                zList = [zList 0];
            end
            
            if asbA >= 2^(col-1) && asbA < 2^col
                zList = [zList asbA];
            else
                for j = 1:col
                    if jpegStream(j) == '0'
                        jpegStream(j) = '1';
                    else
                        jpegStream(j) = '0';
                    end
                end
                asbA = bin2dec(jpegStream(1:col));
                zList = [zList -asbA];
            end
            jpegStream = jpegStream(col+1:length(jpegStream));
            
        elseif strcmp(temp, '11111111001')
            for j=1:15
                zList = [zList 0];
            end
            jpegStream = jpegStream(12:length(jpegStream));
            continue;
            
        elseif strcmp(temp, '1010')
            jpegStream = jpegStream(5:length(jpegStream));
            break;
        else
            disp ('AC DATA ERROR!!!');
        end
    end
    
    % Inverse weighting and inverse DCT
    zList = [zList zeros(1,64-length(zList))];
    subM = [subM IDCT_8(IZig_Zag(zList).*LQTable)];
    sLength = length (jpegStream);
    
    % a simple indicator for the rebuild process
    disp((1-(sLength/tLength))*100);
end


% rebuild the pictur matrix
disp ('Rebuild Complete!!!');

for i = 1:64
    reconIMG(8*i-7:8*i,1:512) = subM (1:8,512*i-511:512*i);
end

reconIMG = uint8(reconIMG);
imwrite(reconIMG,'relena512.bmp');
imshow('relena512.bmp');

% Calculate the PSNR
orignPic = imread('lena512.bmp');
PSNR = 0;
for i = 1:512
    for j = 1:512
        PSNR = PSNR + (double(orignPic(i, j)) - double(reconIMG(i, j))) ^ 2;
    end
end
PSNR = 10 * log10 ((255^2) / (1 / (((512 + 512) / 2) ^ 2) * PSNR));

display (PSNR);
