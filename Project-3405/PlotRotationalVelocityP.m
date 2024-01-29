function PlotRotationalVelocityP(t,Wcg)

    % INPUTS >> 
    % Wcg   : in BODY 

    Titles = {'Body-X Angular Rate vs. Time','Body-Y Angular Rate vs. Time','Body-Z Angular Rate vs. Time','Total Angular Rate vs. Time'};
    %[]Axes titles.

    XLabels = 'Time (s)';
    %[]X-axes labels.

    YLabels = {'\omega_x (\circ/s)','\omega_y (\circ/s)','\omega_z (\circ/s)','\omega_{cg} (\circ/s)'};
    %[]Y-axes labels.

    %-----------------------------------------------------------------------------------------------

    n = numel(t);
    %[]Number of elements in the modeling time vector.

    wcg = zeros(3,n);
    %[]Allocates memory for the rotational velocity vectors.

    w = zeros(1,n);
    %[]Allocates memory for the Rotat

    for k = 1:n

        wcg(:,k) = Wcg(:,k) * 180/pi;

        w(k) = norm(wcg(:,k));
        %[rad/s]Aircraft rotational speed.

    end

    %% for scenario 1
    %{
    XLim = [0,ceil(max(t))];
    %[s]X-axis domain.

    YLim = [ ...
        -1, 1; ...
        -1, 1; ...
        -1, 1; ...
         0, 1];
    %[km]Y-axis ranges.

    XTicks = linspace(XLim(1),XLim(2),11);
    %[s]X-axis tick mark locations.

    YTicks = [ ...
        {linspace(YLim(1,1),YLim(1,2),11)}; ...
        {linspace(YLim(2,1),YLim(2,2),11)}; ...
        {linspace(YLim(3,1),YLim(3,2),11)}; ...
        {linspace(YLim(4,1),YLim(4,2),11)}];
    %[km]Y-axis tick mark locations.
    %}

    
    %% for scenario 2 and 3
    %Wcg = Wcg * 180 / pi;
    %[deg/s]Aircraft rotational velocity WRT the CG in BODY coordinates.
    
    %-----------------------------------------------------------------------------------------------

    XLim = [0,ceil(max(t))];
    %[s]X-axis domain.

    YLim = [ ...
        floor(min(wcg(1,:))), ceil(max(wcg(1,:))); ...
        floor(min(wcg(2,:))), ceil(max(wcg(2,:))); ...
        floor(min(wcg(3,:))), ceil(max(wcg(3,:))); ...
        floor(min(w)), ceil(max(w))];
    %[km]Y-axes ranges.

    XTicks = linspace(XLim(1),XLim(2),11);
    %[s]X-axis tick mark locations.

    YTicks = [ ...
        {linspace(YLim(1,1),YLim(1,2),11)}; ...
        {linspace(YLim(2,1),YLim(2,2),11)}; ...
        {linspace(YLim(3,1),YLim(3,2),11)}; ...
        {linspace(YLim(4,1),YLim(4,2),11)}];
    %[km]Y-axis tick mark locations.
    
    %% 
    %-----------------------------------------------------------------------------------------------
    
    ScreenSize = get(0,'ScreenSize');
    %[]Determines the location and size of the current monitor.

    Window = figure( ...
        'Color','w', ...
        'Name','PROJECTILE ROTATIONAL VELOCITY', ...
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

        plot(t,wcg(k,:), ...
            'Color','k', ...
            'LineStyle','None', ...
            'Marker','.', ...
            'Parent',Axes(k));
        %[]Adds a plot to the specified axes and adjusts its properties.

    end

    plot(t,w, ...
        'Color','k', ...
        'LineStyle','None', ...
        'Marker','.', ...
        'Parent',Axes(4));
    %[]Adds a plot to the specified axes and adjusts its properties.

end
%===================================================================================================