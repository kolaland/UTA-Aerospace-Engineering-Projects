function Fw = WeightP(Rcge,C)
    % Needs structure C for constants. 
    % Rcge: in NED
    
    rcge = norm(Rcge);
    %[km]Magnitude of the position vector in NED coordinates. Cubed

    Fw = - C.P.mcg * C.E.mu * Rcge / rcge^3;
    %[kN]Weight vector of the projectile in NED coordinates. 
end

