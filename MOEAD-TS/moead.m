clc;
clear;
close all;

%% Problem Definition

CostFunction=@(x) MOP2(x);  

nVar=3;             

VarSize=[nVar 1];   
VarMin = 0;         % Decision Variables Lower Bound
VarMax = 1;         % Decision Variables Upper Bound

nObj= 2;


%% MOEA/D Settings

MaxIt=50;  

nPop=100;   

nArchive=50;

T=max(ceil(0.15*nPop),2);   
T=min(max(T,2),15);

crossover_params.gamma=0.5;
crossover_params.VarMin=VarMin;
crossover_params.VarMax=VarMax;

%% Initialization

% Create Sub-problem


empty_individual.Position=[];
empty_individual.Cost=[];
empty_individual.g=[];
empty_individual.IsDominated=[];

% Initialize Goal Point
%z=inf(nObj,1);
z=zeros(nObj,1);

% Create Initial Population

pop=repmat(empty_individual,nPop,1);
for i=1:nPop
    pop(i).Position=randperm(10,10);
   pop(i).Cost=zeros(nObj,1);
     z=min(z,pop(i).Cost);
end

for i=1:nPop
    pop(i).g=DecomposedCost(pop(i),z);
end

% Determine Population Domination Status
pop=DetermineDomination(pop);

% Initialize Estimated Pareto Front
EP=pop(~[pop.IsDominated]);

%% Main Loop
sp=struct('Neighbors',zeros(nPop),'lambda',ones(nPop)*0.1);
for it=1:MaxIt
    for i=1:nPop
        
        % Reproduction (Crossover)
        K=randsample(T,2);
        
        j1=sp.Neighbors(1);
         j1=round(j1)+1;
        p1=pop(j1);
        
        j2=sp.Neighbors(2);
        j2=round(j2)+2;
        p2=pop(j2);
        
        y=empty_individual;
        y.Position=Crossover(p1.Position,p2.Position,crossover_params);% crossover
        sp.Neighbors(1,1)=1;
          y.Cost=zeros(nObj,1);
        z=min(z,y.Cost);
        position=Tabu_Search(p1.Position,p2.Position,crossover_params.gamma);  % new child   
        for j=sp.Neighbors(1,1)
            y.g=DecomposedCost(y,sp(j).lambda);
            if y.g<=pop(j).g
                pop(j)=y;
            end
        end
        
    end
    
    % Determine Population Domination Status
	pop= DetermineDomination(pop);
    
    ndpop=pop(~[pop.IsDominated]);
    
    EP=[EP
        ndpop]; 
    
    EP=DetermineDomination(EP);
    EP=EP(~[EP.IsDominated]);
    
    if numel(EP)>nArchive
        Extra=numel(EP)-nArchive;
        ToBeDeleted=randsample(numel(EP),Extra);
        EP(ToBeDeleted)=[];
    end

    
end