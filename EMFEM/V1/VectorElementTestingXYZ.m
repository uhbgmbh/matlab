InterpSpacing = 0.5;
Edges = [1 5 20 1 1 20 5 1 1 20 5 1];
[Ax,Ay,Az,r,s,t,R,S,T] = PlotEdgeElements(Edges,InterpSpacing);
pause;
% curl
[curlx,curly,curlz,cav] = curl(R,S,T,Ax,Ay,Az);
quiver3(R,S,T,curlx,curly,curlz);
pause;
% 2D slice
quiver(R(:,:,1),S(:,:,1),Ax(:,:,1),zeros(size(Ax(:,:,1))));%Ay(:,:,2));
xlabel('X');
ylabel('Y');
pause;
% 2D slice
quiver(R(:,:,1),S(:,:,1),zeros(size(Ay(:,:,1))),Ay(:,:,1));
xlabel('X');
ylabel('Y');
pause;
% 2D slice
quiver(R(:,:,1),S(:,:,1),Ax(:,:,1),Ay(:,:,1));
xlabel('X');
ylabel('Y');
pause;