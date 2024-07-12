function [list,spd,tsa,psa,mse] = optimal_placement(X,betamse,total_mse,...
    datmatuse,selected_latlist,selected_longlist,ld,location_list,cwm)
%% Input
% sample point in the population
% lat and lon list corresponding to choosen location list
% ld - consists average acroos years at all choosen locations
%% Output
% list - difference between mse by considering all points location list and 
% at choosen locations
% spd spatial difference 
%%
[row,col] = size(X);
ob = betamse; % entire beta values
pb = NaN(row,col/2);
mse = NaN(row,1);
temp = NaN(row,col/2);
l_ind = NaN(row,col/2);
ia = NaN(row,col/2);
parfor i=1:row
    [temp(i,:),l_ind(i,:)] = conversion(X(i,:),selected_latlist,selected_longlist,location_list);
end
parfor i=1:row
    lat_list = selected_latlist;
    % use this for normal simulations for overall year data
    [pb(i,:),mse(i),~] = cal_stat(datmatuse,temp(i,:),lat_list(l_ind(i,:)));
    % use this for an year data simulations (Analysis part)
%     dat_mat = datmatuse;
%     [pb(i,:),mse(i),~] = get_stat(dat_mat(:,temp(i,:)),lat_list(l_ind(i,:)));
    [~,ia(i,:),~] = intersect(location_list,temp(i,:),'stable');
end
%% conversion of choosen location list into their indices in the total list
tsa = sum(ob.*ld')/sum(ob);
psa = sum(pb.*ld(ia),2)./sum(pb,2);
spd = abs(tsa-psa);
% rho = 0.5;
list = 1*mse+0*abs(cwm-psa);
fprintf("total mse is %f\n",total_mse)
end