clear
clc
close all

%% general preprocessing
cluster = importdata('cluster_114years_20clus.dat');
A = importdata('../../Code2/raindat0_25_deg.mat');
total_latlist = A.latlist;
total_longlist = A.lonlist;
datmat = permute(A.hrrainmat,[2,1,3]); %{(days,year,locations)}
locations = 1:1:4964;
year_start = 1901; year_end = 2014;

% months to average
month_start = 6; month_end = 9;

% compute Indices
numdaysinmonth = [30 31 30 31 31 30 31 30]; % number of days in April through November
cumsumdays = cumsum(numdaysinmonth);
cumsumdays = cat(2,0,cumsumdays);

daystartindex = cumsumdays(month_start-3) + 1;
dayendindex = cumsumdays(month_end-3 + 1);

datmatuse = datmat(daystartindex:dayendindex,year_start-1900:year_end-1900,:);


% defining the length of data
dy = [10, 20,30,40,50];%[60,70,80,91];
% dy = [30,20,10];

% years considered for corresponding duration
yc = [1910,1920,1930,1940,1950];%[1960,1970,1980,1991];
% yc = [1962,1972,1982];

op = [25,40,50,75];

% getting optimal locations into entire location data
odata_ref = NaN(length(op),length(dy),4964);
bt_ref = NaN(length(op),length(dy),4964);


for i=1:length(op)
    for j=1:length(dy)
        mask_op = zeros(1,length(locations));
        mask_bt = zeros(1,length(locations));
        odata = importdata(strcat('output_1901-',num2str(yc(j)),'_',...
                num2str(dy(j)),'years_20clus_',num2str(op(i)),'op_rs.dat'));
        beta = importdata(strcat('beta_overall_1901-',num2str(yc(j)),...
                '_20clus_',num2str(dy(j)),'years_',num2str(op(i)),'op_rs.dat'));
        odata = reshape(odata(:,1:op(i)),1,[]);
        mask_op(odata) = odata;
        mask_bt(odata) = beta(1,1:20*op(i));
        odata_ref(i,j,:) = mask_op;
        bt_ref(i,j,:) = mask_bt;
    end
end

OA = NaN(length(op)+1,length(dy),114);
for k=1:length(op)
    tic
    ens_year_spa = NaN(5000,length(dy),114);
    ens_year_spa_es = NaN(5000,length(dy),114);
    parfor i=1:5000
        bt = bt_ref;
        ensem_ble = binornd(1,0.8,114,4964);
        year_spa = NaN(length(dy),114);
        year_spa_es = NaN(length(dy),114);
        for j=1:length(dy)
            datmat = squeeze(mean(datmatuse,1));
            if k==1
                weights_es = importdata(strcat('beta_overall_1901-',...
                    num2str(yc(j)),'_oa.dat'))
                weights_es = repmat(reshape(weights_es,1,[]),[114,1]);
                spa_avg_es = sum((ensem_ble.*datmat.*weights_es),...
                    2)./sum(ensem_ble.*weights_es,2);
                year_spa_es(j,:) = reshape(squeeze(sum(spa_avg,2)),1,[]);
            end
            weights = repmat(reshape(squeeze(bt(k,j,:)),1,[]),[114,1]);
            spa_avg = sum((ensem_ble.*datmat.*weights),2)./sum(ensem_ble.*weights,2);
            year_spa(j,:) = reshape(squeeze(sum(spa_avg,2)),1,[]);
        end
        if k==1
            ens_year_spa_es(i,:,:) = year_spa_es;
        end
        ens_year_spa(i,:,:) = year_spa;
    end
    if k==1
        OA(k,:,:) = mean(ens_year_spa_es,1);
    end
    OA(k+1,:,:) = mean(ens_year_spa,1);
    toc
end

