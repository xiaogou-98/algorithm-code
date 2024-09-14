function mutated_child = poly_mutation(y)
global V xl xu etam pm

del=min((y-xl),(xu-y))./(xu-xl);
t=rand(1,V);
loc_mut=t<pm;        
u=rand(1,V);
delq=(u<=0.5).*((((2*u)+((1-2*u).*((1-del).^(etam+1)))).^(1/(etam+1)))-1)+(u>0.5).*(1-((2*(1-u))+(2*(u-0.5).*((1-del).^(etam+1)))).^(1/(etam+1)));
c=y+delq.*loc_mut.*(xu-xl);
mutated_child=c;
    
