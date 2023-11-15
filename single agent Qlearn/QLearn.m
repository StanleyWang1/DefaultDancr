classdef QLearn
    % Properties
    properties
        % IMPORTED DATA
        s % sampled states
        a % sampled actions
        r % sampled rewards
        sp % sampled next states
        % Q-LEARN PARAMETERS
        n_state % dimension of state space
        n_action % dimension of action space
        Q % Action value function data structure Q(s, a)
        % DISCOUNT AND LEARNING RATES
        alpha % learning rate
        discount % discount factor
    end
    % Methods
    methods
        %% CONSTRUCTOR
        function obj = QLearn(filename, discount, alpha)
            % Import Data
            load(filename, 'DATA'); % load sampled transition data 
            s_arr = cell2mat(DATA(:,1));
            a_arr = cell2mat(DATA(:,2));
            r_arr = cell2mat(DATA(:,3));
            sp_arr = cell2mat(DATA(:,4));
            % Convert to 1D linear state indices
            flat_s = sub2ind([50, 50, 200], s_arr(:,1), s_arr(:,2), s_arr(:,3));
            flat_sp = sub2ind([50, 50, 200], sp_arr(:,1), sp_arr(:,2), sp_arr(:,3));
            % S,A,R,Sp data for Q-Learning
            obj.s = flat_s; 
            obj.a = a_arr; 
            obj.r = r_arr; 
            obj.sp = flat_sp;
            % Learning rate and discount factor
            obj.alpha = alpha;
            obj.discount = discount;
            % Initialize action value function Q(s,a)
            obj.n_state = 50*50*200;
            obj.n_action = 5;
                % obj.n_state = max(unique(obj.s));
                % obj.n_action = max(unique(obj.a));
            obj.Q = ones(obj.n_state, obj.n_action) * mean(obj.r);
        end
        %% Q UPDATE RULE (single sample incremental update)
        function dQ = update_Q(obj, s, a, r, sp)
            maxQ = max(obj.Q(sp,:));
            dQ = obj.alpha * (r + obj.discount*maxQ - obj.Q(s,a));
        end
        %% PRINT OPTIMAL POLICY FROM ACTION VALUE FUNCTION
        function print_policy(obj, filename)
            % Get optimal policy
            policy = zeros(obj.n_state, 1);
            for i = 1:obj.n_state % optimal action at each state
                Qs_i = obj.Q(i,:);
                [~, a_i] = max(Qs_i);
                policy(i) = a_i;
            end
            % Write policy file
            fileID = fopen(filename, 'w');
            if fileID == -1 % check if file opens properly
                error('Failed to open the file for writing.');
            end
            for i = 1:numel(policy)
                fprintf(fileID, '%d\n', policy(i));
            end
            fclose(fileID);
        end
    end
end