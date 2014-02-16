function [A] = GetModeAMatrix(q)
    if (q == 1)
        A = [-1 0;
              0 0];
    elseif (q == 2)
        A = [1 0;
              0 -1];
    else
        A = [1 0; 0 1];
    end
end