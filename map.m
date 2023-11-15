% Stanley J Wang
% Steven Salah-Eddine
% "DefaultDancr"
% RL Bot for Simulating Game Policies in Battle Royales
% Stanford AA 228 (Fall 2023)

classdef map
    properties
        img % downsampled square image to show in background for aesthetics
        dim = 50 % discretize state space to dim x dim rectilinear grid
        img_px = 1000 % rescale image to img_px x img_px pixels
        box_px % size of bounding box of one "state" in grid in image pixel units
    end
    methods
        %% CONSTRUCTOR
        function obj = map(filename)
            orig_img = flipud(imread(filename));
            obj.img = imresize(orig_img, [obj.img_px, obj.img_px]);
            obj.box_px = size(obj.img, 1) / obj.dim;
        end
        %% MAP PLOTTER
        function draw_map(obj)
            % Plot Image
            h = imshow(obj.img);
            set(h, 'AlphaData', 0.5);
            axis on; xlabel('X'); ylabel('Y');
            % Plot Grid
            grid on; 
            set(gca, 'YDir', 'normal');
            set(gca, 'GridLineStyle', '-', 'GridColor', [0.5, 0.5, 0.5], 'LineWidth', 1.25, 'GridAlpha', 0.75);
            xticks(0:obj.box_px:obj.img_px); 
            yticks(0:obj.box_px:obj.img_px);
            scaledXTickValues = xticks/obj.box_px; xticklabels(arrayfun(@num2str, scaledXTickValues, 'UniformOutput', false));
            scaledYTickValues = yticks/obj.box_px; yticklabels(arrayfun(@num2str, scaledYTickValues, 'UniformOutput', false));
        end
        %% STORM PLOTTER
        function P = initialize_storm(obj)
            P = patch('Faces', [], 'Vertices', [], 'FaceColor', [165/255 ,81/255, 227/255], 'FaceAlpha', 0.5);
        end
        function update_storm(obj, P, c, r)
            [F, V] = get_storm(obj, c, r);
            set(P, 'Faces', F, 'Vertices', V);
        end
        function [F, V] = get_storm(obj, c, r)
            cx = c(1); cy = c(2); % center of storm circle
            F = []; V = []; iters = 0; % initialize patch face/vertex data
            % Generate patch faces and vertices
            for xi = 1:obj.dim
                for yi = 1:obj.dim
                   if norm([xi-cx, yi-cy]) >= r % if in storm
                       % falloff = 0.1;
                       % intensity = min(1, falloff*(norm([xi-cx, yi-cy])-r));
                       BLx = obj.box_px*(xi-1); 
                       BLy = obj.box_px*(yi-1);
                       F = [F; [1, 2, 3, 4]+4*iters];
                       V = [V; [BLx, BLy; BLx+obj.box_px, BLy; BLx+obj.box_px, BLy+obj.box_px; BLx, BLy+obj.box_px]];
                       iters = iters + 1;
                   end
                end
            end
        end
        %% AGENT PLOTTING FUNCTIONS
        function P = initialize_agent(obj)
            P = patch('Faces', [], 'Vertices', [], 'FaceColor', 'red');
        end
        function update_agent(obj, P, x, y)
            [F, V] = obj.get_agent(x, y);
            set(P, 'Faces', F, 'Vertices', V);
        end
        function [F, V] = get_agent(obj, x, y)
            % Faces and vertices for agent at x and y
            BLx = obj.box_px*(x-1); 
            BLy = obj.box_px*(y-1);
            sidelength = obj.box_px;
            F = [1, 2, 3, 4];
            V = [BLx, BLy; BLx+sidelength, BLy; BLx+sidelength, BLy+sidelength; BLx, BLy+sidelength];
        end
        %% REWARD OVERLAY PLOTTING FUNCTION
        function P = initialize_reward(obj)
            numColors = 256;
            customColormap = [linspace(1, 0, numColors)', linspace(0, 1, numColors)', zeros(numColors, 1)];
            % colormap(customColormap); % You can choose a different colormap
            P = patch('Faces', [], 'Vertices', []);
        end
        function update_reward(obj, P, R)
            [F, V, C] = obj.get_reward(R);
            set(P, 'Faces', F, 'Vertices', V, 'FaceVertexCData',C,'FaceColor','flat', 'FaceAlpha', 0.5);
        end
        function [F, V, C] = get_reward(obj, R)
            F = []; V = []; iters = 0; % initialize patch face/vertex data
            C = [];
            % Generate patch faces and vertices
            for xi = 1:obj.dim
                for yi = 1:obj.dim
                   BLx = obj.box_px*(xi-1); 
                   BLy = obj.box_px*(yi-1);
                   F = [F; [1, 2, 3, 4]+4*iters];
                   V = [V; [BLx, BLy; BLx+obj.box_px, BLy; BLx+obj.box_px, BLy+obj.box_px; BLx, BLy+obj.box_px]];
                   iters = iters + 1;
                   % Map reward R(x,y) to color
                   Rxy = R(xi, yi);
                   % normalized_Rxy = (Rxy + 1000) / (100 + 1000); % assume Rxy between [-1000,100]
                   C = [C; Rxy];
                end
            end
        end
    end
end