function [ HUFFSIZE, LASTK ] = HUFFSIZE( BITS )
% Grenerate the Huffman size table according to the input HUFFBITS
% return the HUFFSIZE table and LASTK, which is the last entry of the table

k = 0;
i = 1;
j = 1;

while (i <= 16)
    if j > BITS(i)
        i = i+1;
        j = 1;
    else
        HUFFSIZE(k+1) = i;
        k = k+1;
        j = j+1;
    end
end
    HUFFSIZE(k+1) = 0;
    LASTK = k;    
end
