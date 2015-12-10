% Find optimal initial horiz velocity and spin at which to hit a tennisball to
% make a successful monkeyshot
function monkeyshot()
    % Loop through initial speed and angle combinations
%     speed = 30 : 60;
%     angle = 5 : 89;
    speed = 5 : 0.2 : 18;
    angle = 50 : 0.5 : 90;
    heights = zeros(length(speed), length(angle));
    for s = 1 : length(speed)
        for a = 1 : length(angle)
            % baseball simulation returns the final height of the ball
            h = simulate_monkeyshot([0, 1], speed(s), angle(a), -200);
            if h > 0.914
                fprintf('Speed: %d, Angle: %d, HEIGHT: %d\n', speed(s), angle(a), h)
            end
            heights(s, a) = h;
        end
    end
    figure(1)
    % plot the height of the ball as a function of angle and speed
    pcolor(angle, speed, heights);
    hold on
    % Plot line to show where the ball ends up close to the 12 m height is 
    %(the wall) and 1 m, close to the ground
    clabel(contour(angle, speed, heights, [0.914, 1.914, 2.914]), 'LineColor', 'w', 'LineWidth', 2)
end