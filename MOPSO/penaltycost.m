function [Penalty,SynC] = penaltycost(b,x,Dist,time)
speed = 70/60;
 dep = 600;
earl = 0.2;
lat = 0.2;
time = time ;
b = [b,length(x)];
if b(end)==b(end-1)
    b = b(1:end-1);
end

N = length (b);

for i = 1:2:N
    if i ==1
    Z{i} = x(1:b(i));
    else
    Z{i} = x(b(i-1)+1:b(i));
    end
    if i >= N
    break
    else
    Z{i+1} = x(b(i)+1:b(i+1));
    end
end

    for j = 1 : N
        B = cell2mat(Z(j));
        T = time(B,:);
        n = length (B);
        Pen = zeros(1,n);
        Syn = zeros(1,n);
        d = zeros(1,n);
        t = zeros(1,n);
      
        d(1) = Dist(1,B(1)+1);
        t(1) = (d(1)/speed)+dep;
        if t(1)<T(1,1)
            Pen(1) = earl*(T(1,1)-t(1));
            Syn(1) = (T(1,1)-t(1));
        elseif t(1)>T(1,1) & t(1)<T(1,2)
            Pen(1)=0;
            Syn(1)=0;
        else
            Pen(1)=lat*(t(1)-T(1,2));
            Syn(1)=t(1)-T(1,2);
        end
      
        for jj = 2:n
            d(jj) = Dist(B(jj-1)+1,B(jj)+1);
            t(jj) = (d(jj)/speed)+t(jj-1);
            if t(jj)<T(jj,1)
                Pen(jj) = earl*(T(jj,1)-t(jj));
                Syn(jj) = (T(jj,1)-t(jj));
            elseif t(jj)>T(jj,1) & t(jj)<T(jj,2)
                Pen(jj)=0;
                Syn(jj)=0;
            else
                Pen(jj)=lat*(t(jj)-T(jj,2));
                Syn(jj)=(t(jj)-T(jj,2));
            end
        end
        Penalty{j}=Pen;
        SynC{j}=Syn;
    end