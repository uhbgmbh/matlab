function [eval] = RankineFunc(x,z,C,Uinf,sigma,x_o)
%eval = -C + Uinf*z+sigma/(2*pi)*(atan2(z,(x+x_o))-atan2(z,(x-x_o)));
t1 = atan2(z,(x+x_o));
t2 = atan2(z,(x-x_o));
if (t1 < 0)
    t1 = t1 + 2*pi;
end
if (t2 < 0)
    t2 = t2 +2*pi;
end
eval = -C + Uinf*z+sigma/(2*pi)*(t1-t2);