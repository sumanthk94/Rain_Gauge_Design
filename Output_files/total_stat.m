close all 
clear
clc
%% data preprocessing
% load and read data
A = importdata('../../Code2/raindat0_25_deg.mat');
total_latlist = A.latlist;
total_longlist = A.lonlist;
% calculate average
datmat = permute(A.hrrainmat,[2,1,3]); %{(days,year,locations)}

% years to include in time series
year_start = 1901;  %year_end = 1910;
% months to average
month_start = 6; month_end = 9;
% compute Indices
numdaysinmonth = [30 31 30 31 31 30 31 30]; % number of days in April through November
cumsumdays = cumsum(numdaysinmonth);
cumsumdays = cat(2,0,cumsumdays);

daystartindex = cumsumdays(month_start-3) + 1;
dayendindex = cumsumdays(month_end-3 + 1);

% load cluster data
idx = importdata('cluster_114years_20clus.dat');
year_end = [1960,1970,1980]; %[1910,1920,1930,1940,1950];
op = [25,40,50,75];
cs = 20; %[25,20,10];
% op = [8,16,20,32,40,48,60;
%     10,20,25,40,50,60,75;
%     20,40,50,80,100,120,150];
for i=1:3
    for j=op
        outdata = importdata(strcat('output_1901-',num2str(year_end(i))...
            ,'_',num2str(year_end(i)-1900),'years_20clus_',num2str(j),'op_rs.dat'));
%         outdata = importdata(strcat('output_114years_k_',num2str(j),'_',...
%             num2str(cs(i)),'clus_rs.dat'));
        datmatuse2d = datmat;
        latlist1 = total_latlist;
        locations = 1:4964;
        olist = reshape(outdata(:,1:j),1,[]);
        [beta_op,MSE_op,ER_op] = cal_stat(datmatuse2d(daystartindex:dayendindex,...
            year_start-1900:year_end(i)-1900,:),olist,total_latlist(olist));
         dlmwrite(strcat('beta_overall_1901-',num2str(year_end(i)),'_20clus_',...
        num2str(year_end(i)-1900),'years_',num2str(j),'op_rs.dat'),[beta_op,MSE_op;
        ER_op',MSE_op],'delimiter','\t')
%          dlmwrite(strcat('weights for_k_',num2str(j),'_114years_',...
%              num2str(cs(i)),'clus.dat'),[beta_op,MSE_op],'delimiter','\t')
    end
end
% % load output data
% out_data = importdata('output_1901-1910_10years_20clus_75op.dat');
% % k = 10; % number of groups
% mse_clus = NaN(1,20); %{years,clusters}
% spa_clus = NaN(1,20);
% mse_op = NaN(1,20); %{years,clusters}
% beta_y_op = NaN(25,20); %{years,number of locations,clusters}
% Er_op = NaN(25,20);
%% this section is to calculate the 
% for year=2001:2014
%     tic
%     odata = NaN(k,107); % output data
%     parfor i=1:k
%         datmatuse2d = datmat;
%         locations = 1:1:4964;
%         group = locations(idx==i);
% 
%         [objective_value,optimal_locations,spatial_average_difference,...
%         sa_opt,mse_opt,tsa,total_mse,iterations] = genetic_algorithm(100,0.05,group,datmatuse2d(daystartindex:dayendindex,year-1900,:),total_latlist,total_longlist);
% 
%         odata(i,:) = [optimal_locations(end,:),objective_value(end),...
%         spatial_average_difference(end),sa_opt(end),...
%         mse_opt(end),tsa,total_mse,iterations];
%     end
%     dlmwrite(strcat('output_',num2str(year),'_10clus_54years.txt'),odata,'delimiter','\t');
% toc
% end
% %% uncomment the section for the calculation of 60 years stats
% spa_clus = NaN(20,20);
% spa_op = NaN(20,20);
% msemin_clus = NaN(20,20);
% msemin_op = NaN(20,20)
%%
%     for j=1:20
%         clus_list = locations(idx==j);
%         op_list = outdata(j,1:25);
%         [beta_clus,mse_clus(1,j),Er_clus] = cal_stat(datmatuse2d(daystartindex:dayendindex,year_start-1900:year_end-1900,:),clus_list,latlist1(clus_list));
%         [beta_y_op(:,j),mse_op(1,j),Er_op(:,j)] = cal_stat(datmatuse2d(daystartindex:dayendindex,year_start-1900:year_end-1900,:),op_list,latlist1(op_list));
%         spa_clus(1,j) = sum(0.8*(beta_clus.*Er_clus'))/sum(0.8*beta_clus);
% %         spa_op(i,j) = sum(0.8*(beta_op.*Er_op'))/sum(0.8*beta_op);
%     end
%     toc
% end

