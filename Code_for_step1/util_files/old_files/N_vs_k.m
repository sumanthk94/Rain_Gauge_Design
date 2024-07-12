clear
clc
close all
A = importdata('../../Code2/raindat0_25_deg.mat');
latlist = A.latlist;
longlist = A.lonlist;
% idx = importdata('cluster_54years.txt');
n_loc = NaN(1,10);
Mse_clus_k = NaN(10,6);
spd_clus_k = NaN(10,6);
list = [20,40,50,100,120,150,200];
for j=1:length(list)
    a = importdata(strcat('ablation_study/output_114years_k_',num2str(list(j)),'.txt'));
    for i=1:10
        Mse_clus_k(i,j) = (a(i,list(j)+6)-a(i,list(j)+1))/a(i,list(j)+6);
        spd_clus_k(i,j) = (a(i,list(j)+5)-a(i,list(j)+3))/a(i,list(j)+5);
        n_loc(i) = sum(idx==i);
    end
end
locations = 1:4964;
min_latlist = NaN(10,1);
max_latlist = NaN(10,1);
min_longlist = NaN(10,1);
max_longlist = NaN(10,1);
for i=1:10
    cluster = locations(idx==i);
    min_latlist(i) = min(latlist(cluster));
    max_latlist(i) = max(latlist(cluster));
    min_longlist(i) = min(longlist(cluster));
    max_longlist(i) = max(longlist(cluster));
end
for i=1:10
    figure(i)
    set(gcf,'color','w')
    set(gca,'FontSize',15)
    plot(list,Mse_clus_k(i,:),'-s','LineWidth',1)
    hold on
    plot(list,spd_clus_k(i,:),'-^','LineWidth',1)
    title(strcat('lat[',num2str(min_latlist(i)),'-',num2str(max_latlist(i))...
        ,'],','long[',num2str(min_longlist(i)),'-',num2str(max_longlist(i))...
        ,']'))
    xlabel('Number of optimal location set','FontSize',15,'FontWeight','bold')
%     ylabel('$\frac{\textbf{entire set of cluster}-\textbf{optimal set}}{\textbf{entire set of cluster}}$'...
%         ,'Interpreter','latex','FontSize',15,'FontWeight','bold')
    leg = legend('Relative MSE','Relative spatial average');
    set(leg,'location','southeast','box','off')
    saveas(gcf,strcat('N_vs_k_',num2str(i)),'epsc')
end