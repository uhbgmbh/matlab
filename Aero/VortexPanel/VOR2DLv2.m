function [Up,Wp,Upa,Upb,Wpa,Wpb] = ...
    VOR2DLv2(gamma0,gamma1,xcp,zcp,x1,z1,x2,z2)
% Computes the x and z velocity due to a linear vortex panel in the vortex
% panel's local coordinate system.  The collocation point must have its
% coordinates in the local panel coordinate system.


dx = x2-x1; dz = z2-z1;
ds = sqrt(dx.^2+dz.^2);
x1p = 0;
x2p = ds;
if (abs(zcp)<0.0001)
    Upa = 0.25;
    Upb = 0.25;
    Wpa = -1/(2*pi);
    Wpb = 1/(2*pi);
else
    Con1 = atan2(zcp,xcp-x2p)-atan2(zcp,xcp-x1);
    Con2 = log(((xcp-x1)^2+zcp^2)/((xcp-x1)^2+zcp^2));
    Upa = Con1/(2*pi);
    Upb = 1/(4*pi)*(zcp*Con2+2*xcp*Con1);
    Wpa = -1/(4*pi)*Con2;
    Wpb = -1/(2*pi)*(xcp/2*Con2+x1p-x2p+zcp*Con1);
end
Up = gamma0*Upa+gamma1*Upb;
Wp = gamma0*Wpa+gamma1*Wpb;


