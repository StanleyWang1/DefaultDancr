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

%% VALUE ITERATION
% Consider a SINGLE AGENT w/ spatial/temporal state s = (x, y, t)
    % s has 50x50x200 = 500,000 possible values!
% We have give actions = {1, 2, 3, 4, 5} = {'up', 'down', 'left', 'right', 'nothing'}
    % for now, assume perfect transitions (NO stochasticity)

% Initialize value function
U = zeros(500000, 1);
% Initialize reward
R = reward();
% Discount Factor
gamma = 0.65;

dU_norms = zeros(100,1);
for iters = 1:100
    dU = zeros(500000,1);
    for t = 1:200
        % Find reward at time t
        storm.x = cx(t); storm.y = cy(t); storm.r = r(t);
        R_samp = R.Rmap + R.get_storm(storm);
        for x = 1:50
            for y = 1:50
                s_index = sub2ind([50,50,200], x, y, t);
                % Reward (x,y,t)
                R_s = R_samp(x, y);
                % Value iteration
                terms = zeros(5,1);
                for a = 1:5
                    [xp, yp, tp] = transition(x, y, t, a);
                    sp_index = sub2ind([50,50,200], xp, yp, tp);
                    terms(a) = R_s + gamma*U(sp_index);
                end
                dU(s_index) = max(terms) - U(s_index);
            end
        end
    end
    U = U + dU;
    dU_norms(iters) = norm(dU, Inf);
    disp(iters);
end

save('value_iter_gamma_0p65.mat', 'U', 'dU_norms');

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
