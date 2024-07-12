%% Tournament Selection
% Input- old_sample fitness_ratio
% Output- mating_pool and selected rows indices for mating_pool
function [mating_pool,srm] = selection(old_sample,f_ratio)
[row,~] = size(old_sample);
% [sorted_val,index] = sort(f_ratio);
nu = round(0.4*row);
% nu_ind = uint8(rlh(row,nu)*(row-1)+1);
nu_ind = randi(row,row,nu);
ft = f_ratio';
[~,I] = min(ft(nu_ind),[],2);
srm = NaN(row,1); % selected rows for mating_pool
for i=1:row
    srm(i) = nu_ind(i,I(i));
end
mating_pool = old_sample(srm,:);
end
