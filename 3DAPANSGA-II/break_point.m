
 function [point,dem]=break_point(x,demand,lorry)  
    x = round (x);
    qq=demand(x);
    N=length(x);
    TT=zeros(1,N);
    point=zeros(1,N);
    TT=cumsum(qq);  
    aa=find(TT>lorry);  
    if  isempty(aa)  
         point=[];
    else
         point(1)=aa(1)-1;  
         for i=2:N  
             TT=[zeros(1,point(i-1)),cumsum(qq(point(i-1)+1:N))];
             aa=find(TT>lorry);  
             if ~isempty(aa)
                 point(i)=aa(1)-1;
             else
                 break;  
             end
         end
    end
    point(find(point==0))=[];  
    dem = cell(1,length(point)+1);
    for i = 1:length(point)
        n=1;
        dem{i}=qq(:,n:point(i));
        n=n+point(i);
    end
        dem{end}=qq(:,point(end)+1:end);
 end

