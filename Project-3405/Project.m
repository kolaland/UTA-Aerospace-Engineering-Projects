%% Gayathri Kola
%% MAE 3405-001 | FA22 | Flight Dynamics
%% Semester Project

tic;
%[]Starts program timer.

clc;
%[]Clears command window.

clear;
%[]Clears variable workspace.

format('Compact');
%[]Sets the command window output to single-spaced lines.   

format('LongG');
%[]Sets the command window output to display 16 digits for double-precision variables.

close('All');
%[]Closes all figures.S

String = 'Begin Simulation...\n';
%[]Formatted string.
 
Equal = strcat(repelem('=',70),'\n');
%[]Formatted string with 70 equal signs and a carriage return.

fprintf(String);
%[]Prints the formatted string on the command window.

fprintf(Equal);
%[]Prints the formatted string on the command window.

%%
%[]CONSTANTS AND GIVEN QUANTITIES:

C = ConstantsP;
%[]Loads all of the constants that will be used in this simulation.

%%
%[]NUMERICAL INTEGRATION:

tm = 0:0.1:180;
%[s]Modeling time.

So = C.P.S;
%[km,km/s ,rad/s,-]Initial aircraft state.

Options = odeset('RelTol',1E-10,'Events',@(t,S)Event(t,S,C));
%[]Adjusts the accuracy of the numerical integrator and adds a stop-integration event function.

[t,S] = ode45(@(t,S)ProjectileEom1P(t,S,C),tm,So,Options);
%[s,km,km/s]Numerically integrates the projectile equations of motion.

%%
%[]POST-PROCESSING:

t = transpose(t);
%[s]Transpose of the time vector.

S = transpose(S);
%[km,km/s,rad/s,-]Transpose of the state matrix.

%%
%[]PLOT RESULTS:

PlotAltitudeP(t,S(1:3,:),C);
%[]Plots the aircraft's altitude above mean equator as a function of time.

PlotPositionP(t,S(1:3,:));
%[]Plots the aircraft's position WRT the ground station as a function of time.

PlotVelocityP(t,S(4:6,:));
%[]Plots the aircraft's velocity WRT the ground station as a function of time.

PlotAccelerationP(t,S,C);
%[]Plots the aircraft's inertial acceleration in Body coordinates as a function of time.

PlotRotationalVelocityP(t,S(7:9,:));
%[]Plots the aircraft's rotational velocity in Body coordinates as a function of time.

PlotAngles(t,S(10:13,:));
%[]Plots the aircraft's Euler angles as a function of time.


%%
%[]SAVE DATA:

%save('ProjectTest1.mat','t','S');
%[]Saves the numerical integration data to a MatLab database file.


%%
%[]DISPLAY THE SIMULTION TIME:

String = 'Simulation Complete. (%0.3f seconds)\n';
%[]Formatted string.

SimulationTime = toc;
%[s]Stops the program timer.

fprintf(String,SimulationTime);
%[]Prints the simulation time on the command winodw.
%===================================================================================================