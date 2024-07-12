clear 
clc
close all
list = [20,40,50,80,100,120,150];
mse = NaN(length(list),1);
spa = NaN(length(list),1);
for i=1:length(list)
    a = importdata(strcat('/weights for_K_',num2str(list(i)),'_114years.txt'));
    mse(i) = a(list(i)*10+1);
    spa(i) = a(list(i)*10+2);
end
figure(1)
set(gcf,'color','w')
set(gca,'FontSize',15)
plot(list*10,mse,'-s','LineWidth',1)
xlabel('Number of locations','FontSize',15,'FontWeight','bold')
ylabel('MSE','FontSize',15,'FontWeight','bold')
figure(2)
set(gcf,'color','w')
set(gca,'FontSize',15)
plot(list*10,spa,'-^','LineWidth',1)
xlabel('Number of locations','FontSize',15,'FontWeight','bold')
ylabel('spatial average','FontSize',15,'FontWeight','bold')
