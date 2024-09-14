
 function D=distance(a)
    [c,d]=size(a);
    D=zeros(c,c);  
    for i=1:c
        for j=i:c
            bb=(a(i,1)-a(j,1)).^2+(a(i,2)-a(j,2)).^2;
            D(i,j)=bb^(0.5);
            D(j,i)=D(i,j);
        end
    end
