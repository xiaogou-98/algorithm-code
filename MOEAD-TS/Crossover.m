function y=Crossover(p1,p2,K)

gamma=K.gamma;
VarMin=K.VarMin;
VarMax=K.VarMax;
alpha=unifrnd(-gamma,1+gamma,size(p1));
y=alpha.*p1+(1-alpha).*p2;
y=min(max(y,VarMin),VarMax);

end