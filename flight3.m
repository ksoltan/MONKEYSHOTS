function [t, params, fin_time, fin_params] = flight3(init_time, init_pos, init_velocity, init_spin)
% Function takes in initial speed and angle of a tennis ball and returns
% the height of the ball when it is at the net, or if it does not ever
% reach the net after the monkeyshot, some constant incorrect number

    % Tennis ball constants
    m = 0.058; % kg
    r = 0.07 / 2; % m
    A = pi * r^2; % cross sectional area, m
    CD = 0.5;
    
    % Environment constants
    p = 1.2; % kg / m^3
    g = 9.8; % m / s^2
    x_net = 6.40 / 2; % m distance from service line to net
    y_net = 0.914; % m height of net in the middle
    
    % Run the main function
    [t, params, fin_time, fin_params] = simulate();

    % Returns the final params of the ball
    function [t, params, fin_time, fin_params] = simulate()
        options = odeset('Events', @event_function);
        [t, params, fin_time, fin_params] = ode45(@change, [init_time, init_time + 20], ...
            [init_pos, init_velocity, init_spin], options);
        %plot(params(:, 1), params(:, 2))
        
        % Trigger event when the ball is at the net
        function [value, isterminal, direction] = event_function(t, params)
           % To trigger, the value should equal 0.
           value = [params(1) - x_net, params(2)];
%            if params(1) <= x_net || params(2) <= 0;
%                value = 0;
%            end
           isterminal = [1, 1]; % stop function as soon as this event is reached
           direction = [0, 0]; % At any zero (when value = 0) consider this event, not 
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
       CL = 0.15;
       % Force of lift
       
       % Unit velocity vector that points in the horizontal direction
       unit_vx = vx / v;
       % Unit velocity vector that points in the vertical direction
       unit_vy = vy / v;
       
%        % To include lift, must also include the torque on the ball
%        theta = pi / 2;
%        rot_matrix = [cos(theta), -sin(theta); sin(theta), cos(theta)];
%        lift_dir = rot_matrix * [unit_vx; unit_vy]; 
%        lift = 16 / 3 * pi^2 * r^3 * spin * p * v * CL * lift_dir;
%        lift_x = lift(1);
%        lift_y = lift(2);
       % Total horizontal acceleration is the horizontal component of
       % drag and the opposite of the vertical component of lift (lift acts
       % perpendicular to the direction). Must divide by m to get
       % acceleration: F = ma -> a = F / m
       dvxdt = (drag * unit_vx) / m;
       % Total vertical acceleration is the vertical component of drag and
       % the acceleration due to gravity
       dvydt = (gravity + drag * unit_vy) / m;
       dwdt = 0;
       res = [dvxdt; dvydt; dwdt];
    end
end