% Returns the time at which bounce ended and the parameter values at that
% moment
function [time, results, fin_time, fin_params] = bounce(init_time, init_pos, init_velocity)
    % tennis ball constants
    m = 0.145; % kg
    r = 0.07468; % m
    COR = 0.83; % coefficient of restitution for hard courts
    k = 14.3 * 1e3; % average effective spring constant of tennis ball N/m

    % Environment constants
    g = 9.8; % m / s^2
    
    % Run the main function
    [time, results, fin_time, fin_params] = main();
    
    % Main function must return the result of the ode function: time at
    % which the ode function ended and the final param values
    function [time, results, fin_time, fin_params] = main()
        [time, results, fin_time, fin_params] = simulate();
    end
    
    % Returns the final time and parameter values right after the ball
    % begins to leave the ground again
    function [time, results, fin_time, fin_params] = simulate()
        options = odeset('Events', @event_function);
        % Modeling the flight of the ball before the first bounce, after it
        % ileaves the racquet
        [time, results, fin_time, fin_params] = ode45(@change, [init_time, init_time + 5],...
            [init_pos, init_velocity], ...
            options);
        figure(1)
        %plot(time, results(:, 2))
        
        % Triggered when the ball's center of mass is higher than one
        % radius above the ground, when it is rising back up
        function [value, isterminal, direction] = event_function(t, params)
            value = params(2) - r;
            % When the ball is about to take off, y = 0 and the velocity is increasing
            if params(2) >= r && params(4) >= 0
                disp('hi')
                value = 0;
            end
            disp(value)
            isterminal = 1; % stop function as soon as this event is reached
            direction = 0;
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
    % Vertical dir: pretedn the ball is a spring. The bottom of the ball,
    % (y - r), has hit the bottom. Now, its center of mass continues to
    % move down until the spring force balances out gravity and launches it
    % upward
       x = Pos(1);
       y = Pos(2);

       % Force of effective spring
       spring = -k * (y + r); % change in compression is top of the ball to the ground
       % Force of gravity
       gravity = -m * g;
       
       mag = sqrt(x^2 + y^2); % magnitude of position vector
       % Unit velocity vector that points in the horizontal direction
       unit_x = x / mag;
       % Unit velocity vector that points in the vertical direction
       unit_y = y / mag;
       
       % Total horizontal acceleration is not affected by the vertical
       % spring
       dvxdt = 0;
       % Total vertical acceleration is the acceleration due to gravity vs
       % spring force
       dvydt = (gravity - spring * unit_y) / m;
       
       res = [dvxdt; dvydt];
    end
    
end