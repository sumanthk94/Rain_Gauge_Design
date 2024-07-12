% clear
clc
close all
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
dy = [10,20,30,40,50,60,70,80,91];
% dy = [30,20,10];

% years considered for corresponding duration
yc = [1910,1920,1930,1940,1950,1960,1970,1980,1991];
% yc = [1962,1972,1982];

% optimal locations in each cluster
op = [25,40,50,75];

% defining the length
mse_op = NaN(length(dy),20,length(op)); %{no of tests,locations,no of ops in each cluster};
mse_clus = NaN(length(dy),20,length(op));

cf = NaN(length(dy),length(op)); % cumulative frequency 
oa = NaN(length(dy),114,length(op)); %optimal averaging with the optimal locations 
oa_es = NaN(length(dy),114);     %optimal averaging with the entire set
er_ap = NaN(length(dy),114,length(op));  % error-comparison with the OA of entire set with missing data  
rel_er_ap = er_ap;  % relative error in comparing with OA of entire set with the missing data 
er_cw_avg = NaN(length(dy),114,length(op)); % error- comparison with the cosine weighted average 
rel_er_cw_avg = er_cw_avg; % relative error-comparison with the cosine weighted average


cw_avg = sum(squeeze(mean(datmatuse,1)...
    ).*repmat(cosd(total_latlist)',114,1),2)/sum(cosd(total_latlist)); %calculating the cosine weighted mean
ou = []; 
nu = NaN(1,length(op));
colors = {'#0072BD','#D95319','#EDB120','#7E2F8E','#77AC30'};
col = rand(20,3);
uper = NaN(4,9);
% beta_es = NaN(length(dy),length(locations));

%% evaluating the OA with missing data by considering different 
% duration of data while solving constrained optimization-ashwin sir work
% for different data length
% for i=1901:2014
%     for j=1:length(dy)
%         dummy_1 = importdata(strcat('beta_overall_1901-',num2str(yc(j)),...
%             '_oa.dat'));
% %         dummy_1 = importdata(strcat('beta_overall_',num2str(yc(j)),...
% %             '-1991_oa.dat'));
%         bt_es = dummy_1(1,1:4964);
%         data_total = squeeze(mean(datmatuse(:,i-1900,:),1));
%         data_total = reshape(data_total,1,[]);
%         oa_es(j,i-1900) = sum(0.8*(bt_es.*data_total))/sum(0.8*bt_es); 
%     end
% end



% duration of data while solving constrained optimization-ashwin sir work
% for different data length
% for i=1901:2014
mse_oa = NaN(length(dy),1);
    for j=1:length(dy)
        dummy_1 = importdata(strcat('beta_overall_1901-',num2str(yc(j)),...
            '_oa.dat'));
        bt_es = dummy_1(1,1:4964);
        mse_oa(j) = mse(bt_es',datmatuse,1:4964,0.8,total_latlist);
    end
% end
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
    mse_op(i,:,k) = idt(:,op(k)+4);
    mse_clus(i,:,k) = idt(:,op(k)+6);
    if i==length(dy)
        figure(k)
        set(gcf,'color','w')
        set(gcf, 'PaperUnits', 'inches')
        set(gcf, 'PaperSize', [6, 4])
        m_proj('miller','longitudes',[min(total_longlist)-1 max(total_longlist)+1],...
    'latitudes',[min(total_latlist)-1 max(total_latlist)+1])
        idx = importdata('cluster_114years_20clus.dat');
        for j=1:20
            clus_list = locations(idx==j);
            lat_op = total_latlist(idt(j,1:op(k)));
            lon_op = total_longlist(idt(j,1:op(k)));
            lat_clus = total_latlist(clus_list);
            lon_clus = total_longlist(clus_list);
            hold on 
            m_plot(lon_clus,lat_clus,'.','Color',col(j,:))
            hold on
            m_plot(lon_op,lat_op,'*k')
        end
        m_coast('linewidth',2,'color','b');
        m_grid('box','fancy','fintsize',12);
        set(gca,'FontSize',15)
        xlabel('\textbf{Longitudes}','Interpreter','latex','fontsize',15,...
            'FontWeight','bold')
        ylabel('\textbf{Latitudes}','Interpreter','latex','fontsize',15,...
            'FontWeight','bold')
    end
end
% olocations{k} = odata;
% obeta{k} = beta;
%% ######## Study how optimal locations are varying with the data #########
% I = odata(1,:);
% U = odata(1,:);
% % to calculate the union of unique locations and intersection
% % across 5 test cases
% for i=2:9
%     I = intersect(I,odata(i,:));
%     U = union(odata(i,:),U);
% end
% for i=1:length(dy)
%     temp = odata(i,:);
%     for j=1:length(dy)
%         if i~=j 
%             temp = setdiff(temp,odata(j,:));
%         end
%     end
%     uper(k,i) = length(temp);
% end
% ad = reshape(odata,1,[]);
% f = NaN(length(U),1);
% for i=1:length(U)
%     A1 = ad-U(i);
%     f(i) = numel(A1)-nnz(A1);
% end
% for i=1:length(dy)
%     cf(i,k) = sum(f==i);
% end
% nu(k) = length(U);
% ou = cat(2,ou,U);
% % plots the what are the optimal locations in each case of varying op 
% figure(k)
% set(gcf,'color','w')
% m_proj('miller','longitudes',[min(total_longlist)-1 max(total_longlist)+1],...
%     'latitudes',[min(total_latlist)-1 max(total_latlist)+1])
% Markers = {'*','o','d','s','^'};
% colors = {'#0072BD','#D95319','#EDB120','#7E2F8E','#77AC30',"#4DBEEE",...
%     "#A2142F","#00FF00","#000000"};
% for i=1:length(dy)
%     list = U(f==i);
%     latlist = total_latlist(list);
%     longlist = total_longlist(list);
%     hold on
%     m_plot(longlist,latlist,'.','MarkerSize',10,'Color',colors{i})
% end
% m_coast('linewidth',2,'color','b');
% m_grid('box','fancy','fontsize',12)
% legend('','\textbf{F1}','\textbf{F2}',...
%     '\textbf{F3}','\textbf{F4}',...
%     '\textbf{F5}','\textbf{F6}',...
%     '\textbf{F7}','\textbf{F8}',...
%     '\textbf{F9}','Interpreter','latex',...
%     'fontsize',12,'FontWeight','bold','Color','None', 'NumColumns', 2)
% legend('boxoff')
% set(gca,'FontSize',15)
% xlabel('\textbf{Longitudes}','Interpreter','latex',...
%     'fontsize',15,'FontWeight','bold')
% ylabel('\textbf{Latitudes}','Interpreter','latex',...
%     'fontsize',15,'FontWeight','bold')

%% ##################### calculation of overall MSE #######################
% mse_ov = NaN(length(dy),1);
% for i=1:length(dy)
%     year_end = yc(i);
%     datmatuse = datmat(daystartindex:dayendindex,year_start-1900:year_end-1900,:);
%     mse_ov(i) = mse(beta(i,:)',datmatuse,odata(i,:),0.8,total_latlist(odata(i,:)));
% end
% figure(6)
% set(gcf,'color','w')
% hold on
% plot(10:10:90,mse_ov,'-*','LineWidth',2,'Color',colors{k})
% set(gca,'FontSize',15,'FontWeight','bold')
% xlabel('\textbf{Number of years}','Interpreter','latex','fontsize',15,...
%     'FontWeight','bold')
% ylabel({'\textbf{MSE in Estimating Spatial Average }';...
%     '\textbf{Statistics with missing data \boldmath$\zeta=0.8$}'},...
%     'Interpreter','latex','FontSize',15,'FontWeight','bold')
% legend('\textbf{500 Locations}','\textbf{800 Locations}',...
%     '\textbf{1000 Locations}','\textbf{1500 Locations}',...
%     'Interpreter','latex','FontSize',15,'FontWeight','bold','Color','None')
% legend('boxoff')
% grid on
%% calculate the varying in MSE
% MSE = NaN(5,20);
% for i=1:5
%     bt = reshape(beta(i,:),20,[]);
%     ot = reshape(odata(i,:),20,[]);
%     year_end = yc(i);
%     datmatuse = datmat(daystartindex:dayendindex,year_start-1900:year_end-1900,:);
%     for j=1:20
%         MSE(i,j) = mse(bt(j,:)',datmatuse,ot(j,:),0.8,total_latlist(ot(j,:)));
%     end
% end
% figure(1)
% set(gcf,'Color','w')
% for i=1:5
%     hold on
%     plot(1:20,mse_op(i,:),'-^b','LineWidth',2)
%     hold on
%     plot(1:20,mse_clus(i,:),'-^g','LineWidth',2)
% end
% set(gca,'FontSize',15)
% xlabel('\textbf{Number of years}','Interpreter','latex','fontsize',15,...
%     'FontWeight','bold')
% ylabel({'\textbf{MSE in estimating spatial average}';...
%     '\boldmath$\zeta=0.8$'},'Interpreter','latex','fontsize',15,...
%     'FontWeight','bold')
% legend('')
%% ################## calculation of the spatial average ##################
% for i=1901:2014
%     for j=1:length(dy)
%         datmatuse2d = squeeze(mean(datmatuse(:,i-1900,:),1));
%         olist = odata(j,:);
%         data_op = reshape(datmatuse2d(olist),1,[]);
%         bt = beta(j,:);
%         oa(j,i-1900,k) = sum(0.8*(bt.*data_op))/sum(0.8*bt);
%     end
% end
% er_ap(:,:,k) = oa_es - oa(:,:,k);
% rel_er_ap(:,:,k) = er_ap(:,:,k)./oa_es;
% for i=1:length(dy)
%     er_ap(i,:,k) = oa_es(i,:)-oa(i,:,k);
%     rel_er_ap(i,:,k) = er_ap(i,:,k)./oa_es(i,:);
% end
% er_cw_avg(:,:,k) = cw_avg'-oa(:,:,k);
% rel_er_cw_avg(:,:,k) = er_cw_avg(:,:,k)./cw_avg';
% for i=1:length(dy)
%     er_cw_avg(i,:,k) = cw_avg'-oa(i,:,k);
%     rel_er_cw_avg(i,:,k) = er_cw_avg(i,:,k)./cw_avg';
% end
end
% er_cw_oa_es = cw_avg'-oa_es;
% rel_er_cw_oa_es = er_cw_oa_es./cw_avg';
% for i=1:length(op)
%     dlmwrite(strcat('absolute_error_op_',num2str(op(i)),'_rs.dat'),er(:,:,i)',...
%         'delimiter','\t')
% end
% cnu = cumsum(nu);
% un = unique(ou);
% in = ou(1,1:cnu(1));
% for i=2:length(nu)
%     in = intersect(in,ou(1,cnu(i-1)+1:cnu(i)));
% end
%% ########################### Bar diagrams ###############################
%  
% fn = NaN(length(un),1);
% for i=1:length(un)
%     A2 = ou-un(i);
%     fn(i) = numel(A2)-nnz(A2);
% end
% for i=1:length(op)
%     cg(i) = sum(fn==i);
% end
% inter_overall = un(fn==4);
% figure(5)
% set(gcf,'color','w')
% m_proj('miller','longitudes',[min(total_longlist)-1 max(total_longlist)+1],...
%     'latitudes',[min(total_latlist)-1 max(total_latlist)+1])
% for i=1:length(op)
%     list = un(fn==i);
%     latlist = total_latlist(list);
%     longlist = total_longlist(list);
%     hold on
%     m_plot(longlist,latlist,'.','MarkerSize',6,'Color',colors{i})
% end
% m_coast('linewidth',2,'color','b');
% m_grid('box','fancy','fontsize',12)
% legend('','\textbf{Frequency-1}','\textbf{Frequency-2}',...
%     '\textbf{Frequency-3}','\textbf{Frequency-4}',...
%     'Interpreter','latex','fontsize',10,'FontWeight','bold')
% legend('boxoff')
% set(gca,'FontSize',15)
% xlabel('\textbf{Longitudes}','Interpreter','latex',...
%     'fontsize',15,'FontWeight','bold')
% ylabel('\textbf{Latitudes}','Interpreter','latex',...
%     'fontsize',15,'FontWeight','bold')
% figure(6)
% set(gcf,'color','w')
% bar(cg)
% set(gca,'FontSize',15,'FontWeight','bold')
% xlabel('\textbf{Frequency}','Interpreter','latex',...
%     'fontsize',15,'FontWeight','bold')
% ylabel('\textbf{Number of Locations}','Interpreter','latex',...
%     'fontSize',15,'FontWeight','bold')
% grid on
% ######################### end of bar diagram ###########################
%% ######################### start of SPA diagrams #######################
% for i=1:length(dy)
% figure(i)
% % subplot(3, 3, i, 'align')
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
% legend('\textbf{Cosine Weighted Mean}',...
%     '\textbf{OA with \boldmath$\zeta=0.8$ from $500$}',...
%     '\textbf{OA with \boldmath$\zeta=0.8$ from $800$}',...
%     '\textbf{OA with \boldmath$\zeta=0.8$ from $1000$}',...
%     '\textbf{OA with \boldmath$\zeta=0.8$ from $1500$}',...
%     'Interpreter','latex','fontsize',15,'FontWeight','bold',...
%     'Color','None','location','southeast')
% legend('boxoff')
% ylim([3,8.5])
% grid on
% end
% figure(2)
% set(gcf,'color','w')
% for j= 1:length(op)
%     hold on
%     plot(1901:2014,rel_er(5,:,j),'LineWidth',2)
% end
% box on
% set(gca,'FontSize',12,'FontWeight','bold')
% xlabel('Years','FontSize',15,'FontWeight','bold')
% ylabel('Relative Error','FontSize',15,'FontWeight','bold')
% legend('500 Locations','800 Locations','1000 Locations',...
%     '1500 Locations','FontSize',15,'FontWeight','bold',...
%     'color','None','location','northeast')
% legend('boxoff')
% grid on


%% Error and relative error plots

% for i=1:length(op)
%     figure(i)
%     set(gcf,'color','w')
%     for j=1:length(dy)
%         hold on
%         plot(1901:2014,rel_er(j,:,i),'LineWidth',2)
%     end
%     set(gca,'fontsize',12,'FontWeight','bold')
%     box on 
%     grid on
%     legend('\textbf{10 years}','\textbf{20 years}','\textbf{30 years}',...
%         '\textbf{40 years}','\textbf{50 years}','Interpreter','latex',...
%         'fontsize',15,'location','southeast',...
%         'Color','None')
%     legend('boxoff')
%     xlabel('\textbf{Years}','Interpreter','latex','fontsize',15)
%     ylabel('\textbf{Relative Error}','Interpreter','latex','fontsize',15)
% end
%%  Not requried in case if it is required then uncomment
%############################# MSE_clus_op#################################
% for i=1:length(op)
%     figure(i)
%     set(gcf,'color','w')
%     boxplot(mse_clus(:,:,i))
%     hold on
%     boxplot(mse_op(:,:,i))
% %     for j=1
% %         plot(1:20,mse_clus(j,:,i),'LineWidth',2,'Color',colors{i})
% %         hold on
% %         plot(1:20,mse_op(j,:,i),'LineWidth',2,'Color',colors{i})
% %     end
%     set(gca,'FontSize',15)
% end