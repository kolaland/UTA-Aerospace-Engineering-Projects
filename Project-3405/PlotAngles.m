function PlotAngles(t,Q)

    % INPUTS >> 
    % Q     : no units

    XLim = [0,ceil(max(t))];
    %[s]X-axis domain.

    YLim = [ ...
        -180, 180; ...
         -90,  90; ...
        -180, 180];
    %[km]Y-axis ranges.

    XTicks = linspace(XLim(1),XLim(2),21);
    %[s]X-axis tick mark locations.

    YTicks = [ ...
        {linspace(YLim(1,1),YLim(1,2),13)}; ...
        {linspace(YLim(2,1),YLim(2,2),13)}; ...
        {linspace(YLim(3,1),YLim(3,2),13)}];
    %[km]Y-axis tick mark locations.

    %-----------------------------------------------------------------------------------------------

    Titles = {'Roll','Pitch','Yaw'};
    %[]Axes titles.

    XLabels = 'Time (s)';
    %[]X-axes labels.

    YLabels = {'\phi (\circ)','\theta (\circ)','\psi (\circ)'};
    %[]Y-axes labels.

    %-----------------------------------------------------------------------------------------------

    n = numel(t);
    %[]Number of elements in the modeling time vector.

    angles = zeros(3,n);
    %[]Allocates memory for the inertial acceleration vectors.

    for k = 1:n

        LH2B = Q2DCM(Q(:,k));
        %[-]Extracts DCM from Q2DCM using the current quaternions. 

        angles(1,k) = atan2(LH2B(2,3),LH2B(3,3));
        %[rad]Projectile's Roll angle in LH coordindates. 

        angles(2,k) = asin(-LH2B(1,3));
        %[rad]Projectile's Pitch angle in LH coordindates. 

        angles(3,k) = atan2(LH2B(1,2),LH2B(1,1));
        %[rad]Projectile's Yaw angle in LH coordindates. 
    end

    E = angles; 
    %[rad]Brings all angles together in the order of Roll, Pitch, Yaw. 

    E = E * 180 / pi;
    %[deg]Converts all Euler angles from radians to degrees.

    %-----------------------------------------------------------------------------------------------

    ScreenSize = get(0,'ScreenSize');
    %[]Determines the location and size of the current monitor.

    Window = figure( ...
        'Color','w', ...
        'Name','PROJECTILE EULER ANGLES', ...
        'NumberTitle','Off', ...
        'OuterPosition',ScreenSize);
    %[]Opens a new window and adjusts its properties.

    %-----------------------------------------------------------------------------------------------

    Axes = zeros(1,3);
    %[]Allocates memory for the subplot axes.

    for k = 1:3

        Axes(k) = subplot(3,1,k, ...
            'FontName','Arial', ...
            'FontSize',8, ...
            'FontWeight','Bold', ...
            'NextPlot','Add', ...
            'Parent',Window, ...
            'XGrid','On', ...
            'YGrid','On', ...
            'XLim',XLim, ...
            'YLim',YLim(k,:), ...
            'XTick',XTicks, ...
            'YTick',YTicks{k});
        %[]Adds an axes to the specified window and adjusts its properties.

        title(Titles{k}, ...
            'FontSize',16, ...
            'Parent',Axes(k));
        %[]Adds a title to the specified axes and adjusts its properties.

        xlabel(XLabels, ...
            'FontSize',12, ...
            'Parent',Axes(k));
        %[]Adds a label to the specified x-axis and adjusts its properties.

        ylabel(YLabels{k}, ...
            'FontSize',12, ...
            'Parent',Axes(k));
        %[]Adds a label to the specified x-axis and adjusts its properties.

    end

    %-----------------------------------------------------------------------------------------------

    for k = 1:3

        plot(t,E(k,:), ...
            'Color','k', ...
            'LineStyle','None', ...
            'Marker','.', ...
            'Parent',Axes(k));
        %[]Adds a plot to the specified axes and adjusts its properties.

    end

end
%===================================================================================================