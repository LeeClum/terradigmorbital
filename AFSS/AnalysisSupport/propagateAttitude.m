clearvars
close all
paramInit

n = sqrt(earth.mu/fgc.sma^3); % mean motion
moi = [fgc.moi(1,1), fgc.moi(2,2), fgc.moi(3,3)];

tolerance = 1e-13;
options = odeset('RelTol',tolerance,'AbsTol',tolerance);

trange = [0 60];
x = [0.00001; 0; 0; pi/100; 0; 0];
T = [0.001 0 0.001];

%% Propagate Attitude Dynamics
[tout,att] = ode45(@SatAttDyn, trange, x, options, moi, T);
att = att';
[~,n] = size(att);


for i = 1:n
    theta = att(1,i);
    phi = att(2,i);
    psi = att(3,i);
    
    Ry= [cos(theta)     0       sin(theta);
            0           1           0;
         -sin(theta)    0      cos(theta)];

    Rx = [  1           0           0;
            0       cos(phi)    -sin(phi);
            0       sin(phi)    cos(phi)];

    Rz = [cos(psi)  -sin(psi)       0;
          sin(psi)  cos(psi)        0;
            0           0           1];
        
    rvec = Rz*Ry*Rz*att(1:3,i);
    r(:,i) = rvec/norm(rvec);
end

figure(1)
hold on
rotate3d on
% axis equal
grid on
plot3(0,0,0,'.','MarkerSize',5,'Color','k')
plot3(r(1,:),r(2,:),r(3,:))
plot3(r(1,1),r(2,1),r(3,1),'.','Color','b')
plot3(r(1,end),r(2,end),r(3,end),'.','Color','r')
title('Satellite Attitude')
xlabel('X')
ylabel('Y')
zlabel('Z')






