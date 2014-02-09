function [Up,Wp,Upa,Upb,Wpa,Wpb] = ...
    VOR2DLv4(gamma0,gamma1,xcp,zcp,x1p,z1p,x2p,z2p)
% Computes the x and z velocity due to a linear vortex panel in the vortex
% panel's local coordinate system.  The collocation point must have its
% coordinates in the local panel coordinate system.
theta1 = atan2(zcp-z1p,xcp-x1p);
theta2 = atan2(zcp-z2p,xcp-x2p);
dtheta = theta2 - theta1;
r1 = sqrt((xcp-x1p)^2+(zcp-z1p)^2);
r2 = sqrt((xcp-x2p)^2+(zcp-z2p)^2);
Upa = -zcp/(2*pi)*log(r2/r1)/(x2p-x1p)+dtheta/(2*pi)-(xcp-x1p)*dtheta/(2*pi*(x2p-x1p));
Upb = zcp/(2*pi)*log(r2/r1)/(x2p-x1p)+(xcp-x1p)*(dtheta)/(2*pi*(x2p-x1p));
Wpa = -log(r1/r2)/(2*pi)+(xcp-x1p)*log(r1/r2)/(2*pi*(x2p-x1p))-1/(2*pi)-zcp*dtheta/(2*pi*(x2p-x1p));
Wpb = -(xcp-x1p)/(2*pi*(x2p-x1p))*log(r1/r2) + 1/(2*pi) + zcp*dtheta/(2*pi*(x2p-x1p));
Up = gamma0*Upa+gamma1*Upb;
Wp = gamma0*Wpa+gamma1*Wpb;


