clear 
close all
clc
a = importdata('MSE_clus_30years_1985-2014.txt');
b = importdata('MSE_op_30years_1985-2014.txt');
c = importdata('spa_clus_30years_1985-2014.txt');
d = importdata('spa_op_30years_1985-2014.txt');
figure(1)
set(gcf,'color','w')
set(gca,'FontSize',15)
boxplot(a)
xlabel('Cluster Number','FontSize',15)
ylabel('distribution of MSE','FontSize',15)
figure(2)
set(gcf,'color','w')
set(gca,'FontSize',15)
boxplot(b)
xlabel('Cluster Number','FontSize',15)
ylabel('distribution of MSE','FontSize',15)
figure(3)
set(gcf,'color','w')
set(gca,'FontSize',15)
boxplot(c)
xlabel('Cluster Number','FontSize',15)
ylabel('distribution of spatial average','FontSize',15)
figure(4)
set(gcf,'color','w')
set(gca,'FontSize',15)
boxplot(d)
xlabel('Cluster Number','FontSize',15)
ylabel('distribution of spatial average','FontSize',15)
figure(5)
set(gcf,'color','w')
set(gca,'FontSize',15)
boxplot((a-b)./a)
xlabel('Cluster Number','FontSize',15)
ylabel('distribution of relative MSE','FontSize',15)
figure(6)
set(gcf,'color','w')
set(gca,'FontSize',15)
boxplot((c-d)./c)
xlabel('Cluster Number','FontSize',15)
ylabel('distribution of relative Spatial average','FontSize',15)

