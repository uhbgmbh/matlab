% 3D Flow over a Sphere

NumPointTheta = 10;
NumPointR = 10;
theta = 0:2*pi/(NumPointTheta-1):2*pi;
R = 1;  % Circle Radius
rMax = 2;
r = R:(rMax-R)/(NumPointR-1):rMax;
Uinf = 1;
q_r = Uinf*cos(theta')*(1 - R^3./(r.^3));
q_theta = -Uinf*sin(theta')*(1+R^3./(2*r.^3));
q = sqrt(q_r.^2+q_theta.^2);
x = cos(theta')*r;
y = sin(theta')*r;
