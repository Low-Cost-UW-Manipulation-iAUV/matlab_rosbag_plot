clear rosbag_wrapper;
clear ros.Bag;
clear all
clc 
close all
%% Load a bag and get information about it
% Using load() lets you auto-complete filepaths.
bag = ros.Bag.load('2014-10-28-14-04-48.bag');
bag.info()
%% Read all messages on a few topics
topic1 = 'imu/data';	% make sure it matches EXACTLY, including all / or without / the data shown in the command window here
topic2 = 'imu/position';

%% Re-read msgs on topic1 and get their metadata
[imu_data, imu_data_meta] = bag.readAll(topic1);
[imu_position, imu_position_meta] = bag.readAll(topic2);

fprintf('Got %i messages, first one at time %f\n', ...
length(imu_data), imu_data_meta{1}.time.time);

accessor = @(Imu) Imu.linear_acceleration;
[acceleration] = ros.msgs2mat(imu_data, accessor); % Convert struct to 3-by-N matrix of linear velcoity
times_acc = cellfun(@(x) x.time.time, imu_data_meta); % Get timestamps
pulled_down_acc = times_acc-times_acc(1);

figure(213123);
% Plot linear speed over time
plot(pulled_down_acc, acceleration);
ylim([-5 5]);


%% Plot the position
accessor = @(Vector3) Vector3;
[position] = ros.msgs2mat(imu_position, accessor); % Convert struct to 3-by-N matrix of linear velcoity
times_pos = cellfun(@(x) x.time.time, imu_position_meta); % Get timestamps
pulled_down_pos = times_pos-times_pos(1);

figure(4352242);
plot (pulled_down_pos, position);
%% Learn more
