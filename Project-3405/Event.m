function [hcggs,Isterminal,Direction] = Event(~,S,C)
    
    Rcggs = S(1:3);
    %[km]Projectile position WRT the ground station in NED coordinates.

    Rcge = C.GS.Rgse + Rcggs;
    %[km]Projectile position WRT the Earth in NED coordinates.
    
    rcge = norm(Rcge);
    %[km]Projectile range WRT the Earth.

    rgse = norm(C.GS.Rgse);
    %[km]Ground station range WRT the Earth.
    
    hcggs = rcge - rgse;
    %[km]Projectile altitude above the ground station altitude above mean equator.
    
    Isterminal = 1;
    %[]Terminates the numerical integration as soon as the zero-condition is met.
    
    Direction = -1;
    %[]Calculates zeros when the projectile altitude above the ground station is decreasing.
    
end
%===================================================================================================