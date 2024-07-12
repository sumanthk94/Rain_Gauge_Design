function [msemodel,biasmodel,varmodel] = mse(beta,datmatuse,location_list,alpha,latlist)
    sigmae = 1; %mm/day
    size(datmatuse)
    precipp =squeeze(mean(datmatuse(:,:,location_list),1));  % this is the data matrix [t=year,location]
    N = size(precipp,2); % number of locations
    T = size(precipp,1); % number of years
    % cosine weighted mean
%     size(latlist)
%     size(repmat(latlist',T,1))
    rainmean = sum(precipp.*cosd(repmat(latlist',T,1)),2)/sum(cosd(latlist));
    % rainmean is cosine-latitude weighted mean rainfall rate over chosen months, in mm/day
    % Covariance matrix
    % mean observation
    pmean = mean(precipp,1); % this is the mean of observations across years
    % covariance estimation
    Xp = precipp - repmat(pmean,[T 1]); % anomaly matrix
    Sv = 1/(T-1)*(Xp'*Xp); % field covariance matrix
    Sr = Sv + sigmae^2*eye(N); % observation covariance matrix
    % varr = diag(Sr);
    % Temporal mean
    Er = pmean';
    % observation placements and weights
    w = ones(N,1);
%     size(beclearta)
    %% weights
    gamma = w.*beta;
    %% Variance

    varsigma2 = (1/T*sum(precipp.*precipp,1) - alpha*(1/T*sum(precipp,1)).^2)';
    % Srnd = Sr;  I = eye(N); idiag = find(I); Srnd(idiag) = 0;
    Srnd = Sr.*(ones(N)-eye(N)); 

    varm1 = 1/alpha*sum(gamma.^2.*varsigma2);
    varm2 = gamma'*Srnd*gamma;
    varm3 = 1/alpha*sigmae^2*(gamma'*gamma);
    varm4 = -2*((1-alpha)/alpha)*(gamma'*Er)*sum((gamma.^2).*Er);
    varm5 = (1-alpha)/alpha*(gamma'*Er)^2*(gamma'*gamma);

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