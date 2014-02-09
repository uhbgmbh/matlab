function [Up,Wp,Upa,Upb,Wpa,Wpb] = ...
    VOR2DLv3(gamma0,gamma1,xcp,zcp,x1,z1,x2,z2)
% Computes the x and z velocity due to a linear vortex panel in the vortex
% panel's local coordinate system.  The collocation point must have its
% coordinates in the local panel coordinate system.
theta1 = atan2(zcp-z1,xcp-x1);
theta2 = atan2(zcp-z2,xcp-x2);
dtheta = theta2 - theta1;
r1 = sqrt((xcp-x1)^2+(zcp-z1)^2);
r2 = sqrt((xcp-x2)^2+(zcp-z2)^2);
ds = sqrt((x2-x1)^2+(z2-z1)^2);
x1p = 0;
x2p = ds;
Upa = zcp/(2*pi)*log(r2/r1)/(x2p-x1p)+(xcp-x1p)*(dtheta)/(2*pi*(x2p-x1p));
Upb = -zcp/(2*pi)*log(r2/r1)/(x2p-x1p)+dtheta/(2*pi)-(xcp-x1p)*dtheta/(2*pi*x2p-x1p);
Wpa = -log(r1/r2)/(2*pi)+(xcp-x1p)*log(r1/r2)/(2*pi*(x2p-x1p))-1/(2*pi)-zcp*dtheta/(2*pi*(x2p-x1p));
Wpb = -(xcp-x1p)/(2*pi*(x2p-x1p))*log(r1/r2) + 1/(2*pi) + zcp*dtheta/(2*pi*(x2p-x1p));
Up = gamma0*Upa+gamma1*Upb;
Wp = gamma0*Wpa+gamma1*Wpb;


