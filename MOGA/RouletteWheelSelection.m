function i=RouletteWheelSelection(P)
%% ���̶�����  %�ҵ�ָ�������ĸ�λ��
    r=rand;
    
    C=cumsum(P);
    
    i=find(r<=C,1,'first');

end