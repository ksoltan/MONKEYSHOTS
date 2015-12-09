%% The init_velocity should have a v_y negative, because the ball is flying downwards!
% Spin: TOPSPIN WILL BE POSITIVE, BACKSPIN IS NEGATIVE VALUE in rad/s
function [t, params, fin_time, fin_params] = bounce2(init_time, init_pos, init_velocity, init_spin)
    % Tennis ball constants
    m = 0.058; % kg
    r = 0.07 / 2; % m
    r_inner = r - 0.003; % m
    A = pi * r^2; % cross sectional area, m
    k = 14.3 * 1e3; % N / m
    g = -9.8; % m / s^2
    COF = 0.7;
    COR = 0.8;
    [t, params, fin_time, fin_params] = simulate();
    
        % Returns the final params of the ball
    function [t, params, fin_time, fin_params] = simulate()
        options = odeset('Events', @event_function);
        [t, params, fin_time, fin_params] = ode45(@change, [init_time, init_time + 2], ...
            [init_pos, init_velocity, init_spin], options);
                fin_params(3) = fin_params(3) * COR;
        fin_params(4) = fin_params(4) * COR;
%        fprintf('final velocity: %d, %d\n', fin_params(3), fin_params(4))
        subplot(3, 2, 1); plot(params(:, 1), params(:, 2))
        hold on
        xlabel('X pos')
        ylabel('Y pos')
        subplot(3, 2, 2); plot(t, params(:, 5))
        hold on
        xlabel('Time')
        ylabel('Spin')
        subplot(3, 2, 3); plot(t, params(:, 3))
        hold on
        xlabel('Time')
        ylabel('Vx')
        subplot(3, 2, 4); plot(t, params(:, 4))
        hold on
        xlabel('Time')
        ylabel('Vy')
        subplot(3, 2, 5); plot(t, params(:, 5) * -r)
        hold on
        xlabel('Time')
        ylabel('Vbottom')
        subplot(3, 2, 6); plot(t, params(:, 3) + params(:, 5) * -r, 'r')
        hold on
        xlabel('Time')
        ylabel('Vbottom + Vx')
        %figure(2)
        %comet(params(:, 1), params(:, 2))
        
        % Trigger event when the ball is leaving the ground, defined as its
        % center of gravity being 1 radius above the ground
        function [value, isterminal, direction] = event_function(t, params)
           % To trigger, the value should equal 0.
           value = params(2);
           if params(2) >= r
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
       spin = params(5);
       % change in position is velocity
       dPosdt = V;
       % change in velocity is acceleration
       dVdt = acceleration(t, Pos, V, spin);
       res = [dPosdt; dVdt];
       %fprintf('Spin: %d, dwdt: % d\n Vx: %d, Vbottom: %d\n\n', spin, dVdt(3), V(1), spin * r)
    end

    function res = acceleration(t, Pos, V, spin)
        y = Pos(2); % distance of top of the ball from ground
        v_x = V(1);
        % if positive spin makes the ball rotate forward, the bottom of the
        % ball is going opposite the spin direction
        v_bot = -spin * r;
        spring = -k * (y - r); % Force of spring goes opposite the velocity of the ball
        % Force of gravity
        gravity = m * g;
       % Total vertical acceleration is the vertical component of drag and
       % the acceleration due to gravity
       dvydt = (gravity + spring) / m;
       normal_force = spring;
       dir_f = -sign(v_x + v_bot);
%        if v_x + v_bot > 0
%            dir_f = -1;
%        else if v_x + v_bot < 0
%                dir_f = 1;
%            end
%        end
       friction = dir_f * COF * normal_force;
       % Total horizontal acceleration is slowed down by friction
       dvxdt = friction / m;
       I = 2 * m / 5 * ((r^5 - r_inner^5) / (r^3 - r_inner^3));
       dwdt = -r * friction / I;
       res = [dvxdt; dvydt; dwdt];
    end

end