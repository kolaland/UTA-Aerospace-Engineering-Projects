function Q = DCM2Q(T)

    K = zeros(4,4);
    %[]Allocates memory for the eigen matrix.

    K(1,1) = T(1,1) - T(2,2) - T(3,3);
    K(1,2) = T(2,1) + T(1,2);
    K(1,3) = T(3,1) + T(1,3);
    K(1,4) = T(2,3) - T(3,2);
    K(2,1) = T(2,1) + T(1,2);
    K(2,2) = -T(1,1) + T(2,2) - T(3,3);
    K(2,3) = T(3,2) + T(2,3);
    K(2,4) = T(3,1) - T(1,3);
    K(3,1) = T(3,1) + T(1,3);
    K(3,2) = T(3,2) + T(2,3);
    K(3,3) = -T(1,1) - T(2,2) + T(3,3);
    K(3,4) = T(1,2) - T(2,1);
    K(4,1) = T(2,3) - T(3,2);
    K(4,2) = T(3,1) - T(1,3);
    K(4,3) = T(1,2) - T(2,1);
    K(4,4) = T(1,1) + T(2,2) + T(3,3);
    %[]Eigen matrix update.

    K = 1 / 3 * K;
    %[]Eigen matrix update.

    [EigenVector,EigenValue] = eig(K);
    %[]Calculates the eigen values and respective eigen vectors for the eigen matrix.

    [~,Index] = max(diag(EigenValue));
    %[]Selects the maximum eigen value.

    Q = EigenVector(:,Index);
    %[]Quaternion

end
%===================================================================================================