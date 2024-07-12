clear
close all
clc


%% data preprocessing 
% Input data
% years to include in time series
% year_start = 1901;  year_end = 1991;

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

dy = [10,20,30,40,50];
yc = [1910,1920,1930,1940,1950];
op = [25,40,50,75];

year_start_valid = 1951;
year_start_train = 1901;
year_end = 2014;
%% MSE values during training 
train_mse = NaN(length(op),length(dy));
train_var = NaN(length(op),length(dy));
train_bias = NaN(length(op),length(dy));

valid_mse = NaN(length(op),length(dy));
valid_var = NaN(length(op),length(dy));
valid_bias = NaN(length(op),length(dy));
for j = 1%1:length(op)
    for i=1%1:length(dy)
        oloc = importdata(strcat('output_1901-',num2str(yc(i)),'_',...
            num2str(dy(i)),'years_20clus_',num2str(op(j)),'op_rs.dat'));
        oloc = reshape(oloc(:,1:op(j)),1,[]);
        beta = importdata(strcat('beta_overall_1901-',num2str(yc(i)),...
            '_20clus_',num2str(dy(i)),'years_',num2str(op(j)),'op_rs.dat'));
        beta = beta(1,1:20*op(j));
        [train_mse(j,i),train_bias(j,i),train_var(j,i)] = mse(beta',...
            datmat(daystartindex:dayendindex,...
            year_start_train-1900:yc(i)-1900,:),oloc,0.8,...
            total_latlist(oloc));
        [valid_mse(j,i),valid_bias(j,i),valid_var(j,i)] = mse(beta',...
            datmat(daystartindex:dayendindex,...
            year_start_valid-1900:end,:),oloc,0.8,...
            total_latlist(oloc));
    end
end