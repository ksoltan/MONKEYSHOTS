% Simulate the ball's flight path for two bounces, beginning with the
% moment right after it hits the racquet
function simulate_tennis(init_pos, init_speed, init_angle)
    % Initial flight from the racquet
    [t1, params, fin_time, fin_params] = flight(0, init_pos, ...
        velocity_vector(init_speed, init_angle));
    X = params(:, 1);
    Y = params(:, 2);
    VX = params(:, 3);
    VY = params(:, 4);
    T = t1;
    num_bounces = 20;
    is_bounce = 1;
    count = 1;
    while count < num_bounces
        if is_bounce
           is_bounce = 0;
           [t, params, fin_t, fin_p] = bounce(fin_time, ...
               fin_params(1 : 2), fin_params(3 : 4));
        else
            is_bounce = 1;
           [t, params, fin_t, fin_p] = flight(fin_time, ...
               fin_params(1 : 2), fin_params(3 : 4));
        end
        count = count + 1;
        fin_time = fin_t;
        fin_params = fin_p;
        X = [X ; params(:, 1)];
        Y = [Y ; params(:, 2)];
        VX = [VX; params(:, 3)];
        VY = [VY; params(:, 4)];
        T = [T; t];
    end
    figure(1)
    plot(X, Y)
    %draw net
    H = 0 : 0.01 : 1.07;
    for i = 1 : length(H)
       N(i) = 11.89; 
    end
    hold on
    plot(N, H)
    figure(2)
    hold on
    plot(T, VX)
    figure(3)
    hold on
    plot(T, VY)
    figure(4)
    hold on
    plot(VX, VY)

    function res = velocity_vector(speed, angle)
        % Takes the magnitude of the velocity and the angle at which the
        % object is moving to the horizontal
        % Returns a velocity vector in the form (vx, vy)
        res = [speed * cosd(angle), speed * sind(angle)];
    end
end