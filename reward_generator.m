clear all; close all; clc;

dim = 50;

%% Ocean Border Reward Generation
Rborder = zeros(dim);
ocean_penalty = -500;
% Horizontal/vertical XY bands 
Rborder(:,[1:2, 47:50]) = ocean_penalty; % Horizontal y bands
Rborder([1:3, 49:50],:) = ocean_penalty; % Vertical x bands
% Bottom left ocean
Rborder(4:15, 3:12) = ocean_penalty;
Rborder(4:8, 13:16) = ocean_penalty;
Rborder(9:10, 13:14) = ocean_penalty;
Rborder(4:6, 17:18) = ocean_penalty;
Rborder(16:22, 3:4) = ocean_penalty;
% Bottom right ocean
Rborder(33:43, 3:4) = ocean_penalty;
Rborder(44:48, 3:8) = ocean_penalty;
Rborder(47:48, 9:18) = ocean_penalty;
% Top left ocean
Rborder(4:8, 44:46) = ocean_penalty;
Rborder(4:5, 33:43) = ocean_penalty;
% Top right ocean
Rborder(21:48, 44:46) = ocean_penalty;
Rborder(44:48, 40:43) = ocean_penalty;
Rborder(47:48, 30:39) = ocean_penalty;

%% Hotspot Reward Generation
Rlocations = zeros(dim);
location_reward = 100;
Rlocations(18:21, 23:26) = 1 * location_reward; % tilted towers
Rlocations(14:16, 33:36) = 0.75 * location_reward; % pleasant park
Rlocations(36:39, 22:24) = 0.75 * location_reward; % retail row
Rlocations(28:30, 18:19) = 0.5 * location_reward; % salty springs
Rlocations(32:33, 32:34) = 0.5 * location_reward; % tomato town
Rlocations(11:13, 17:20) = 0.5 * location_reward; % greasy grove
Rlocations(28:29, 26:27) = 0.5 * location_reward; % dusty depot
Rlocations(29:33, 9:13) = 0.25 * location_reward; % frenzy fields
Rlocations(25:29, 35:39) = 0.25 * location_reward; % anarchy acres

Rmap = Rborder + Rlocations;
save Rmap.mat Rmap
