function [ bin ] = Dec2Bin( M )
% Convert the input value to a 8-bit bin string  
% Input M should not larger than 255.

bin = '';

for i=1:length(M)
    if length(dec2bin(M(i)))<8;
        temp = '';
        for j = 1:8-length(dec2bin(M(i)))
            temp =[temp '0'];
        end
        bin = [bin temp dec2bin(M(i))]; 
    else
        bin = [bin dec2bin(M(i))];
    end
end

end
