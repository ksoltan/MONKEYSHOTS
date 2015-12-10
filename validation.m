% For validation, examine extreme cases

% Vertical velocity validated because in the following three cases the
% different relationships between vx and vy are present, and vy does not
% have any effect on spin
%% BACKSPIN
%% Low vx, high vy, high backspin
figure(1)
bounce2(0, [0, 0.07 / 2], [5, -30], -500);
% title('Behavior of Tennis Ball With High Backspin, Low Horizontal Velocity, and High Vertical Velocity',...
%     'FontName', 'Times', 'FontSize', 16)

%% Equal vx, equal vy, equal backspin
figure(2)
bounce2(0, [0, 0.07 / 2], [40, -40], -40 / (0.07 / 2));
%% High vx, low vy, low backspin
figure(3)
bounce2(0, [0, 0.07 / 2], [50, -10], -50);
%% TOPSPIN
figure(4)
bounce2(0, [0, 0.07 / 2], [40, -40], 40);