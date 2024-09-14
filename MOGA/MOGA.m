%% GA  optimization  
clc; clear; close all;
feature jit off  

%% Problem Definition  ��������
%  ����ģ�Ͳ���  ���洢��  model   �ṹ����
model=CreateModel();        % Create Model of the Problem  ���⽨ģ

CostFunction=@(q) MyCost(q,model);       % Cost Function  ȷ��Ŀ�꺯��

nVar =model.nVar;        % Number of Decision Variables  ��������59

VarSize=[1 nVar];       % Size of Decision Variables Matrix  ����ά��

M = 2; %Ŀ�꺯���ĸ���
V = 59;

%% GA Settings  �㷨��������
MaxIt= 100 ;              % Maximum Number of Iterations  ����������
nPop= 100  ;               % Population Size (Colony Size)  ��Ⱥ��Ŀ
pc  = 0.8;  %�������
pm = 0.6 ; %�������
nrep = 10; %�ⲿ�浵��ģ
nGrid = 5 ;%ÿ��ά�ȵ�������
alpha = 0.1;    
beta=2;             % Leader Selection Pressure
gamma=2;            % Deletion Selection Pressure
%% Initialization  ��ʼ��
  rand( 'seed' ,sum(clock));
% Empty Bee Structure
empty_bee.Position=[];
empty_bee.Cost=[];
%empty_bee.standard=[];
empty_bee.sol=[ ];
%empty_bee.IsDominated=[]; 
%empty_bee.GridIndex=[];  %���ӵ���ʵ����λ������
%empty_bee.GridSubIndex=[]; 
empty_bee.rank=[];
empty_bee.distance=[];
empty_bee.F1=[];
empty_bee.F2=[];
empty_bee.distance1=[];
empty_bee.distance2=[];

% Initialize Population Array
pop=repmat(empty_bee,nPop,1);  %�洢50�������������Ϣ

% Initialize Best Solution Ever Found
BestSol.F1=inf;  
% Create Initial Population  ��ʼ����ȺĿ�꺯��ֵ����

for i=1:nPop
    pop(i).Position=  randperm( nVar )  ;
    
    [ pop(i).Cost, pop(i).sol, pop(i).F1,pop(i).F2] =CostFunction(pop(i).Position);  
end

pop = non_domination_sort_mod(pop, M, nVar);
     
 
for it=1:MaxIt
    %%������ѡ��  ����
    pool = round(nPop/2) ;
    tour = 2 ;%������ ����ѡ�ָ���
    newpop = tournament_selection(pop, pool, tour);%������ѡ���ʺϷ�ֳ�ĸ���
    for i = 1: nPop/2  %1:50
        if  rand< pc
            
            K=[1:i-1 i+1:nPop];  
            k=K(randi([1 numel(K)]));  
            
            newpop(i).Position   =  crossoveroperation(   newpop(i).Position ,   pop(k).Position ,  nVar);
            %newpop�Ĺ�ģ��Ϊ50
        end
    end
    %%  �������
    for i = 1: nPop/2  %1:50
        if  rand< pm         
            newpop(i).Position = CreateNeighbor( newpop(i).Position  );
        end
    end
    %%  ����Ŀ�꺯��ֵ
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