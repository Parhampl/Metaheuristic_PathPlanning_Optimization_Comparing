function [e, elapsed_time ,fbest, nbest, mins, ns] = FireFly_Optimization(n, alpha, beta0, gamma, theta, d, Lb, Ub, ns, Lightn, x11, y11, x22, y22, e, mins, f_tot)
    fbest = 0; % Best fitness for exit condition

    % Start timing

    tic;

    while fbest + 959.6407 > 0.01 % Exit condition



        scale = abs(Ub - Lb); % Scale of the optimization problem

        % Two loops over all the n fireflies
        for i = 1:n
            for j = 1:n
                Lightn(i) = egg_holder(ns(i, :)); % Call the objective
                if Lightn(i) >= Lightn(j) % Brighter/more attractive
                    r = sqrt(sum((ns(i, :) - ns(j, :)).^2));
                    beta = beta0 * exp(-gamma * r.^2); % Attractiveness
                    steps = alpha * (rand(1, d) - 0.5) .* scale;
                    ns(i, :) = ns(i, :) + beta * (ns(j, :) - ns(i, :)) + steps;
                end
            end
        end

        % Ensure new fireflies are within bounds/limits
        for i = 1:n

            nsol_tmp = ns(i, :);

            I = nsol_tmp < Lb;
            nsol_tmp(I) = Lb(I);

            J = nsol_tmp > Ub;
            nsol_tmp(J) = Ub(J);

            ns(i, :) = nsol_tmp;
            Lightn(i) = egg_holder(ns(i, :));
        end

        % Rank fireflies by their light intensity/objectives
        [Lightn, Index] = sort(Lightn);
        nsol_tmp = ns;

        for i = 1:n
            ns(i, :) = nsol_tmp(Index(i), :);
        end

        % Find the current best solution
        fbest = Lightn(1);
        nbest = ns(1, :);
        e = e + 1;
        mins = [mins fbest];

        %Randomization Damping

        alpha = alpha * theta; % Reduce alpha by a factor theta

         % Reset the whole initial swarm and alpha factor
        if alpha < 1e-4 % To avoid getting stuck in the loop
            alpha = 0.9;
%             for i = 1:n
%                 ns(i, :) = Lb + (Ub - Lb) .* rand(1, d); % Randomization
%                 Lightn(i) = egg_holder(ns(i, :)); % Evaluate objectives
%             end
        end

    end
    elapsed_time=toc;

    
end
