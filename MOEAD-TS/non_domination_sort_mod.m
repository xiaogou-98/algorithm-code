function f = non_domination_sort_mod(x, M, V)

[N, ~] = size(x);
clear m
front = 1;
F(front).f = [];
individual = [];
 
for i = 1 : N
    individual(i).n = 0; 
    individual(i).p = [];
    for j = 1 : N
        dom_less = 0;   
        dom_equal = 0;
        dom_more = 0;

            if (x(i).F1< x(j).F1) ;
 
                dom_less = dom_less + 1;
            elseif (x(i).F1 == x(j).F1)

                dom_equal = dom_equal + 1;
            else
                dom_more = dom_more + 1;
            
            end
            if (x(i).F2< x(j).F2) ; 
                dom_less = dom_less + 1;
            elseif (x(i).F2 == x(j).F2)
                dom_equal = dom_equal + 1;
            else
                dom_more = dom_more + 1;
            end

        if dom_less == 0 && dom_equal ~= M %
            individual(i).n = individual(i).n + 1;
        elseif dom_more == 0 && dom_equal ~= M 
            individual(i).p = [individual(i).p j];
        end
    end   
    if individual(i).n == 0 
        x(i).rank=1;

        F(front).f = [F(front).f i];
    end
end

while ~isempty(F(front).f)
   Q = [];
   for i = 1 : length(F(front).f)
       if ~isempty(individual(F(front).f(i)).p)
        	for j = 1 : length(individual(F(front).f(i)).p)
            	individual(individual(F(front).f(i)).p(j)).n = ...
                	individual(individual(F(front).f(i)).p(j)).n - 1;
        	   	 if individual(individual(F(front).f(i)).p(j)).n == 0
                      x(individual(F(front).f(i)).p(j)).rank = front + 1;
                    Q = [Q individual(F(front).f(i)).p(j)];
                end
            end
       end
   end
   front =  front + 1;
   F(front).f = Q;
end
 [temp,index_of_fronts] = sort([x.rank]);

for i = 1 : length(index_of_fronts)
    sorted_based_on_front(i,:) = x(index_of_fronts(i),:);
end
current_index = 0;
%% Crowding distance 
for front = 1 : (length(F) - 1)
   y = sorted_based_on_front([]);
    previous_index = current_index + 1;
    for i = 1 : length(F(front).f)
        y(i,:) = sorted_based_on_front(current_index + i,:);
    end

    current_index = current_index + i;
        [abc, index_of_objectives] = ...
            sort([y.F1]);
        for j = 1 : length(index_of_objectives)
            sorted_based_on_objective(j,:) = y(index_of_objectives(j),:);
        end
        f_max = ...
            sorted_based_on_objective(length(index_of_objectives),:).F1;
        f_min = sorted_based_on_objective(1, :).F1;
        y(index_of_objectives(length(index_of_objectives))).distance1..
            = Inf;
        y(index_of_objectives(1)).distance1 = Inf;
         for j = 2 : length(index_of_objectives) - 1
            next_obj  = sorted_based_on_objective(j + 1).F1;
            previous_obj  = sorted_based_on_objective(j - 1).F1;
            if (f_max - f_min == 0)
                y(index_of_objectives(j)).distance1 = Inf;  
            else
                y(index_of_objectives(j)).distance1 = ...
                     (next_obj - previous_obj)/(f_max - f_min);
            end
         end
 [abc, index_of_objectives] = ...
            sort([y.F2]);
           
        for j = 1 : length(index_of_objectives)
            sorted_based_on_objective(j,:) = y(index_of_objectives(j),:);
        end
        f_max = ...
            sorted_based_on_objective(length(index_of_objectives)).F2;
        f_min = sorted_based_on_objective(1).F2;
        y(index_of_objectives(length(index_of_objectives))).distance2
            = Inf;
        y(index_of_objectives(1)).distance2 = Inf;
         for j = 2 : length(index_of_objectives) - 1
          
            next_obj  = sorted_based_on_objective(j + 1).F2;
            previous_obj  = sorted_based_on_objective(j - 1).F2;
            if (f_max - f_min == 0)
                y(index_of_objectives(j)).distance2 = Inf;  
            else
                y(index_of_objectives(j)).distance2 = ...
                     (next_obj - previous_obj)/(f_max - f_min);
            end
         end
         for k = 1:length(F(front).f)
y(k).distance = y(k).distance1 + y(k).distance2;
         end
 
   z(previous_index:current_index,:) = y;
  
end
f = z();
end
