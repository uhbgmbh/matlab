% Linear Strength Vortex Element Test
alpha = 0;
gamma0 = 1;
gamma1 = 1;
xc = 1; zc = 1;
C1 = atan2(zc,xc-x2)-atan2(zc,xc-x1);
C2 = log(((xc-x1).^2+zc^2)/((xc-x2).^2+zc^2));
ua = 1/(2*pi)*C1;
ub = 1/(4*pi)*(zc*C2+2*xc*C1);
wa = -1/(4*pi)*C2;
wb = -1/(2*pi)*(xc/2*C2+(x2-x1)+zc*C1);
up = gamma0*ua+gamma1*ub;
wp = gamma0*wa+gamma1*wb;
u = up.*cos(alpha)+wp.*sin(alpha);
w = up.*(-sin(alpha))+wp.*cos(alpha);
