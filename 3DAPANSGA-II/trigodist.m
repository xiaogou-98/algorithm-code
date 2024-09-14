function D=trigodist(a)
    a = (a./180)*3.14;    
    [c,~]=size(a);
    D=zeros(c,c);  
    for i=1:c
        for j=i:c
           D(i,j)= 6371.004 * sqrt((cos(a(i,1))*cos(a(i,2))-(cos(a(j,1))*cos(a(j,2))))^2 + (sin(a(i,1))*cos(a(i,2))-(sin(a(j,1))*cos(a(j,2))))^2 + (sin(a(i,2))-sin(a(j,2)))^2);
           D(j,i)=D(i,j);
        end
    end