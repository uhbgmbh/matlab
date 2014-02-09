function [U,W,Ua,Ub,Wa,Wb,VN1,VN2] = ...
    VOR2DL(gamma0,gamma1,xc,zc,x1,z1,x2,z2,xg,zg)

rcolg = [xc-xg,zc-zg];
rx1g = [x1-xg,z1-zg];
relx1colg = rcolg-rx1g;
PanelLength = sqrt((x1-x2).^2+(z1-z2).^2);
x1p = 0;
x2p = PanelLength;
ex_panel_in_g = [x2-x1,z2-z1]/PanelLength;
ex_global = [1,0];
%alpha = acos(ex_global*ex_panel_in_g');
alpha = atan2(z2-z1,x2-x1);
alpha*180/pi
TwoToThree = [1 0 0; 0 0 1];
ez_panel_in_g = [-sin(alpha),cos(alpha)];
RotationDirection = sign(...
    cross(ex_global*TwoToThree,ex_panel_in_g*TwoToThree));
if (RotationDirection(2) == 1)
    Rot = [cos(alpha), sin(alpha); -sin(alpha), cos(alpha)];
else
    Rot = [cos(alpha), -sin(alpha); sin(alpha), cos(alpha)];
end
relx1colp = Rot*relx1colg';
xcp = relx1colp(1);
zcp = relx1colp(2);
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
Vga = Rot'*[Upa;Wpa];
Vgb = Rot'*[Upb;Wpb];
Ua = Vga(1);
Wa = Vga(2);
Ub = Vgb(1);
Wb = Vgb(2);
U = gamma0*Ua+gamma1*Ub;
W = gamma0*Wa+gamma1*Wb;
VN1 = ez_panel_in_g*Vga;
VN2 = ez_panel_in_g*Vgb;


