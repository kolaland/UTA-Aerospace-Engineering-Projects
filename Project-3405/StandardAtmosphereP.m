%===================================================================================================
%[]FUNCTION NAME: StandardAtmosphere.m
%[]AUTHOR: Julio César Benavides
%[]CREATED: 07/17/2012
%[]REVISED: 09/13/2018
%===================================================================================================
%[]FUNCTION DESCRIPTION:
%This function calculates the local atmospheric temperature, pressure, and density based on the ARDC
%1959 Standard Atmosphere.
%===================================================================================================
%[]INPUT VARIABLES:
%(h)|Current altitude.
%===================================================================================================
%[]OUTPUT VARIABLES:
%(T)|Local atmospheric temperature.
%---------------------------------------------------------------------------------------------------
%(P)|Local atmospheric pressure.
%---------------------------------------------------------------------------------------------------
%(D)|Local atmospheric density.
%===================================================================================================
%[]VARIABLE FORMAT:
%(h)|Scalar {1x1}.
%---------------------------------------------------------------------------------------------------
%(T)|Scalar {1x1}.
%---------------------------------------------------------------------------------------------------
%(P)|Scalar {1x1}.
%---------------------------------------------------------------------------------------------------
%(D)|Scalar {1x1}.
%===================================================================================================
%[]AUXILIARY FUNCTIONS:
%None.
%===================================================================================================
%[]COMMENTS:
%The altitude input must be in units of kilometers and the density output is in units of kg/km^3.
%===================================================================================================
function [T,P,D] = StandardAtmosphereP(h)
    
    h = h * 1000;
    %[m]Converts the altitude above mean equator from kilometers to meters.
    
    g = 9.81;
    %[m/s^2]Sea-level acceleration due to gravity.
    
    R = 287;
    %[J/kg/K]Specific gas constant.
    
    if h < 0
        
        T = 288.16;
        %[K]Generic atmospheric temperature
        
        P = 101325;
        %[Pa]Generic atmospheric pressure.
        
        D = 2.65E12;
        %[kg/km^3]Generic atmospheric density.
        
        fprintf('The object is below Earth mean equator!!!\n');
        %[]Displays this message on the command window.
        
        return;
        %[]Closes the density function and returns the focus to the calling function or script.
        
    elseif h == 0
        
        T = 288.16;
        %[K]Sea-level atmospheric temperature
        
        P = 101325;
        %[Pa]Sea-level atmospheric pressure.
        
        D = 1.225 * 1E9;
        %[kg/km^3]Sea-level atomospheric density.
        
        return;
        %[]Closes the density function and returns the focus to the calling function or script.
        
    elseif (h > 0) && (h <= 11e3)
        
        a = (216.66 - 288.16) / 11e3;
        %[K/m]Temperature gradient for the current altitude.
        
        T = 288.16 + a * h;
        %[K]Current atmospheric temperature.
        
        P = 101325 * (T / 288.16)^(-g / (a * R));
        %[Pa]Current atmospheric pressure.
        
        D = 1.225 * (T / 288.16)^(-g / (a * R) - 1) * 1E9;
        %[kg/km^3]Current atmospheric density.
        
        return;
        %[]Closes the density function and returns the focus to the calling function or script.
        
    elseif (h > 11e3) && (h <= 25e3)
        
        T = 216.66;
        %[K]Current atmospheric temperature.
        
        P = 22650.1684742737 * exp(-g / (R * T) * (h - 11e3));
        %[Pa]Current atmospheric pressure.
        
        D = 0.364204971415039 * exp(-g / (R * T) * (h - 11e3)) * 1E9;
        %[kg/km^3]Current atmospheric density.
        
        return;
        %[]Closes the density function and returns the focus to the calling function or script.
        
    elseif (h > 25e3) && (h <= 47e3)
        
        a = (282.66 - 216.66) / (47e3 - 25e3);
        %[K/m]Temperature gradient for the current altitude.
        
        T = 216.66 + a * (h - 25e3);
        %[K]Current atmospheric temperature.
        
        P = 2493.58245271879 * (T / 216.66)^(-g / (a * R));
        %[Pa]Current atmospheric pressure.
        
        D = 0.0400957338107663 * (T / 216.66)^(-g / (a * R) - 1) * 1E9;
        %[kg/km^3]Current atmospheric density.
        
        return;
        %[]Closes the density function and returns the focus to the calling function or script.
        
    elseif (h > 47e3) && (h <= 53e3)
        
        T = 282.66;
        %[K]Current atmospheric temperature.
        
        P = 120.879682128688 * exp(-g / (R * T) * (h - 47e3));
        %[Pa]Current atmospheric pressure.
        
        D = 0.001489848563098 * exp(-g / (R * T) * (h - 47e3)) * 1E9;
        %[kg/km^3]Current atmospheric density.
        
        return;
        %[]Closes the density function and returns the focus to the calling function or script.
        
    elseif (h > 53e3) && (h <= 79e3)
        
        a = (165.66 - 282.66) / (79e3 - 53e3);
        %[K/m]Temperature gradient for the current altitude.
        
        T = 282.66 + a * (h - 53e3);
        %[K]Current atmospheric temperature.
        
        P = 58.5554504138705 * (T / 282.66)^(-g / (a * R));
        %[Pa]Current atmospheric pressure.
        
        D = 0.000721699065751904 * (T / 282.66)^(-g / (a * R) - 1) * 1E9;
        %[kg/km^3]Current atmospheric density.
        
        return;
        %[]Closes the density function and returns the focus to the calling function or script.
        
    elseif (h > 79e3) && (h <= 90e3)
        
        T = 165.66;
        %[K]Current atmospheric temperature.
        
        P = 1.01573256565262 * exp(-g / (R * T) * (h - 79e3));
        %[Pa]Current atmospheric pressure.
        
        D = 2.1360671021146e-005 * exp(-g / (R * T) * (h - 79e3)) * 1E9;
        %[kg/km^3]Current atmospheric density.
        
        return;
        %[]Closes the density function and returns the focus to the calling function or script.
        
    elseif (h > 90e3) && (h <= 105e3)
        
        a = (225.66 - 165.66) / (105e3 - 90e3);
        %[K/m]Temperature gradient for the current altitude.
        
        T = 165.66 + a * (h - 90e3);
        %[K]Current atmospheric temperature.
        
        P = 0.105215646463089 * (T / 165.66)^(-g / (a * R));
        %[Pa]Current atmospheric pressure.
        
        D = 2.21266589885421e-006 * (T / 165.66)^(-g / (a * R) - 1) * 1E9;
        %[kg/km^3]Current atmospheric density.
        
        return;
        %[]Closes the density function and returns the focus to the calling function or script.
        
    elseif (h > 105e3) && (h <= 500e3)
        
        a = (4 - 225.66) / (500e3 - 105e3);
        %[K/m]Temperature gradient for the current altitude.
        
        T = 225.66 + a * (h - 105e3);
        %[K]Current atmospheric temperature.
        
        P = 0.00751891790761519 * (T / 225.66)^(-g / (a * R));
        %[Pa]Current atmospheric pressure.
        
        D = 1.1607907298299e-007 * (T / 225.66)^(-g / (a * R) - 1) * 1E9;
        %[kg/km^3]Current atmospheric density.
        
        return;
        %[]Closes the density function and returns the focus to the calling function or script.
        
    elseif (h > 500e3)
        
        T = 4;
        %[K]Current atmospheric temperature.
        
        P = 0;
        %[Pa]Current atmospheric pressure.
        
        D = 0;
        %[kg/m^3]Current atmospheric density.
        
        return;
        %[]Closes the density function and returns the focus to the calling function or script.
        
    end
    
end
%===================================================================================================