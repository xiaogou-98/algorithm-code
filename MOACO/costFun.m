

function [cost,NV,TD]=costFun(VC,dist)
NV=size(VC,1);                     
TD=travel_distance(VC,dist) ;        
cost=1000*NV+1*TD;
end