clear rosbag_wrapper;
clear ros.Bag;
clear all
clc 
close all
%% Load a bag and get information about it
% Using load() lets you auto-complete filepaths.
bag = ros.Bag.load('2014-10-28-14-45-08.bag');
bag.info()
%% Read all messages on a few topics
topic1 = '/imu/data';	% make sure it matches EXACTLY, including all / or without / the data shown in the command window here
topic2 = '/imu/deadbanded';
topic3 = '/imu/position';
topic4 = '/imu/velocity';
topic5 = '/imu/velocity_zeroed';


%% Re-read msgs on topic1 and get their metadata
[data_1, meta_1] = bag.readAll(topic1);
[data_2, meta_2] = bag.readAll(topic2);
[data_3, meta_3] = bag.readAll(topic3);
[data_4, meta_4] = bag.readAll(topic4);
[data_5, meta_5] = bag.readAll(topic5);

%% Plot the raw data
accessor = @(Imu) Imu.linear_acceleration;
[plot_data_1] = ros.msgs2mat(data_1, accessor); % Convert struct to 3-by-N matrix of linear velcoity
times_data_1 = cellfun(@(x) x.time.time, meta_1); % Get timestamps
baseline_time_data_1 = times_data_1-times_data_1(1);

figure(1001);
hold all;
% Plot linear speed over time
plot(baseline_time_data_1, plot_data_1);
title('Free Acceleration (no g) [m/s^]');
legend('x','y','z');
ylim([-5 5]);
hold off;

%% Plot the position
accessor = @(Vector3) Vector3;
[plot_data_3] = ros.msgs2mat(data_3, accessor); % Convert struct to 3-by-N matrix of linear velcoity
times_data_3 = cellfun(@(x) x.time.time, meta_3); % Get timestamps
baseline_time_data_3 = times_data_3-times_data_3(1);

figure(1003);
hold all;
plot (baseline_time_data_3, plot_data_3);
title('Position');
legend('x','y','z');
hold off;

%% Plot the Velocity

accessor = @(Vector3) Vector3;
[plot_data_4] = ros.msgs2mat(data_4, accessor); % Convert struct to 3-by-N matrix of linear velcoity
times_data_4 = cellfun(@(x) x.time.time, meta_4); % Get timestamps
baseline_time_data_4 = times_data_4-times_data_4(1);

accessor = @(Vector3) Vector3;
[plot_data_5] = ros.msgs2mat(data_5, accessor); % Convert struct to 3-by-N matrix of linear velcoity
times_data_5 = cellfun(@(x) x.time.time, meta_5); % Get timestamps
baseline_time_data_5 = times_data_5-times_data_5(1);

%% plot x
figure(10041);
hold all;
title('Velocity along x axis');
plot (baseline_time_data_4,plot_data_4(1,:));
plot (baseline_time_data_5,plot_data_5(1,:));
legend('velocity (m/s)', 'velocity after zero detection');
hold off;

%% plot y
figure(10042);
hold all;
title('Velocity along y axis');
plot (baseline_time_data_4,plot_data_4(2,:));
plot (baseline_time_data_5,plot_data_5(2,:));
legend('velocity (m/s)', 'velocity after zero detection');
hold off;

%% plot z
figure(10043);
hold all;
title('Velocity along z axis');
plot (baseline_time_data_4,plot_data_4(3,:));
plot (baseline_time_data_5,plot_data_5(3,:));
legend('velocity (m/s)', 'velocity after zero detection');
hold off;

%% Learn more
