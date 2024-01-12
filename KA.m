%% Supersonic Airfoil Design, GAYATHRI KOLA, SP2022, MAE3303-001, Due: 27 April 2022
%{
%% Background:
- all functions used are included at the end of the code
- p-codes oswbeta.p , pm.p , thetamax.p are needed to run this file
- clockwise direction is positive
- if MATLAB shows pre-allocation warnings, please ignore, the code works
  properly.
Start here------->>>
%% Variables
MInf        > Freestream Mach number
M1, M2      > Mach numbers on the upper surfaces of the airfoil
M3, M4      > Mach numbers on the lower surfaces of the airfoil
gamma       > Specific heat ratio for air 
alpha       > Angle of attack
delta       > Half-wedge angles for upper and lower surfaces of the airfoil
theta       > Deflection angle between incoming and outgoing flow direction
xu          > x-distance from LE to upper peak of the airfoil
xl          > x-distance from LE to lower peak of the airfoil
tu          > y-direction from chord line to maximum upper peak 
tl          > y-direciton from chord line to maximum lower peak
c           > Chord length of the airofil [Non-dimensionalized]
Cl          > Lift Coefficient 
Cd          > Wave Drag Coefficient 
CmLE        > Pitching Moment Coefficient about the Leading Edge

%% Shockwave-Expansion Wave Conditions
alpha > delta : Expansion waves, theta deflection angle = alpha - delta
alpha = delta : No waves
alpha < delta : Oblique shock waves, theta deflection angle = delta - alpha

%% Constraints: 
1. tu/c + tl/c >= 0.05 [Set to 5% of chord directly]
2. | Cm, LE | < = 0.08
3. cl >= 0.2

%}

clc, clear all
close

%% Initialize design variables

% Fixed Parameters
MInf = 2;
gamma = 1.4;
c = 1.0;

% Design variables
alpha = linspace(-15,15,31)';    % 31 divisions, equally spaced
xu = linspace(0.1, 0.9, 31)';    % 31 divisions: **Not starting at leading edge
xl = linspace(0.9, 0.1, 31)';    % 31 divisions  **Not starting at leading edge
tu = linspace(0, 0.05, 31)';     % 31 divisions  **From chord to max thickness (x = 0; y = 0.05)

% Upper point: x1, y1
xubar = 0;
tubar = 0;
% Lower point: x2, y2
xlbar = 0;
tlbar = 0;

% averages> Upper: xa01, xa13 | Lower: xa02, xa23
xa01 = 0;
xa13 = 0;
xa02 = 0;
xa23 = 0;

% half-wedge angles:: Upper: delta1, delta2 | Lower: delta3, delta4
delta1 = 0;
delta2 = 0;
delta3 = 0;
delta4 = 0;

% Arrays to store values
Tarray = [];
CpArray = [];
UP = [];
LOW = [];
CONS = [];
UPDATED = [];

% Variables to display values in a table
T = table();
C = table();
UPPERSURFACE = table();
LOWERSURFACE = table();
CONSNEW = table();
updated = table();

%% Airfoil shape

%{
loop to calculate airfoil shape
- outer loop for angle of attack: alpha
- inner loop for airfoil geometric parameters: xu, xl, tu, tl
NOTE: 
Here, I used only two loops. One for alpha, and one for geometric
parameters. Inner loop (i) generates the same geometric parameters every time (j) changes.
Outer loop (j) executes 30 times over inner loop (i), so for j = 1,
i iterates 30 times.  
Hence, we get 31 x 31 = 961 values.  
%}

