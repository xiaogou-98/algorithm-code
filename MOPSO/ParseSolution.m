
function [L,D,TotalD,d0,d,v]=ParseSolution(q,nVar,demand,lorry,Dist)  
    q=round(q);   
    d=Dist(2:end,:);
    d0=Dist(1,:); 
    I = nVar;
    r = demand;
    dem = cumsum(r);
    v = [];
    for i =1:I
        veh = find(dem>lorry);
        if isempty (veh)
            break
        end
        v(i) = veh(1)-1;
        r(1:v(i))=0;
        dem = cumsum(r);   
    end
    if isempty(v)
        J = 1;
        v = length(q);
    elseif v(end)<I
        J = length(v)+1;
        v = [v,I];
    else
         J = length(v);
    end
       
    L=cell(J,1);   
    D=zeros(1,J);
    UC=zeros(1,J);
    for j=1:2:J
        L{j}=q(1:v(j));
        ii=j+1;
        if ii>J
            break
        else
            L{ii}=q(v(j)+1:v(ii));
        end
    end
       
    for j=1:J
        
        if ~isempty(L{j})
            
            D(j)=d0(L{j}(1));
            
            for k=1:numel(L{j})-1
                D(j)=D(j)+d(L{j}(k),L{j}(k+1));
            end
            
            D(j)=D(j)+d0(L{j}(end));

        end
    end

    TotalD=D;
end