function [Fm,Mm] = MagnusP(R,V,Wcg,We,C)

    % INPUTS >> 
    % R = (Rcge): in BODY 
    % V = (Vcge): in BODY
    % Wcg       : in BODY 
    % We        : in BODY 
    % Q         : no units

    Vinf = V - cross(We,R);
    %[km/s]True air velocity WRT the CG in BODY coordinates.

    vinf = norm(Vinf);
    %[km/s]Magnitude of true air velocity in BODY coordinates. 

    %-----------------------------------------------------------------------------------------------

    hcg = norm(R) - C.E.Re;
    %[km]Altitude above mean equator.

    [~,~,rho] = StandardAtmosphereP(hcg);
    %[kg/km^2]Atmospheric density.

    %-----------------------------------------------------------------------------------------------

    wcg = norm(Wcg);
    %[rad]Local horizontal Roll angle rounded to the nearest digit. 
    
    % Check to see if Roll angle is 0 or higher, helps continue integration.
    if wcg == 0
        Fm = zeros(3,1);
    else 
        Fm = 0.5 * C.P.Cl * rho * C.P.area * vinf^2 * (cross(Wcg,Vinf)/norm(cross(Wcg,Vinf)));
        %[kN]Magnus force WRT the CG in BODY coordinates.
    end 
    
    Mm = cross(C.P.Rcpcg,Fm);
    %[km-kN]Moment due to Magnus force WRT the CG in BODY coordinates.

end
%===================================================================================================