function [ SSSS ] = AC_SSSS( AC )
% Get SSSS number in AC coefficients coding
% Input AC is a value.

absAC = abs(AC);

if (absAC == 0)
    SSSS = 0;
elseif (absAC == 1)       
    SSSS = 1;   
elseif (absAC >= 2 && absAC<=3)       
    SSSS = 2;   
elseif (absAC >= 4 && absAC<=7)       
    SSSS = 3;   
elseif (absAC >= 8 && absAC<=15)       
    SSSS = 4;   
elseif (absAC >= 16 && absAC<=31)       
    SSSS = 5;   
elseif (absAC >= 32 && absAC<=63)       
    SSSS = 6;   
elseif (absAC >= 64 && absAC<=127)       
    SSSS = 7;   
elseif (absAC >= 128 && absAC<=255)       
    SSSS = 8;   
elseif (absAC >= 256 && absAC<=511)
    SSSS = 9;   
elseif (absAC >= 512 && absAC<=1023)       
    SSSS = 10;   
end

end

