function [Xt_ijk,Xc_ijk,Xc_rel_ric] = chaserTargetIJK(Xc_ric)
% Input
% X_ric [7x:] [r i c rdot idot cdot timeStamp]
% Output
% Xt_ijk [7x:] target s/c in ijk 
% Xc_ijk [7x:] chaser s/c in ijk
% Xc_ric [7x:] chaser in 

% Initialize parameters
tolerance = 1e-13;
options = odeset('RelTol',tolerance,'AbsTol',tolerance);
mu = 3.986004415E+14; % m^3/s^2
Xt_kepel.sma = 42164000; % m
Xt_kepel.ecc = 0;
Xt_kepel.incl = 0;
Xt_kepel.raan = 0;
Xt_kepel.argp = 0;
Xt_kepel.tran = 0;

Xt0_ijk = kep2cart(Xt_kepel);

j = 0;

%% Initial state of target at t=0
Xt_ijk(1:7,1) = [Xt0_ijk; 0];

%% Initial state of chaser at t=0
RIC_IJK = dcm('ric',Xt_ijk(1:3,1),Xt_ijk(4:6));
xcijk = blkdiag(RIC_IJK,RIC_IJK)'*Xc_ric(1:6,1);
Xc_ijk(:,1) = [xcijk; Xc_ric(7,1)];

%% Propagate Target to find Ephemeris at each time stamp

trange = [0 10];
[~,m] = size(Xc_ric);

for i = 1:m
    if mod(Xc_ric(7,i),trange(2)) == 0
        j = j+1;
        [~,Xtn] = ode45(@propagate_2BP, trange, [Xt_ijk(1:3,end) Xt_ijk(4:6,end)], options, mu);
        Xtn = [Xtn(end,:)'; Xc_ric(7,i)];
        Xt_ijk(:,j) = Xtn;

        RIC_IJK = dcm('ric',Xt_ijk(1:3,j),Xt_ijk(4:6,j));
        Xtric = blkdiag(RIC_IJK,RIC_IJK)*Xt_ijk(1:6,j);
        Xcric = Xtric + Xc_ric(1:6,i);
        xcijk = blkdiag(RIC_IJK,RIC_IJK)'*Xcric;
        Xc_ijk(:,j) = [xcijk; Xc_ric(7,i)];
        Xrelric = Xt_ijk(1:6,j)+Xc_ric(1:6,i);
        Xc_rel_ric(:,j) = [Xrelric; Xc_ric(7,i)];
        
        if mod(j,1000) == 0
            fprintf('\nPropagationTime: %d',j)
        end
    end

end
fprintf('\n')
end


function Pdot = propagate_2BP(t,P,mu)
% P = [x position, y position, z position, xvel, yvel, zvel]
% r = radial distance
r = sqrt(P(1)^2 + P(2)^2 + P(3)^2);

Pdot(1,1) = P(4);
Pdot(2,1) = P(5);
Pdot(3,1) = P(6);
Pdot(4,1) = -(mu/r^3)*P(1);
Pdot(5,1) = -(mu/r^3)*P(2);
Pdot(6,1) = -(mu/r^3)*P(3);
end