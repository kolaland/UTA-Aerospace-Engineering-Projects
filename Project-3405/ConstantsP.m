function C = ConstantsP

    C.T.UTC = [2022, 12, 2, 17, 37, 27];
    %[year,month,day,hour, minute,second]Coordinated universal time at launch.

    C.T.JDo = juliandate(datetime(C.T.UTC));
    %[solar days]Julian date at takeoff.

    %-----------------------------------------------------------------------------------------------

    C.E.mu = 398600.44;
    %[km^3/s^2]Gravitational parameter of the Earth.

    C.E.Re = 6378.137;
    %[km]Mean equatorial radius of the Earth.

    C.E.we = 2 * pi / 86164.1;
    %[rad/s]Rotational speed of the Earth.

    C.E.g = 9.81 / 1000;
    %[km/s^2]Mean acceleration due to gravity.

    %-----------------------------------------------------------------------------------------------

    C.GS.phi = (32 + 44 / 60 + 52 / 3600) * pi / 180;
    %[rad]Ground station latitude.

    C.GS.lambda = -(97 + 5 / 60 + 34 / 3600) * pi / 180;
    %[rad]Ground station longitude.

    C.GS.hgs = 0.185;
    %[km]Ground station altitude above mean equator.

    C.GS.Azimuth = 107 * pi / 180;
    %[rad]Projectile's Local Horizontal Yaw angle WRT to the ground station.

    C.GS.Elevation = 45 * pi / 180;
    %[rad]Projectile's Local Horizontal Pitch angle WRT to the ground station.

    C.GS.Bank = 0;
    %[rad]Projectile's Local Horizontal Roll angle WRT to the ground station.

    C.GS.We = C.E.we * [cos(C.GS.phi); 0; -sin(C.GS.phi)];
    %[rad/s]Rotational velocity of the Earth in NED coordinates.

    C.GS.Rgse = (C.E.Re + C.GS.hgs) * [0; 0; -1];
    %[km]Ground station position WRT the Earth in NED coordinates.

    C.GS.Vgse = C.E.we * (C.E.Re + C.GS.hgs) * cos(C.GS.phi) * [0; 1; 0];
    %[km/s]Ground station velocity WRT the Earth in NED coordinates.

    C.GS.Agse = cross(C.GS.We,cross(C.GS.We,C.GS.Rgse));
    %[km/s^2]Ground station acceleration WRT the Earth in NED coordinates.

    C.GS.EcefToNed = Ecef2Ned(C.GS.phi,C.GS.lambda);
    %[]Matrix that transforms vectors from ECEF coordinates to NED coordinates.

    C.GS.NedToEcef = transpose(C.GS.EcefToNed);
    %[]Matrix that transforms vectors from NED coordinates to ECEF coordinates.

    %-----------------------------------------------------------------------------------------------

    C.P.mcg = 35;
    %[kg]Projectile mass.

    C.P.vcggs = 0.827;
    %[km/s]Projectile speed WRT the ground station at launch.

    C.P.Cl = 0.173;
    %[-]Projectile Lift coefficient.

    C.P.Cd = 0.820;
    %[-]Projectile drag coefficient.  

    C.P.area = 6006.25 * pi * 1E-12;
    %[km^2]Projectile's Reference area. 

    C.P.Ixx = 0.063065625 * 1E-6;
    %[kg-km^2]Projectile's x-inertia. 

    C.P.Iyy = 1.3440328125 * 1E-6;
    %[kg-km^2]Projectile's y-inertia. 

    C.P.Izz = 1.3440328125 * 1E-6;
    %[kg-km^2]Projectile's z-inertia.

    C.P.Ixz = 0;
    C.P.Iyz = 0;
    C.P.Ixy = 0;
    %[kg-km^2]Porjectile's product of ineritas. 

    C.P.Icg = [...
        C.P.Ixx C.P.Ixy C.P.Ixz; ...
        C.P.Ixy C.P.Iyy C.P.Iyz; ...
        C.P.Ixz C.P.Iyz C.P.Izz];
    %[kg-km^2]Projectile's inertia tensor WRT center of gravity. 

    C.P.IcgInv = C.P.Icg \ eye(3,3);
    %[kg-km^2]Redundant inversion of a matrix. 

    C.P.Rcpcg = [1; 0; 0] * 1E-6;
    %[km]The position of the center of pressure WRT to the center of gravity. 

%%
%[]PROJECTILE STATE WITH RESPECT TO THE GROUND STATION IN NED COORDINATES:

    C.P.Rcggs = zeros(3,1);
    %[km]Projectile position WRT the ground station in NED coordinates at launch.
    
    C.P.Vcggs = C.P.vcggs * [ ...
        cos(C.GS.Elevation) * cos(C.GS.Azimuth); ...
        cos(C.GS.Elevation) * sin(C.GS.Azimuth); ...
                        -sin(C.GS.Elevation)];
    %[km/s]Projectile velocity WRT the ground station in NED coordinates at launch.
    
    C.P.Wcg = zeros(3,1);
    %[rad/s]Projectile's rotational velcoity in BODY coordinates. 

%% 
%[]INITIAL QUATERNION:

    C.Q.Yaw = C.GS.Azimuth;
    %[rad]Initial local-horizontal Yaw angle WRT to the ground station.
    
    C.Q.Pitch = C.GS.Elevation;
    %[rad]Initial local-horizontal Pitch angle WRT to the ground station. 
    
    C.Q.Roll = C.GS.Bank;
    %[rad]Initial local-horizontal Roll angle WRT to the ground station. 
    
    C.Q.T1 = [...
        1,          0,         0; ...
        0,  cos(C.Q.Roll), sin(C.Q.Roll); ...
        0, -sin(C.Q.Roll), cos(C.Q.Roll)];
    %[]Matrix that transforms vectors about the 1-axis by an angle Roll.
    
    C.Q.T2 = [ ...
        cos(C.Q.Pitch), 0, -sin(C.Q.Pitch); ...
        0, 1,           0; ...
        sin(C.Q.Pitch), 0,  cos(C.Q.Pitch)];
    %[]Matrix that transforms vectors about the 2-axis by an angle Pitch.
    
    C.Q.T3 = [ ...
        cos(C.Q.Yaw), sin(C.Q.Yaw), 0; ...
        -sin(C.Q.Yaw), cos(C.Q.Yaw), 0; ...
        0,        0, 1];
    %[]Matrix that transforms vectors about the 3-axis by an angle Yaw.
    
    C.Q.T = C.Q.T1 * C.Q.T2 * C.Q.T3;
    %[]Matrix that transforms vectors from LH coordinates to Body coordinates.
    
    C.P.Q = DCM2Q(C.Q.T);
    %[]Initial Quaternion of the projectile. 

    C.P.S = [C.P.Rcggs; C.P.Vcggs; C.P.Wcg; C.P.Q];
    %[km,km/s,rad/s,-]Aircraft state vector.

end
%===================================================================================================