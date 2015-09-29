function [ codedAC ] = AC_Huffman( AC )
% Huffman coding for AC coefficients, return a string of coded AC coefficent
% Input AC must be a list with 63 elements

% Define End of Block
EOB = '1010';
% Define Zero Run Length
ZRL = '11111111001';
acTable = ACTable();

runLength = 0;
count = 1;

for i=1:63
    if AC(i) == 0 && runLength < 15;
        runLength = runLength+1;
    else
        if runLength == 15
            RLC(count) = 15;
            RLC(count+1) = 0;
        else
           RLC(count) = runLength;
           RLC(count+1) = AC(i);
        end
        runLength = 0;
        count = count+2;
    end
end

if AC(63) == 0
    RLC(count) = 0;
    RLC(count+1) = 0;
end

while (length(RLC)>2)
    if (RLC(length(RLC)) == 0) && (RLC(length(RLC)-2) == 0)
        RLC = RLC(1:(length(RLC)-2));
        RLC(length(RLC)-1) = 0;
    else
        break
    end
end


codedAC = '';
for i = 1:2:length(RLC)
    run = RLC(i);
    SSSS = AC_SSSS(RLC(i+1));
    
    if SSSS == 0 && run == 0
        codedAC = [codedAC EOB];
    elseif SSSS == 0 && run == 15
        codedAC = [codedAC ZRL];
    else
        RRRR = char(acTable(run+1,SSSS));
        
        if RLC(i+1)>= 0
            codedAC = [codedAC RRRR dec2bin(RLC(i+1))];
        else
            temp = dec2bin(abs(RLC(i+1)));
            for j = 1:length(temp)
                if temp(j) == '0'
                    temp(j) = '1';
                else
                    temp(j) = '0';
                end
            end
            codedAC = [codedAC RRRR temp];
        end
    end
end
        
end