for j = 1:31
    for i = 1:31
        % Upper coordinate: xu, tu (noramlized)
        xubar = xu(i);
        tubar = tu(i);
        % Lower coordinate: xl, tl (normalized)
        xlbar = xl(i);
        tlbar = tu(i) - 0.05;

        % Upper average: x0(LE), x1(xubar), x3(TE)
        xa01 = (0 + xu(i)) / 2;
        xa13 = (xu(i) + 1) / 2;
        % Lower average: x0(LE), x2(xlbar), x3(TE)
        xa02 = (0 + xl(i)) / 2;
        xa23 = (xl(i) + 1) / 2;

        % Calls the function for half wedge angle calculation
        [delta1, delta2, delta3, delta4] = hw_angles(xubar,tubar,xlbar,tlbar);

        % Calculating the maximum deflection angle for MInf (Pcode)
        ThetaMax_MInf = thetamax(MInf, gamma);

        % creating an array to store all values calculated for airfoil geometry
        Tnewarray = [i j xubar tubar xlbar tlbar xa01 xa13 xa02 xa23 delta1 delta2 delta3 delta4];
        Tarray = [Tarray; Tnewarray];

        % displaying a table of calculated values for airfoil geometry
        Tnew = table(i, j, xubar, tubar, xlbar, tlbar, xa01, xa13, xa02, xa23, delta1, delta2, delta3, delta4);
        T = [T; Tnew];

        %% UPPER SURFACE OF THE AIRFOIL: 1, 2

        % Condition 1: Expansion wave at LE
        if alpha(j) > delta1
            UPPER1 = {'01UP: EXPANSION'};
            theta1 = abs(alpha(j) - delta1);
            P0Inf_PInf = totalPRatio(MInf, gamma);
            M1 = pm(MInf, theta1, gamma);
            P01_P1 = totalPRatio(M1, gamma);                        % P01/P1
            P1_PInf = P0Inf_PInf / (P01_P1);                     % P1/PInf
            Cp1 = pressureCoefficient(P1_PInf,MInf, gamma);

            UPPER2 = {'02UP: EXPANSION'};
            theta2 = abs(delta1 + delta2);
            M2 = pm(M1, theta2, gamma);
            P02_P2 = totalPRatio(M2, gamma);                        % P02/P2
            P2_PInf = (P02_P2) \ (P0Inf_PInf);                   % P2/PInf
            Cp2 = pressureCoefficient(P2_PInf,MInf, gamma);
            UPPERSURFACE = table(i, j, theta1, theta2, UPPER1, UPPER2, Cp1, Cp2);
            UP = [UP; UPPERSURFACE];

            % Condition 2: No wave at LE
        elseif alpha(j) == delta1
            UPPER1 = {'01UP: NO WAVE'};
            theta1 = abs(alpha(j));
            MInf = M1;
            P0Inf_PInf = totalPRatio(MInf, gamma);
            Cp1 = 0;

            % code for the second expansion wave here
            UPPER2 = {'02UP: EXPANSION'};
            theta2 = abs(delta1 + delta2);
            M2 = pm(M1, theta2, gamma);
            P02_P2 = totalPRatio(M2, gamma);
            P2_PInf = (P02_P2) \ (P0Inf_PInf);                   % P2/PInf
            Cp2 = pressureCoefficient(P2_PInf,MInf, gamma);
            UPPERSURFACE = table(i, j, theta1, theta2, UPPER1, UPPER2, Cp1, Cp2)
            UP = [UP; UPPERSURFACE];

            % Condition 3: Oblique Shock wave at LE
        else
            alpha(j) < delta1
            UPPER1 = {'01UP: OBLIQUE'};
            theta1 = abs(alpha(j) - delta1);
            beta1 = oswbeta(MInf, theta1, gamma);
            [thetamax1, betamax1] = thetamax(MInf, gamma);
            if theta1 > thetamax1 || beta1 > betamax1
                disp("Det ached Shock Wave at UPPER Leading Edge")
                continue
            end
            P1_PInf = staticPressure(MInf, gamma, beta1);           % P1/PInf
            Cp1 = pressureCoefficient(P1_PInf,MInf, gamma);

            UPPER2 = {'02UP: EXPANSION'};
            [Mn1] = MnNext(MInf, gamma, beta1);
            M1 = (Mn1)/ sind(beta1 - theta1);
            P01_P1 = totalPRatio(M1, gamma);                        % P01/P1
            theta2 = abs(delta1 + delta2);
            M2 = pm(M1, theta2, gamma);
            P02_P2 = totalPRatio(M2, gamma);                        % P02/P2
            P2_PInf = (P02_P2) \ (P01_P1) * (P1_PInf);           % P2/PInf
            Cp2 = pressureCoefficient(P2_PInf,MInf, gamma);
            UPPERSURFACE = table(i, j, theta1, theta2, UPPER1, UPPER2, Cp1, Cp2);
            UP = [UP; UPPERSURFACE];
        end

        % for loop 2nd part >>

        %% LOWER SURFACE OF AIRFOIL 3, 4

        % Condition 4: Oblique shock wave at LE
        if alpha(j) > 0
            LOWER3 = {'01DOWN: OBLIQUE'};
            theta3 = alpha(j) + abs(delta3);
            beta3 = oswbeta(MInf, theta3, gamma);
            [thetamax3, betamax3] = thetamax(MInf, gamma);
            % checking for maximum delfection to be less than theta1
            if theta3 > thetamax3 || beta3 > betamax3
                disp("Detached Shock Wave at BOTTOM Leading Edge")
                continue                                            % exits loop if true
            end
            Mn3 = MnNext(MInf, gamma, beta3);
            P3_PInf = staticPressure(MInf, gamma, beta3);           % P3/PInf
            Cp3 = pressureCoefficient(P3_PInf,MInf, gamma);         % Cp3

            LOWER4 = {'02DOWN: EXPANSION'};
            theta4 = abs(delta3 + delta4);
            M3 = (Mn3) / sind(beta3 - theta3);
            M4 = pm(M3, theta4, gamma);
            P04_P4 = totalPRatio(M4, gamma);                        % P04/P4
            P03_P3 = totalPRatio(M3, gamma);                        % P03/P3
            P4_PInf = (P04_P4) \ (P03_P3) * P3_PInf;
            Cp4 = pressureCoefficient(P4_PInf,MInf, gamma);         % Cp4
            LOWERSURFACE = table(i, j, theta3, theta4, LOWER3, LOWER4, Cp3, Cp4);
            LOW = [LOW; LOWERSURFACE];

            % Condition 5: No wave at LE
        elseif alpha(j) == delta3
            LOWER3 = {'01DOWN: NO WAVES'};
            theta3 = alpha(j);
            M3 = MInf;
            P0Inf_PInf = totalPRatio(MInf, gamma);                  % P0Inf/PInf
            P03_P3 = totalPRatio(M3, gamma);                        % P03/P3
            Cp3 = 0;

            % code for the second expansion wave here
            LOWER4 = {'02DOWN: EXPANSION'};
            theta4 = abs(delta3 + delta4);
            M4 = pm(M3, theta4, gamma);
            P04_P4 = totalPRatio(M4, gamma);
            P4_PInf = (P04_P4) \ (P0Inf_PInf);
            Cp4 = pressureCoefficient(P4_PInf,MInf, gamma);
            LOWERSURFACE = table(i, j, theta3, theta4, LOWER3, LOWER4, Cp3, Cp4);
            LOW = [LOW; LOWERSURFACE];

            % Condition 6: Expansion wave at LE
        else
            alpha(j) < 0
            LOWER3 = {'01DOWN: EXPANSION'};
            theta3 = abs(alpha(j) - delta3);
            P0Inf_PInf = totalPRatio(MInf, gamma);                  % P0Inf/PInf
            M3 = pm(MInf, theta3, gamma);
            P03_P3 = totalPRatio(M3, gamma);                        % P03/P3
            P3_PInf = (P03_P3) \ P0Inf_PInf;                     % P3/PInf
            Cp3 = pressureCoefficient(P3_PInf,MInf, gamma);         % Cp3

            LOWER4 = {'02DOWN: EXPANSION'};
            theta4 = abs(delta3 + delta4);
            M4 = pm(M3, theta4, gamma);
            P04_P4 = totalPRatio(M4, gamma);                        % P04/P4
            P4_PInf = (P04_P4) \ (P0Inf_PInf);                   % P4/PInf
            Cp4 = pressureCoefficient(P4_PInf,MInf, gamma);         % Cp4
            LOWERSURFACE = table(i, j, theta3, theta4, LOWER3, LOWER4, Cp3, Cp4);
            LOW = [LOW; LOWERSURFACE];
        end


        %% Performance Analysis

        % Calculate normal force coefficient: Cn
        Cni = (Cp3 * (xlbar - 0)) + (Cp4 * (1 - xlbar)) - (Cp1 * (xubar - 0)) - (Cp2 * (1 - xubar));
        Cn = real(Cni);

        % Calculate axial force coefficient: Ca
        Cai = (Cp1 * tand(delta1) * (xubar - 0)) + (Cp2 * tand(-1 * delta2) * (1 - xubar)) - (Cp3 * tand(-1 * abs(delta3)) * (xlbar - 0)) - (Cp4 * tand(abs(delta4)) * (1 - xlbar));
        Ca = real(Cai);

        % Calculate lift coefficient: Cl
        Cli = (Cn * cosd(alpha(j))) - (Ca * sind(alpha(j)));
        Cl = abs(real(Cli));

        % Calculate drag coefficient: Cd
        Cdi = (Cn * sind(alpha(j))) + (Ca * cosd(alpha(j)));
        Cd = abs(real(Cdi));

        % Calculate the lift-to-drag ratio: L/D
        L_Di = Cl / Cd;
        L_D = real(L_Di);

        % Calculate pitching moment coefficient about the leading edge: CmLE
        Cm_term1 = (Cp1 * xa01 * (xubar - 0)) + (Cp2 * xa13 * (1 - xubar)) - (Cp3 * xa02 * (xlbar - 0)) - (Cp4 * xa23 * (1 - xlbar));
        Cm_term2 = (Cp1 * tand(delta1) * xa01 * (xubar - 0)) + (Cp2 * tand(-1 * delta2) * xa13 * (1 - xubar)) - (Cp3 * tand(-1 * abs(delta3)) * xa02 * (xlbar - 0)) - (Cp4 * tand(abs(delta4)) * xa23 * (1 - xlbar));
        CmLEi = Cm_term1 + Cm_term2;
        CmLE = real(CmLEi);

        % storing current value for angle of attack: alpha
        angleofattack = alpha(j);

        Cpnewarray = [i j angleofattack Cp1 Cp2 Cp3 Cp4 Cn Ca xubar tubar xlbar tlbar Cl Cd L_D CmLE];
        CpArray = [CpArray; Cpnewarray];

        % displaying a table for calculated values so far
        Cpnew = table(i, j, angleofattack, Cp1, Cp2, Cp3, Cp4, Cn, Ca, xubar, tubar, xlbar, tlbar, Cl, Cd, L_D, CmLE);
        C = [C; Cpnew];

        %% Feasible Design?

        % Constraint check 2:
        if round(Cl,1,"significant") >= 0.2
            CONS2 = {'Contraint 2: DONE'};
        else
            continue
        end

        % Constraint check 3:
        if abs(round(CmLE,1,"significant")) <= 0.08
            CONS3 = {'Constraint 3: DONE'};
        else
            continue
        end

        % Update feasible design
        UPDATE = [j i angleofattack xubar tubar xlbar tlbar Cl Cd CmLE L_D];
        UPDATED = [UPDATED; UPDATE];
        update = table(j, i, angleofattack, xubar, tubar, xlbar, tlbar, Cl, Cd, CmLE, L_D);
        updated = [updated; update];

    end
