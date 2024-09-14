function [ Fitnessval , sol , F1,F2]=MyCost(q,model)
numCustomer =   model.numCustomer ; 

standQ =  model.standQ    ;  
NumVehicle =model.NumVehicle   ;  

Center2CustD= model.Center2CustD ;  
CustD=  model.CustD; 


DelPos=find(q>  numCustomer );

From=[0 DelPos]+1;
To=[DelPos          numCustomer+NumVehicle ]-1;


t=1;
for j=1: NumVehicle  %
    if ~numel(  q(From(j):To(j)) )  
        continue;
    end
    L{ t, 1}=q(From(j):To(j));
    t=t+1;
end
Num_Route = numel(L  ); 

empty_rourte.CustomerSequence = []; % 每条客户序列
empty_rourte.Load_val  =[ ]; %  装载量
empty_rourte.LoadValidation =[ ]; 
empty_rourte.RouteLength=[];  % 每条线路的长度

Detailed_Route =repmat(empty_rourte ,Num_Route  ,1); 
ArrivalTime =  zeros(  model.numCustomer , 1 ) ; % 到达时间

for     t =  1: Num_Route  
    % 每条客户序列
    Detailed_Route( t ).CustomerSequence  =  L{ t, 1};
    
    % 每条线路的长度
    temp =     L{ t, 1};  %把每条路线取出来
    Detailed_Route( t ).RouteLength = Center2CustD(  temp(1) )+ Center2CustD(   temp(end)  );
    if  numel(   temp  )>1  %说明有两个及以上的客户，则需要计算客户之间的距离
        for j = 2: numel( temp )  %第2个客户到最后一个客户进行循环
            Detailed_Route( t ).RouteLength=    Detailed_Route( t ).RouteLength +  CustD(   temp(j-1)       , temp(j)    );
        end
    end
    
    
    %  装载量
    Detailed_Route( t ).Load_val   =  sum( model.Demand(     temp   ) );  
    %  装载量违反约束的程度
    Detailed_Route( t ).LoadValidation = max(0, Detailed_Route( t ).Load_val-model.standQ);  %  装载量违反约束的程度
   
   
    %  计算每个客户的到达时间
    ArrivalTime(  temp(1) ) =   model.Tstart  + Center2CustD(  temp(1) )/model.standV;
    
    if  numel( temp  )>1
        for j = 2: numel( temp )
            ArrivalTime(  temp( j ) ) =  ArrivalTime(  temp(j-1) )  +  CustD(   temp(j-1)       , temp(j)    )/model.standV ;
        end
    end
    
end

%% 违反时间窗的惩罚成本    
TimeViolationCost  = 0 ;

for i = 1: model.numCustomer
    
    if ArrivalTime( i ) < model.Ej( i ) 

	TimeViolationCost  = TimeViolationCost + model.c1(i)*( model.Ej( i )-ArrivalTime( i )  ) ;
    Timebefore = model.Ej( i )-ArrivalTime( i );
        continue;
    end
    
    if  ArrivalTime( i ) >model.Tj( i )  
	TimeViolationCost  = TimeViolationCost + model.c2(i)*( ArrivalTime( i )-model.Tj( i )) ;
    Timeafter = ArrivalTime( i )-model.Tj( i );
        continue;
    end
    
end

%%  目标函数计算
F1 = model.F*Num_Route  + ...  
    model.A* sum( [Detailed_Route.RouteLength ])  +  ... 
    TimeViolationCost  ;
F2 = Timebefore + Timeafter ;  


%%    适应度值计算

Violation =sum( [ Detailed_Route.LoadValidation ]) ; 

Fitnessval2 = F1+model.PenaltyCoefficient* Violation;
Fitnessval =  [F1+model.PenaltyCoefficient* Violation]' ;
IsFeasible = ( Violation==0 );



%% 解的结构体
sol.Num_Route = Num_Route ; %  总的线路数目
sol.Detailed_Route = Detailed_Route ; % 每条线路的相关情况
sol.ArrivalTime=ArrivalTime; % 到达时间
sol.TimeViolationCost   = TimeViolationCost ;
sol.Violation  = Violation ; % 违反约束的情况
sol.Fitnessval = Fitnessval; %适应度值
sol.IsFeasible  = IsFeasible  ; % 0-1  逻辑变量表示解是否可行




