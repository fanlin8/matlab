function [ extendVector ] = MV_InterP( originVector )
% This function will compute and return a pixel-wise Motion Field given an
% input block-based Motion Field.
% In this case, we assume the MV for each block is actually the MV of the
% block center. AND (8,8) is treated as each block's center.
 
[M, N] = size(originVector);

% Enlarge the image by a factor 16.
extendVector = zeros(16*M, 16*N);

% Put a vector to the center of each block, assume (8,8) is the center of 
% each block
for i=1:M
    for j=1:N
        extendVector(8*(2*i-1), 8*(2*j-1)) = originVector(i, j);
    end
end

[M, N] = size(extendVector);

% Unterpolation first done in rows
for i=8:16:M
    for j=8:16:N
        if j == 8
            % disp('start')
            for k=1:7
                % 0 is used if exceed the boundary.
                extendVector(i, k) = k*extendVector (i, j)/7;   
            end
        elseif j == N-8
            % disp('end')
            for k=1:15
                extendVector(i, j-k) = (k*extendVector(i, j-16)...
                    + (16-k)*extendVector(i, j))/16;   
            end            
            for k=1:8
                % 0 is used if exceed the boundary.
                extendVector(i, j+k) = (9-k)*extendVector (i, j)/8;
            end
        else
            for k=1:15
                extendVector(i, j-k) = (k*extendVector(i, j-16)...
                    + (16-k)*extendVector(i, j))/16;   
            end
        end
    end
end

% interpolation then done in cols
for i=8:16:M
    for j=1:N
        if i == 8
            % disp('start')
            for k=1:7
                % 0 is used if exceed the boundary.
                extendVector(k, j) = k*extendVector (i, j)/7;   
            end
        elseif i == M-8
            % disp('end')
            for k=1:15
                extendVector(i-k, j) = (k*extendVector(i-16, j)...
                    + (16-k)*extendVector(i, j))/16;        
            end            
            for k=1:8
                % 0 is used if exceed the boundary.
                extendVector(i+k, j) = (9-k)*extendVector (i, j)/8;
            end
        else
            for k=1:15
                extendVector(i-k, j) = (k*extendVector(i-16, j)...
                    + (16-k)*extendVector(i, j))/16;   
            end
        end
    end
end

% get integer values for each MV
extendVector = round(extendVector);

end
