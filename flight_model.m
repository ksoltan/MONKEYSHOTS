function flight_model(init_velocity, init_angle)
    % tennis ball constants
    m = 0.145; % kg
    r = 0.07468; % m
    A = pi * r ^ 2; % cross sectional area, m
    C_D = 0.5;
    COR = 0.83; % coefficient of restitution for hard courts
    
    % Environment constants
    air_density = 1.2; % kg / m^3
    g = 9.8; % m / s^2
    
    % Run the main function
    main()
    
    function main()   
        simulate()
    end
    
    function simulate()
        options = odeset('Events', @event_function);
        % Modeling the flight of the ball before the first bounce, after it
        % ileaves the racquet
        [Time1, Y1, TE1, YE1] = ode45(@change, [0, 100], [0, 3, ...
            velocity_vector(init_velocity, init_angle)], ...
            options);
        x_bounce = YE1(1);
        y_bounce = YE1(2);
        vx_bounce = YE1(3);
        vy_bounce = YE1(4);
        
        % Model the flight after the bounce by reversing the y velocity
        [Time2, Y2, TE2, YE2] = ode45(@change, [TE1, 100], [x_bounce, y_bounce, ...
            vx_bounce, -vy_bounce * COR], ...
            options);
        % Plot the trajectory of the ball, x vs y
        figure(1)
        hold on
        plot(Y1(:, 1), Y1(:, 2))
        plot(Y2(:, 1), Y2(:, 2))
        figure(2)
        % Plot the velocity vs time
        hold on
        plot(Time1, Y1(:, 3), 'r')
        plot(Time1, Y1(:, 4), 'b')
        plot(Time2, Y2(:, 3), 'r')
        plot(Time2, Y2(:, 4), 'b')
        legend('v_x', 'v_y')
        
        % Trigger a bounce event when the ball hits the ground
        function [value, isterminal, direction] = event_function(t, params)
           value = params(2); % When the ball is at the ground, y = 0, bounce
           isterminal = 1; % stop function as soon as this event is reached
           direction = 0; % At any zero (when value = 0) consider this event, not 
                          % only when the function is either increasing (1) or 
                          % decreasing (-1)
        end

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