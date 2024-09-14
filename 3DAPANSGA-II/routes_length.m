function [lensub,Veh,point,dem]= routes_length(x,D,demand,lorry)

    [point,dem]=break_point(x,demand,lorry);  %���ó��������ӳ���
    p=x+1;  %�ͻ�����Ȼ�������ڽӾ����λ��С1λ����һλΪDC��
    lensub=zeros(1,length(point)+1);  %�����洢��·��������
    if ~isempty(point)  %�ж��ǵ������Ƕ೵�����Ƕ೵��·�����зֶμ���
        lensub(1,1)=lensub(1,1)+D(1,p(1));
        for i=2:point(1)  %�����һ��������ʻ����
            lensub(1,1)=lensub(1,1)+D(p(i-1),p(i));
        end
        lensub(1,1)=lensub(1,1)+D(p(point(1)),1);
        for ii=2:length(point)  %�����м䳵����ʻ����
            lensub(1,ii)=lensub(1,ii)+D(1,p(point(ii-1)+1));
            for i=point(ii-1)+1:point(ii)-1
                lensub(1,ii)=lensub(1,ii)+D(p(i),p(i+1));
            end
            lensub(1,ii)=lensub(1,ii)+D(p(point(ii)),1);
        end
        lensub(1,length(point)+1)=lensub(1,length(point)+1)+D(1,p(point(length(point))+1));
        for i=point(length(point))+1:length(p)-1  %�������һ��������ʻ����
            lensub(1,length(point)+1)=lensub(1,length(point)+1)+D(p(i),p(i+1));
         end
            lensub(1,length(point)+1)=lensub(1,length(point)+1)+D(p(length(p)),1);

    else    %����ǵ�����ֱ�Ӽ���
        lensub(1,1)=lensub(1,1)+D(1,p(1));
        for i=2:length(p)
            lensub(1,1)=lensub(1,1)+D(p(i-1),p(i));
        end
        lensub(1,1)=lensub(1,1)+D(p(length(p)),1);  
    end
    Veh = length(lensub);