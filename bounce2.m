%% The init_velocity should have a v_y negative, because the ball is flying downwards!
function [t, params, fin_time, fin_params] = bounce2(init_time, init_pos, init_velocity)
    % Tennis ball constants
    m = 0.058; % kg
    r = 0.07 / 2; % m
    r_inner = r - 0.003; % m
    A = pi * r^2; % cross sectional area, m
    k = 14.3 * 1e3; % N / m
    g = -9.8; % m / s^2
    COF = 0.7;
    [t, params, fin_time, fin_params] = simulate();
    
        % Returns the final params of the ball
    function [t, params, fin_time, fin_params] = simulate()
        options = odeset('Events', @event_function);
        [t, params, fin_time, fin_params] = ode45(@change, [init_time, init_time + 2], ...
            [init_pos, init_velocity], options);
        plot(params(:, 1), params(:, 2))
        
        % Trigger event when the ball is leaving the ground, defined as its
        % center of gravity being 1 radius above the ground
        function [value, isterminal, direction] = event_function(t, params)
           % To trigger, the value should equal 0.
           value = params(2);
           if params(2) <= r
               value = 0;
           end
           isterminal = 1; % stop function as soon as this event is reached
           direction = 1; % At any zero (when value = 0) consider this event, not 
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
        y = Pos(2); % distance of top of the ball from ground
        spring = -k * (y + r); % Force of spring goes opposite the velocity of the ball
        % Force of gravity
        gravity = -m * g;
       % Total vertical acceleration is the vertical component of drag and
       % the acceleration due to gravity
       dvydt = (gravity + spring) / m;
       normal_force = m * (g + dvydt);
       friction = - COF * normal_force;
       % Total horizontal acceleration is slowed down by friction
       dvxdt = friction; 
       res = [dvxdt; dvydt];
    end

end