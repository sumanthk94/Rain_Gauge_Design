clear
clc
close all


cluster = importdata('cluster_114years_20clus.dat');
A = importdata('../../Code2/raindat0_25_deg.mat');
total_latlist = A.latlist;
total_longlist = A.lonlist;
locations = 1:1:4964;


% defining the length of data
dy = [10,20,30,40,50,60,70,80,91];
% dy = [30,20,10];

% years considered for corresponding duration
yc = [1910,1920,1930,1940,1950,1960,1970,1980,1991];
% yc = [1962,1972,1982];

% optimal locations in each cluster
op = [25,40,50,75];

ou = []; 
nu = NaN(1,length(op));
colors = {'#0072BD','#D95319','#EDB120','#7E2F8E','#000000'};
col = rand(20,3);
uper = NaN(4,5);
%%
for k=1:length(op)
odata = NaN(length(dy),20*op(k)); 
for i=1:length(dy)
    idt = importdata(strcat('output_1901-',num2str(yc(i)),'_',...
        num2str(dy(i)),'years_20clus_',num2str(op(k)),'op_rs.dat')); %Forward
%     idt = importdata(strcat('output_',num2str(yc(i)),'-1991_',...
%         num2str(dy(i)),'years_20clus_',num2str(op(k)),'op_rs.dat')); %Backward
    odata(i,:) = reshape(idt(:,1:op(k)),1,[]);
%     if i==length(dy)
%         figure(k)
%         set(gcf,'color','w')
%         m_proj('miller','longitudes',[min(total_longlist)-1 max(total_longlist)+1],...
%     'latitudes',[min(total_latlist)-1 max(total_latlist)+1])
%         idx = importdata('cluster_114years_20clus.dat');
%         for j=1:20
%             clus_list = locations(idx==j);
%             lat_op = total_latlist(idt(j,1:op(k)));
%             lon_op = total_longlist(idt(j,1:op(k)));
%             lat_clus = total_latlist(clus_list);
%             lon_clus = total_longlist(clus_list);
%             hold on 
%             m_plot(lon_clus,lat_clus,'.','Color',col(j,:))
%             hold on
%             m_plot(lon_op,lat_op,'*k')
%         end
%         m_coast('linewidth',2,'color','b');
%         m_grid('box','fancy','fintsize',12);
%         set(gca,'FontSize',15)
%         xlabel('\textbf{Longitudes}','Interpreter','latex','fontsize',15,...
%             'FontWeight','bold')
%         ylabel('\textbf{Latitudes}','Interpreter','latex','fontsize',15,...
%             'FontWeight','bold')
%     end
end



%% ######## Study how optimal locations are varying with the data #########
I = odata(1,:); %calculating the intersections across length of data for given K
U = odata(1,:); % calcualting the union across the length of data for given K

% to calculate the union of unique locations and intersection
% across 5 test cases(length of data) for given locations

for i=2:9
    I = intersect(I,odata(i,:));
    U = union(odata(i,:),U);
end

% calculating the unique locations that are repeated in each length of data
% for a given K

for i=1:length(dy)
    temp = odata(i,:);
    for j=1:length(dy)
        if i~=j 
            temp = setdiff(temp,odata(j,:));
        end
    end
    uper(k,i) = length(temp);
end

% contains the total locations obtained for each length data for a given K
ad = reshape(odata,1,[]); 
f = NaN(length(U),1); %frequency

% evaluates the frequency
for i=1:length(U)
    A1 = ad-U(i);
    f(i) = numel(A1)-nnz(A1);
end

% evaluates the cumulative frequency
for i=1:length(dy)
    cf(i,k) = sum(f==i);
end


nu(k) = length(U);
ou = cat(2,ou,U);

