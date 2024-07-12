function X = rlh(n,k)
X=zeros(n,k);
parfor i=1:k
    X(:,i)=randperm(n);
end
X=(X-1)/(n-1);
end