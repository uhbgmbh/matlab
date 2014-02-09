function [eval] = RankineFunc2(x,z,Uinf,Sigma,x_o)
t1 = atan2(z,(x+x_o));
t2 = atan2(z,(x-x_o));
if (t1 < 0)
    t1 = t1 + 2*pi;
end
if (t2 < 0)
    t2 = t2 +2*pi;
end
eval =  cos(Uinf*z*2*pi/Sigma)-cos(t2-t1);