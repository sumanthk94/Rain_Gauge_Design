clear
close all
clc
% %% data preprocessing 
% % Input data
% years to include in time series
year_start = 1901; year_end = 2014;
% 
% % months to average
month_start = 6; month_end = 9;
% 
% 
% load and read data
A = importdata('../../Code2/raindat0_25_deg.mat');
datmat = permute(A.hrrainmat,[2,1,3]); %{(days,year,locations)}
total_latlist = A.latlist;
total_longlist = A.lonlist;
% compute Indices
numdaysinmonth = [30 31 30 31 31 30 31 30]; % number of days in April through November
cumsumdays = cumsum(numdaysinmonth);
cumsumdays = cat(2,0,cumsumdays);

daystartindex = cumsumdays(month_start-3) + 1;
dayendindex = cumsumdays(month_end-3 + 1);

datmatuse = datmat(daystartindex:dayendindex,year_start-1900:year_end-1900,:);
% datmatuse2d = squeeze(mean(datmatuse,1)); 

% cw_avg = sum(mean(squeeze(mean(datmatuse,1)),...
%     1)'.*cosd(total_latlist))/sum(cosd(total_latlist));

cw_avg = sum(squeeze(mean(datmatuse,1)...
    ).*repmat(cosd(total_latlist)',114,1),2)/sum(cosd(total_latlist));

op_list = [20,40,50,80,100,120,150;
    10,20,25,40,50,60,75;
    8,16,20,32,40,48,60;
    4,8,10,16,20,24,30];
nc = [10,20,25,50];
% parfor i=1:length(op_list)
% A = importdata(strcat('output_114years_k_',num2str(op_list(i)),'_25clus.dat'));
% loc_list = reshape(A(:,1:op_list(i)),1,[]);
% latlist = total_latlist;
% [betamse,mse,Er] = cal_stat(datmatuse,loc_list,latlist(loc_list));
% disp(i)
% disp(mse)
% disp(sum(betamse))
% spa = sum(0.8*betamse.*Er')/sum(0.8*betamse);
% disp(spa)
% dlmwrite(strcat('weights for_K_',num2str(op_list(i)),'_114years_25clus.dat'),[betamse,mse,spa])
% end
%% ablation_study_plots
[r,c] = size(op_list);
mse = NaN(r,c);
rms_spa = NaN(r,c);
spa = NaN(r,c,114);
for j=1:r
    for i=1:c
        a = importdata(strcat('weights for_k_',...
            num2str(op_list(j,i)),'_114years_',num2str(nc(j)),'clus.dat'));
        b = importdata(strcat('output_114years_k_',...
            num2str(op_list(j,i)),'_',num2str(nc(j)),'clus_rs.dat'));
        olist = reshape(b(:,1:op_list(j,i)),1,[]);
        mse(j,i) = a(op_list(j,i)*nc(j)+1);
        error = NaN(1,114);
        for k=1901:2014
            datmatuse2d = mean(squeeze(mean(datmatuse(:,k-1900,olist),1)),1);
            temp = sum(0.8*a(1:op_list(j,i)*nc(j)...
                ).*datmatuse2d)/sum(0.8*a(1:op_list(j,i)*nc(j)));
            spa(j,i,k-1900) = temp;
            error(k-1900) = (cw_avg(k-1900)-temp)/cw_avg(k-1900);
        end
        rms_spa(j,i) = mean(error.^2)^0.5;
        mse(j,i) = a(op_list(j,i)*nc(j)+1);
    end      
end
% colors = {'#0072BD','#D95319','#EDB120'};
colors = {'r','k','b','m'};
for i=1:r
figure(1)
hold on
set(gcf,'color','w')
plot(op_list(i,:)*nc(i),mse(i,:),'-s','color',colors{i},'LineWidth',2)
set(gca,'FontSize',12,'FontWeight','bold')
xlabel('\textbf{Number of Optimal Locations-K}','Interpreter','latex',...
    'fontsize',15,'FontWeight','bold')
ylabel({'\textbf{MSE in Estimating}';...
    '\textbf{ Spatial Average Statistics with \boldmath$\zeta=0.8$}'},...
    'Interpreter','latex','fontsize',15,'FontWeight','bold')
grid on
figure(2)
set(gcf,'color','w')
hold on
plot(op_list(i,:)*nc(i),rms_spa(i,:),'-^','color',colors{i},'LineWidth',2)
set(gca,'FontSize',12,'FontWeight','bold')
xlabel('\textbf{Number of Optimal Locations-K}','Interpreter','latex',...
    'FontSize',15,'FontWeight','bold')
ylabel({'\textbf{RMS of Relative Error of}';...
    '\textbf{Spatial Average across 114 years (1901-2014)}'},...
    'Interpreter','latex','FontSize',15,'FontWeight','bold')
grid on
end
figure(1)
hold on
legend('$\alpha=10$','$\alpha=20$','$\alpha=25$','$\alpha=50$',...
    'Interpreter','latex','FontSize',12,'FontWeight','bold',...
    'color','none','location','southeast')
legend('boxoff')
figure(3)
set(gcf,'color','w')
locations = [200,400,500,800,1000,1200,1500];
for i=1:r
    hold on
    bh = boxplot(squeeze(spa(i,:,:))',locations,'color',colors{i},...
        'outliersize',10,'Widths',0.5-(i/100),'Notch','on',...
        'MedianStyle','target');
    set(bh, 'LineWidth',2)
end
ylim([3,7])
grid on
set(gca,'FontSize',12,'FontWeight','bold')
xlabel('\textbf{Number of Optimal Locations-K}','Interpreter','latex',...
    'FontSize',15,'FontWeight','bold')
ylabel('\textbf{Distribution of Spatial avearage} $\bar{c}$ ($\boldmath{1901-2014}$)',...
    'Interpreter','latex','FontSize',15,'FontWeight','bold')
hold on
h(1) = plot(nan,nan,strcat('-',colors{1}),'LineWidth',2);
h(2) = plot(nan,nan,strcat('-',colors{2}),'LineWidth',2);
h(3) = plot(nan,nan,strcat('-',colors{3}),'LineWidth',2);
h(4) = plot(nan,nan,strcat('-',colors{4}),'LineWidth',2);
legend(h,'$\alpha=10$','$\alpha=20$','$\alpha=25$','$\alpha=50$',...
    'Interpreter','latex','FontSize',12,'FontWeight','bold',...
    'color','none','location','southeast')
legend('boxoff')


