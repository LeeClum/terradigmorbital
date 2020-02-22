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
fgc.Cr              =   1.6; % reflectivity constant
% lengths estimated using volume of .53 radius sphere
% side length twice face
fgc.ls              =   1.3562; % m length of side
fgc.lf              =   0.6781; % m length of face
fgc.Cg              =   [0 0]; % center of gravity coord 
fgc.thrustMomentArm =   0.5; % m
fgc.wheelMomentum   =   0.3; % N*m*s
Ix                  =   1/12*fgc.ls*fgc.lf^3;
Iy                  =   1/12*fgc.lf*fgc.ls^3;
Iz                  =   1/12*fgc.lf^4;
fgc.moi             =   [Ix  0    0;
                         0   Iy   0;
                         0   0   Iz]*fgc.mass;
                     
fgc.sma             =   42164000; % m
fgc.ecc             =   0;
fgc.incl            =   0; % rad
fgc.raan            =   0; % rad
fgc.argp            =   0; % rad
fgc.tran            =   0; % rad
%% Depot

depot.mass              =   14766; % kg
depot.Cr                =   1.6; % reflectivity constant
% lengths estimated using volume of 1.19 radius sphere
% side length twice face
depot.ls                =   3.0451; % m length of side
depot.lf                =   1.5225; % m lenfth of face
depot.Cg                =   [0 0]; % center of gravity coord
depot.thrustMomentArm   =   0.5; % m
depot.wheelMomentum     =   0.9; % N*m*s
Ix                      =   1/12*depot.ls*depot.lf^3;
Iy                      =   1/12*depot.lf*depot.ls^3;
Iz                      =   1/12*depot.lf^4;
depot.moi               =   [Ix  0    0;
                             0   Iy   0;
                             0   0   Iz]*depot.mass;
    
depot.sma               =   42164000; % m
depot.ecc               =   0;
depot.incl              =   0; % rad
depot.raan              =   0; % rad
depot.argp              =   0; % rad
depot.tran              =   0; % rad
             
             
             
             
             