%% cross over - uniform cross over
% Input-mating_pool, function values and selected rows indices for
% mating_pool
% Output-offsprings before mutation (obm)
function obm = cross_over(mating_pool,f_val,srm)
[row,~] = size(mating_pool);
obm = NaN(size(mating_pool));
fmin = min(f_val);
favg = mean(f_val);
for i = 1:2:row
    p1_index = 0; p2_index = 0;
    while p1_index == p2_index
        indices = randperm(row,2);
        p1_index = srm(indices(1));
        p2_index = srm(indices(2));
    end
    frp = [f_val(p1_index),f_val(p2_index)];
    frpm = min(frp);
    if frpm<=favg
        Pc = 0.3*(frpm-favg)/(fmin-favg);
    else
        Pc = 0.9;
    end
    c1 = mating_pool(p1_index,:).*(mating_pool(p1_index,:)>Pc) +...
        mating_pool(p2_index,:).*(mating_pool(p1_index,:)<Pc);
    c2 = mating_pool(p1_index,:).*(mating_pool(p2_index,:)<Pc) +...
        mating_pool(p2_index,:).*(mating_pool(p2_index,:)>Pc);
    obm(i:i+1,:) = [c1;c2];
end
end