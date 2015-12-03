% Simulate the ball's flight path for two bounces, beginning with the
% moment right after it hits the racquet
function simulate_tennis(init_pos, init_speed, init_angle)
hold on
    % Initial flight from the racquet
    [t1, params, fin_time, fin_params] = flight2(0, init_pos, ...
        velocity_vector(init_speed, init_angle));
    T = t1;
    X = params(:, 1);
    Y = params(:, 2);
    VX = params(:, 3);
    VY = params(:, 4);
    num_bounces = 4;
    is_bounce = 1;
    count = 0;

    while count < num_bounces
        if is_bounce
            fprintf('BOUNCE\n')
           is_bounce = 0;
           [t, params, fin_t, fin_p] = bounce2(fin_time, ...
               fin_params(1 : 2), fin_params(3 : 4))
           count = count + 1;
        else
            fprintf('FLY\n')
            is_bounce = 1;
           [t, params, fin_t, fin_p] = flight2(fin_time, ...
               fin_params(1 : 2), fin_params(3 : 4))
        end
        fin_time = fin_t;
        fin_params = fin_p
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
%    plot(N, H)
%     figure(2)
%     plot(T, VX)
%     figure(3)
%     plot(T, VY)
    
    function res = velocity_vector(speed, angle)
        % Takes the magnitude of the velocity and the angle at which the
        % object is moving to the horizontal
        % Returns a velocity vector in the form (vx, vy)
        % Angle is in degrees, therefore must be converted to radians
        angle_rad = angle * pi / 180;
        res = [speed * cos(angle_rad), speed * sin(angle_rad)];
    end

end