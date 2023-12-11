clear all; close all; clc;

files = {'rewards_gamma_0p50.mat'
    'rewards_gamma_0p65.mat'
    'rewards_gamma_0p80.mat'
    'rewards_gamma_0p90.mat'
    'rewards_gamma_0p95.mat'
    'rewards_gamma_0p99.mat'};
names = {'\gamma = 0.5'
    '\gamma = 0.65'
    '\gamma = 0.8'
    '\gamma = 0.9'
    '\gamma = 0.95'
    '\gamma = 0.99'};

figure(1)
for i = 1:numel(files)
    load(files{i})
    plot(1:200, REWARD_TIMESERIES, 'linewidth', 1.5);
    hold on;
end
grid on;
xlabel('Iterations'); ylabel('Cumulative Reward');
title('Average Reward across 49 Agents');
set(gca, 'fontsize', 18, 'fontname', 'SF Pro Display')
legend(names, 'fontsize', 18, 'location', 'best'); legend boxoff;