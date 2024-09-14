
function [z,f1,f2,L]=MyCost(x,nVar,demand,lorry,Dist,time)   

     [L,~,TotalD,~,~,v]=ParseSolution(x,nVar,demand,lorry,Dist);   
%% Data
M = 1500; 
B = 52; 
    Fk=3.52; 
    G=3;  

%% 2 depots
%     P = [1 0]; % S1 
%     P = [0 1]; % S2  
%% 4 depots
%     P = [1 0 0 0]; % S1 
%     P = [0 1 0 0]; % S2 
%     P = [0 0 1 0]; % S3 
%     P = [0 0 0 1]; % S4 
%% 6 depots
%     P = [1 0 0 0 0 0]; % S1 
%     P = [0 1 0 0 0 0]; % S2 
%     P = [0 0 1 0 0 0]; % S3 
%     P = [0 0 0 1 0 0]; % S4 
%     P = [0 0 0 0 1 0]; % S5 
%     P = [0 0 0 0 0 1]; % S6 
%% 8 depots
%     P = [1 0 0 0 0 0 0 0]; % S1 
%     P = [0 1 0 0 0 0 0 0]; % S2 
%     P = [0 0 1 0 0 0 0 0]; % S3 
%     P = [0 0 0 1 0 0 0 0]; % S4 
%     P = [0 0 0 0 1 0 0 0]; % S5 
%     P = [0 0 0 0 0 1 0 0]; % S6 
%     P = [0 0 0 0 0 0 1 0]; % S7
     P = [0 0 0 0 0 0 0 1]; % S8
%% 9 depots
%     P = [1 0 0 0 0 0 0 0 0]; % S1 
%     P = [0 1 0 0 0 0 0 0 0]; % S2 
%     P = [0 0 1 0 0 0 0 0 0]; % S3 
%     P = [0 0 0 1 0 0 0 0 0]; % S4 
%     P = [0 0 0 0 1 0 0 0 0]; % S5 
%     P = [0 0 0 0 0 1 0 0 0]; % S6 
%     P = [0 0 0 0 0 0 1 0 0]; % S7
%     P = [0 0 0 0 0 0 0 1 0]; % S8
%     P = [0 0 0 0 0 0 0 0 1]; % S9
%% 10 depots
%     P = [1 0 0 0 0 0 0 0 0 0]; % S1 
%     P = [0 1 0 0 0 0 0 0 0 0]; % S2 
%     P = [0 0 1 0 0 0 0 0 0 0]; % S3 
%     P = [0 0 0 1 0 0 0 0 0 0]; % S4 
%     P = [0 0 0 0 1 0 0 0 0 0]; % S5 
%     P = [0 0 0 0 0 1 0 0 0 0]; % S6 
%     P = [0 0 0 0 0 0 1 0 0 0]; % S7
%     P = [0 0 0 0 0 0 0 1 0 0]; % S8
%     P = [0 0 0 0 0 0 0 0 1 0]; % S9
%     P = [0 0 0 0 0 0 0 0 0 1]; % S10
%% 12 depots
%     P = [1 0 0 0 0 0 0 0 0 0 0 0]; % S1 
%     P = [0 1 0 0 0 0 0 0 0 0 0 0]; % S2 
%     P = [0 0 1 0 0 0 0 0 0 0 0 0]; % S3 
%     P = [0 0 0 1 0 0 0 0 0 0 0 0]; % S4 
%     P = [0 0 0 0 1 0 0 0 0 0 0 0]; % S5 
%     P = [0 0 0 0 0 1 0 0 0 0 0 0]; % S6 
%     P = [0 0 0 0 0 0 1 0 0 0 0 0]; % S7
%     P = [0 0 0 0 0 0 0 1 0 0 0 0]; % S8
%     P = [0 0 0 0 0 0 0 0 1 0 0 0]; % S9
%     P = [0 0 0 0 0 0 0 0 0 1 0 0]; % S10
%     P = [0 0 0 0 0 0 0 0 1 0 1 0]; % S11
%     P = [0 0 0 0 0 0 0 0 0 1 0 1]; % S12
   
   [Penalty,SynC] = penaltycost(v,x,Dist,time);   
    Veh = length(L);
    totdem = zeros(1,Veh);
    len = zeros(1,Veh);
    PenCost = zeros(1,Veh);
    Synchronization = zeros(1,Veh);
    for j = 1:Veh
        totdem = sum(demand(L{j}));
        len=TotalD(j)/1.609;
        PenCost(j) = sum(Penalty{j});
         Synchronization(j) = sum(SynC{j});
        TC(j)=(Fk*G*len)+PenCost(j);     
    end  
    f1 = sum(TC);
    f2 =sum(Synchronization);
z=f1';
end