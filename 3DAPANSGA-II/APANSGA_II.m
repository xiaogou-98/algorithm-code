global V M etac etam pop_size 

%% code starts
M=3;
pop_size=100;           % Population size
no_runs = 2;              
gen_max=150;            % MAx number of generations - stopping criteria
fname='test_case';      % Objective function and constraint evaluation

%% Data Loading

V=19; load testdata.mat;

etac = 20;                  % crossover
etam = 20;                  % mutation / mutation constant

A = [a';0 demand];

Q=[];
for run = 1:no_runs
%% Initial population & Objective function evaluation 
    D = Haversin(a);
    x = zeros(pop_size,V);
    x(1,:) = CW(A,D,lorry);
    for j = 2:pop_size
%         x(j,:) = randperm(V);
        x(j,:) = angle(a);
    end
for i =1:pop_size
    [ff(i,:),err(i,:)] = feval(fname,x(i,:),D,demand,time,lorry);         % Objective function evaulation 
end
error_norm=normalisation(err);                      % Normalisation of the constraint violation
population_init=[x ff error_norm];
[population,front]=NDS_CD_cons(population_init);    % Non domination Sorting on initial population
    
%% Generation Starts
for gen_count=1:gen_max
% selection (Parent Pt of 'N' pop size)
parent_selected=tour_selection(population);                     % 10 Tournament selection
%% Reproduction (Offspring Qt of 'N' pop size)
child_offspring  = genetic_operator(parent_selected(:,1:sum(V)),V);    % crossover and mutation
child_offspring1  = round(child_offspring);
%% 
%% 
for ii = 1:pop_size
    [fff(ii,:),err(ii,:)] = feval(fname,child_offspring(ii,:),D,demand,time,lorry);% objective function evaluation for offspring
end
error_norm=normalisation(err);  
child_offspring=[child_offspring fff error_norm];

%% INtermediate population (Rt= Pt U Qt of 2N size)
population_inter=[population(:,1:sum(V)+M+1) ; child_offspring(:,1:sum(V)+M+1)];
[population_inter_sorted front]=NDS_CD_cons(population_inter);              % Non domination Sorting on offspring
%% Replacement - N
new_pop=replacement(population_inter_sorted, front);
population=new_pop;
end
new_pop=sortrows(new_pop,sum(V)+1);
paretoset(run).trial=new_pop(:,1:sum(V)+M+1);
Q = [Q; paretoset(run).trial];                      % Combining Pareto solutions obtained in each run
test = sort (Q(:,end-3:end-1));
end
%% Result                                    
[pareto_filter,front]=NDS_CD_cons(Q);               % Applying non domination sorting on the combined Pareto solution set
rank1_index=find(pareto_filter(:,sum(V)+M+2)==1);        % Filtering the best solutions of rank 1 Pareto
pareto_rank1=pareto_filter(rank1_index,1:sum(V)+M);