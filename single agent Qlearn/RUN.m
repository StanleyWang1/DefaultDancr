clear all; close all; clc;

num_iters = 250;
S_small = QLearn('./DATA.mat', 0.95, 0.1);
tic;
for n = 1:num_iters
    for i = 1:numel(S_small.s) % incrementally update Q w/ each sample
        s = S_small.s(i);
        a = S_small.a(i);
        r = S_small.r(i);
        sp = S_small.sp(i);
        S_small.Q(s,a) = S_small.Q(s,a) + S_small.update_Q(s, a, r, sp);
    end
    disp(num2str(n))
end
toc;
S_small.print_policy('./single_agent.policy');

return;
return;
return;

%% SMALL DATASET
num_iters = 500;
S_small = QLearn('./data/small.csv', 0.95, 0.0125);
tic;
for n = 1:num_iters
    for i = 1:numel(S_small.s) % incrementally update Q w/ each sample
        s = S_small.s(i);
        a = S_small.a(i);
        r = S_small.r(i);
        sp = S_small.sp(i);
        S_small.Q(s,a) = S_small.Q(s,a) + S_small.update_Q(s, a, r, sp);
    end
    disp(num2str(n))
end
toc;
S_small.print_policy('./small.policy');

%% MEDIUM DATASET
num_iters = 250;
S_med = QLearn('./data/medium.csv', 1, 0.2);
tic;
for n = 1:num_iters
    for i = 1:numel(S_med.s) % incrementally update Q w/ each sample
    s = S_med.s(i);
    a = S_med.a(i);
    r = S_med.r(i);
    sp = S_med.sp(i);
    S_med.Q(s,a) = S_med.Q(s,a) + S_med.update_Q(s, a, r, sp);
    end
    disp(num2str(n))
end
toc;
S_med.print_policy('./medium.policy');

%% LARGE DATASET
num_iters = 250;
S_large = QLearn('./data/large.csv', 0.95, 0.1);
tic;
for n = 1:num_iters
    for i = 1:numel(S_large.s) % incrementally update Q w/ each sample
        s = S_large.s(i);
        a = S_large.a(i);
        r = S_large.r(i);
        sp = S_large.sp(i);
        S_large.Q(s,a) = S_large.Q(s,a) + S_large.update_Q(s, a, r, sp);
    end
    disp(num2str(n))
end
toc;
S_large.print_policy('./large.policy');
