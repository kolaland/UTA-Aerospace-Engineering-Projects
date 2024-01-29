function [Wdot,Qdot] = EulerP(W,Q,M,C)

    % INPUTS >> 
    % W = (Wcg): in BODY 
    % Q        : no units 
    % M        : in BODY 

    Wdot = C.P.IcgInv * (M - cross(W,C.P.Icg * W));
    %[rad/s^2]Rotational acceleration WRT the CG in BODY coordinates.

    Wx = W(1);
    Wy = W(2);
    Wz = W(3);
    %[rad/s^2]Rotational veolcity WRT the CG in Body coordinates.

    Omega = [ ...
          0, Wz, -Wy, Wx;...
        -Wz,  0,  Wx, Wy;...
         Wy,-Wx,   0, Wz;...
        -Wx,-Wy, -Wz,  0];
    %[]Matrix that maps rotational velocity.

    Qdot = 0.5 * Omega * Q;
    %[rad/s]Euler angles rate of change WRT time.

end
%===================================================================================================