function [tour,Cost,Best] = exchange2(tour,D,Cost)
%
n = numel(tour);               % vertex number
Best=zeros([],1);              % Array to Hold Best Cost Values
Best(1,1)=Cost;
zmin = -Cost;
k=1;
% Iterate until the tour is 2-optimal
while zmin/Cost < -1e-6        
    k=k+1;
    zmin = 0;
    i = 0;
    b = tour(n);               % Select the last vertex   
    % Loop over all edge pairs (ab,cd) 
    while i < n-2                
        a = b;                  
        i = i+1;
        b = tour(i);           % select the second vertex
        Dab = D(a,b);          % Calculation of the Cost 
        j = i+1;
        d = tour(j);           % select the third vertex
        % Calculation of the new Cost
        while j < n
            c = d;
            j = j+1;
            d = tour(j);       % select the forth vertex
            % Tour length diff z
            % Note: a == d will occur and give z = 0
            z = (D(a,c) - D(c,d)) + D(b,d) - Dab;
            % Keep best exchange
            if z < zmin
                zmin = z;
                imin = i;
                jmin = j;
            end
        end
    end
    % Apply exchange
    if zmin < 0
        tour(imin:jmin-1) = tour(jmin-1:-1:imin);
        Cost = Cost + zmin;
        Best(k,1)=Cost;
    end 
end