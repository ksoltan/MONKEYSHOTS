function [t, params, fin_time, fin_params] = bounce(init_time, init_pos, init_velocity)
    COR = 0.83; % coefficient of restitution for hard courts
    
    % Unpack variables
    x_bounce = init_pos(1);
    y_bounce = init_pos(2);
    vx_bounce = init_velocity(1);
    vy_bounce = init_velocity(2);
    
    t = [init_time + 0.0001];
    params = [x_bounce, y_bounce, vx_bounce, -vy_bounce * COR];
    fin_time = [init_time + 0.0001];
    fin_params = [x_bounce, y_bounce, vx_bounce, -vy_bounce * COR];
end