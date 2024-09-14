function ActionList=CreatePermActionList(n)
    nSwap=n*(n-1)/2;  
    nAction=nSwap  ;  %+nReversion+nInsertion;1171
    
    ActionList=cell(nAction,1);
    
    c=0;
    
    for i=1:n-1
        for j=i+1:n
            c=c+1;
            ActionList{c}=[1 i j];
        end
    end