function X=bestlh(n,k,Population,Iterations)
if k<2
    error('Latin hypercubes are not defined for k<2');
end

q=[1 2 5 10 20 50 100];

% p=1;

XStart = rlh(n,k);

X3D = zeros(n,k,length(q));

parfor i=1:length(q)
%     fprintf('Now optimizing for q=%d...\n',q(i));
    X3D(:,:,i) = mmlhs(XStart,Population,Iterations,q(i));
end

Index=mmsort(X3D);
fprintf('Best lh found using q=%d...\n',q(Index(1)));

X=X3D(:,:,Index(1));

% phi_s = mmphi(XStart,q(Index(1)));
% disp(phi_s)
% phi_q = mmphi(X,q(Index(1)));
% disp(phi_q)
% figure(1)
% set(gcf,'color','w')
% set(gca,'FontSize',15)
% plot(XStart(:,1),XStart(:,2),'.b','MarkerSize',10)
% hold on
% plot(X(:,1),X(:,2),'.r','MarkerSize',10)
% xlabel('$\textbf{X}_{1}$','Interpreter','latex',...
% 'FontSize',15,'FontWeight','bold')
% ylabel('$\textbf{X}_{2}$','Interpreter','latex',...
% 'FontSize',15,'FontWeight','bold')
% set(gca,'xtick',0:1/20:1)
% set(gca,'ytick',0:1/20:1)
% grid on
% title(strcat('{\color{blue}.','$\phi_{',num2str(q(Index(1))),'}$=',num2str(phi_s),'}'),...
% strcat('{\color{red}.','$\phi_{',num2str(q(Index(1))),'}$=',num2str(phi_q),'}'),'Interpreter',...
% 'latex','fontsize',15,'FontWeight','bold')
end