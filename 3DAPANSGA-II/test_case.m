
function [fit,err]=test_case(x,D,demand,time,lorry)

%% Data
    M = 1500; % Vehicles maintenance cost
    G = [1455 1455 824 747 674 956]; % Fixed cost
    B = 52; % Number of working period
    E = 0.5; % transportation cost per unit per mile

    P = [1 0 0 0 0 0]; % S1 Scnd Echelon
%     P = [0 1 0 0 0 0]; % S2 Scnd Echelon
%     P = [0 0 1 0 0 0]; % S3 Scnd Echelon
%     P = [0 0 0 1 0 0]; % S4 Scnd Echelon
%     P = [0 0 0 0 1 0]; % S5 Scnd Echelon
%     P = [0 0 0 0 0 1]; % S6 Scnd Echelon
%% Length computation
    x = round (x);
    [lensub,Veh,point,Dem] = routes_length(x,D,demand,lorry);  
    
%% Time computation
    [Penalty,SynC] = penaltycost(point,x,D,time);
%% Objective functions
%     totdem = sum(demand);
%     len = sum(lensub)/1.609;
    totdem = zeros(1,Veh);
    len = zeros(1,Veh);
    PenCost = zeros(1,Veh);
    Synchronization = zeros(1,Veh);
    for j = 1:Veh
        totdem = sum(Dem{j});
        len=lensub(j)/1.609;
        PenCost(j) = sum(Penalty{j});
        Synchronization(j) = sum(SynC{j});
        TC(j)=(E*totdem*len)+((M/B)*Veh);
    end
%     TC1 = (* fkv * C * len) +((totdem/sum(Q.*P)) * (sum(M.*P)/B));% Transportation cost.
%     TC2 = sum(G.*P) + (sum(Var.*P) * totdem) - sum(E.*P);
    
    f1 = sum(TC)+sum(PenCost)+ sum(G.*P);
    f2 =sum(Synchronization);
    err= zeros(1,1);
fit=[f1 f2 Veh];