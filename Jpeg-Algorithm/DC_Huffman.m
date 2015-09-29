function [ codedDC ] = DC_Huffman( DC, lastDC )
% Huffman coding for AC coefficients
% Two inputs, DC and LAST DC, return a string of coded DC coefficent

dcTable = DCTable();
DIFF = DC-lastDC;
absD = abs(DIFF);

if DIFF == 0
    SSSS = 0;   
elseif (absD == 1)       
    SSSS = 1;   
elseif (absD >= 2 && absD<=3)       
    SSSS = 2;   
elseif (absD >= 4 && absD<=7)       
    SSSS = 3;   
elseif (absD >= 8 && absD<=15)       
    SSSS = 4;   
elseif (absD >= 16 && absD<=31)       
    SSSS = 5;   
elseif (absD >= 32 && absD<=63)       
    SSSS = 6;   
elseif (absD >= 64 && absD<=127)       
    SSSS = 7;   
elseif (absD >= 128 && absD<=255)       
    SSSS = 8;   
elseif (absD >= 256 && absD<=511)
    SSSS = 9;   
elseif (absD >= 512 && absD<=1023)       
    SSSS = 10;   
elseif (absD >= 1024 && abs(DIFF)<=2047)       
    SSSS = 11;  
end

if DIFF >= 0
    codedDC = [char(dcTable(SSSS+1)) dec2bin(absD)];
else
    temp = dec2bin(absD);
    for i = 1:length(temp)
        if temp(i) == '0'
            temp(i) = '1';
        else
            temp(i) = '0';
        end
    codedDC = [char(dcTable(SSSS+1)) temp];
    end     
end

