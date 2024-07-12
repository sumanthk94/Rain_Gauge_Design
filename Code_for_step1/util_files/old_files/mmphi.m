function Phiq = mmphi(X,q)

% if ~exist('p','var')
%     p=1;
% end
if~exist('q','var')
    q=2;
end

[J,d] = jd(X);

Phiq = sum(J.*(d.^(-q)))^(1/q);
end