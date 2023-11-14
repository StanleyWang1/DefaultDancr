% Stanley J Wang
% Steven Salah-Eddine
% "DefaultDancr"
% RL Bot for Simulating Game Policies in Battle Royales
% Stanford AA 228 (Fall 2023)

classdef map
    properties
        img % downsampled square image to show in background for aesthetics
        dim = 20 % discretize state space to dim x dim rectilinear grid
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
        function draw_map(obj, fig_num)
            figure(fig_num)
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
        function draw_storm(obj, fig_num)
            figure(fig_num)
        end
    end
end