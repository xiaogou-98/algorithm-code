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

empty_rourte.CustomerSequence = []; % ÿ���ͻ�����
empty_rourte.Load_val  =[ ]; %  װ����
empty_rourte.LoadValidation =[ ]; 
empty_rourte.RouteLength=[];  % ÿ����·�ĳ���

Detailed_Route =repmat(empty_rourte ,Num_Route  ,1); 
ArrivalTime =  zeros(  model.numCustomer , 1 ) ; % ����ʱ��

for     t =  1: Num_Route  
    % ÿ���ͻ�����
    Detailed_Route( t ).CustomerSequence  =  L{ t, 1};
    
    % ÿ����·�ĳ���
    temp =     L{ t, 1};  %��ÿ��·��ȡ����
    Detailed_Route( t ).RouteLength = Center2CustD(  temp(1) )+ Center2CustD(   temp(end)  );
    if  numel(   temp  )>1  %˵�������������ϵĿͻ�������Ҫ����ͻ�֮��ľ���
        for j = 2: numel( temp )  %��2���ͻ������һ���ͻ�����ѭ��
            Detailed_Route( t ).RouteLength=    Detailed_Route( t ).RouteLength +  CustD(   temp(j-1)       , temp(j)    );
        end
    end
    
    
    %  װ����
    Detailed_Route( t ).Load_val   =  sum( model.Demand(     temp   ) );  
    %  װ����Υ��Լ���ĳ̶�
    Detailed_Route( t ).LoadValidation = max(0, Detailed_Route( t ).Load_val-model.standQ);  %  װ����Υ��Լ���ĳ̶�
   
   
    %  ����ÿ���ͻ��ĵ���ʱ��
    ArrivalTime(  temp(1) ) =   model.Tstart  + Center2CustD(  temp(1) )/model.standV;
    
    if  numel( temp  )>1
        for j = 2: numel( temp )
            ArrivalTime(  temp( j ) ) =  ArrivalTime(  temp(j-1) )  +  CustD(   temp(j-1)       , temp(j)    )/model.standV ;
        end
    end
    
end

%% Υ��ʱ�䴰�ĳͷ��ɱ�    
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

%%  Ŀ�꺯������
F1 = model.F*Num_Route  + ...  
    model.A* sum( [Detailed_Route.RouteLength ])  +  ... 
    TimeViolationCost  ;
F2 = Timebefore + Timeafter ;  


%%    ��Ӧ��ֵ����

Violation =sum( [ Detailed_Route.LoadValidation ]) ; 

Fitnessval2 = F1+model.PenaltyCoefficient* Violation;
Fitnessval =  [F1+model.PenaltyCoefficient* Violation]' ;
IsFeasible = ( Violation==0 );



%% ��Ľṹ��
sol.Num_Route = Num_Route ; %  �ܵ���·��Ŀ
sol.Detailed_Route = Detailed_Route ; % ÿ����·��������
sol.ArrivalTime=ArrivalTime; % ����ʱ��
sol.TimeViolationCost   = TimeViolationCost ;
sol.Violation  = Violation ; % Υ��Լ�������
sol.Fitnessval = Fitnessval; %��Ӧ��ֵ
sol.IsFeasible  = IsFeasible  ; % 0-1  �߼�������ʾ���Ƿ����




