function xchild= Tabu_Search(xchild,ychild,a)
%%  Neighbour action
%  邻域搜索
switch round(a)+1
    case 1
        % couple_exchange  
        xchild=couple_exchange (xchild);
        
    case 2
        % block_exchange  
        xchild=block_exchange (xchild);
        
    case 3
        % couple_relocate  
        xchild=couple_relocate(xchild);
    case 4
        % block_relocate
        xchild=block_relocate(xchild);
        
end