% Stanley J Wang
% Steven Salah-Eddine
% "DefaultDancr"
% RL Bot for Simulating Game Policies in Battle Royales
% Stanford AA 228 (Fall 2023)

% SINGLE AGENT SIMULATION
% FIXED MAP, FIXED STORM PARAMETERS

clear all; close all; clc;

%% SIMULATION PARAMETERS
% 50x50 XY grid world
dim = 50;
% Storm with 200 ticks
ticks = 200;
r = linspace(30, 5, 200); % storm raddi evolution
cx = linspace(20, 30, 200); cy = linspace(20, 30, 200); % storm center evolution

%% GENERATE TRANSITION DATA
% Consider a SINGLE AGENT w/ spatial/temporal state s = (x, y, t)
    % s has 50x50x200 = 500,000 possible values!
% We have four actions = {1, 2, 3, 4} = {'up', 'down', 'left', 'right'}
    % for now, assume perfect transitions (NO stochasticity)

% Initialize reward
R = reward();

samples = 1e5; 
DATA = cell(samples, 4);

for n = 1:samples
    % Consider random state (x, y, t)
    xi = randi([1 50]); yi = randi([1 50]); ti = randi([1 199]);
    s = [xi, yi, ti];
    % Consider random action a = (1, 2, 3, 4, 5)
    a = randi([1 5]);
    switch a
        case 1
            sp = s + [0 1 1]; % "up", +y
        case 2
            sp = s + [0 -1 1]; % "down", -y
        case 3
            sp = s + [-1 0 1]; % "left" -x
        case 4
            sp = s + [1 0 1]; % "right" +x
        case 5
            sp = s; % stay in place
    end
    % Ensure first two elements of next state are between 1 and 50
    for i = 1:2
        sp(i) = max(1, min(sp(i), 50));
    end
    % Find reward R(s.a.t)
    storm.x = cx(ti); storm.y = cy(ti); storm.r = r(ti);
    R_samp = R.Rmap + R.get_storm(storm);
    R_sa = R_samp(xi, yi);

    DATA{n,1} = s;
    DATA{n,2} = a;
    DATA{n,3} = R_sa;
    DATA{n,4} = sp;
    disp(n);
end
save DATA_100k.mat DATA
