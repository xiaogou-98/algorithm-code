
 function angleR=angle(a)
    n=length(a);  
    xy_angle=zeros(1,n-1);
    for i=2:length(a)  
        x_arrow=a(i,1)-a(1,1);
        y_arrow=a(i,2)-a(1,2);
        if x_arrow==0  
            if y_arrow==0
                xy_angle(i-1)=0;
            elseif y_arrow>0
                xy_angle(i-1)=pi/2;
            else
                xy_angle(i-1)=3*pi/2;
            end
        elseif x_arrow>0  
            if y_arrow>0  
                xy_angle(i-1)=atan(y_arrow/x_arrow);  
            else    
                xy_angle(i-1)=2*pi+atan(y_arrow/x_arrow);
            end
        else    
            xy_angle(i-1)=pi+atan(y_arrow/x_arrow);
        end
    end
    [angle_sequence,angleR]=sort(xy_angle(1:n-1));  
