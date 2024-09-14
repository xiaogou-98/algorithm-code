function bee=FindGridIndex(bee,Grid)

    nObj=numel(bee.Cost);
    
    nGrid=numel(Grid(1).LB);
    
    bee.GridSubIndex=zeros(1,nObj);
    
    for j=1:nObj
        
        bee.GridSubIndex(j)=...
            find(bee.Cost(j)<Grid(j).UB,1,'first');
        
    end

    bee.GridIndex=bee.GridSubIndex(1);
    for j=2:nObj
       bee.GridIndex=bee.GridIndex-1;
        bee.GridIndex=nGrid*bee.GridIndex;
        bee.GridIndex=bee.GridIndex+bee.GridSubIndex(j);
    end
    