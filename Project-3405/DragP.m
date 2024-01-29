function [Fd,Md] = DragP(R,V,We,C)
    
    % INPUTS >> 
    % R = (Rcge): in BODY
    % V = (Vcge): in BODY
    % We =  (We): in BODY 
    
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

    Fd = -0.5 * C.P.Cd * rho * C.P.area * vinf * Vinf;
    %[kN]Longitudinal drag force WRT the CG in BODY coordinates.

    Md = cross(C.P.Rcpcg,Fd);
    %[km-kN]Total moment due to drag WRT the CG in BODY coordinates.

end
%===================================================================================================