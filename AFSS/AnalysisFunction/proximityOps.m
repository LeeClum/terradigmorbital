clear
close all

%% Parameter Initializition
paramInit % Init mission parameters
targ.sma = 42164000; % m
scenarioDuration = 36*3600; % sec Scenario duration
n = sqrt(earth.mu/targ.sma^3); % mean motion
stepSize = 0.1; % sec State transition step interval
burnAccel = fgc.thrust/fgc.mass*fgc.pulseWidth; % m/s^2 Min acceleration achievable
burnMax = fgc.thrustCount*fgc.thrust/fgc.mass*stepSize; % m/s^2 Max acceleration
captureDist = 3; % m Distance to start hold maneuver
maxTargetAngle = 10*pi/180; % 1 deg max allowable deviation from target trajectory
maxHoldDrift = 0.01; % 0.1 m max allowable drift from capture hold position
Kp = 10; % Proportional distance to target gain used for transfer
Kp_h = 1; % Porportional distance to hold position used for hold maneuver

%% Variable Initialization
dockingRange = false;
thrustCycle = [0 0 0]; % trajectory maneuver, drift hold correction, total cycles
exitSafetyEllipse = false;
i = 0; % Index Variable
ii = 0; % Index Variable
transferDV = 0;
holdDV = 0;
Xfgc = zeros(7,scenarioDuration+1);

%% Initial State
xmax = 50; % m 
ycdot = 0; % secular drift: 0 stable safety ellipse orbit
ydot = ycdot -2*xmax*n; % m/s
% for 45 deg safety ellipse zdot = ydot 
Xfgc_n = [xmax;0;0;0;ydot;ydot];

%% State transition
for elapsedSec = 0:stepSize:scenarioDuration
    i = i+1;
    
    % Build HCW State Transition Matrices
    
    t = stepSize;
    s = sin(n*t);
    c = cos(n*t);

    Phi_rr = [4-3*c         0           0;
              6*(s-n*t)     1           0;
              0             0           c];
    Phi_rv = [s/n           2/n*(1-c)   0;
              -2/n*(1-c)    4*s/n-3*t   0;
              0             0           s/n];
    Phi_vr = [3*n*s         0           0;
              -6*n*(1-c)    0           0;
              0             0           -n*s];
    Phi_vv = [c             2*s         0;
              -2*s          4*c-3       0;
              0             0           c];

    Phi = [Phi_rr Phi_rv;
           Phi_vr Phi_vv];
    
    % Check if within capture distance 
    dist2target = norm(Xfgc_n(1:3));
    posError = dist2target;
    if ((dist2target < captureDist) && (~dockingRange) && (mod(elapsedSec,1) == 0))
        dockingRange = true;
        % Set hold positional values
        xHold = Xfgc_n;
        % Timestamp hold maneuver & index 
        time_hold = [elapsedSec i] ;
    end
    
    % Initial burn to exit Safety Ellipse
    
    if ((elapsedSec > 24*3600) && (~exitSafetyEllipse))
        % Determine burn vector
        captureUnitVector = -Xfgc_n(1:3)/norm(Xfgc_n);
        targetUnitVector = captureUnitVector;
        burnDirection = captureUnitVector-Xfgc_n(4:6);
        burnMag = min([Kp*burnAccel*posError burnMax]); 
        burnVector = burnMag*burnDirection;
        Xfgc_n = [Xfgc_n(1:3);burnVector];
        % Count thrust cycles
        thrustCycle(1) = thrustCycle(1) + 1;
        thrustCycle(3) = thrustCycle(3) + 1;
        % Burn position & timestamp for plotting
        burnPos(:,thrustCycle(1)) = [Xfgc_n(1:3); elapsedSec];
        % Delta V calculation
        transferDV = transferDV + norm(burnVector);
        % Set Safety Ellipse Exit flag
        exitSafetyEllipse = true;        
    end
        
    % Adjust capture trajectory to target vector angle exceeds tolerance
    if ((exitSafetyEllipse) && (~dockingRange) && (mod(elapsedSec,1) == 0))
        captureUnitVector = -Xfgc_n(1:3)/norm(Xfgc_n);
        deviationAngle = acos(dot(captureUnitVector,targetUnitVector));
        if deviationAngle > maxTargetAngle
            targetUnitVector = captureUnitVector;
            burnDirection = captureUnitVector-Xfgc_n(4:6);
            burnMag = min([Kp*burnAccel*posError burnMax]); 
            burnVector = burnMag*burnDirection;
            Xfgc_n = [Xfgc_n(1:3);burnVector];
            % Count thrust cycles
            thrustCycle(1) = thrustCycle(1) + 1;
            thrustCycle(3) = thrustCycle(3) + 1;
            % Burn position & timestamp for plotting
            burnPos(:,thrustCycle(1)) = [Xfgc_n(1:3); elapsedSec];
            % Delta V calculation
            transferDV = transferDV + norm(burnVector);
        end   
    end
    
    % Burn to hold position if drift more than 0.1 m
    if dockingRange
    holdDist = norm(xHold(1:3)-Xfgc_n(1:3));
        if ((holdDist > maxHoldDrift) && (mod(elapsedSec,1) == 0))
            holdVector = (xHold(1:3)-Xfgc_n(1:3))/holdDist;
            burnDirection = holdVector-Xfgc_n(4:6);
            burnMinCheck = max([Kp*burnAccel*holdDist burnAccel]);
            burnMag = min([burnMinCheck burnMax]); 
            burnVector = burnMag*burnDirection;
            Xfgc_n = [Xfgc_n(1:3);burnVector];
            % Count thrust cycles
            thrustCycle(2) = thrustCycle(2) + 1;
            thrustCycle(3) = thrustCycle(3) + 1;
            % Delta V calculation
            holdDV = holdDV + norm(burnVector);
        end
    end
    
    
    Xfgc(:,i) = [Phi*Xfgc_n; elapsedSec];
    Xfgc_n = Xfgc(1:6,i);
    
end

%% Analysis
holdDuration = scenarioDuration - time_hold(1);
thrustCyclePeriod = holdDuration/thrustCycle(2);

%% Plot Rendezvous
figure(1)
[x,y,z] = sphere;
a = [0 0 0 1];
s1 = surf(x*a(1,4)+a(1,1), y*a(1,4)+a(1,2), z*a(1,4)+a(1,3));
hold on
axis equal
plot3(Xfgc(1,:),Xfgc(2,:),Xfgc(3,:))
for j = 1:thrustCycle(1)
    plot3(burnPos(1,j),burnPos(2,j),burnPos(3,j),'.','MarkerSize',5,'Color','r')
end
plot3([0 0],[-100 100],[0 0],'Color','k')
rotate3d on
grid on
title('Orbital Path')
xlabel('X Coord (m)')
ylabel('Y Coord (m)')
zlabel('Z Coord (m)')
set(findall(gcf,'-property','FontSize'),'FontSize',14)

%% Plot Maneuver Drift
Xdrift = Xfgc(1:6,time_hold(2):end);
for i = 0:stepSize:holdDuration 
    ii = ii+1;
    XdriftMag(:,ii) = norm(Xdrift(1:6,ii))-captureDist;
end
figure(2)
plot((0:stepSize:holdDuration),XdriftMag);

       
       
   