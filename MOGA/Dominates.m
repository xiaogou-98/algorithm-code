
function b=Dominates(x,y)   

    if isstruct(x)   
        x=[x.F1 x.F2];    
    end
    
    if isstruct(y)
        y=[y.F1 y.F2];
    end

    b=all(x<=y) && any(x<y);   

end