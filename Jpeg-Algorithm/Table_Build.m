function [ Table ] = Table_Build( HUFFSIZE, HUFFLENGTH )
% Generate a Huffman code table

Table = {};
l = length(HUFFLENGTH);

n = max(HUFFSIZE);
temp = dec2bin(HUFFLENGTH);
temp = transpose(temp);

for i=1:l;
    codeWord = (temp(n*i-HUFFSIZE(i)+1:n*i));
    Table = [Table codeWord];
end

end
