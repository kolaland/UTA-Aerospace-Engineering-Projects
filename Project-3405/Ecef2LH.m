function T = Ecef2LH(phi,lambda)
    
    % INPUTS >> 
    % phi: in CG 
    % lambda: in CG 

    T = [-sin(phi) * cos(lambda), -sin(phi) * sin(lambda),  cos(phi); ...
                    -sin(lambda),             cos(lambda),         0; ...
         -cos(phi) * cos(lambda), -cos(phi) * sin(lambda), -sin(phi)];
    %[]Matrix that transforms vectors from ECEF coordinates to NED coordinates.
    
end
%===================================================================================================