function err_norm  = normalisation(error_pop)
  

 
%% Error Nomalisation
[N,nc]=size(error_pop);
 con_max=0.001+max(error_pop);
 con_maxx=repmat(con_max,N,1);
 cc=error_pop./con_maxx;
 err_norm=sum(cc,2);                % finally sum up all violations
 

 