end

%% Displaying all calculated values and feasible designs

disp('All calculated values for geometric parameters')
disp(T)


disp('COEFFICIENTS and GEOMETRIC PARAMETERS')
disp(C)

disp('ALL FEASIBLE DESIGNS')
disp(updated)

%% Better objective?

% Extracting array values from feasible desings
ClUP = UPDATED(:, 8);
CdUP = UPDATED(:, 9);
CmLEUP = UPDATED(:,10);
L_DUP = UPDATED(:,11);
maxRatio = L_DUP(1);

% calculating the maximum Lift to Drag ratio from all feasible desings
for k = 1:length(L_DUP)
    if (L_DUP(k) > maxRatio)
        maxRatio = L_DUP(k);
        displayy = UPDATED(k,:);
    end
end

disp('Maximum Lift to Drag ratio L/D:')
disp(maxRatio)

disp('Geometry and Coefficients for Maximum Lift to Drag ratio')
disp(displayy)

%% plotting Airfoil

% LE: x0, y0 = (0,0)
% TE: x3, y3 = (1,0)
x0 = 0;
y0 = 0;
% extracting geometry values from best airfoil stored in displayy
pxu = displayy(4);
ptu = displayy(5);
pxl = displayy(6);
ptl = displayy(7);
cx = 1;
cy = 0;

