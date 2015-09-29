function [ dec ] = Bin2Dec( bin )
% Convert input 8-bit bin string to an array of decimal numbers.
% Note input bin string should have a length of multiples of 8.

l = length(bin);
for i=1:length(bin)/8
    temp = bin((8*i)-7:8*i);
    dec(i) = bin2dec(temp);
end

end
