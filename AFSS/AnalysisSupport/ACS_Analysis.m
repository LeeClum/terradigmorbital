%% S/c and Orbit Parameters
clearvars
paramInit

%% Gravity Gradient
moi_min = min([fgc.moi(1,1) fgc.moi(2,2)]);
Tg_fgc = 3*earth.mu/2/fgc.sma^3*abs(fgc.moi(3,3)-moi_min)*sin(2*pi/2); % maximum at 90 deg offset

moi_min = min([depot.moi(1,1) depot.moi(2,2)]);
Tg_depot = 3*earth.mu/2/depot.sma^3*abs(depot.moi(3,3)-moi_min)*sind(2*1); % 1 deg offset from z

%% Solar Radiation
Tsp_fgc = earth.Fs/c*fgc.ls^2*fgc.Cr*cos(0)*abs(norm(fgc.Cg)-norm(fgc.Cps));
Tsp_depot = earth.Fs/c*depot.ls^2*depot.Cr*cos(0)*abs(norm(depot.Cg)-norm(depot.Cps));

%% Magnetic Field
D = 20; % this is a placeholder for the residual dipole of vehicle in A*m^2
Tm_fgc = D*earth.MM/fgc.sma^3;
Tm_depot = D*earth.MM/depot.sma^3;

%% Aerodynamics
% Orbit altitude large enough to disregard aerodynamic torque

%% Slew Rates
earthPointing = 2*pi/24/3600; % rad/sec
targetMatching = 1*pi/180; % rad/sec max spin rate of target s/c
rendezvousManeuver = pi/2/2830; % (assume worst case 45 deg slew towards burn vector in min time between burn form ProxOps 28030 sec) 
sunAcquisition = pi/2/600; % rad/sec (assume worst case 45 deg slew to solar array sun vector normal in 10 min)

%% Slew Torques
moi_max = max([fgc.moi(1,1),fgc.moi(2,2),fgc.moi(3,3)]);
Tsr_fgc = 4*45*pi/180*moi_max/600^2;
moi_max = max([depot.moi(1,1),depot.moi(2,2),depot.moi(3,3)]);
Tsr_depot = 4*45*pi/180*moi_max/600^2;

%% Max Disturbance
TD_fgc = max([Tg_fgc,Tsp_fgc,Tm_fgc]);
TD_depot = max([Tg_depot,Tsp_depot,Tm_depot]);

%% Max Torques
Tmax_fgc = max([TD_fgc,Tsr_fgc]);
Tmax_depot = max([TD_depot,Tsr_depot]);

%% Max Slew Rate
Sr_fgc = max([earthPointing,targetMatching,sunAcquisition]);
Sr_depot = max([earthPointing,sunAcquisition]);

%% Max Momentum Storage in Reaction Wheels
% gravity gradient
Hw_fgc_g = Tg_fgc*2*pi*sqrt(fgc.sma^3/earth.mu)/4*0.637;
Hw_depot_g = Tg_depot*2*pi*sqrt(depot.sma^3/earth.mu)/4*0.637;
% solar radiation pressure (derivation for 1 orbit)
Hw_fgc_srp = earth.Fs/c*fgc.Cr*fgc.lf*fgc.lf^2*(23/24*pi+0.517)*sqrt(earth.mu/fgc.sma^3);
Hw_depot_srp = earth.Fs/c*depot.Cr*depot.lf*depot.lf^2*(23/24*pi+0.517)*sqrt(earth.mu/depot.sma^3);
% determine max
Hw_fgc = Hw_fgc_g + Hw_fgc_srp;
Hw_depot = Hw_depot_g + Hw_depot_srp;

%% Force Required for Momentum Dumping
thrustForce_fgc = fgc.wheelMomentum/fgc.thrustMomentArm; % N*s
thrustForce_depot = depot.wheelMomentum/depot.thrustMomentArm; % N*s

fprintf('\nGravity Gradient\t[N*m]\n')
fprintf('-------------------------------\n')
fprintf('FGC:\t%0.3E\nDepot\t%0.3E\n',Tg_fgc,Tg_depot)
fprintf('\nSolar Radiation\t\t[N*m]\n')
fprintf('-------------------------------\n')
fprintf('FGC:\t%0.3E\nDepot\t%0.3E\n',Tsp_fgc,Tsp_depot)
fprintf('\nMagnetic Field\t\t[N*m]\n')
fprintf('-------------------------------\n')
fprintf('FGC:\t%0.3E\nDepot\t%0.3E\n',Tm_fgc,Tm_depot)
fprintf('\nAerodynamics\t\t[N*m]\n')
fprintf('-------------------------------\n')
fprintf('Orbit altitude large enough to disregard aerodynamic torque\n')
fprintf('\nSlew Rates\t\t\t[deg/sec]\n')
fprintf('-------------------------------\n')
fprintf('FGC:\n\tEarth Pointing:\t\t%0.3E\n\tTarget Spin match:\t%0.3E\n\tRendezvous Burn\t\t%0.3E\n\tSun Acquisition:\t%0.3E\n'...
    ,earthPointing*180/pi,targetMatching*180/pi,rendezvousManeuver*180/pi,sunAcquisition*180/pi)
fprintf('Depot:\n\tEarth Pointing:\t\t%0.3E\n\tSun Acquisition:\t%0.3E\n'...
    ,earthPointing*180/pi,sunAcquisition*180/pi)
fprintf('\nMomentum Storage\t[N*m*s]\n')
fprintf('Per Orbit\n')
fprintf('-------------------------------\n')
fprintf('FGC:\t%0.3E\nDepot:\t%0.3E\n',Hw_fgc,Hw_depot)
fprintf('\nMax Torques\t\t\t[N*m]\n')
fprintf('-------------------------------\n')
fprintf('FGC:\t%0.3E\nDepot:\t%0.3E\n',Tmax_fgc,Tmax_depot)
fprintf('\nThrust Force\t\t[N*s]\n')
fprintf('Momentum Dumping\n')
fprintf('-------------------------------\n')
fprintf('FGC:\t%0.3E\nDepot:\t%0.3E\n',thrustForce_fgc,thrustForce_depot)

