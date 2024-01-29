function T = Ned2Body(R,Q,C)
    
    % IPNUTS >> 
    % R = (Rcge): in NED 
    % Q         : no units 

    R = C.GS.NedToEcef * R;
    %[km]Aircraft position WRT the Earth in ECEF coordinates.

    x = R(1);
    %[km]Aircraft x-displacement WRT the Earth in ECEF coordinates.

    y = R(2);
    %[km]Aircraft y-displacement WRT the Earth in ECEF coordinates.

    z = R(3);
    %[km]Aircraft z-displacement WRT the Earth in ECEF coordinates.

    r = norm(R);
    %[km]Aircraft range WRT the Earth.

    phi = asin(z / r);
    %[rad]Aircraft latitude WRT the Earth. [phi.cg]

    lambda = atan2(y,x);
    %[rad]Aircraft longitude WRT the Earth. [lambda.cg]

    EcefToLh = Ecef2LH(phi,lambda);
    %[]Matrix that transforms vectors from ECEF coordinates to LH coordinates.

    LhToBody = Q2DCM(Q);
    %[]Matrix that transforms vectors from LH coordinates to Body coordinates.

    T = LhToBody * EcefToLh * C.GS.NedToEcef;
    %[]Matrix that transforms vectors from NED coordinates to Body coordinates.

end
%===================================================================================================