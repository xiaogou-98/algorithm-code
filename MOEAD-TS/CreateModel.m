  function model=CreateModel()
%% 
%% 
 rand( 'seed' , 12.5)  
% clc,clear all
model.CenterX=
;  % 
model.CenterY=
; % 

model.numCustomer  =; 
model.CustX = []

model.CustY = []; 

model.Demand =   [] ; 
 
model.Ej = [] ;  % 
model.Tj = [] ;  % 
%%  其他基本参数
model.Tstart =  ;  %  
model.standQ2 =   ;  % 
model.standQ1 =  ;  % 
model.standV = ;  %  
model.NumVehicle = ;  %  
 
%   
model.F =   ;  % 
model.A  = ;  % 

model.c1 = [];%  
model.c2 = [];

model.nVa = model.numCustomer;  

model.PenaltyCoefficient = ; 


%%  
model.Center2CustD=  zeros( model.numCustomer ,1)  ;  
Q1=[ model.CenterX, model.CenterY  ];
for i=1:   model.numCustomer
    
    Q2= [  model.CustX(i)   model.CustY(i) ];
    
    model.Center2CustD(i)=norm(     Q1-    Q2   );   
end
model.CustD=  zeros( model.numCustomer )  ;  
for i=1:   model.numCustomer
    for j=i:model.numCustomer
        Q1= [  model.CustX(i)   model.CustY(i) ];
        Q2= [  model.CustX(j)   model.CustY(j) ];
     model.CustD(i,j)=norm(     Q1-    Q2   );

        model.CustD(j,i)=   model.CustD(i,j);
        
    end
end
