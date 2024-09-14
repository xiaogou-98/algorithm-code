
 function [T1,T2,T3,point1,point2,point3]=break_point1(x,demand,lorry,L,W)  
    x = round (x);
    A = find(x>L & x<W);
    B = find(x>L & x>W);
    T2 = x(A);
    T3 = x(B);
    P = find(~ismember((x),T2) & ~ismember((x),T3));
    T1 = x(P);
    C = find(T1==L);
    T1(C) = [];
    D = find(T1==W);
    T1(D) = [];
    clear A B C D P
    qq1=demand(T1);
    qq2=demand(T2);
    qq3=demand(T3);
    N1=length(T1);
    N2=length(T2);
    N3=length(T3);
    TT1=zeros(1,N1);
    TT2=zeros(1,N2);
    TT2=zeros(1,N3);
    point1=zeros(1,N1);
    point2=zeros(1,N2);
    point3=zeros(1,N3);
    TT1=cumsum(qq1); 
    TT2=cumsum(qq2);  
    TT3=cumsum(qq3); 
    aa1=find(TT1>lorry);  
    aa2=find(TT2>lorry);  
    aa3=find(TT3>lorry);  
    %%
    if  isempty(aa1)  
         point1=[];
    else
         point1(1)=aa1(1)-1;  
         for i=2:N1 
             TT1=[zeros(1,point1(i-1)),cumsum(qq1(point1(i-1)+1:N1))];
             aa1=find(TT1>lorry);  
             if ~isempty(aa1)
                 point1(i)=aa1(1)-1;
             else
                 break;  
             end
         end
    end
    %%
    if  isempty(aa2)  
         point2=[];
    else
         point2(1)=aa2(1)-1;  
         for i=2:N2  
             TT2=[zeros(1,point2(i-1)),cumsum(qq2(point2(i-1)+1:N2))];
             aa2=find(TT2>lorry);  
             if ~isempty(aa2)
                 point2(i)=aa2(1)-1;
             else
                 break;  
             end
         end
    end
     %%
    if  isempty(aa3)  
         point3=[];
    else
         point3(1)=aa3(1)-1;  
         for i=2:N3  
             TT3=[zeros(1,point3(i-1)),cumsum(qq3(point3(i-1)+1:N3))];
             aa3=find(TT3>lorry);  
             if ~isempty(aa3)
                 point3(i)=aa3(1)-1;
             else
                 break;  
             end
         end
    end
    %%
    point1(find(point1==0))=[];  
    point2(find(point2==0))=[];  
    point3(find(point3==0))=[];  
