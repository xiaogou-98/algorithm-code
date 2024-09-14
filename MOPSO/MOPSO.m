clc;
clear;
close all;

%% Data Loading 

 nVar=11; load DC1_1st;

%% Problem Definition
Dist = Haversin(a);   %计算距离矩阵（输入的是经纬度位置）
CostFunction=@(x) MyCost(x,nVar,demand,lorry,Dist,time);      % Cost Function 
VarSize=[1 nVar];   % Size of Decision Variables Matrix
VarMin=1;          % Lower Bound of Variables  决策变量的大小1~nVar 也就是粒子的边界
VarMax=nVar;          % Upper Bound of Variables

%% MOPSO Parameters

MaxIt=30;           % Maximum Number of Iterations
nPop=100;            % Population Size

nRep=10;            % Reposiatory Size 外部存档规模（帕累托最优解存档）

w=0.9;              % Inertia Weight 惯性系数
wdamp=0.99;         % Intertia Weight Damping Rate  惯性因子衰减率
c1=1.25;               % Personal Learning Coefficient 认知系数
c2=2;               % Global Learning Coefficient  社会学习系数

nGrid=7;            % Number of Grids per Dimension  每个维度里的网格数
alpha=0.1;          % Inflation Rate
beta=2;             % Leader Selection Pressure
gamma=2;            % Deletion Selection Pressure

mu=0.1;             % Mutation Rate


%% Initialization

empty_particle.Position=[];
empty_particle.Velocity=[];
empty_particle.Cost=[];
empty_particle.Best.Position=[];
empty_particle.Best.Cost=[];
empty_particle.IsDominated=[];
empty_particle.GridIndex=[];
empty_particle.GridSubIndex=[];

pop=repmat(empty_particle,nPop,1);    

for i=1:nPop
    
    pop(i).Position=randperm(nVar); %粒子位置
    
    pop(i).Velocity=zeros(VarSize); %粒子速度
    
    [pop(i).Cost,f1,f2,L]=CostFunction(pop(i).Position);  
    
    
    % Update Personal Best 
    pop(i).Best.Position=pop(i).Position;
    pop(i).Best.Cost=pop(i).Cost;
    
end


% Determine Domination    %支配关系
pop=DetermineDomination(pop);       
                            

rep=pop(~[pop.IsDominated]);   
Grid=CreateGrid(rep,nGrid,alpha);
for i=1:numel(rep)
    rep(i)=FindGridIndex(rep(i),Grid);
end

%% MOPSO Main Loop

for it=1:MaxIt
    
    for i=1:nPop
        
        leader=SelectLeader(rep,beta);
        
        pop(i).Velocity = round(w*pop(i).Velocity ...
            +c1*rand(VarSize).*(pop(i).Best.Position-pop(i).Position) ...
            +c2*rand(VarSize).*(leader.Position-pop(i).Position));
        
        [pop(i).Cost,f1,f2,L]=CostFunction(pop(i).Position);
        % Apply Mutation
        pm=(1-(it-1)/(MaxIt-1))^(1/mu);
        if rand<pm
            NewSol.Position=Mutate(pop(i).Position,pm,VarMin,VarMax);
            NewSol.Position=round(NewSol.Position);
            [NewSol.Cost,f1,f2,L]=CostFunction(NewSol.Position);
            if Dominates(NewSol,pop(i))
                pop(i).Position=NewSol.Position;
                pop(i).Cost=NewSol.Cost;

            elseif Dominates(pop(i),NewSol)
                

            else
                if rand<0.5
                    pop(i).Position=NewSol.Position;
                    pop(i).Cost=NewSol.Cost;
                end
            end
        end
        
        if Dominates(pop(i),pop(i).Best)
            pop(i).Best.Position=pop(i).Position;
            pop(i).Best.Cost=pop(i).Cost;
            
        elseif Dominates(pop(i).Best,pop(i))  
        else
            if rand<0.5
                pop(i).Best.Position=pop(i).Position;
                pop(i).Best.Cost=pop(i).Cost;
            end
        end
        
    end
    
    % Add Non-Dominated Particles to REPOSITORY
    rep=[rep
         pop(~[pop.IsDominated])]; 
    
    % Determine Domination of New Resository Members
    rep=DetermineDomination(rep);
    
    % Keep only Non-Dminated Memebrs in the Repository
    rep=rep(~[rep.IsDominated]);
    
    % Update Grid
    Grid=CreateGrid(rep,nGrid,alpha);

    % Update Grid Indices
    for i=1:numel(rep)
        rep(i)=FindGridIndex(rep(i),Grid);
    end
    
    % Check if Repository is Full
    if numel(rep)>nRep
        
        Extra=numel(rep)-nRep;
        for e=1:Extra
            rep=DeleteOneRepMemebr(rep,gamma);
        end
        
    end 
end

%% Results
[Cost,f1,f2,L]=CostFunction(NewSol.Position);
Results={NewSol.Position,[f1,f2,length(L)],L};
