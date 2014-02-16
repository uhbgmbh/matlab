function [expA] = MatExp(A,dt,k)
% A must be square and k >= 1
expA = eye(size(A));
for i = 1:k
    expA = expA + A^i*dt^i/factorial(i);
end