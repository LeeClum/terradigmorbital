function exportEphemeris(filetype,X,filename)
% Input
% X [7x:] [X Y Z Xdot Ydot Zdot timeStamp]
fileID = fopen([filename '.txt'],'w');
[~,m] = size(X);
if strcmp(filetype,'stk')
    % Write ephemeris to inertial frame in STK format
    stkVersion = 'stk.v.11.0';
    InterpolationMethod = 'Lagrange';
    centralBody = 'Earth';
    coordSystem = 'ICRF';
    timeFormat = 'EpSec';

    % Header
    fprintf(fileID,'%s\n\n',stkVersion);
    fprintf(fileID,'# Written By\tMatlab\n\n');

    % Scenario Init
    fprintf(fileID,'BEGIN Ephemeris\n\n');
    fprintf(fileID,'\tNumberOfEphemerisPoints\t%d\n\n',m);
    fprintf(fileID,'\tInterpolationMethod\t%s\n\n',InterpolationMethod);
    fprintf(fileID,'\tCentralBody\t%s\n\n',centralBody);
    fprintf(fileID,'\tCoordinateSystem\t%s\n\n',coordSystem);
    fprintf(fileID,'\tTimeFormat\t%s\n\n',timeFormat);
    fprintf(fileID,'\tEphemerisTimePosVel\n\n');

    % Ephemeris Data

    for i = 1:m
        fprintf(fileID,'%0.16E %0.16E %0.16E %0.16E %0.16E %0.16E %0.16E\n',...
            X(7,i),X(1,i),X(2,i),X(3,i),X(4,i),X(5,i),X(6,i));
    end

    fprintf(fileID,'\nEND Ephemeris\n');

    fclose(fileID);
end

if strcmp(filetype,'ff')
    fprintf(fileID,'HEADER_START\n');
    fprintf(fileID,'FreeFlyer 7.5 Ephemeris\n');
    fprintf(fileID,'FormatVersion = 3\n');
    fprintf(fileID,'Spacecraft = "Spacecraft1"\n');
    fprintf(fileID,'StartTime = 2492596837.000000000 TAI GSFC MJD (Jan 01 2020 00:00:00.000000000 UTC)\n');
    fprintf(fileID,'StopTime = 2492726437.000000000 TAI GSFC MJD (Jan 02 2020 12:00:00.000000000 UTC)\n');
    fprintf(fileID,'CentralBody = Earth\n');
    fprintf(fileID,'ReferenceFrame = Mean of J2000\n');
    fprintf(fileID,'PrincipalPlane = Equatorial\n');
    fprintf(fileID,'ColumnDelimiter = " "\n');
    fprintf(fileID,'DiscontinuityDelimiter = "|"\n');
    fprintf(fileID,'Project = Servicer.MissionPlan\n');
    fprintf(fileID,'FileCreationDate = Feb 20 2020 00:00:00.000 UTC\n');
    fprintf(fileID,'HEADER_END\n\n');
    fprintf(fileID,'TITLE_START\n');
    fprintf(fileID,'COLUMN_LABELS = "ElapsedTime" "X" "Y" "Z" "VX" "VY" "VZ"\n');
    fprintf(fileID,'COLUMN_UNIT_LABELS = "s" "km" "km" "km" "km/s" "km/s" "km/s"\n');
    fprintf(fileID,'SPACECRAFT_PROPERTIES = ElapsedTime X Y Z VX VY VZ\n');
    fprintf(fileID,'COLUMN_INTERPOLATORS = "Independent Variable" "5th Order Spline" "5th Order Spline" "5th Order Spline" "5th Order Spline" "5th Order Spline" "5th Order Spline"\n');
    fprintf(fileID,'COLUMN_TYPES = TimeSpan Variable Variable Variable Variable Variable Variable\n');
    fprintf(fileID,'TITLE_END\n\n');
    fprintf(fileID,'DATA_START\n');
    
    for i = 1:m
        fprintf(fileID,'%0.9f %0.17e %0.17e %0.17e %0.17e %0.17e %0.17e\n'...
            ,X(7,i),X(1,i)/1000,X(2,i)/1000,X(3,i)/1000,X(4,i)/1000,X(5,i)/1000,X(6,i))/1000;
    end
    fprintf(fileID,'DATA_END\n');
    
    fclose(fileID);
    
end      
end

