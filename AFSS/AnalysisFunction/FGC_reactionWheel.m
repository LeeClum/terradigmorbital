% Determine FGC Reaction wheel sizing
ACS_Analysis

% Reaction wheel design
% 4 reaction wheels (pair for x and y axis) 15 deg angular offset alpha to there respective axis
alpha = 15; % deg axis angular offset
% all 4 at some tilt angle beta from z axis

syms betas

eq = (Tmax_fgc*cosd(alpha) + Tmax_fgc*cosd(alpha)*sind(alpha))*cosd(betas)/2 == sind(betas)*Tmax_fgc/4;
beta = double(vpasolve(eq,betas));

torqueXY = (Tmax_fgc*cosd(alpha) + Tmax_fgc*cosd(alpha)*sind(alpha))*cosd(beta)/2;
torqueZ = sind(beta)*Tmax_fgc/4;




