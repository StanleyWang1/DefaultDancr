clear all; close all; clc;

files = {'value_iter_gamma_0p50.mat' 
    'value_iter_gamma_0p65.mat' 
    'value_iter_gamma_0p80.mat'
    'value_iter_gamma_0p90.mat'
    'value_iter_gamma_0p95.mat'
    'value_iter_gamma_0p99.mat'};
names = {'\gamma = 0.5'
    '\gamma = 0.65'
    '\gamma = 0.8'
    '\gamma = 0.9'
    '\gamma = 0.95'
    '\gamma = 0.99'};

figure(1)
for i = 1:numel(files)
    load(files{i})
    plot(1:100, dU_norms, 'linewidth', 1.5);
    hold on;
end
grid on;
xlabel('Iterations'); ylabel('max change in U(s)');
title('Value Iteration Convergence')
set(gca, 'fontsize', 18, 'fontname', 'SF Pro Display')
legend(names, 'fontsize', 18, 'location', 'best'); legend boxoff;