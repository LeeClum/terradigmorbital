%% Parameter Init File
earth.mu = 3.986004415E+14; % m^3/s^2
earth.Fs = 1358; % Solar Constant W/m^2
c  = 3E8; % speed of light m/s
earth.MM = 7.96E+15; % earth magnetic moment tesla*m^3


%% Servicer
fgc.thrust          =   20; % N
fgc.thrustCount     =   2; % number of thruster
fgc.pulseWidth      =   0.001; % sec
fgc.mass            =   1004.7; % kg
fgc.moi             =   [112.89  0   0;
                         0  112.89   0;
                         0  0   112.89];
fgc.Cr              =   1.6; % reflectivity constant
fgc.ls              =   0.53; % m length of side
fgc.lf              =   0.53; % m length of face
fgc.Cg              =   [0 0]; % center of gravity coord 
fgc.Cps             =   [0.1 0]; % location of center of solar pressure
fgc.thrustMomentArm =   0.5; % m
fgc.wheelMomentum   =   0.3; % N*m*s

fgc.sma             =   42164000; % m
fgc.ecc             =   0;
fgc.incl            =   0; % rad
fgc.raan            =   0; % rad
fgc.argp            =   0; % rad
fgc.tran            =   0; % rad
%% Depot

depot.mass              =   0;
depot.moi               =   [23000  0       0;
                             0      23000   0;
                             0      0       23000];
depot.Cr                =   1.6; % reflectivity constant
depot.ls                =   1.19; % m length of side
depot.lf                =   1.19; % m lenfth of face
depot.Cg                =   [0 0]; % center of gravity coord
depot.Cps               =   [0.1 0]; % location of center of solar pressure
depot.thrustMomentArm   =   0.5; % m
depot.wheelMomentum     =   0.9; % N*m*s
    
depot.sma               =   42164000; % m
depot.ecc               =   0;
depot.incl              =   0; % rad
depot.raan              =   0; % rad
depot.argp              =   0; % rad
depot.tran              =   0; % rad
             
             
             
             
             