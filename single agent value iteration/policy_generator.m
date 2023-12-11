clear all; close all; clc;

%% SIMULATION PARAMETERS
% 50x50 XY grid world
dim = 50;
% Storm with 200 ticks
ticks = 200;
r = linspace(30, 5, 200); % storm raddi evolution
cx = linspace(20, 30, 200); cy = linspace(20, 30, 200); % storm center evolution

%% Load value function (from value iteration)
load('value_iter_gamma_0p50.mat');
gamma = 0.5;

%% POLICY EXTRACTION
% Initialize reward
R = reward();
% Policy data 
POLICY = zeros(500000, 1);

for t = 1:200
    % Find reward at time t
    storm.x = cx(t); storm.y = cy(t); storm.r = r(t);
    R_samp = R.Rmap + R.get_storm(storm);
    for x = 1:50
        for y = 1:50
            s_index = sub2ind([50,50,200], x, y, t);
            % Reward (x,y,t)
            R_s = R_samp(x, y);
            % Optimal policy extraction
            terms = zeros(5, 1);
            for a = 1:5
                [xp, yp, tp] = transition(x, y, t, a);
                sp_index = sub2ind([50,50,200], xp, yp, tp);
                terms(a) = R_s + gamma*U(sp_index);
            end
            [~, argmax_action] = max(terms);
            POLICY(s_index) = argmax_action;
        end
    end
end

% SAVE POLICY
% Write policy file
fileID = fopen('./POLICIES/gamma_0p50', 'w');
if fileID == -1 % check if file opens properly
    error('Failed to open the file for writing.');
end
for i = 1:numel(POLICY)
    fprintf(fileID, '%d\n', POLICY(i));
end
fclose(fileID);

function [xp, yp, tp] = transition(x, y, t, a)
    switch a
        case 1
            xp = x; yp = y+1; tp = t+1; % "up", +y
        case 2
            xp = x; yp = y-1; tp = t+1; % "down", -y
        case 3
            xp = x-1; yp = y; tp = t+1; % "left" -x
        case 4
            xp = x+1; yp = y; tp = t+1; % "right" +x
        case 5
            xp = x; yp = y; tp = t+1;
    end
    % Enforce state bounds
    xp = max(min(xp, 50), 1);
    yp = max(min(yp, 50), 1);
    tp = max(min(tp, 200), 1);
end
