
 function [a,b]=intercross(a,b)
    L=length(a);
    W=floor(2*L/3);
    p=unidrnd(L-W+1);  
    for i=1:W  
        x=find(a==b(1,p+i-1));  
        y=find(b==a(1,p+i-1));  
        [a(1,p+i-1),b(1,p+i-1)]=exchange(a(1,p+i-1),b(1,p+i-1));
        [a(1,x),b(1,y)]=exchange(a(1,x),b(1,y));
    end