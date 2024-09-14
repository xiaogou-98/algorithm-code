function D=Haversin(data)
    data = (data./180)*3.14;
    [c,~]=size(data);
    D=zeros(c,c);  
    for i=1:c
        for j=i:c
           D(i,j)= 2 * 6371.004 * asin(sqrt(((1-cos(data(i,2)- data(j,2)))/2)+(cos(data(i,1))*cos(data(j,1))*((1-cos(data(i,1)- data(j,1)))/2))));
           D(j,i)=D(i,j);
        end
    end