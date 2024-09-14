function child_offspring  = genetic_operator(parent_selected,V)
%% Description
% 1. Crossover followed by mutation
% 2. Input is in 'parent_selected' matrix of size [pop_size,V].
% 3. Output is also of same size in 'child_offspring'. 

%% Reference 
% Deb & samir agrawal,"A Niched-Penalty Approach for Constraint Handling in Genetic Algorithms". 
%% OX (ORDER CROSSOVER) cross over operation + POLYNOMIAL MUTATION
[N] = size(parent_selected,1);
     for i=1:2:N
         if i < N
                  A=parent_selected(i,:);
                  B=parent_selected(i+1,:);
%                   [A,B]=intercross(A,B);% PMX
                  [A,B] = OX(A,B,V);% OX
                  child(i,:) = A;
                  child(i+1,:) = B;
                  child_offspring((i+1),:)=swap_mutation(child(i,:)); % polynomial mutation
                  child_offspring(i,:)=swap_mutation(child(i+1,:)); % polynomial mutation
         end     
              if i > N
                 child_offspring((i-2),:)=swap_mutation(child1);
              end
     end
end
