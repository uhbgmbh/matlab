function [NewMode] = CheckGuardCondition(x,q)
    % Good candidate for a functor
    if (q==1)
        if(sqrt(sum(x.^2)) < 1.2)
            NewMode = 2;
        else
            NewMode = 1;
        end
    elseif (q==2)
        NewMode = 2;
    else
        NewMode = q;
    end
end