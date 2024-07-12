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
year_start = 1901;  year_end = 1991;
% months to average
month_start = 6; month_end = 9;
% compute Indices
numdaysinmonth = [30 31 30 31 31 30 31 30]; % number of days in April through November
cumsumdays = cumsum(numdaysinmonth);
cumsumdays = cat(2,0,cumsumdays);

daystartindex = cumsumdays(month_start-3) + 1;
dayendindex = cumsumdays(month_end-3 + 1);

odata = reshape(importdata('intersection_overall.dat'),1,[]);
[beta_op,MSE_op,ER_op] = cal_stat(datmat(daystartindex:dayendindex,...
    year_start-1900:year_end-1900,:),odata,total_latlist(odata));
dlmwrite(strcat('beta_overall_1901-',num2str(year_end),...
    num2str(year_end-1900),'intesection_overall_op_rs.dat'),...
    [beta_op,MSE_op;ER_op',MSE_op],'delimiter','\t')