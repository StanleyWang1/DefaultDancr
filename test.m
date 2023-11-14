% Stanley J Wang
% Steven Salah-Eddine
% "DefaultDancr"
% RL Bot for Simulating Game Policies in Battle Royales
% Stanford AA 228 (Fall 2023)

imagepath = './assets/map.jpeg';

M = map(imagepath);
r = linspace(25, 5, 100);

% Video creation
vidfile = VideoWriter('demo_storm_closure', 'MPEG-4');
vidfile.FrameRate = 30;
vidfile.Quality = 100;
open(vidfile);

% Initialize agent position 
A = [20 23
    35 11
    12 36
    24 32
    15 19
    45 23
    37 22];
colors = {'red', 'green', 'blue', 'cyan', 'magenta', 'yellow', 'white'};
% Simulate
for i = 1:100
    M.draw_map(1);
    hold on;
    for j = 1:7
        R = randi([1, 5]);
        if R == 1
            A(j,1) = max(min(A(j,1) + 1, 50), 0);
        elseif R == 2
            A(j,1) = max(min(A(j,1) - 1, 50), 0);
        elseif R == 3
            A(j,2) = max(min(A(j,2) + 1, 50), 0);
        elseif R == 4
            A(j,2) = max(min(A(j,2) - 1, 50), 0);
        end
        M.draw_agent(1, A(j,1), A(j,2), colors{j});
    end
    M.draw_storm(1, [20,23], r(i));
    hold off;
    
    % Capture and write frame
    frm = getframe(gcf);
    im = imresize(frame2im(frm),1);
    writeVideo(vidfile,im)
end
close(vidfile)
% set(gcf, 'position', [ 1   676   208*3   165*3]);
