function [msemodel] = getmodelmse(beta,precipp,sigmae,T,N,rainmean,Sr,Er,alpha,w)
% global precipp sigmae T N rainmean Sr Er alpha w

%% weights
gamma = w.*beta;
% fprintf('size of gamma is\n')
% size(gamma)
% fprintf('size of Er is\n')
% size(Er)
%% Variance

varsigma2 = (1/T*sum(precipp.*precipp,1) - alpha*(1/T*sum(precipp,1)).^2)';
% fprintf('size of varsigma2 is\n')
% size(varsigma2)
% Srnd = Sr;  I = eye(N); idiag = find(I); Srnd(idiag) = 0;
Srnd = Sr.*(ones(N)-eye(N)); 
% fprintf('size of Srnd is\n')
% size(Srnd)

varm1 = 1/alpha*sum(gamma.^2.*varsigma2);
% fprintf('size of varm1 is\n')
% size(varm1)
varm2 = gamma'*Srnd*gamma;
% fprintf('size of varm2 is\n')
% size(varm2)
varm3 = 1/alpha*sigmae^2*(gamma'*gamma);
% fprintf('size of varm3 is\n')
% size(varm3)
varm4 = -2*((1-alpha)/alpha)*(gamma'*Er)*sum((gamma.^2).*Er);
% fprintf('size of varm4 is\n')
% size(varm4)
varm5 = (1-alpha)/alpha*(gamma'*Er)^2*(gamma'*gamma);
% fprintf('size of varm5 is\n')
% size(varm5)

varmodel = varm1 + varm2 + varm3 + varm4 + varm5; % equation (24) 
%% Bias
bias2 = (1-alpha)/alpha*((gamma'*Er)*(gamma'*gamma) - sum(gamma.^2.*Er));

a1 = gamma.*precipp';
a2 = sum(a1,1)';
bias1 = a2-rainmean;
biasmodel = mean((bias1+bias2).^2);
%% MSE
msemodel = biasmodel + varmodel; 
end