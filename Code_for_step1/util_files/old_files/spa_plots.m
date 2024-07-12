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
dy = [20,30,40,50];%[60,70,80,91];
% dy = [30,20,10];

% years considered for corresponding duration
yc = [1920,1930,1940,1950];%[1960,1970,1980,1991];
% yc = [1962,1972,1982];

% optimal locations in each cluster
op = [25,40,50,75];


%% spatial average calculations

% initiating the variables
oa = NaN(length(dy),114,length(op)); %optimal averaging with the optimal locations 
oa_es = NaN(length(dy),114);     %optimal averaging with the entire set
er_ap = NaN(length(dy),114,length(op));  % error-comparison with the OA of entire set with missing data  
rel_er_ap = er_ap;  % relative error in comparing with OA of entire set with the missing data 
er_cw_avg = NaN(length(dy),114,length(op)); % error- comparison with the cosine weighted average 
rel_er_cw_avg = er_cw_avg; % relative error-comparison with the cosine weighted average
oa_overall = NaN(length(dy),114);
er_overall = oa_overall;
rel_er_overall = oa_overall;

% calcualte the cosine weighted average
cw_avg = sum(squeeze(mean(datmatuse,1)...
    ).*repmat(cosd(total_latlist)',114,1),2)/sum(cosd(total_latlist));

% OA for entire locations with the weights obtained by considering
% different length of data
for i=1901:2014
    for j=1:length(dy)
        dummy_1 = importdata(strcat('beta_overall_1901-',num2str(yc(j)),...
            '_oa.dat'));
%         dummy_1 = importdata(strcat('beta_overall_',num2str(yc(j)),...
%             '-1991_oa.dat'));
        bt_es = dummy_1(1,1:4964);
        data_total = squeeze(mean(datmatuse(:,i-1900,:),1));
        data_total = reshape(data_total,1,[]);
        oa_es(j,i-1900) = sum(0.8*(bt_es.*data_total))/sum(0.8*bt_es); 
    end
end

%% OA for overall importance locations
% overall_locations = importdata('intersection_overall.dat');
% for i=1901:2014
%     for j=1:length(dy)
%         dummy_2 = importdata(...
%             strcat('overall_locations_analysis/beta_overall_1901-'...
%             ,num2str(yc(j)),num2str(dy(j)),'years_intesection_ovverall.dat'));
%         bt_overall = dummy_2(1,1:length(overall_locations));
%         data_total = squeeze(mean(datmatuse(:,i-1900,:),1));
%         data_total = reshape(data_total(overall_locations),1,[]);
%         oa_overall(j,i-1900) = sum(0.8*(bt_overall.*data_total))/sum(0.8*bt_overall); 
%     end
% end
% er_overall = oa_es - oa_overall;
% rel_er_overall = er_overall./oa_es;


%%
for k=1:length(op)
    odata = NaN(length(dy),20*op(k)); 
    beta = NaN(length(dy),20*op(k));
    for i=1:length(dy)
        idt = importdata(strcat('output_1901-',num2str(yc(i)),'_',...
            num2str(dy(i)),'years_20clus_',num2str(op(k)),'op_rs.dat')); %Forward
%     idt = importdata(strcat('output_',num2str(yc(i)),'-1991_',...
%         num2str(dy(i)),'years_20clus_',num2str(op(k)),'op_rs.dat')); %Backward

     dummy = importdata(strcat('beta_overall_1901-',num2str(yc(i)),...
        '_20clus_',num2str(dy(i)),'years_',num2str(op(k)),'op_rs.dat'));
%         %forward
%     dummy = importdata(strcat('beta_overall_',num2str(yc(i)),...
%         '-1991_20clus_',num2str(dy(i)),'years_',num2str(op(k)),'op_rs.dat'));
    beta(i,:) = dummy(1,1:20*op(k));
%     fprintf("shape of beta values are: %d,%d\n",size(beta(i,:)))
    odata(i,:) = reshape(idt(:,1:op(k)),1,[]);
%     mse_op(i,:,k) = idt(:,op(k)+4);
%     mse_clus(i,:,k) = idt(:,op(k)+6);
    end
    for i=1901:2014
        for j=1:length(dy)
            datmatuse2d = squeeze(mean(datmatuse(:,i-1900,:),1));
            olist = odata(j,:);
            data_op = reshape(datmatuse2d(olist),1,[]);
            bt = beta(j,:);
            oa(j,i-1900,k) = sum(0.8*(bt.*data_op))/sum(0.8*bt);
        end
    end
er_ap(:,:,k) = oa_es - oa(:,:,k);
rel_er_ap(:,:,k) = er_ap(:,:,k)./oa_es;

er_cw_avg(:,:,k) = cw_avg'-oa(:,:,k);
rel_er_cw_avg(:,:,k) = er_cw_avg(:,:,k)./cw_avg';
end


%% plots
% for i=1:length(dy)
% figure(i)
% set(gcf,'color','w')
% plot(1901:2014,oa_es(i,:),'LineWidth',2)
% for k=1:length(op)
%     hold on
%     plot(1901:2014,oa(i,:,k),'LineWidth',2)
% end
% set(gca,'FontSize',12,'FontWeight','bold')
% box on
% ylabel('\textbf{ISMR}','Interpreter','latex',...
%     'fontSize',15,'FontWeight','bold')
% xlabel('\textbf{Years}','Interpreter','latex',...
%     'fontsize',15,'FontWeight','bold')
% legend('\textbf{OA(\boldmath$\zeta=0.8$),$K$=$N$ }',...
%     '\textbf{OA(\boldmath$\zeta=0.8$), $K$=$500$}',...
%     '\textbf{OA(\boldmath$\zeta=0.8$), $K$=$800$}',...
%     '\textbf{OA(\boldmath$\zeta=0.8$), $K$=$1000$}',...
%     '\textbf{OA(\boldmath$\zeta=0.8$), $K$=$1500$}',...
%     'Interpreter','latex','fontsize',15,'FontWeight','bold',...
%     'Color','None','location','southeast')
% legend('boxoff')
% ylim([3,8.5])
% grid on
% end

% Error and relative error plots

for i=1:length(op)
    figure(i)
    set(gcf,'color','w')
    for j=1:length(dy)
        hold on
        plot(1901:2014,rel_er_ap(j,:,i),'LineWidth',2)
    end
    set(gca,'fontsize',12,'FontWeight','bold')
    box on 
    grid on
    legend('\textbf{20 years}','\textbf{30 years}','\textbf{40 years}',...
        '\textbf{50 years}','\textbf{50 years}','Interpreter','latex',...
        'fontsize',15,'location','southeast',...
        'Color','None')
    legend('boxoff')
    xlabel('\textbf{Years}','Interpreter','latex','fontsize',15)
    ylabel('\textbf{Relative Error}','Interpreter','latex','fontsize',15)
end

figure(5)
set(gcf,'color','w')
% plot(1901:2014,rel_oa_es(end,:),'LineWidth',2)
% hold on
plot(1901:2014,rel_er_ap(end,:,end-1),'LineWidth',2)
% hold on
% plot(1901:2014,rel_er_ap(end,:,end),'LineWidth',2)
hold on
plot(1901:2014,rel_er_overall(end,:),'LineWidth',2)
legend('1','2','3')






