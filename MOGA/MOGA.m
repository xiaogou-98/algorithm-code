%% GA  optimization  
clc; clear; close all;
feature jit off  

%% Problem Definition  构建问题
%  构建模型参数  并存储于  model   结构体中
model=CreateModel();        % Create Model of the Problem  问题建模

CostFunction=@(q) MyCost(q,model);       % Cost Function  确定目标函数

nVar =model.nVar;        % Number of Decision Variables  变量个数59

VarSize=[1 nVar];       % Size of Decision Variables Matrix  问题维度

M = 2; %目标函数的个数
V = 59;

%% GA Settings  算法参数设置
MaxIt= 100 ;              % Maximum Number of Iterations  最大迭代次数
nPop= 100  ;               % Population Size (Colony Size)  种群数目
pc  = 0.8;  %交叉概率
pm = 0.6 ; %变异概率
nrep = 10; %外部存档规模
nGrid = 5 ;%每个维度的网格数
alpha = 0.1;    
beta=2;             % Leader Selection Pressure
gamma=2;            % Deletion Selection Pressure
%% Initialization  初始化
  rand( 'seed' ,sum(clock));
% Empty Bee Structure
empty_bee.Position=[];
empty_bee.Cost=[];
%empty_bee.standard=[];
empty_bee.sol=[ ];
%empty_bee.IsDominated=[]; 
%empty_bee.GridIndex=[];  %粒子的真实网格位置坐标
%empty_bee.GridSubIndex=[]; 
empty_bee.rank=[];
empty_bee.distance=[];
empty_bee.F1=[];
empty_bee.F2=[];
empty_bee.distance1=[];
empty_bee.distance2=[];

% Initialize Population Array
pop=repmat(empty_bee,nPop,1);  %存储50个个体的三类信息

% Initialize Best Solution Ever Found
BestSol.F1=inf;  
% Create Initial Population  初始化种群目标函数值计算

for i=1:nPop
    pop(i).Position=  randperm( nVar )  ;
    
    [ pop(i).Cost, pop(i).sol, pop(i).F1,pop(i).F2] =CostFunction(pop(i).Position);  
end

pop = non_domination_sort_mod(pop, M, nVar);
     
 
for it=1:MaxIt
    %%锦标赛选择  参数
    pool = round(nPop/2) ;
    tour = 2 ;%锦标赛 参赛选手个数
    newpop = tournament_selection(pop, pool, tour);%竞标赛选择适合繁殖的父代
    for i = 1: nPop/2  %1:50
        if  rand< pc
            
            K=[1:i-1 i+1:nPop];  
            k=K(randi([1 numel(K)]));  
            
            newpop(i).Position   =  crossoveroperation(   newpop(i).Position ,   pop(k).Position ,  nVar);
            %newpop的规模仍为50
        end
    end
    %%  变异操作
    for i = 1: nPop/2  %1:50
        if  rand< pm         
            newpop(i).Position = CreateNeighbor( newpop(i).Position  );
        end
    end
    %%  更新目标函数值
    for i = 1: nPop/2       
        [ newpop(i).Cost,  newpop(i).sol,newpop(i).F1,newpop(i).F2 ] = CostFunction( newpop(i).Position);          
    end
    [nnewpop,~] = size(newpop);
    intermediate_pop(1:nPop,:) = pop;
    intermediate_pop(nPop+1:nPop+nnewpop,:) = newpop;
    intermediate_pop = non_domination_sort_mod(intermediate_pop, M, nVar) ;
    lastpop = replace_chromosome(intermediate_pop, M, nVar, nPop) ;
[~,idx]=sort([lastpop.distance],'descend');
sortedlastpop=lastpop(idx);
    BestCost(it)=BestSol;
end    