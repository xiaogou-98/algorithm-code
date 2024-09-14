function xchild=block_relocate(xchild)
%% block_relocate operation
N=numel(xchild);
%% random choose two couples. 
i1=[round(N*random()),round(N*random())];
i2=i1+3;
for i=1:numel(i1:i2)
   xchild_new(i(1)+i)=xchild(i1+i);
end
xchild_new(1)=xchild(i(1)+4); 
xchild_new(2)=xchild(i(1)+5);
xchild=xchild_new;
end