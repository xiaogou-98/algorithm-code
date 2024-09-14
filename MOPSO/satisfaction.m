function f2 = satisfaction(L,time,d0,d,demand)
speed = 40;
dep = 2;

N = length(L); 
    for j = 1 : N
        B = cell2mat(L(j));
        T = time(B,:)*60;
        n = length (B);
        dem = demand(B);
        %totdem(j) = sum (dem);
        totdem = sum (dem);
        dis = zeros(1,n);
        t = zeros(1,n);
        z = zeros(1,n);
      
        dis(1) = d0(B(1));
        t(1) = (dis(1)/speed)+dep;
        z(1) = (trimf(t(1),T(1,:)));
      
        for jj = 2:n
            dis(jj) = d(B(jj-1),B(jj));
            t(jj) = (dis(jj)/speed)+t(jj-1);
            z(jj) = (trimf(t(jj),T(jj,:)));
        end

    end
    f2 = sum(dem.*z)/totdem;