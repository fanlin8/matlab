function [ HUFFCODE ] = HUFFCODE( HUFFSIZE )
% Generate the Huffman code word according to input HUFFSIZE

k = 1;
code = 0;
si = HUFFSIZE(1);

while (true)
    HUFFCODE(k) = code;
    code = code + 1;
    k = k+1;
    if HUFFSIZE(k) == si
        continue
    else
        if HUFFSIZE(k) == 0
            break
        else
            while (HUFFSIZE(k) ~= si)
                code = bitshift(code,1);
                si = si + 1;        
            end
            continue
        end
    end
end

end
