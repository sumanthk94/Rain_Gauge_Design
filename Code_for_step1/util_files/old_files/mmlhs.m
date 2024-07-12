function X_best = mmlhs(X_start,population,iteration,q)
 X_s = X_start;
 X_best = X_s;
 [n,~] = size(X_s);
 Phi_best = mmphi(X_best,q);
 leveloff = 0.85*iteration;
 for i=1:iteration
     if i<leveloff
         mutation = round((1+(0.5*n-1)*(leveloff-i)/(leveloff-1)));
     else
         mutation = 1;
     end
    X_improved = X_best;
    Phi_improved = Phi_best;
%     X_try = NaN(row,col,population);
%     Phi_try = NaN(1,population);
%     for j=1:population
%         X_try(:,:,j) = Peturb(X_best,mutation);
%         Phi_try(j) = mmphi(X_try(:,:,j),q); 
%     end
%     if sum(Phi_try<Phi_improved) ~= 0
%         [M,I] = min(Phi_try);
%         Phi_improved = M;
%         X_improved = X_try(:,:,I);
%     end
    for j=1:population
        X_try = Peturb(X_best,mutation);
        Phi_try = mmphi(X_try,q);
        
        if Phi_try < Phi_improved
            X_improved = X_try;
            Phi_improved = Phi_try;
        end
    end
    if Phi_improved < Phi_best
        X_best = X_improved;
        Phi_best = Phi_improved;
    end
 end
end