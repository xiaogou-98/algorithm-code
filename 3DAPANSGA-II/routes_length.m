function [lensub,Veh,point,dem]= routes_length(x,D,demand,lorry)

    [point,dem]=break_point(x,demand,lorry);  %调用车辆分配子程序
    p=x+1;  %客户的自然序列在邻接矩阵的位置小1位（第一位为DC）
    lensub=zeros(1,length(point)+1);  %创建存储子路径的数组
    if ~isempty(point)  %判断是单车还是多车，若是多车对路径进行分段计算
        lensub(1,1)=lensub(1,1)+D(1,p(1));
        for i=2:point(1)  %计算第一辆车的行驶距离
            lensub(1,1)=lensub(1,1)+D(p(i-1),p(i));
        end
        lensub(1,1)=lensub(1,1)+D(p(point(1)),1);
        for ii=2:length(point)  %计算中间车的行驶距离
            lensub(1,ii)=lensub(1,ii)+D(1,p(point(ii-1)+1));
            for i=point(ii-1)+1:point(ii)-1
                lensub(1,ii)=lensub(1,ii)+D(p(i),p(i+1));
            end
            lensub(1,ii)=lensub(1,ii)+D(p(point(ii)),1);
        end
        lensub(1,length(point)+1)=lensub(1,length(point)+1)+D(1,p(point(length(point))+1));
        for i=point(length(point))+1:length(p)-1  %计算最后一辆车的行驶距离
            lensub(1,length(point)+1)=lensub(1,length(point)+1)+D(p(i),p(i+1));
         end
            lensub(1,length(point)+1)=lensub(1,length(point)+1)+D(p(length(p)),1);

    else    %如果是单车，直接计算
        lensub(1,1)=lensub(1,1)+D(1,p(1));
        for i=2:length(p)
            lensub(1,1)=lensub(1,1)+D(p(i-1),p(i));
        end
        lensub(1,1)=lensub(1,1)+D(p(length(p)),1);  
    end
    Veh = length(lensub);