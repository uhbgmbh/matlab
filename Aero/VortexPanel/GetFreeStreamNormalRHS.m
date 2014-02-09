function [RHSval] = ...
    GetFreeStreamNormalRHS(x1,z1,x2,z2,Qinf,alphainf)
PanelLength = sqrt((x1-x2).^2+(z1-z2).^2);
ex_panel_in_g = [x2-x1,z2-z1]/PanelLength;
ex_global = [1,0];
alpha = atan2(z2-z1,x2-x1);
ez_panel_in_g = [-sin(alpha),cos(alpha)]
Uinf = Qinf*cos(alphainf);
Winf = Qinf*sin(alphainf);
RHSval = -[Uinf,Winf]*ez_panel_in_g';