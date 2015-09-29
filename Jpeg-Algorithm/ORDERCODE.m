function [ EHUFCO, EHUFSI ] = ORDERCODE( LASTK, HUFFSIZE, HUFFCODE, HUFFVAL )
% Generate the ordered Huffman Table
% The encoding procedure code tables, EHUFCO and EHUFSI, 
% are created by reordering the codes specified by HUFFCODE and HUFFSIZE 
% according to the symbol values assigned to each code in HUFFVAL.

k = 0;

while (k < LASTK)
    i = HUFFVAL(k+1);
    EHUFCO(i+1) = HUFFCODE(k+1);
    EHUFSI(i+1) = HUFFSIZE(k+1);
    k = k+1;
end
    
end
