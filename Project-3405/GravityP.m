function g = GravityP(R,C)

    % INPUTS >> 
    % R = (Rcge): in NED 
    
    r = norm(R);
    %[km]Range WRT the Earth.

    g = -C.E.mu * R / r^3;
    %[km/s^2]Acceleration due to gravity in NED coordinates.

end
%===================================================================================================