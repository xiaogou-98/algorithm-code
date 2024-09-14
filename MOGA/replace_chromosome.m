function f  = replace_chromosome(intermediate_chromosome, M, V, pop) %精英策略
%lastpop = replace_chromosome(intermediate_pop, M, nVar, nPop)
 
[N, m] = size(intermediate_chromosome);
[temp,index] = sort([intermediate_chromosome.rank]);
 
clear temp m
for i = 1 : N
    sorted_chromosome(i,:) = intermediate_chromosome(index(i),:);
end
 
max_rank = max([intermediate_chromosome.rank]);
 
previous_index = 0;
for i = 1 : max_rank
    current_index = max(find([sorted_chromosome.rank] == i));  
    if current_index > pop
        remaining = pop - previous_index;
        temp_pop = ...
            sorted_chromosome(previous_index + 1 : current_index, :);
        [temp_sort,temp_sort_index] = ...
            sort([temp_pop.distance],'descend');
        for j = 1 : remaining
            f(previous_index + j,:) = temp_pop(temp_sort_index(j),:);
        end
        return;
    elseif current_index < pop
        f(previous_index + 1 : current_index, :) = ...
            sorted_chromosome(previous_index + 1 : current_index, :);
    else
        f(previous_index + 1 : current_index, :) = ...
            sorted_chromosome(previous_index + 1 : current_index, :);
        return;
    end
    previous_index = current_index;
end
end