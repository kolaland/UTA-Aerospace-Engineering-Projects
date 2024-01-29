function PlotVelocityP(t,Vcggs)

    % INPUTS >> 
    % Vcggs   : in NED 

    Titles = {'Northern Speed','Eastern Speed','Zenith Speed','Total Speed'};
    %[]Axes title strings.

    XLabels = 'Time (s)';
    %[]X-axes labels.

    YLabels = {'North (km/s)','East (km/s)','Zenith (km/s)','Total (km/s)'};
    %[]Y-axes labels.

    %-----------------------------------------------------------------------------------------------    

    n = numel(t);
    %[]Number of elements in the modeling time vector.

    Speed = zeros(1,n);
    %[]Allocates memory for the speeds WRT the ground station.

    for k = 1:n

        Speed(k) = norm(Vcggs(:,k));
        %[km/s]Projectile speed WRT the ground station.

    end

    %-----------------------------------------------------------------------------------------------

    Vcggs(3,:) = -1 * Vcggs(3,:);
    %[km]Replace all the elements in z in Zenith (Up) direction. 

    XLim = [0,ceil(max(t))];
    %[s]X-axis domain.

    YLim = [ ...
        floor(min(Vcggs(1,:))), ceil(max(Vcggs(1,:))); ...
        floor(min(Vcggs(2,:))), ceil(max(Vcggs(2,:))); ...
        floor(min(Vcggs(3,:))), ceil(max(Vcggs(3,:))); ...
        floor(min(Speed)), ceil(max(Speed))];
    %[km]Y-axes ranges.

    XTicks = linspace(XLim(1),XLim(2),11);
    %[s]X-axis tick mark locations.

    YTicks = [ ...
        {linspace(YLim(1,1),YLim(1,2),11)}; ...
        {linspace(YLim(2,1),YLim(2,2),11)}; ...
        {linspace(YLim(3,1),YLim(3,2),11)}; ...
        {linspace(YLim(4,1),YLim(4,2),11)}];
    %[km]Y-axis tick mark locations.

    %-----------------------------------------------------------------------------------------------
    ScreenSize = get(0,'ScreenSize');
    %[]Determines the location and size of the current monitor.

    Window = figure( ...
        'Color','w', ...
        'Name','PROJECTILE VELOCITY WITH RESPECT TO THE GROUND STATION', ...
        'NumberTitle','Off', ...
        'OuterPosition',ScreenSize);
    %[]Opens a new window and adjusts its properties.

    %-----------------------------------------------------------------------------------------------

    Axes = zeros(1,4);
    %[]Allocates memory for the subplot axes.

    for k = 1:4

        Axes(k) = subplot(2,2,k, ...
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

        plot(t,Vcggs(k,:), ...
            'Color','k', ...
            'LineStyle','None', ...
            'Marker','.', ...
            'Parent',Axes(k));
        %[]Adds a plot to the specified axes and adjusts its properties.

    end

    plot(t,Speed, ...
        'Color','k', ...
        'LineStyle','None', ...
        'Marker','.', ...
        'Parent',Axes(4));
    %[]Adds a plot to the specified axes and adjusts its properties.

end
%===================================================================================================