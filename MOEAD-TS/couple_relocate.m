function xchild=couple_relocate(xchild)
%% couple-relocate operation
i1=[round(N*random())];
i2=[round(N*random())];
Bw=xchild(i1,i1+2);
Bx=xchild(i2,i2+4);
Rest=xchild(i1+3,i2-1);
xchild(i2+3,i1-1)=Rest;
end