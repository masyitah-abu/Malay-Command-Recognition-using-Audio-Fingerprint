function [B,M] = firstUnique(A,srt)
% B is the unique elements in A
% M indexes the first instance of each so B = A(M)
B = unique(A);
M = zeros(size(B));
for ib = 1:length(B)
    M(ib) = min(find(A==B(ib)));
end