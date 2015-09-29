function [ wMatrix ] = WeightedMatrix( blk_window, orignMatrix )
%The function will return a weighted matrix. 
%   Detailed explanation goes here

[height,width] = size(orignMatrix);
[M,N] = size(blk_window);

for i = 1:height-N+1
    for j = 1:width-M+1
        block = orignMatrix((i:i+10),(j:j+10));
        block = blk_window.*block;
        wMatrix(i,j) = sum(sum(block));        
    end
end

end
