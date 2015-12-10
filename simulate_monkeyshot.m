function HEIGHT = simulate_monkeyshot(init_pos, init_speed, init_angle, init_spin)
    % Initial flight from the racquet
    [t1, params1, fin_t1, fin_params1] = flight2(0, init_pos, ...
        velocity_vector(init_speed, init_angle), init_spin);
    [t2, params2, fin_t2, fin_params2] = bounce2(fin_t1, ...
       fin_params1(1 : 2), fin_params1(3 : 4), fin_params1(5));
    [t3, params3, fin_t3, fin_params3] = flight3(fin_t2, fin_params2(1 : 2),... 
        fin_params2(3 : 4), fin_params2(5));
    plot([params1(:, 1); params2(:, 1); params3(:, 1)], [params1(:, 2); params2(:, 2); params3(:, 2)])
    HEIGHT = fin_params3(end, 2);
    function res = velocity_vector(speed, angle)
        % Takes the magnitude of the velocity and the angle at which the
        % object is moving to the horizontal
        % Returns a velocity vector in the form (vx, vy)
        % Angle is in degrees, therefore must be converted to radians
        angle_rad = angle * pi / 180;
        res = [speed * cos(angle_rad), speed * sin(angle_rad)];
    end

end