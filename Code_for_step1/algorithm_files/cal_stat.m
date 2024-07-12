function [betamse,msemin,Er] = cal_stat(datmatuse,location_list,latlist,a) 
% global precipp sigmae T N rainmean Sr varr Er alpha w 

if~exist('a','var')
    a=0.8;
end

%% Input parameters
%measurement standard deviation
sigmae = 1; %mm/day
datmatuse2d = squeeze(mean(datmatuse(:,:,location_list),1));

%%
precipp = datmatuse2d; % this is the data matrix [t=year,location]

N = size(precipp,2); % number of locations
T = size(precipp,1); % number of years

%% cosine weighted mean
rainmean = sum(precipp.*cosd(repmat(latlist',T,1)),2)/sum(cosd(latlist));

% rainmean is cosine-latitude weighted mean rainfall rate over chosen months, in mm/day

%% Covariance matrix

% mean observation
pmean = mean(precipp,1); % this is the mean of observations across years


% covariance estimation
Xp = precipp - repmat(pmean,[T 1]); % anomaly matrix

Sv = 1/(T-1)*(Xp'*Xp); % field covariance matrix

% Sv = (1/2)*(Sv + Sv'); % use for yearwise calculations


Sr = Sv + sigmae^2*eye(N); % observation covariance matrix

% varr = diag(Sr);

%% Temporal mean
Er = pmean';

%% observation placements and weights
w = ones(N,1);

alpha = a;

 %% Optimization parameters
A = []; b = [];
lb = zeros(N,1); ub = [];
Aeq = w'; beq = 1;
beta0 = ones(N,1)/sum(w); % uniform weights
options = optimoptions('fmincon','Algorithm','sqp','MaxFunctionEvaluations',1e10,...
    'MaxIterations',1e10,'ConstraintTolerance',1e-8,'OptimalityTolerance',1e-8,...
    'StepTolerance',1e-8,'Display','off','UseParallel',false);

%% Min MSE
betamse = fmincon(@getmodelmse,beta0,A,b,Aeq,beq,lb,ub,[],options,precipp,sigmae,T,N,rainmean,Sr,Er,alpha,w);
betamse = betamse';
msemin = getmodelmse(betamse',precipp,sigmae,T,N,rainmean,Sr,Er,alpha,w);
end
