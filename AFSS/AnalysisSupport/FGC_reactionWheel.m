% Determine FGC Reaction wheel sizing
ACS_Analysis

% Reaction wheel design
% 4 reaction wheels (pair for x and y axis) angular offset alpha to there respective axis
alpha = 0; % deg axis angular offset
% all 4 at some tilt angle beta from xy plane

% Determine optimal beta angle for reaction wheels
syms betas
eq = (Tmax_fgc*cosd(alpha) + Tmax_fgc*cosd(alpha)*sind(alpha))*cosd(betas)/2 == sind(betas)*Tmax_fgc/4;
beta = double(vpasolve(eq,betas));

% torque required per reaciton wheel (torqueXY should = torqueZ)
torqueXY = (Tmax_fgc*cosd(alpha) + Tmax_fgc*cosd(alpha)*sind(alpha))*cosd(beta)/2;
torqueZ = sind(beta)*Tmax_fgc/4;

% Determine momentum storage needed for reaction wheel
daysBetweenDesaturation = 14; % momentum dumping every 2 weeks
FOS = 1.5;
momentumStorage = Hw_fgc*daysBetweenDesaturation*FOS/4;
fprintf('\n\n---------------------------------\n')
fprintf('FGC Pyramidal 4 Reacion Wheels\n')
fprintf('---------------------------------\n')
fprintf('Beta Tilt angle:\t%.1f\t\t[deg]\n',beta)
fprintf('Torque Per wheel:\t%.2E\t[N*m]\n',torqueXY)
fprintf('Storage Per Wheel:\t%.2E\t[N*m*s]\n',momentumStorage)

