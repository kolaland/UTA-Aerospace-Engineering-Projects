function DCM = Q2DCM(Q)

    DCM = zeros(3,3);
    %[]Allocates memory for the direction cosine matrix.

    DCM(1,1) = Q(1)^2 - Q(2)^2 - Q(3)^2 + Q(4)^2;
    DCM(1,2) = 2 * (Q(1) * Q(2) + Q(3) * Q(4));
    DCM(1,3) = 2 * (Q(1) * Q(3) - Q(2) * Q(4));
    DCM(2,1) = 2 * (Q(1) * Q(2) - Q(3) * Q(4));
    DCM(2,2) = -Q(1)^2 + Q(2)^2 - Q(3)^2 + Q(4)^2;
    DCM(2,3) = 2 * (Q(2) * Q(3) + Q(1) * Q(4));
    DCM(3,1) = 2 * (Q(1) * Q(3) + Q(2) * Q(4));
    DCM(3,2) = 2 * (Q(2) * Q(3) - Q(1) * Q(4));
    DCM(3,3) = -Q(1)^2 - Q(2)^2 + Q(3)^2 + Q(4)^2;
    %[]Matrix that transforms vectors from LH coordinates to Body coordinates.

end
%===================================================================================================