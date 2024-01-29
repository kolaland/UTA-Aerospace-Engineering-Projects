   function PlotPositionP(t,Rcggs)

    % INPUTS >> 
    % Rcggs  : in NED 

    Titles = {'Northern Displacement','Eastern Displacement','Zenith Displacement','Linear Range'};
    %[]Axes titles.

    XLabels = 'Time (s)';
    %[]X-axes labels.

    YLabels = {'North (km)','East (km)','Zenith (km)','Range (km)'};
    %[]Y-axes labels.

    %-----------------------------------------------------------------------------------------------

    n = numel(t);
    %[]Number of elements in the modeling time vector.

    Range = zeros(1,n);
    %[]Allocates memory for the projectile linear ranges WRT the ground station.

    for k = 1:n

        Range(k) = norm(Rcggs(:,k));
        %[km]Projectile range WRT the ground station in NED coordinates.

    end

    %-----------------------------------------------------------------------------------------------

    Rcggs(3,:) = -1 * Rcggs(3,:);
    %[km]Replace all the elements in z in Zenith (Up) direction. 

    XLim = [0,ceil(max(t))];
    %[s]X-axis domain.

    YLim = [ ...
        floor(min(Rcggs(1,:))), ceil(max(Rcggs(1,:))); ...
        floor(min(Rcggs(2,:))), ceil(max(Rcggs(2,:))); ...
        floor(min(Rcggs(3,:))), ceil(max(Rcggs(3,:))); ...
        floor(min(Range)), ceil(max(Range))];
    %[km]Y-axis ranges.

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
        'Name','PROJECTILE POSITION WITH RESPECT TO THE GROUND STATION', ...
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

        plot(t,Rcggs(k,:), ...
            'Color','k', ...
            'LineStyle','None', ...
            'Marker','.', ...
            'Parent',Axes(k));
        %[]Adds a plot to the specified axes and adjusts its properties.

    end

    plot(t,Range, ...
        'Color','k', ...
        'LineStyle','None', ...
        'Marker','.', ...
        'Parent',Axes(4));
    %[]Adds a plot to the specified axes and adjusts its properties.

end
%===================================================================================================