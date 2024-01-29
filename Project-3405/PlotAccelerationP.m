function PlotAccelerationP(t,S,C)

    Titles = {'Body-X Acceleration','Body-Y Acceleration','Body-Z Acceleration','Total Acceleration'};
    %[]Axes title strings.

    XLabels = 'Time (s)';
    %[]X-axes labels.

    YLabels = {'a_x (g''s)','a_y (g''s)','a_z (g''s)','a (g''s)'};
    %[]Y-axes labels.

    %-----------------------------------------------------------------------------------------------

    n = numel(t);
    %[]Number of elements in the modeling time vector.

    A = zeros(3,n);
    %[]Allocates memory for the inertial acceleration vectors.

    a = zeros(1,n);
    %[]Allocates memory for the acceleration magnitudes.

    for k = 1:n

        Rcggs = S(1:3,k);
        %[km]Projectile position WRT the ground station in NED coordinates.

        Vcggs = S(4:6,k);
        %[km/s]Projectile velocity WRT the ground station in NED coordinates.

        Q = S(10:13,k);
        %[-]Quaternions

        dSdt = ProjectileEom1P(t(k),S(:,k),C);
        %[km/s,km/s^2]State vector derivative WRT the ground station in NED coordinates.

        Acggs = dSdt(4:6);
        %[km/s^2]Projectile non-inertial acceleration WRT the ground station in NED coordinates.

        A(:,k) = C.GS.Agse + cross(C.GS.We,cross(C.GS.We,Rcggs)) + 2 * cross(C.GS.We,Vcggs) + Acggs;
        %[km/s^2]Projectile inertial acceleration WRT the Earth in NED coordinates.

        Rcge = C.GS.Rgse + Rcggs;
        %[km]Projectile position WRT the Earth in NED coordinates.

        NedToBody = Ned2Body(Rcge,Q,C);
        %[]Matrix that transforms vectors from NED coordinates to Body coordinates.

        A(:,k) = (NedToBody * A(:,k)) ./ C.E.g;
        %[g's]Projectile acceleration WRT the Earth in BODY coordinates.

        a(k) = norm(A(:,k));
        %[g's]Projectile acceleration WRT the Earth.

    end


    %-----------------------------------------------------------------------------------------------

    XLim = [0,ceil(max(t))];
    %[s]X-axis domain.

    YLim = [ ...
        floor(min(A(1,:))), ceil(max(A(1,:))); ...
        floor(min(A(2,:))), ceil(max(A(2,:))); ...
        floor(min(A(3,:))), ceil(max(A(3,:))); ...
        floor(min(a)), ceil(max(a))];
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
        'Name','PROJECTILE ACCELERATION', ...
        'NumberTitle','Off', ...
        'OuterPosition',ScreenSize);
    %[]Opens a new window and adjusts its properties.

    %-----------------------------------------------------------------------------------------------

    Axes = zeros(1,4);
    %[]Allocates memory for all axes.

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

        plot(t,A(k,:), ...
            'Color','k', ...
            'LineStyle','None', ...
            'Marker','.', ...
            'Parent',Axes(k));
        %[]Adds a plot to the specified axes and adjusts its properties.

    end

    plot(t,a, ...
        'Color','k', ...
        'LineStyle','None', ...
        'Marker','.', ...
        'Parent',Axes(4));

end
%===================================================================================================