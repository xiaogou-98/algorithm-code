function z=MOP2(q,model)
%% route construct
k=1;                                   
init_vc=cell(k,1); 
route=[];     
load=0;    
i=1;
while i<=q   
 
    if load+model.Demand(q(i))<=model.standQ2        
        load=load+model.Demand(q(i));      
        if isempty(route)
            route=[q(i)];
        elseif length(route)==1
            if model.Ej(q(i))<=model.Ej(route(1))
                route=[q(i),route];   
            else
                route=[route,q(i)];
            end
        else          
            lr=length(route);       
            flag=0;               
       
        end
        if i==numCustomer
            init_vc{k,1}=route;
            break
        end
        i=i+1;
    else   
        init_vc{k,1}=route;
        
        route=[];
        load=0;
        k=k+1;
    end
end




%%  
empty_rourte.CustomerSequence = [];
empty_rourte.Load_val  =[ ];
empty_rourte.LoadValidation =[ ]; 
empty_rourte.RouteLength=[];  

Detailed_Route =repmat(empty_rourte ,Num_Route  ,1); 
ArrivalTime =  zeros(  model.numCustomer , 1 ) ; % 到达时间

for     t =  1: Num_Route 

    Detailed_Route( t ).CustomerSequence  =  init_vc{t, 1};
    

    Detailed_Route( t ).RouteLength = Center2CustD(  temp(1) )+ Center2CustD(   temp(end)  );
    if  numel(   temp  )>1  
        for j = 2: numel( temp ) 
            Detailed_Route( t ).RouteLength=    Detailed_Route( t ).RouteLength +  CustD(   temp(j-1)       , temp(j)    );
        end
    end
    Detailed_Route( t ).Load_val   =  sum( model.Demand(     temp   ) ); 
    Detailed_Route( t ).LoadValidation = max(0, Detailed_Route( t ).Load_val-model.standQ2)+max(0, model.standQ1-Detailed_Route( t ).Load_val); 
    ArrivalTime(  temp(1) ) =   model.Tstart  + Center2CustD(  temp(1) )/model.standV;
  
    if  numel( temp  )>1
        for j = 2: numel( temp )
            ArrivalTime(  temp( j ) ) =  ArrivalTime(  temp(j-1) )  +  CustD(   temp(j-1)       , temp(j)    )/model.standV ;
        end
    end
    
end


%% time violation
TimeViolationCost  = 0 ;

for i = 1: model.numCustomer
    
    if ArrivalTime( i ) < model.Ej( i ) 

	TimeViolationCost  = TimeViolationCost + model.c1(i)*( model.Ej( i )-ArrivalTime( i )  )*6/250 ;
    Timebefore = model.Ej( i )-ArrivalTime( i );
        continue;
    end
    
    if  ArrivalTime( i ) >model.Tj( i )  
	TimeViolationCost  = TimeViolationCost + model.c2(i)*( ArrivalTime( i )-model.Tj( i ))*6/250 ;
    Timeafter = ArrivalTime( i )-model.Tj( i );
        continue;
    end
    
end
%% 
for ii=1:Num_Route
    Detailed_Route(ii).LoadValidation = max(0, Detailed_Route(ii).Load_val-model.standQ2)+max(0, model.standQ1-Detailed_Route(ii).Load_val);  
end



%%  
F1 = model.F*Num_Route  + ...  
    model.A* sum( [Detailed_Route.RouteLength ])  +  ...  
    TimeViolationCost  ;
F2 = Num_Route;



%%    fitness

Violation =sum( [ Detailed_Route.LoadValidation ]) ;

Fitnessval2 = F1+model.PenaltyCoefficient* Violation;
Fitnessval =  [F1+model.PenaltyCoefficient* Violation]' ;
IsFeasible = ( Violation==0 );



%% solution
sol.Num_Route = Num_Route ;
sol.Detailed_Route = Detailed_Route ; 
sol.ArrivalTime=ArrivalTime; 
sol.TimeViolationCost   = TimeViolationCost ;
sol.Violation  = Violation ; 
sol.F1=F1;
sol.F2=F2;
sol.F3=F3;
sol.Fitnessval = Fitnessval;
sol.IsFeasible  = IsFeasible  ; 
end    