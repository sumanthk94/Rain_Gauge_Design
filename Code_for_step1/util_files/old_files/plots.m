close all
clc
A = importdata('../../Code2/raindat0_25_deg.mat');
latlist = A.latlist;
longlist = A.lonlist;
ed = importdata('cluster_54years.txt');
odata = importdata('output_files/1901-1954_54years/output_54years.txt');
locations = 1:4964;
min_latlist = NaN(20,1);
max_latlist = NaN(20,1);
min_longlist = NaN(20,1);
max_longlist = NaN(20,1);
for i=1:10
    cluster = locations(ed==i);
    min_latlist(i) = min(latlist(cluster));
    max_latlist(i) = max(latlist(cluster));
    min_longlist(i) = min(longlist(cluster));
    max_longlist(i) = max(longlist(cluster));
end
for i=1:10
    ind = locations(ed==i);
    lt = latlist(odata(i,1:50));
    ln = longlist(odata(i,1:50));
    figure(1)
    set(gcf,'color','w')
    set(gca,'FontSize',15)
    hold on
    plot(longlist(ind),latlist(ind),'.')
    hold on
    plot(ln,lt,'*k')
    xlabel('longitudes','FontSize',15,'FontWeight','bold')
    ylabel('latitudes','FontSize',15,'FontWeight','bold')
end
for i=1:10
    figure(1)
    hold on
    yline(min_latlist(i),'--k')
    hold on
    yline(max_latlist(i),'--k')
    hold on
    xline(min_longlist(i),'--k')
    hold on
    xline(max_longlist(i),'--k')
end
tsa = odata(:,105);
sa_opt = odata(:,103);
total_mse = odata(:,106);
mse_opt = odata(:,104);
figure(2)
set(gcf,'color','w')
set(gca,'FontSize',15);
plot(1:10,tsa,'-^r','LineWidth',1)
hold on
plot(1:10,sa_opt,'-^b','LineWidth',1)
hold on
plot(1:10,total_mse,'-sr','LineWidth',1)
hold on
plot(1:10,mse_opt,'-sb','LineWidth',1)
xlabel('Cluster number','FontSize',15,'FontWeight','bold')
legend('Total spatial average','optimal configuration spatial average','Total MSE','Optimal configuration MSE','box','off')
