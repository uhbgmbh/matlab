function [U,L] = NACA4Series(A,B,CD,numChordPoints,PlotSwitch)
% NACA ABCD Airfoil Input:
%   A - max value of the mean line ordinate Yc in percent of chord
%   B - distance from the leading edge to the location of the maximum
%   camber in tenths of the chord
%   CD - the section thickness in % of the chord
%
%   Output:
%       U - Airfoil upper surface coordinates
%       L - Airfoil lower surface coordinates

% Create camber points

LocMaxCamber = B/10; % Should be between 0 and 9 and an integer
SectionThickness = CD/10/2;
m = A/100; p = B/10;

% Create chord x locations
NumChordPointsForward = floor(LocMaxCamber*numChordPoints);
NumChordPointsAft = numChordPoints - NumChordPointsForward;
xfor = 0:LocMaxCamber/(NumChordPointsForward-1):LocMaxCamber;
xaft = LocMaxCamber:(1-LocMaxCamber)/(NumChordPointsAft-1):1;

% Create camber line ordinates
ycfor = m/p^2*(2*p*xfor-xfor.^2);
ycaft = m/(1-p)^2*(1-2*p+2*p*xaft-xaft.^2);
thetaFor = atan2(ycfor,xfor);
thetaAft = atan2(ycaft,xaft);

% Create section thickness ordinates
ytfor = SectionThickness*...
    (0.29690*sqrt(xfor)-0.126*xfor-...
    0.35160*xfor.^2+0.28430*xfor.^3-0.10150*xfor.^4);
ytaft = SectionThickness*...
    (0.29690*sqrt(xaft)-0.126*xaft-...
    0.35160*xaft.^2+0.28430*xaft.^3-0.10150*xaft.^4);

% Create upper surface coordinates
XUfor = xfor - ytfor.*sin(thetaFor);
XUaft = xaft - ytaft.*sin(thetaAft);
YUfor = ycfor + ytfor.*cos(thetaFor);
YUaft = ycaft + ytaft.*cos(thetaAft);

% Create lower surface coordinates
XLfor = xfor + ytfor.*sin(thetaFor);
XLaft = xaft + ytaft.*sin(thetaAft);
YLfor = ycfor - ytfor.*cos(thetaFor);
YLaft = ycaft - ytaft.*cos(thetaAft);

% Plot airfoil is PlotSwitch == 1
if (PlotSwitch == 1)
    figure;
    hold on;
    axis([-0.1 1.1 -0.6 0.6]);
    grid on;
    plot([xfor,xaft],[ycfor,ycaft],'k');
    plot([XUfor,XUaft],[YUfor,YUaft],'r');
    plot([XLfor,XLaft],[YLfor,YLaft],'b');
    if (CD < 10)
        title(['NACA' num2str(A) num2str(B) '0' num2str(CD)]);
    else
        title(['NACA' num2str(A) num2str(B) num2str(CD)]);
    end
    xlabel('x/c'); ylabel('y/c');
    legend('Camber Line','Upper Surface','Lower Surface');
end

U = [[XUfor,XUaft]';[YUfor,YUaft]'];
L = [[XLfor,XLaft]';[YLfor,YLaft]'];