%% plots the what are the optimal locations in each case of varying op 
% figure(k)
% set(gcf,'color','w')
% m_proj('miller','longitudes',[min(total_longlist)-1 max(total_longlist)+1],...
%     'latitudes',[min(total_latlist)-1 max(total_latlist)+1])
% Markers = {'*','o','d','s','^'};
% % colors = {'#0072BD','#D95319','#EDB120','#7E2F8E','#77AC30'};
% for i=1:length(dy)
%     list = U(f==i);
%     latlist = total_latlist(list);
%     longlist = total_longlist(list);
%     hold on
%     m_plot(longlist,latlist,'.','MarkerSize',10,'Color',colors{i})
% end
% m_coast('linewidth',2,'color','b');
% m_grid('box','fancy','fontsize',12)
% for i=1:5
%     hold on
%     h(i) = plot(nan,nan,'o','MarkerSize',6,'MarkerFaceColor',colors{i},...
%         'MarkerEdgeColor',colors{i});
% end
% legend(h,'\textbf{Frequency-1}','\textbf{Frequency-2}',...
%     '\textbf{Frequency-3}','\textbf{Frequency-4}',...
%     '\textbf{Frequency-5}','Interpreter','latex',...
%     'fontsize',12,'FontWeight','bold','Color','None')
% legend('boxoff')
% set(gca,'FontSize',15)
% xlabel('\textbf{Longitudes}','Interpreter','latex',...
%     'fontsize',15,'FontWeight','bold')
% ylabel('\textbf{Latitudes}','Interpreter','latex',...
%     'fontsize',15,'FontWeight','bold')

end


%% ########################### Bar diagrams ###############################
figure(4)
set(gcf,'color','w')
bar(cf)
set(gca,'FontSize',15,'FontWeight','bold')
xlabel('\textbf{Frequency}','Interpreter','latex',...
    'fontsize',15,'FontWeight','bold')
ylabel('\textbf{Number of Locations}','Interpreter','latex',...
    'fontsize',15,'FontWeight','bold')
legend('\textbf{500 Locations}','\textbf{800 Locations}',...
    '\textbf{1000 Locations}','\textbf{1500 Locations}',...
    'Interpreter','latex','fontsize',15,'FontWeight','bold','Color','None')
legend('boxoff')
grid on
% 
cnu = cumsum(nu);
un = unique(ou);
in = ou(1,1:cnu(1));
for i=2:length(nu)
    in = intersect(in,ou(1,cnu(i-1)+1:cnu(i)));
end
fn = NaN(length(un),1);
for i=1:length(un)
    A2 = ou-un(i);
    fn(i) = numel(A2)-nnz(A2);
end
for i=1:length(op)
    cg(i) = sum(fn==i);
end
% inter_overall = un(fn==4);
opd = importdata('output_1901-1950_50years_20clus_50op_rs.dat');
opd = reshape(opd(:,1:end-7),1,[]);
% figure(5)
% set(gcf,'color','w')
% m_proj('miller','longitudes',[min(total_longlist)-1 max(total_longlist)+1],...
%     'latitudes',[min(total_latlist)-1 max(total_latlist)+1])
% for i=1:length(op)
%     list = un(fn==i);
%     latlist = total_latlist(list);
%     longlist = total_longlist(list);
%     hold on
%     m_plot(longlist,latlist,'.','MarkerSize',8,'Color',colors{i})
% end
% m_coast('linewidth',2,'color','b');
% m_grid('box','fancy','fontsize',12)
% set(gca,'FontSize',15)
% xlabel('\textbf{Longitudes}','Interpreter','latex',...
%     'fontsize',15,'FontWeight','bold')
% ylabel('\textbf{Latitudes}','Interpreter','latex',...
%     'fontsize',15,'FontWeight','bold')
% for i=1:4
%     hold on
%     h(i) = plot(nan,nan,'o','MarkerSize',6,...
%         'MArkerFaceColor',colors{i},'MarkerEdgeColor',colors{i});
% end
% legend(h,'\textbf{Frequency-1}','\textbf{Frequency-2}',...
%     '\textbf{Frequency-3}','\textbf{Frequency-4}',...
%     'Interpreter','latex','fontsize',10,'FontWeight','bold')
% legend('boxoff')
% figure(6)
% set(gcf,'color','w')
% bar(cg)
% set(gca,'FontSize',15,'FontWeight','bold')
% xlabel('\textbf{Frequency}','Interpreter','latex',...
%     'fontsize',15,'FontWeight','bold')
% ylabel('\textbf{Number of Locations}','Interpreter','latex',...
%     'fontSize',15,'FontWeight','bold')
% grid on
