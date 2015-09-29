function [ extendFrame ] = Bilinear_InterP( originFrame )
% Interpolating a frame by factor 2 with a Bilinear Manner.
% Enlarge the input frame by 2 with Bilinear Interpolation.

[M, N] = size(originFrame);

% enlarge the image by factor 2
extendFrame = zeros(2*M, 2*N);

for i=0:M-1
    for j=0:N-1
        extendFrame(2*i+1, 2*j+1) = originFrame(i+1, j+1);
    end
end

[M, N] = size(extendFrame);

% interpolation first in row
for i=1:2:M
    for j=2:2:N
        if j == N
            % 0 is used if exceed the boundary.
            extendFrame(i, j) = extendFrame(i, j-1);
        else
            extendFrame(i, j) = (extendFrame(i, j-1)+...
            extendFrame(i, j+1))/2;
        end
    end
end

% interpolation then in col
for i=2:2:M
    for j=1:N
        if i == M
            % 0 is used if exceed the boundary.
            extendFrame(i, j) = extendFrame(i-1, j);
        else
            extendFrame(i, j) = (extendFrame(i-1, j)+...
            extendFrame(i+1, j))/2;
        end
    end
end

end
