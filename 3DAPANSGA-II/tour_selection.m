function [parent_selected] = tour_selection(pool)


%% Binary Tournament Selection
[pop_size, distance]=size(pool);
rank=distance-1;
candidate=[randperm(pop_size);randperm(pop_size)]';

for i = 1: pop_size
    parent=candidate(i,:);                                  % Two parents indexes are randomly selected
 if pool(parent(1),rank)~=pool(parent(2),rank)              % For parents with different ranks
    if pool(parent(1),rank)<pool(parent(2),rank)            % Checking the rank of two individuals
        mincandidate=pool(parent(1),:);
    elseif pool(parent(1),rank)>pool(parent(2),rank)
        mincandidate=pool(parent(2),:);
    end
parent_selected(i,:)=mincandidate;                          % Minimum rank individual is selected finally
 else                                                       % for parents with same ranks  
    if pool(parent(1),distance)>pool(parent(2),distance)    % Checking the distance of two parents
        maxcandidate=pool(parent(1),:);
    elseif pool(parent(1),distance)< pool(parent(2),distance)
        maxcandidate=pool(parent(2),:);
    else
        temp=randperm(2);
        maxcandidate=pool(parent(temp(1)),:);
    end 
parent_selected(i,:)=maxcandidate;                          % Maximum distance individual is selected finally
end
end


    
    
    
    
    
    
    
    
    