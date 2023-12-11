% Stanley J Wang
% Steven Salah-Eddine
% "DefaultDancr"
% RL Bot for Simulating Game Policies in Battle Royales
% Stanford AA 228 (Fall 2023)

clear all; close all; clc;
addpath('/Users/stanleywang/Documents/GitHub/DefaultDancr');

%% SIMULATION PARAMETERS
% 50x50 XY grid world
dim = 50;
% STORM with 200 ticks
ticks = 200;
r = linspace(30, 5, 200); % storm raddi evolution
cx = linspace(20, 30, 200); cy = linspace(20, 30, 200); % storm center evolution

% rng(228); % will start near tilted
% rng(505); % start in bottom left

%% LOAD PRE-TRAINED POLICY
policy_path = './POLICIES/gamma_0p99';
policy = readtable(policy_path).Var1;

%% INITIALIZE MAP ASSET
imagepath = '/Users/stanleywang/Documents/GitHub/DefaultDancr/assets/map.jpeg';
M = map(imagepath);
figure(1)
M.draw_map();
hold on;

%% INITIALIZE REWARD OVERLAY
Re = reward();
REWARD = M.initialize_reward();
clim([-100, 100]);
colorbar;

%% INITIALIZE STORM
STORM = M.initialize_storm();
% Plot a dashed white circle around the final storm circle
theta = linspace(0, 2*pi, 100);
x_dash = r(end)*M.box_px * cos(theta) + (cx(end)-0.5)*M.box_px;
y_dash = r(end)*M.box_px * sin(theta) + (cy(end)-0.5)*M.box_px;
plot(x_dash, y_dash, '-', 'LineWidth', 3, 'Color', [165/255 ,81/255, 227/255]);

%% INITIALIZE AGENTS
x = [10 15 20 25 30 35 40];
y = [10 15 20 25 30 35 40];
AGENTS = cell(49,1);
for i = 1:7
    for j = 1:7
        ind = sub2ind([7, 7], i, j);
        AGENTS{ind}.handle = M.initialize_agent();
        AGENTS{ind}.x = x(i);
        AGENTS{ind}.y = y(j);
    end
end
% AGENT.x = randi([1 50]); AGENT.y = randi([1 50]); % random starting location
% AGENT.x = 45; AGENT.y = 8;

%% Video creation
vidfile = VideoWriter('./VIDEOS/test.mp4', 'MPEG-4');
vidfile.FrameRate = 30;
vidfile.Quality = 100;
open(vidfile);

%% SIMULATE
TOTAL_REWARDS = zeros(49, 1);
REWARD_TIMESERIES = zeros(200, 1);

for i = 1:ticks
    % STORM Overlay
        % M.update_storm(STORM, [cx(i), cy(i)], r(i));
    % REWARD Overlay
        storm.x = cx(i); storm.y = cy(i); storm.r = r(i);
        M.update_reward(REWARD, Re.Rmap + Re.get_storm(storm));
    % DRAW AND UPDATE AGENT
    for a = 1:49
        M.update_agent(AGENTS{a}.handle, AGENTS{a}.x, AGENTS{a}.y);
        s = sub2ind([50, 50, 200], AGENTS{a}.x, AGENTS{a}.y, i); % linear state
        action = policy(s);
        switch action
            case 1
                AGENTS{a}.y = min(max(AGENTS{a}.y + 1, 1), 50); % up
            case 2
                AGENTS{a}.y = min(max(AGENTS{a}.y - 1, 1), 50); % down
            case 3
                AGENTS{a}.x = min(max(AGENTS{a}.x - 1, 1), 50); % left
            case 4
                AGENTS{a}.x = min(max(AGENTS{a}.x + 1, 1), 50); % right
        end
        % Get reward
        R_comp = Re.Rmap + Re.get_storm(storm);
        TOTAL_REWARDS(a) = TOTAL_REWARDS(a) + R_comp(AGENTS{a}.x, AGENTS{a}.y);
    end
    REWARD_TIMESERIES(i) = mean(TOTAL_REWARDS);
    % Capture and write frame
    frm = getframe(gcf);
    im = imresize(frame2im(frm),1);
    writeVideo(vidfile,im)
    % pause(1/100);
end
close(vidfile)

disp(mean(TOTAL_REWARDS))
disp(std(TOTAL_REWARDS))
save ./REWARDS/rewards_gamma_0p99.mat TOTAL_REWARDS REWARD_TIMESERIES
