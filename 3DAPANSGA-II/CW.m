function x = CW(A,D,Cap)
% A is a matrix of 3 lines with A(1) and A(2)refering to the coordinates including the origin
% and A(3)designating the demands. Note that the demand corresponding to...
% the origin is 0.
% Cap is the limit capacity of the transportation vehicle
[~,m]=size(A);
p=zeros(m,m);
for i=2:(m-1)    %p���ǶԳƾ��󣬽�Լ�������
    for j=(i+1):m
        p(i,j)=D(1,i)+D(1,j)-D(i,j);
    end
end

s=p(:);     %�Ծ�����н�������
[hs,wz]=sort(s,1,'descend');
for i=1:(m^2)     
    [x,y]=ind2sub(size(p),wz(i)); 
    if A(3,x)+A(3,y)<=Cap    
        solut=[x,y];
        n(1)=2;
        zhuang(1)=A(3,x)+A(3,y);
        ii=i;
        break
    else
       continue
    end
end  
    for rr=(ii+1):(m^2)      %ѭ������������·�������һ�б�ʾһ����·
        [x,y]=ind2sub(size(p),wz(rr));
        if hs(rr)==0
            break
        end
        
     [xa,ya]=find(x==solut);                
     [xb,yb]=find(y==solut);
     [sa,sb]=size(solut);
     if isempty(xa)==0 && isempty(xb)==0      %�¼������������ԭ����·���ҵõ�
         if xa==xb
             continue        %��������һ�����ϣ�����
         end
         
      if n(xa)~=2     %n(xa)�����ܵ���1  ������һ������һ����·�м����ȣ�����
            if 1<ya<n(xa) 
               continue
            end
      end
      
      if n(xb)~=2    %n(xb)�����ܵ���1������һ������һ����·�м����ȣ�����
            if 1<yb<n(xb) 
               continue
            end
      end
      
         zh1=zhuang(xa);
         zh2=zhuang(xb);
      if zhuang(xa)+zhuang(xb)<=Cap   %��������������·�ı߽�㣬������·������֮��û�г����������
          if ya==1&&yb==1
              newm=[solut(xb,n(xb):-1:1) solut(xa,1:n(xa))];
          elseif ya==1&&yb==n(xb)
               newm=[solut(xb,1:n(xb)) solut(xa,1:n(xa))];
          elseif ya==n(xa)&&yb==1
              newm=[solut(xa,1:n(xa)) solut(xb,1:n(xb))];
          elseif ya==n(xa)&&yb==n(xb)
              newm=[solut(xa,1:n(xa)) solut(xb,n(xb):-1:1)];
          end
          
          xab = [xa,xb];
          solut(xab,:)=[];
          n(xab)=[];
          zhuang(xab)=[];
%           solut(xa,:)=[];
%           solut(xb,:)=[];
         
%           n(xa)=[];
%           n(xb)=[];
%           zhuang(xa)=[];
%           zhuang(xb)=[];
          
          [qa,qb]=size(solut);          
      
          solut((qa+1),1:length(newm))=newm;
          n(qa+1)=length(newm);
          
          zhuang(qa+1)=zh1+zh2;
          
      else                       
          continue
      end
      
     elseif isempty(xa)==0     %�¼������������ԭ����·ֻ���ҵ�һ��    
         
       if n(xa)~=2      %n(xa)�����ܵ���1���������һ����·���м䲻��
            if 1<ya<n(xa) 
               continue
            end
       end
       
       zh3=zhuang(xa)+A(3,y);
    if zhuang(xa)+A(3,y)<=Cap          %�������ԭ����·�ı߽��ϣ�������û�г����������
        if ya==1
            newm=[y solut(xa,1:n(xa))];
        elseif ya==n(xa)                 %��elseҲ����
               newm=[solut(xa,1:n(xa)) y];
        end
        solut(xa,:)=[];
        n(xa)=[];
        zhuang(xa)=[];
        [qa,qb]=size(solut);            
                                       
        solut((qa+1),1:length(newm))=newm;
        n(qa+1)=length(newm);
        zhuang(qa+1)=zh3;
    end
        
     elseif isempty(xb)==0                   
      
     if n(xb)~=2                     
            if 1<yb<n(xb) 
               continue
            end
      end
       
       zh4=zhuang(xb)+A(3,x);
    if zhuang(xb)+A(3,x)<=Cap
        if yb==1
            newm=[x solut(xb,1:n(xb))];
        elseif yb==n(xb)                 %��elseҲ����
               newm=[solut(xb,1:n(xb)) x];
        end
        solut(xb,:)=[];
        n(xb)=[];
        zhuang(xb)=[];
        [qa,qb]=size(solut);
        solut((qa+1),1:length(newm))=newm;
        n(qa+1)=length(newm);
        zhuang(qa+1)=zh4;
    end
    
     else                                         
         zh5=A(3,x)+A(3,y);
         if zh5<=Cap
             newm=[x y];
            [qa,qb]=size(solut);
            solut((qa+1),1:length(newm))=newm;
            n(qa+1)=length(newm);
            zhuang(qa+1)=zh5;
         end
     end
    end
    
    if sum(n)<(m-1)                             
      for i=2:m
       [qqqa,qqqb]=size(solut);
       kk=find(i==solut);                          
       if isempty(kk)
          solut(qqqa+1,1)=i;
          n(qqqa+1)=1;
          zhuang(qqqa+1)=A(3,i);
       end
      end
    end
       
    [op,ok]=size(solut);                    %��������ܵĳɱ������룩
    for i=1:op
        solut(i,n(i)+1)=1;
    end
    solut=[ones(op,1) solut];
    
    opt=0;
    for i=1:op
        for j=2:(n(i)+2)                  
            med=D(solut(i,j-1),solut(i,j));
            opt=opt+med;
        end
    end
    solut=solut-1;                        
    %% Mon ajout (Kevin)
    [m,n]=size(solut);
    solut = solut';
    x = reshape(solut,1,(m*n));
    x(x<=0)=[];