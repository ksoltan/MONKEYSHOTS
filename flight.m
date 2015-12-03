% Returns the time and the position and velocity vectors at the moment the ball
% hits the ground given an initial velocity and angle. The ball hits the
% ground when its center of mass is separated by a radius length from the
% ground

function [time, results, fin_time, fin_params] = flight(init_time, init_pos, init_velocity)
    % tennis ball constants
    m = 0.145; % kg
    r = 0.07468; % m
    A = pi * r ^ 2; % cross sectional area, m
    C_D = 0.5;

    % Environment constants
    air_density = 1.2; % kg / m^3
    g = 9.8; % m / s^2
    
    % Run the main function
    [time, results, fin_time, fin_params] = main();
    
    % Main function must return the result of the ode function: time at
    % which the ode function ended and the final param values
    function [time, results, fin_time, fin_params] = main()   
        [time, results, fin_time, fin_params] = simulate();
    end
    
    % Returns the final time and parameter values right before the ball
    % hits the ground
    function [time, results, fin_time, fin_params] = simulate()
        options = odeset('Events', @event_function);
        % Modeling the flight of the ball before the first bounce, after it
        % ileaves the racquet
        [time, results, fin_time, fin_params] = ode45(@change, [init_time, init_time + 100],...
            [init_pos, init_velocity], ...
            options);
        %comet(results(:, 1), results(:, 2))
        % Trigger a bounce event when the ball hits the ground
        function [value, isterminal, direction] = event_function(t, params)
            % When the ball is at the ground, the center of mass y should
            % be a radius above the ground, that means the bottom of ball
            % has touched the ground
           value = params(2);
           isterminal = 1; % stop function as soon as this event is reached
           direction = 0; % At any zero (when value = 0) consider this event, not 
                          % only when the function is either increasing (1) or 
                          % decreasing (-1)
        end
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