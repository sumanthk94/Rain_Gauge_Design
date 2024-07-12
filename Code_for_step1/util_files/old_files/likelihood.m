function[NegLnLike,Psi,U]=likelihood(x)

global ModelInfo
X = ModelInfo.X;
y = ModelInfo.y;
theta = 10.^x;
n=size(X,1);
one =ones(n,1);

Psi=zeros(n,n);
% Build upper half of correlation matrix
for i=1:n
    for j=i+1:n
        Psi(i,j)=exp(-sum(theta.*(X(i,:)-X(j,:)).^2));
    end
end
% Add upper and lower halves and diagonal of ones plus
Psi = Psi+Psi'+eye(n)+eye(n).*eps;

% cholesky factorization
[U,p] = chol(Psi);

% Use penality if ill conditioned
if p>0
    NegLnLike=1e4;
else
    % Sum lns of diagonal to find ln(det(Psi))
    LnDetPsi = 2*sum(log(abs(diag(U))));
    
    %use back-substitiution of cholesky instead of inverse
    mu = (one'*(U\(U'\y)))/(one'*(U\(U'\one)));
    SigmaSqr = ((y-one*mu)'*(U\(U'\(y-one*mu))))/n;
    NegLnLike = -1*(-(n/2)*log(SigmaSqr)-0.5*LnDetPsi);
end
