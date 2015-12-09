function [t, params, fin_time, fin_params] = flight2(init_time, init_pos, init_velocity, init_spin)
% Function takes in initial speed and angle of a tennis ball and returns the
% final parameters of the ball when it is within one radius of the ground,
% aka when the bottom of the ball touches the ground.

    % Tennis ball constants
    m = 0.058; % kg
    r = 0.07 / 2; % m
    A = pi * r^2; % cross sectional area, m
    CD = 0.5;
    
    % Environment constants
    p = 1.2; % kg / m^3
    g = 9.8; % m / s^2
    
    % Run the main function
    [t, params, fin_time, fin_params] = simulate();

    % Returns the final params of the ball
    function [t, params, fin_time, fin_params] = simulate()
        options = odeset('Events', @event_function);
        [t, params, fin_time, fin_params] = ode45(@change, [init_time, init_time + 10], ...
            [init_pos, init_velocity, init_spin], options);
        %plot(params(:, 1), params(:, 2))
        
        % Trigger event when the ball hits the ground, defined as its
        % center of gravity being 1 radius above the ground
        function [value, isterminal, direction] = event_function(t, params)
           % To trigger, the value should equal 0.
           value = params(2);
           if params(2) <= r
               value = 0;
           end
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
       spin = params(5);
       % change in position is velocity
       dPosdt = V;
       % change in velocity is acceleration
       dVdt = acceleration(t, Pos, V, spin);
       res = [dPosdt; dVdt];
    end

    function res = acceleration(t, Pos, V, spin)
        % Drag is dependent only on velocity, therefore position and time
        % are not needed. But just in case we included an acceleration
        % source dependent upon them, t and pos are passed into the
        % function.
       vx = V(1);
       vy = V(2);
       % Force of drag
       v = sqrt(vx^2 + vy^2);
       drag = -1/2 * CD * A * p * v^2;
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
       dwdt = 0;
       res = [dvxdt; dvydt; dwdt];
    end
    
end