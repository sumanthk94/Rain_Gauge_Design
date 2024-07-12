clear 
clc
close all
A = importdata('../../Code2/raindat0_25_deg.mat');
latlist = A.latlist;
lonlist = A.lonlist;
co_data = [latlist,lonlist];
% n = 500; %number of groups
% idx = kmeans(co_data,n,'MaxIter',1000,'Display','final');
% ol = NaN(n,2);
% MSE = NaN(n,1);
% location_list = 1:4964;
groups = 10:5:100;
J = NaN(length(groups));

for i=1:length(groups)
    [~,~,sumd] = kmeans(co_data,groups(i),'MaxIter',1000,'Display','final');
    J(i) = sum(sumd);
end

figure(1)
set(gcf,'color','w')
plot(groups,J,'-d','LineWidth',2)
set(gca,'FontSize',12,'FontWeight','bold')
xlabel('\textbf{Different number of clusters} (\boldmath$\alpha$)','Interpreter','latex',...
    'FontSize',12,'FontWeight','bold')
ylabel('Inertia','FontSize',12,'FontWeight','bold')
grid on
box on