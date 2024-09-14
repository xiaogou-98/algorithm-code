function i=RouletteWheelSelection(P)
%% 轮盘赌算子  %找到指针落在哪个位置
    r=rand;
    
    C=cumsum(P);
    
    i=find(r<=C,1,'first');

end