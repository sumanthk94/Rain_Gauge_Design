 %% new generation
% Input - old_sample, old_function_values, elite ratio, offsprings before
% and after mutation, weights, latitude and longitude list, mean accros the
% year at choosen locations (ld), choosen location list
% Output - new_samples and new function values

function [new_sample,nfv,nspd,npsav,nmse] = new_generation(old_sample,f_ov,spd_ov,...
    psa_ov,mse_ov,er,obm,oam,betamse,total_mse,datmatuse,latlist,lonlist,...
    ld,location_list,cwm)
[row,col] = size(old_sample);
new_sample = zeros(row,col);
nfv = NaN(row,1);
nspd = NaN(row,1);
npsav = NaN(row,1);
nmse = NaN(row,1);
l = ceil(er*row);

% get the samples from elite ratio
% consider the old function values-f_ov
[sfov,oi] = sort(f_ov);
new_sample(1:l,:) = old_sample(oi(1:l),:);
nfv(1:l) = sfov(1:l);
nspd(1:l) = spd_ov(oi(1:l));
npsav(1:l) = psa_ov(oi(1:l));
nmse(1:l) = mse_ov(oi(1:l));

% now with the offsprings obm and oam
total_samples = [old_sample;obm;oam];
[f_os,spd_nv,~,psa_nv,mse_nv] = optimal_placement([obm;oam],betamse,total_mse,...
    datmatuse,latlist,lonlist,ld,location_list,cwm);
f_total = [f_ov;f_os];
spd_total = [spd_ov;spd_nv];
psa_total = [psa_ov;psa_nv];
mse_total = [mse_ov;mse_nv];

% extract unique values and unique id's
[~,f_ui] = unique(f_total);

% extract values from offsprings
f_uos = f_total(f_ui(f_ui>row));
spd_u = spd_total(f_ui(f_ui>row));
psa_u = psa_total(f_ui(f_ui>row));
mse_u = mse_total(f_ui(f_ui>row));
unique_ofs = total_samples(f_ui(f_ui>row),:);

% get the size of the offsprings
[r,~] = size(f_uos);
if r< row-l
%     a_lat = bestlh(row,col/2,5,5);
    a_lat = rand(row,col/2);
%     a_lon = bestlh(row,col/2,5,5);
    a_lon = rand(row,col/2);
    a_samples = [a_lat,a_lon];
    new_sample(l+1:l+r,:) = unique_ofs;
    [f_val,mval,~,mpsa,mmse] = optimal_placement(a_samples,betamse,total_mse,...
        datmatuse,latlist,lonlist,ld,location_list,cwm);
    [s,in] = sort(f_val);
    new_sample(l+r+1:row,:) = a_samples(in(1:row-l-r),:);
    nfv(l+1:row) = [f_uos;s(1:row-l-r)];
    nspd(l+1:row) = [spd_u;mval(1:row-l-r)];
    npsav(l+1:row) = [psa_u;mpsa(1:row-l-r)];
    nmse(l+1:row) = [mse_u;mmse(1:row-l-r)];
else
    new_sample(l+1:row,:) = unique_ofs(1:row-l,:);
    nfv(l+1:row) = f_uos(1:row-l);
    nspd(l+1:row) = spd_u(1:row-l);
    npsav(l+1:row) = psa_u(1:row-l);
    nmse(l+1:row) = mse_u(1:row-l);
end
end