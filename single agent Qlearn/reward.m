% Stanley J Wang
% Steven Salah-Eddine
% "DefaultDancr"
% RL Bot for Simulating Game Policies in Battle Royales
% Stanford AA 228 (Fall 2023)

classdef reward
    properties
        dim = 50 % HARDCODED for now, may need to change later...
        Rmap % topographic reward associated with map layout
        Rstorm % reward associated with not being in storm
        storm_reward = -200 % base value of being caught in storm
        falloff = 10 % gradient of storm reward (being in storm a tiny bit not too bad...)
    end
    methods
        %% CONSTRUCTOR
        function obj = reward()
            % Initialize rewards
            load Rmap.mat Rmap
            obj.Rmap = Rmap;
            obj.Rstorm = zeros(obj.dim);
        end 
        %% Construct storm reward
        function Rstorm_temp = get_storm(obj, storm)
            cx = storm.x; cy = storm.y; r = storm.r;
            r_mid = r - obj.falloff/3; % construct soft barrier for storm
            Rstorm_temp = zeros(obj.dim); % initialze storm reward
            for xi = 1:obj.dim
                for yi = 1:obj.dim
                    if norm([xi-cx, yi-cy]) >= r_mid % if in storm
                        intensity = min(1, (norm([xi-cx, yi-cy])-r_mid)/obj.falloff);
                        Rstorm_temp(xi, yi) = intensity * obj.storm_reward; 
                    end
                end
            end
        end
    end
end