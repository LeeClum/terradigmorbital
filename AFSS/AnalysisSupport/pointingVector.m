function r = pointingVector(angle,input)
%% tranforms angles to pointing unit vector
% default uses euler (theta,phi,psi) 

if nargin < 2
    input = 'eul';
end

if strcmp(input,'eul')
    
    [~,n] = size(angle);
    r = zeros(3,n);
    for i = 1:n
        theta = angle(1,i);
        phi = angle(2,i);
        psi = angle(3,i);

        Ry= [cos(theta)     0       sin(theta);
                0           1           0;
             -sin(theta)    0      cos(theta)];

        Rx = [  1           0           0;
                0       cos(phi)    -sin(phi);
                0       sin(phi)    cos(phi)];

        Rz = [cos(psi)  -sin(psi)       0;
              sin(psi)  cos(psi)        0;
                0           0           1];

        rvec = Rz*Ry*Rx*[1;1;1];
        r(:,i) = rvec/norm(rvec);
    end
end