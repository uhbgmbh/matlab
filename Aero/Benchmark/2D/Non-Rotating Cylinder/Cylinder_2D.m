% Non-Rotating Cylinder Test Script (2D Flow Visualization)
%  - benchmark for panel code validation
% Lawrence Stratton
% 1/29/2014

% Problem Parameters

R = 1;                              % Cylinder radius
Uinf = 1;                           % Freestream velocity
mu = 2*pi*Uinf*R^2;                 % Doublet strength
CylStreamFunction = @(r,theta) ...  % StreamFunction
    Uinf.*r.*sin(theta)-mu/(2*pi).*sin(theta)./r;

% Graphing Parameters

hAxis = 3.0;    % Axes scaling
axisMax = R;    % Max axes length
NumVec = 20;    % Number of vectors
hVec = 0.25;    % Vector scaling


% Map x,y region
x = -hAxis*R:0.25:hAxis*R;
y = -hAxis*R:0.25:hAxis*R;
[X,Y] = meshgrid(x,y);

% Convert to polar coordinates
r = sqrt(X.^2+Y.^2);
theta = atan2(Y,X);

% Map theta from [-pi,pi] to [0,2pi]
theta(theta < 0) = theta(theta < 0) + 2*pi; 

% Remove points interior to the cylinder and set interior region to 1
index = r <= 1.0;
r(index) = 1;

% Calculate Velocity Field
qr = Uinf*cos(theta).*(1-R^2./r.^2);        % Radial velocity
qtheta = -Uinf*sin(theta).*(1+R^2./r.^2);   % Tangential velocity
q = sqrt(qr.^2+qtheta.^2);                  % Total velocity

% Freestream Display Vectors
Uinf = ones(NumVec+1,1)*hVec;
Winf = zeros(NumVec+1,1);
Xinf = (-hAxis*axisMax+0.5)*ones(NumVec+1,1);
Zinf = ((-hAxis*axisMax)*0.5:(hAxis*axisMax)/NumVec:0.5*(hAxis*axisMax))';

% Stagnation Streamline
StagnationPoint = R;
thetaStag = 0:2*pi/20:2*pi;
rStag = R*ones(size(thetaStag));
xStag = rStag.*cos(thetaStag);
zStag = rStag.*sin(thetaStag);

% Cp Calculation
thetaCp = 0:pi/40:pi;
CpUpper = 1 - 4*sin(thetaCp).^2;
CpLower = 1 - 4*sin(-thetaCp).^2;

%%
% Plotting

% Plot StreamFunction Contours
C = CylStreamFunction(r,theta);
[csContour,hContour] = contourf(C,20);
colorbar;
clabel(csContour,hContour);
title('Streamlines');

% Plot Velocity Field
figure; hold on;
quiver(X,Y,...
    qr.*cos(theta)+qtheta.*-sin(theta),...
    qr.*sin(theta)+qtheta.*cos(theta),...
    'b');
axis square
axis([-hAxis*axisMax hAxis*axisMax -hAxis*axisMax hAxis*axisMax])
% Plot Freestream Vectors
hinf = quiver(Xinf,Zinf,Uinf,Winf,0,'k');   
% Plot Stagnation points
hstag = plot([-StagnationPoint; StagnationPoint],[0;0],'ro','LineWidth',2);
% Plot Stagnation Streamline
hstagstrm = plot(xStag,zStag,'k','LineWidth',1.5);
legend(...
    [hinf hstag hstagstrm],...
    {'Freestream',...
    'Stagnation Points',...
    'Stagnation Streamline'});
title('Non-Rotating Cylinder');

figure; hold on;
plot(thetaCp*180/pi,CpUpper,'k-.');
plot(-thetaCp*180/pi,CpLower,'k^');
legend('C_p Upper',...
    'C_p Lower',...
    'Location','EastOutside');
title('C_p at locations along Cylinder Surface');

figure; hold on;
plot(thetaCp*180/pi,1-CpUpper,'k-.');
plot(-thetaCp*180/pi,1-CpLower,'k^');
legend('q / U_i_n_f Upper',...
    'q / U_i_n_f Lower',...
    'Location','EastOutside');
title('q / U_i_n_f at locations along Cylinder Surface');
