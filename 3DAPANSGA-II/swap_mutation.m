function mutated_child = swap_mutation(y)
    L=length(y);
    rray=randperm(L);  
    [y(rray(1)),y(rray(2))]=exchange(y(rray(1)),y(rray(2)));  
mutated_child=y;    
