
function xnew=Mutate(y,pm,VarMin,VarMax)



     N=length(y);
     route=y;
     t=unidrnd(N,1,2); 
     route(t(1))=y(t(2));
     route(t(2))=y(t(1));
     xnew=route;

end