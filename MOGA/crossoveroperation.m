function Newstring=crossoveroperation( parent_strin1 ,  parent_strin2,  nVar)%先随机交叉，再打乱位置
strin1 =  randperm(  nVar )  ;
strin2 =   randperm(  nVar )  ;
OFspring = MPX(strin1,   strin2,  nVar)  ;
Newstring_1  =   parent_strin1( OFspring  ); 
OFspring = MPX( strin2, strin1,   nVar)  ;
Newstring_2  = parent_strin2( OFspring  ); 

if  rand<0.5
    Newstring =Newstring_1;
else
    Newstring =Newstring_2;
end


function   OFspring = MPX(strin1,   strin2,  nVar)

kk = randperm(  nVar );  
t=randperm(  nVar-1,1 ); 

v1=kk (1:t ); 


OFspring=zeros( size( strin1 ));

aa=strin1(   v1 );
OFspring(1:  length( v1 ) )= aa;

for  i= nVar: -1 :1
    
    if  any(  strin2(i)==  aa       )
        strin2(i)=[];
    end
    
end

OFspring(length( v1 ) +1:end)= strin2;
