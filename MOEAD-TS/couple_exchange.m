
function xchild=couple_exchange(xchild)
%% couple_exchange operation
N=numel(xchild);
%% random choose two couples. 
i1=[round(N*random()),round(N*random())];
i2=[round(N*random()),round(N*random())];
xchild_new(i1(1))=xchild(i2(1));
xchild_new(i1(2))=xchild(i2(2));
xchild_new(i2(1))=xchild(i1(1));
xchild_new(i2(2))=xchild(i1(2));
xchild=xchild_new;
end