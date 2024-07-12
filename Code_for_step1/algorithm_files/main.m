clear
% close all
clc
%% data preprocessing 
% Input data
% years to include in time series
year_start = 1901;  year_end = 1991;

% months to average
month_start = 6; month_end = 9;


% load and read data
A = importdata('../../Code2/raindat0_25_deg.mat');
total_latlist = A.latlist;
total_longlist = A.lonlist;

% calculate average
datmat = permute(A.hrrainmat,[2,1,3]); %{(days,year,locations)}

% compute Indices
numdaysinmonth = [30 31 30 31 31 30 31 30]; % number of days in April through November
cumsumdays = cumsum(numdaysinmonth);
cumsumdays = cat(2,0,cumsumdays);

daystartindex = cumsumdays(month_start-3) + 1;
dayendindex = cumsumdays(month_end-3 + 1);


%%
k = 20; %[25,20,10]; % number of groups
for l=1:length(k)
idx = importdata(strcat('cluster_114years_',num2str(k(l)),'clus.dat'));
% year_end = [1910,1920,1930,1940,1950];
year_start = 1952; %[1962,1962,1972,1982];
op = [25,40,50,75];
% op = [8,16,20,32,40,48,60;
%     10,20,25,40,50,60,75;
%     20,40,50,80,100,120,150];
% data that we need to use
for m=op(l,:)
    tic
    odata = NaN(k(l),m+7); % output data
    for j = year_start
        datmatuse = datmat(daystartindex:dayendindex,j-1900:year_end-1900,:);
        for i=1:k(l)
        locations = 1:1:4964;
        dat_mat = datmatuse;
        group = locations(idx==i);
        [objective_value,optimal_locations,spatial_average_difference,...
            sa_opt,mse_opt,tsa,total_mse,iterations] = ...
            genetic_algorithm(m,0.05,group,dat_mat,total_latlist,total_longlist); 
        odata(i,:) = [optimal_locations(end,:),objective_value(end),...
            spatial_average_difference(end),sa_opt(end),...
            mse_opt(end),tsa,total_mse,iterations];
%         figure(i)
%         set(gcf,'color','w')
%         hold on
%         plot(objective_value,'LineWidth',2)
%         set(gca,'FontSize',15)
%         xlabel('\textbf{Iterations}','Interpreter','latex','fontsize',15,...
%             'FontWeight','bold')
%         ylabel('\textbf{Objective Value}','Interpreter','latex','fontsize',15,...
%             'FontWeight','bold')
%         drawnow
        end
%       dlmwrite(strcat('output_1901-',num2str(j),'_',...
%           num2str(j-1900),'years_20clus_',num2str(m),...
%           'op_rs.dat'),odata,'delimiter','\t');
      dlmwrite(strcat('output_',num2str(j),'-1991_',...
          num2str(j-year_end+1),'years_20clus_',num2str(m),...
          'op_rs.dat'),odata,'delimiter','\t');
%         dlmwrite(strcat('output_114years_k_',num2str(m),'_',...
%             num2str(k(l)),'clus_rs.dat'),odata,'delimiter','\t');
%         
    end
    toc
end
end