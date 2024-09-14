
function x=CreateRandomSolution(a,nVar)
% 

    angleR = angle(a);
    unidp=unidrnd(nVar);
    x=[angleR(unidp:end),angleR(1:unidp-1)];

end