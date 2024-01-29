function PlotAltitudeP(t,Rcggs,C)

    % INPUTS >> 
    % t     : in seconds
    % Rcggs : in NED 
    
    Title = 'Projectile Altitude Above Mean Equator';
    %[]Axes title.

    XLabel = 'Time (s)';
    %[]X-axis label.

    YLabel = 'Altitude (km)';
    %[]Y-axis label.

    %-----------------------------------------------------------------------------------------------

    n = numel(t);
    %[]Number of elements in the modeling time vector.

    hcg = zeros(1,n);
    %[]Allocates memory for the projectile altitudes above mean equator.

    %-----------------------------------------------------------------------------------------------

    for k = 1:n

        Rcge = C.GS.Rgse + Rcggs(:,k);
        %[km]Projectile position WRT the Earth in NED coordinates.

        rcge = norm(Rcge);
        %[km]Projectile range WRT the Earth in NED coordinates.

        hcg(k) = rcge - C.E.Re;
        %[km]Projectile altitude above mean equator.

    end

    %-----------------------------------------------------------------------------------------------

    XLim = [0,ceil(max(t))];
    %[s]X-axis domain.

    YLim = [0,ceil(max(hcg))];
    %[km]Y-axis range.

    XTicks = linspace(XLim(1),XLim(2),21);
    %[s]X-axis tick mark locations.

    YTicks = linspace(YLim(1),YLim(2),21);
    %[km]Y-axis tick mark locations.

    %-----------------------------------------------------------------------------------------------

    ScreenSize = get(0,'ScreenSize');
    %[]Determines the location and size of the current monitor.

    Window = figure( ...
        'Color','w', ...
        'Name','PROJECTILE ALTITUDE ABOVE MEAN EQUATOR', ...
        'NumberTitle','Off', ...
        'OuterPosition',ScreenSize);
    %[]Opens a new window and adjusts its properties.

    %-----------------------------------------------------------------------------------------------

    Axes = axes( ...
        'FontName','Arial', ...
        'FontSize',12, ...
        'FontWeight','Bold', ...
        'NextPlot','Add', ...
        'Parent',Window, ...
        'XGrid','On', ...
        'YGrid','On', ...
        'XLim',XLim, ...
        'YLim',YLim, ...
        'XTick',XTicks, ...
        'YTick',YTicks);
    %[]Adds an axes to the specified window and adjusts its properties.

    %-----------------------------------------------------------------------------------------------

    title(Title, ...
        'FontSize',20, ...
        'Parent',Axes);
    %[]Adds a title to the specified axes and adjusts its properties.

    xlabel(XLabel, ...
        'FontSize',16, ...
        'Parent',Axes);
    %[]Adds a label to the specified x-axis and adjusts its properties.

    ylabel(YLabel, ...
        'FontSize',16, ...
        'Parent',Axes);
    %[]Adds a label to the specified y-axis and adjusts its properties.

    %-----------------------------------------------------------------------------------------------

    plot(t,hcg, ...
        'Color','k', ...
        'LineStyle','None', ...
        'Marker','.', ...
        'Parent',Axes);
    %[]Adds a plot to the specified axes and adjusts its properties.

end
%===================================================================================================