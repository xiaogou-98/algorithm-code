function g=DecomposedCost(individual,x)

    if isfield(individual,'Cost')
        fx=individual.Cost;
    else
        fx=individual;
    end
    y=x;
    g=2;
    f(1)= 1000;  
   f(2)=  0;  
end