%% 2 快速非支配排序和拥挤度计算代码

%% 对初始种群开始排序 快速非支配排序
% 使用非支配排序对种群进行排序。该函数返回每个个体对应的排序值和拥挤距离，是一个两列的矩阵。  
% 并将排序值和拥挤距离添加到染色体矩阵中 
%计算每个粒子被支配的次数，以及每个粒子支配的其他粒子的信息
function f = non_domination_sort_mod(x, M, V)
%chromosome = non_domination_sort_mod(chromosome, M, V)
%pop= non_domination_sort_mod(pop, M, nVar)
[N, ~] = size(x);% N为矩阵x的行数，也是种群的数量50
clear m
front = 1;
F(front).f = [];
individual = [];
 
for i = 1 : N
    individual(i).n = 0; %n是个体i被支配的个体数量/支配i的个体数量
    individual(i).p = [];%p是被个体i支配的个体集合
    for j = 1 : N
        dom_less = 0;    %这三个值是作为媒介来判断i和j的支配情况的
        dom_equal = 0;
        dom_more = 0;
      %  for k = 1 : M        %判断个体i和个体j的支配关系
            if (x(i).F1< x(j).F1) ;
            %if (x(i,V + k) < x(j,V + k))  
                dom_less = dom_less + 1;
            elseif (x(i).F1 == x(j).F1)
                % elseif (x(i,V + k) == x(j,V + k))
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
       % end
        if dom_less == 0 && dom_equal ~= M % 说明i受j支配，相应的n加1，一个大于一个等于或两个大于
            individual(i).n = individual(i).n + 1;
        elseif dom_more == 0 && dom_equal ~= M % 说明i支配j,把j加入i的支配合集中  一个小于一个等于或两个小于
            individual(i).p = [individual(i).p j];
        end
    end   
    if individual(i).n == 0 %个体i非支配等级排序最高，属于当前最优解集，相应的染色体中携带代表排序数的信息
        x(i).rank=1;
       % x(i,M + V + 1) = 1;
        F(front).f = [F(front).f i];%等级为1的非支配解集
    end
end
while ~isempty(F(front).f)
   Q = []; %存放下一个front集合，Q要再每一次填满之后再及时清空
   for i = 1 : length(F(front).f)%循环当前支配解集中的个体
       if ~isempty(individual(F(front).f(i)).p)%个体i有自己所支配的解集
        	for j = 1 : length(individual(F(front).f(i)).p)%循环个体i所支配解集中的个体
            	individual(individual(F(front).f(i)).p(j)).n = ...%...表示的是与下一行代码是相连的， 这里表示个体j的被支配个数减1
                	individual(individual(F(front).f(i)).p(j)).n - 1;
        	   	 if individual(individual(F(front).f(i)).p(j)).n == 0% 如果q是非支配解集，则放入集合Q中
               		%x(individual(F(front).f(i)).p(j),M + V + 1) = ...%个体染色体中加入分级信息
                      %  front + 1;
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
    sorted_based_on_front(i,:) = x(index_of_fronts(i),:);%sorted_based_on_front中存放的是x矩阵按照排序等级升序排序后的矩阵
end
current_index = 0;
%% Crowding distance 计算每个个体的拥挤度
 
for front = 1 : (length(F) - 1)

   y = sorted_based_on_front([]);
    previous_index = current_index + 1;
    for i = 1 : length(F(front).f)
        y(i,:) = sorted_based_on_front(current_index + i,:);
    end
    %y = y(i,:);
    current_index = current_index + i;
        [abc, index_of_objectives] = ...
            sort([y.F1]);

        for j = 1 : length(index_of_objectives)
            sorted_based_on_objective(j,:) = y(index_of_objectives(j),:);
        end
        f_max = ...
            sorted_based_on_objective(length(index_of_objectives),:).F1;
        f_min = sorted_based_on_objective(1, :).F1;
        y(index_of_objectives(length(index_of_objectives))).distance1...
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
        y(index_of_objectives(length(index_of_objectives))).distance2=Inf;
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
