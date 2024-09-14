function xchild=block_exchange(xchild)
%% block_exchange operation
N=length(xchild);
i1=round(rand(1,1)*N);
i2=round(rand(1,1)*N);
Bw=xchild(1);
Bx=xchild(2);
xchild(Bw)=xchild(Bx);
xchild(Bx)=xchild(Bw);
end