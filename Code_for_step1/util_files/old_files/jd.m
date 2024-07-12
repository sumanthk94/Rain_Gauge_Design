function [J,distinct_d]=jd(X)
% if~exist('p','var')
%     p=1; %order of norm
% end

n=size(X,1);

% d=zeros(1,n*(n-1)/2);
% 
% for i=1:n-1
%     for j=i+1:n
%         d((((i-1)*n)-((i-1)*i/2))+j-i)=norm(X(i,:)-X(j,:),p);
%     end
% end
dis = zeros(n,n);
parfor i=1:n
    G = X-repmat(X(i,:),n,1);
    dis(i,:) = sqrt(sum((G).^2,2))';
end
dis = triu(dis);
dist = dis(dis~=0);
    
distinct_d=unique(dist);

J = zeros(size(distinct_d));

parfor i=1:length(distinct_d)
    J(i)=sum(ismember(dist,distinct_d(i)));
end
end