function flight_model()
    % tennis ball constants
    m = 0.145; % kg
    r = 0.07468; % m
    A = pi * r ^ 2; % cross sectional area, m
    C_D = 0.5;
    
    % Environment constants
    air_density = 1.2; % kg / m^3
    g = 9.8; % m / s^2
    
    % Run the main function
    main()
    
    function main()
    [Time, Y] = ode45(@change, [0, 10], [0, 3, velocity_vector(init_speed, init_angle)]);
    % Plot the trajectory of the ball, x vs y
    figure(1)
    plot(Y(:, 1), Y(:, 2))
    figure(2)
    % Plot the velocity vs time
    hold on
    plot(Time, Y(:, 3), 'r')
    plot(Time, Y(:, 4), 'b')
    legend('v_x', 'v_y')
    end

    function res = velocity_vector(speed, angle)
        % Takes the magnitude of the velocity and the angle at which the
        % object is moving to the horizontal
        % Returns a velocity vector in the form (vx, vy)
        % Angle is in degrees, therefore must be converted to radians
        angle_rad = angle * pi / 180;
        res = [speed * cos(angle_rad), speed * sin(angle_rad)];
    end

    function res = change(t, params)
       % Position is a vector. (x, y)
       Pos = params(1 : 2);
       % velocity is a vector. (vx, vy)
       V = params(3 : 4);
       % change in position is velocity
       dPosdt = V;
       % change in velocity is acceleration
       dVdt = acceleration(t, Pos, V);
       res = [dPosdt; dVdt];
    end

    function res = acceleration(t, Pos, V)
        % Drag is dependent only on velocity, therefore position and time
        % are not needed. But just in case we included an acceleration
        % source dependent upon them, t and pos are passed into the
        % function.
       vx = V(1);
       vy = V(2);
       % Force of drag
       v = sqrt(vx^2 + vy^2);
       drag = -1/2 * C_D * A * air_density * v^2;
       % Force of gravity
       gravity = -m * g;
       
       % Unit velocity vector that points in the horizontal direction
       unit_vx = vx / v;
       % Unit velocity vector that points in the vertical direction
       unit_vy = vy / v;
       
       % Total horizontal acceleration is just the horizontal component of
       % drag. Must be divided by m because F = ma, a = F/m
       dvxdt = (drag * unit_vx) / m;
       % Total vertical acceleration is the vertical component of drag and
       % the acceleration due to gravity
       dvydt = (gravity + drag * unit_vy) / m;
       
       res = [dvxdt; dvydt];
    end
    
end