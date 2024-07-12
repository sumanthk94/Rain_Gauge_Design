function X = Peturb(X,PertNum)
if ~exist('PetNum','var')
    PertNum=1;
end
[n,k] = size(X);
col_list = floor(rand(1,PertNum)*k) + 1;
for i=1:PertNum
    temp = randperm(n,2);
    X(fliplr(temp),col_list(i)) = X(temp,col_list(i));
end
end