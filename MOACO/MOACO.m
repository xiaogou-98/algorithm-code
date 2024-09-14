clear
clc
close all
tic
feature jit off  %加速代码运行

c101=importdata('c101.txt');
cap=300;                                                        

%% 提取数据信息
E=c101(1,5);                                                    
L=c101(1,6);                                                    
vertexs=c101(:,2:3);                                            
customer=vertexs(2:end,:);                                      
cusnum=size(customer,1);                                        
v_num=25;                                                       
demands=c101(2:end,4);                                          
a=c101(2:end,5);                                                
b=c101(2:end,6);                                                
width=b-a;                                                      
s=c101(2:end,7);                                                
h=pdist(vertexs);                                               
dist=squareform(h);                                             

%% 初始化参数
m=40;                                                           %number of ants
alpha=1;                                                        %信息素重要程度因子
beta=3;                                                         %启发函数重要程度因子
gama=2;                                                         %等待时间重要程度因子
delta=3;                                                        %时间窗跨度重要程度因子
r0=0.5;                                                         %r0为用来控制转移规则的参数
rho=0.85;                                                       %信息素挥发因子
Q=5;                                                            %更新信息素浓度的常数
Eta=1./dist;                                                    %启发函数
Tau=ones(cusnum+1,cusnum+1);                                    %信息素矩阵
Table=zeros(m,cusnum);                                          %路径记录表
iter=1;                                                         %迭代次数初值
iter_max=50;                                                   %最大迭代次数

Route_best1=zeros(iter_max,cusnum);                              
Route_best2=zeros(iter_max,cusnum); 
Cost_best=zeros(iter_max,1);                                
TD_best=zeros(iter_max,1);
Route_best=zeros(iter_max,cusnum);

%% 迭代寻找最佳路径
while iter<=iter_max
    %% 先构建出所有蚂蚁的路径
    %逐个蚂蚁选择
    for i=1:m
        %逐个顾客选择
        for j=1:cusnum
            r=rand;                                             %r为在[0,1]上的随机变量
            np=next_point(i,Table,Tau,Eta,alpha,beta,gama,delta,r,r0,a,b,width,s,L,dist,cap,demands);
            Table(i,j)=np;
        end
    end
   
    %% 计算各个蚂蚁的成本
    cost=zeros(m,1);%各代中各个蚂蚁的成本
    NV=zeros(m,1);%各代中各个蚂蚁的车辆使用数
    TD=zeros(m,1);%各代中各个蚂蚁的行驶距离
    for i=1:m
        VC=decode(Table(i,:),cap,demands,a,b,L,s,dist);
        [cost(i,1),NV(i,1),TD(i,1)]=costFun(VC,dist);
    end

     if iter == 1
        [min_Cost,min_index]=min(cost);
        Cost_best(iter)=min_Cost;
        Route_best1(iter,:)=Table(min_index,:);
    else
        [min_Cost,min_index]=min(cost);
        Cost_best(iter)=min(Cost_best(iter - 1),min_Cost);
        if Cost_best(iter)==min_Cost
            Route_best1(iter,:)=Table(min_index,:);
        else
            Route_best1(iter,:)=Route_best1((iter-1),:);
        end
     end
      
      chromosome1=[Route_best1(iter,:),Cost_best(iter),0];
    
      if iter == 1
        [min_TD,min_index]=min(TD);
        TD_best(iter)=min_TD;
        Route_best2(iter,:)=Table(min_index,:);
    else
        [min_TD,min_index]=min(TD);
        TD_best(iter)=min(TD_best(iter - 1),min_TD);
        if TD_best(iter)==min_TD
            Route_best2(iter,:)=Table(min_index,:);
        else
            Route_best2(iter,:)=Route_best2((iter-1),:);
        end
      end
     
      %exchange2
      [Route_best2(iter,:),minTD,Best2]=exchange2(Route_best2(iter,:),dist,TD_best(iter));
  
       chromosome2=[Route_best2(iter,:),0,minTD];
       %% 非支配排序
       M = 2; %目标函数数量
       V = 100; %维度（决策变量的个数）
       chromosome=[chromosome1;chromosome2];%构建双目标种群
       chromosome=non_domination_sort_mod(chromosome, M, V);%对种群进行非支配快速排序和拥挤度计算
      
       %% 更新信息素
       Route_best(iter,:)=chromosome(1,1:cusnum);%按照非支配排序，首行的为最佳
       Tau=updateTau(Tau,Route_best(iter,:),rho,Q,cap,demands,a,b,L,s,dist);
       
       %% 迭代次数加1，清空路径记录表
       iter=iter+1;
       Table=zeros(m,cusnum);
end