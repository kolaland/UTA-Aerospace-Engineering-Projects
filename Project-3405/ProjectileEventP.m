function [LW,Isterminal,Direction] = ProjectileEventP(~,S,C)

    Rcggs = S(1:3);
    %[km]Aircraft position WRT the ground station in NED coordinates.

    Vcggs = S(4:6);
    %[km/s]Aircraft velocity WRT the ground station in NED coordinates.

    Wcg = S(7:9);
    %[rad/s]Projectile's angular velocity in BODY coordinates. 

    Q = S(10:13);
    %[-]Aircraft quaternion.

    %-----------------------------------------------------------------------------------------------

    Rcge = C.GS.Rgse + Rcggs;
    %[km]Aircraft position WRT the Earth in NED coordinates.

    Vcge = C.GS.Vgse + cross(C.GS.We,Rcggs) + Vcggs;
    %[km/s]Aircraft velocity WRT the Earth in NED coordinates.

    %-----------------------------------------------------------------------------------------------

    NedToBody = Ned2Body(Rcge,Q,C);
    %[]Matrix that transforms vectors from NED coordinates to Body coordinates.

    R = NedToBody * Rcge;
    %[km]Aircraft position WRT the Earth in Body coordinates.

    V = NedToBody * Vcge;
    %[km/s]Aircraft velocity WRT the Earth in Body coordinates.

    We = NedToBody * C.GS.We;
    %[rad/s]Rotational velocity of the Earth in Body coordinates.

    %-----------------------------------------------------------------------------------------------

    [Fm,~] = MagnusP(R,V,Wcg,We,C,Q);
    %[kN]Lift force WRT the CG in Body coordinates.

    Fw = NedToBody * WeightP(Rcge,C); 
    %[kN]Weight force WRT the CG in BODY coordinates. 

    LW = norm(Fm) - norm(Fw);
    %[]Lift minus weight event.

    Isterminal = 1;
    %[]Terminates the numerical integration as soon as the zero-condition is met.

    Direction = -1;
    %[]Calculates zeros when the projectile altitude above the ground station is decreasing.

end
%===================================================================================================