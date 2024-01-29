function dSdt = ProjectileEom1P(~,S,C)
    
    Rcggs = S(1:3);
    %[km]Projectile position WRT the ground station in NED coordinates.
    
    Vcggs = S(4:6);
    %[km/s]Projectile velocity WRT the ground station in NED coordinates.

    Wcg = S(7:9);
    %[rad/s]Aircraft rotational velocity WRT the CG in Body coordinates.

    Q = S(10:13);
    %[-]Aricraft's quaternion. 

    %-----------------------------------------------------------------------------------------------

    Rcge = C.GS.Rgse + Rcggs;
    %[km]Aircraft position WRT the Earth in NED coordinates.

    Vcge = C.GS.Vgse + cross(C.GS.We,Rcggs) + Vcggs;
    %[km/s]Aircraft velocity WRT the Earth in NED coordinates.

    g = GravityP(Rcge,C);
    %[km/s^2]Gravity vector in NED coordinates. 

    %-----------------------------------------------------------------------------------------------

    NedToBody = Ned2Body(Rcge,Q,C);
    %[]Matrix that transforms vectors from NED coordinates to Body coordinates.

    BodyToNed = transpose(NedToBody);
    %[]Matrix that transforms vectors from Body coordinates to NED coordinates.

    %-----------------------------------------------------------------------------------------------

    RcgeB = NedToBody * Rcge;
    %[km]Aircraft position WRT the Earth in Body coordinates.

    VcgeB = NedToBody * Vcge;
    %[km/s]Aircraft velocity WRT the Earth in Body coordinates.

    WeB = NedToBody * C.GS.We;
    %[rad/s]Rotational velocity of the Earth in Body coordinates.

    gB = NedToBody * g;
    %[km/s^2]Gravity vector in Body coordinates. 

    %-----------------------------------------------------------------------------------------------

    [Fd,Md] = DragP(RcgeB,VcgeB,WeB,C);
    %[kN,km-kN]Drag force and moment WRT the CG in Body coordinates.

    [Fm,Mm] = MagnusP(RcgeB,VcgeB,Wcg,WeB,C);
    %[kN]Magnus force WRT the CG in Body coordinates.

    Fw = NedToBody * WeightP(Rcge,C);
    %[kN]Weight force due to gravity in Body coordinates. 

    %-----------------------------------------------------------------------------------------------

    F = BodyToNed * (Fd + Fm + Fw);
    %[kN]Total force WRT the CG in Ned coordinates.

    M = Md + Mm;
    %[km-kN]Total moment WRT the CG in Body coordinates.

    %-----------------------------------------------------------------------------------------------

    [Wdot,Qdot] = EulerP(Wcg,Q,M,C);
    %[rad/s^2,rad/s]Rotational acceleration WRT the CG in Body coordinates and Quaternion rate of
    %change WRT time.

    %-----------------------------------------------------------------------------------------------

    dSdt = zeros(13,1);
    %[]Allocates memory for the state vector derivative.

    dSdt(1:3) = Vcggs;
    %[km/s]Aircraft velocity WRT the ground station in NED coordinates.

    dSdt(4:6) = ...
        F / C.P.mcg - ...
        C.GS.Agse - ...
        cross(C.GS.We,cross(C.GS.We,Rcggs)) - ...
        2 * cross(C.GS.We,Vcggs);
    %[km/s^2]Aircraft acceleration WRT the ground sstation in NED coordinates.

    dSdt(7:9) = Wdot;
    %[rad/s^2]Aircraft rotational acceleration WRT the CG in Body coordinates.

    dSdt(10:13) = Qdot;
    %[rad/s^2]Aircraft Quaternion rate of change WRT time.

end
%===================================================================================================
