function [objective_value,optimal_locations,spatial_average_difference,...
    sa_opt,mse_opt,tsa,total_mse,iteration] = genetic_algorithm(k,er,location_list,datmatuse,total_latlist,total_longlist)
% Input - number of dimensions(k), elite-ratio(er),
% location_list (caution-location_list should be sorted)
% Output - optimal locations, function values, optimal weights, mse,
% iteration

% population size
if k<=20
    pop_s = 2*k;
else
    pop_s = 200;
end

% initialization of the population
% lat_sample = bestlh(pop_s,k,5,5);
lat_sample = rand(pop_s,k);
% long_sample = bestlh(pop_s,k,5,5);
long_sample = rand(pop_s,k);
old_sample = [lat_sample,long_sample];

selected_latlist = total_latlist(location_list);
selected_longlist = total_longlist(location_list);

% er = 0.05; % elite ratio
iteration = 1;
miwn = 0; % initializtion of maximum iterations without improvement
%% use this for normal simulation
[betamse,total_mse,ld] = cal_stat(datmatuse,location_list,selected_latlist);
cwm = sum(ld.*cosd(selected_latlist))/sum(cosd(selected_latlist));
%% use this for analysis of individual year simulations
% [betamse,total_mse,ld] = get_stat(datmatuse(:,location_list),selected_latlist);
%%
fprintf("mean square errror is %f\n",total_mse)
[f_val,spd,tsa,psa,mse] = optimal_placement(old_sample,betamse,...
    total_mse,datmatuse,selected_latlist,selected_longlist,ld,...
    location_list,cwm); % function values of old_sample
optimal_locations = [];
objective_value = [];
spatial_average_difference = [];
mse_opt = [];
sa_opt = [];

while iteration>=1
    fprintf("iteration-%d\n",iteration)
    f_ratio = f_val/sum(f_val);
    [old_best_val,~] = min(f_val);
    [mating_pool,srm] = selection(old_sample,f_ratio);
    obm = cross_over(mating_pool,f_val,srm);
    oam = mutation(obm);
    [new_sample,f_val,spd,psa,mse] = new_generation(old_sample,f_val,spd,...
        psa,mse,er,obm,oam,betamse,total_mse,datmatuse,selected_latlist,...
        selected_longlist,ld,location_list,cwm);
    [new_best_val,ind] = min(f_val);
    objective_value = [objective_value;new_best_val]; % difference in mse
    spatial_average_difference = [spatial_average_difference;spd(ind)];
     old_sample = new_sample;
     fprintf("optimal localtions are\n")
     [op,~] = conversion(new_sample(ind,:),selected_latlist,selected_longlist,location_list);
     disp(op)
     [~,index,~] = intersect(location_list,op);
     fprintf("function value at %d is %f \n",iteration,new_best_val);
     fprintf("total MSE of conisdered cluster is %f\n",total_mse)
     fprintf("corresponding MSE is %f\n",mse(ind))
     mse_opt = [mse_opt;mse(ind)];
     fprintf("corresponding spatial difference is %f\n",spd(ind))
     fprintf("total spatial average of considered cluster is %f\n",tsa);
     fprintf("corresponding spatial average is %f\n",psa(ind))
     sa_opt = [sa_opt;psa(ind)];
     optimal_locations = [optimal_locations;op];
     if new_best_val == old_best_val
         miwn = miwn+1; 
     else
         miwn = 0;
     end
     figure(1)
     plot(selected_longlist,selected_latlist,'*b')
     hold on
     plot(selected_longlist(index),selected_latlist(index),'*r')
     drawnow
     
     % stopping criteria
     if miwn == 20
         fprintf("solution exceeds maximum no of iterations without improvement \n")
         break;
     end
     if iteration > 100
         fprintf("solutions exceeds no of maximum iterations \n");
         break;
     end
     if new_best_val < 1e-4
         fprintf("solution is less than the tolerance %f\n",1e-4)
         break;
     end
     iteration = iteration+1;
end
end