line(xlim(), [0,0], 'LineWidth', 0.5, 'Color', 'k', 'LineStyle', '--');
grid on
hold on
xlabel('x-distance')
ylabel('y-distance')
title('Airfoil with maximum Lift to Drag {L/D} ratio')
plot([x0 pxu cx], [y0 ptu cy],'b','LineWidth',1)
axis equal
hold on
plot([x0 pxl cx], [y0 ptl cy],'g','LineWidth',1)
legend('Middle','Upper','Lower','Location','NorthEast')
ax.XAxis.LineWidth = 1.5;
ax.XAxis.Color = 'k';
ax.YAxis.LineWidth = 1.5;
ax.YAxis.Color = 'k';
set(gcf, 'Color','W')

%% All Functions

% Pressure Coefficient: Cp
function [Cpn] = pressureCoefficient(Pstatic_PInf,MInf, gamma)
    Cpn = ((Pstatic_PInf) - 1) / (0.5 * gamma * (MInf)^2);
end


% Normal Mach number: Mn2
function [Mn2] = MnNext(M, gamma, beta)
    Mn1 = M * sind(beta);
    Mn2_num = 1 + ((gamma - 1)/2 * (Mn1)^2);
    Mn2_denom = (gamma*(Mn1)^2) - ((gamma - 1)/ 2);
    Mn2 = sqrt(Mn2_num/Mn2_denom);
end

% Half-wedge angles: deltas
function [delta1, delta2, delta3, delta4] = hw_angles(xubar,tubar,xlbar,tlbar)
    delta1 = atand(tubar/xubar);
    delta2 = atand(tubar/(1- xubar));
    delta3 = atand(tlbar/xlbar);
    delta4 = atand((tlbar/(1 - xlbar)));
end

% Total pressure to static pressure ratio: Po/P
function [P0toP] = totalPRatio(M, gamma)
    P0toP = (1 + ((gamma - 1)/2 * (M)^2))^(gamma/(gamma-1));
end

% Static pressure ratio: P2/P1
function [PfPb] = staticPressure(M, gamma, beta)
    Mn1 = M * sind(beta);
    PfPb = 1 + ((( 2* gamma)/ (gamma + 1)) * ((Mn1)^2 - 1));
end

% Additonal p-codes: oswbeta.p , pm.p , thetamax.p

