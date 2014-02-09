function [eval] = RankineStreamFunc(x,z,Uinf,Sigma,x_o)
t1 = atan2(z,(x+x_o));
t2 = atan2(z,(x-x_o));
if (t1 < 0)
    t1 = t1 + 2*pi;
end
if (t2 < 0)
    t2 = t2 + 2*pi;
end
eval = Uinf*z+Sigma/(2*pi)*(t1-t2);