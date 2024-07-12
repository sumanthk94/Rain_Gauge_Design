clear
clc
close all
k=2;
if k<=20
    pop_s = 100;
else
    pop_s = 200;
end

% initialization of the population
old_sample =bestlh(pop_s,k,30,30);
er = 0.05; % elite ratio
iteration = 1;
miwn = 0; % initializtion of maximum iterations without improvement
f_val = fun(old_sample);

while iteration>=1
    fprintf("iteration-%d\n",iteration)
    f_ratio = f_val/sum(f_val);
    [old_best_val,~] = min(f_val);
    [mating_pool,srm] = selection(old_sample,f_ratio);
    obm = cross_over(mating_pool,f_val,srm);
    oam = mutation(obm);
    [new_sample,f_val] = new_generation(old_sample,f_val,er,obm,oam);
    [new_best_val,ind] = min(f_val);
    fprintf("new_best_value is %f\n",new_best_val)
    fprintf("samples are:")
    disp(new_sample(ind,:))
     old_sample = new_sample;
     if new_best_val == old_best_val
         miwn = miwn+1; 
     else
         miwn = 0;
     end
     
     % stopping criteria
     if miwn == 10
         fprintf("solution exceeds maximum no of iterations without improvement \n")
         break;
     end
     if iteration > 100*k
         fprintf("solutions exceeds no of maximum iterations \n");
         break;
     end
     if new_best_val < 1e-4
         fprintf("solution is less than the tolerance %f\n",1e-4)
         break;
     end
     iteration = iteration+1;
end
function [mating_pool,srm] = selection(old_sample,f_ratio)
[row,~] = size(old_sample);
% [sorted_val,index] = sort(f_ratio);
nu = round(0.4*row);
nu_ind = uint8(rlh(row,nu)*(row-1)+1);
ft = f_ratio';
[~,I] = min(ft(nu_ind),[],2);
srm = NaN(row,1); % selected rows for mating_pool
for i=1:row
    srm(i) = nu_ind(i,I(i));
end
mating_pool = old_sample(srm,:);
end
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
function oam = mutation(obm)
[row,col] = size(obm);
% fval = optimal_placement(obm,betamse,latlist,lonlist,ld);
mcf = rand(row,col);
Pm = 0.2;
temp = rand(row,col);
oam = obm.*(mcf>Pm) + temp.*(mcf<Pm);
end
function [new_sample,nfv] = new_generation(old_sample,f_ov,er,obm,oam)
[row,col] = size(old_sample);
new_sample = zeros(row,col);
nfv = NaN(row,1);
l = ceil(er*row);

% get the samples from elite ratio
% consider the old function values-f_ov
[sfov,oi] = sort(f_ov);
new_sample(1:l,:) = old_sample(oi(1:l),:);
nfv(1:l) = sfov(1:l);

% now with the offsprings obm and oam
total_samples = [old_sample;obm;oam];
f_os = fun([obm;oam]);
f_total = [f_ov;f_os];

% extract unique values and unique id's
[~,f_ui] = unique(f_total);

% extract values from offsprings
f_uos = f_total(f_ui(f_ui>row));
unique_ofs = total_samples(f_ui(f_ui>row),:);

% get the size of the offsprings
[r,~] = size(f_uos);
if r< row-l
    a_samples = bestlh(row,col,5,5);
    new_sample(l+1:l+r,:) = unique_ofs;
    f_val = fun(a_samples);
    [s,in] = sort(f_val);
    new_sample(l+r+1:row,:) = a_samples(in(1:row-l-r),:);
    nfv(l+1:row) = [f_uos;s(1:row-l-r)];
else
    new_sample(l+1:row,:) = unique_ofs(1:row-l,:);
    nfv(l+1:row) = f_uos(1:row-l);
end
end