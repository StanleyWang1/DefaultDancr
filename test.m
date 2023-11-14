% Stanley J Wang
% Steven Salah-Eddine
% "DefaultDancr"
% RL Bot for Simulating Game Policies in Battle Royales
% Stanford AA 228 (Fall 2023)

clear all; close all; clc;

%% INITIALIZE MAP ASSET
imagepath = './assets/map.jpeg';
M = map(imagepath);
figure(1)
M.draw_map();
hold on;

%% INITIALIZE AGENTS
num_agents = 10;
AGENTS.handle = cell(num_agents, 1); % array of graphics handle for agents
AGENTS.x = randi([0, M.dim], num_agents, 1);
AGENTS.y = randi([0, M.dim], num_agents, 1);
for i = 1:num_agents
    AGENTS.handle{i} = M.initialize_agent();
end

%% INITIALIZE STORM
ticks = 200; % total number of time steps (part of STATE)
r = linspace(30, 5, 200);
cx = linspace(20, 30, 200);
cy = linspace(20, 30, 200);
STORM = M.initialize_storm();
% Plot a dashed white circle around the final storm circle
theta = linspace(0, 2*pi, 100);
x_dash = r(end)*M.box_px * cos(theta) + (cx(end)-0.5)*M.box_px;
y_dash = r(end)*M.box_px * sin(theta) + (cy(end)-0.5)*M.box_px;
plot(x_dash, y_dash, '-', 'LineWidth', 3, 'Color', [165/255 ,81/255, 227/255]);

% Video creation
% vidfile = VideoWriter('demo_storm_closure', 'MPEG-4');
% vidfile.FrameRate = 30;
% vidfile.Quality = 100;
% open(vidfile);

%% SIMULATE
for i = 1:ticks
    M.update_storm(STORM, [cx(i), cy(i)], r(i))
    for j = 1:num_agents
        R = randi([1, 5]);
        if R == 1
            AGENTS.x(j) = max(min(AGENTS.x(j) + 1, 50), 0);
        elseif R == 2
            AGENTS.x(j) = max(min(AGENTS.x(j) - 1, 50), 0);
        elseif R == 3
            AGENTS.y(j) = max(min(AGENTS.y(j) + 1, 50), 0);
        elseif R == 4
            AGENTS.y(j) = max(min(AGENTS.y(j) - 1, 50), 0);
        end
        M.update_agent(AGENTS.handle{j}, AGENTS.x(j), AGENTS.y(j))
    end
    % Capture and write frame
    % frm = getframe(gcf);
    % im = imresize(frame2im(frm),1);
    % writeVideo(vidfile,im)
    pause(1/30)
end
% close(vidfile)
% set(gcf, 'position', [ 1   676   208*3   165*3]);
