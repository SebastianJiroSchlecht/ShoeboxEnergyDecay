function [h,envelope,H,sigma] = stochasticRIR(maxTime,beta,L,c,fs,varargin)
% update of envelope computation, Sunday, 24 September 2023

%% Parser
% Create an input parser object
p = inputParser;

% Define the required input
addParameter(p, 'usePressureSource', false, @islogical);

% Parse the input arguments
parse(p, varargin{:});

% Extract the values from the parsed input
usePressureSource = p.Results.usePressureSource;

%% Computation
V = prod(L);

Kx = log(prod(beta(1:2))) / L(1);
Ky = log(prod(beta(3:4))) / L(2);
Kz = log(prod(beta(5:6))) / L(3);

Kxyz = [Kx,Ky,Kz];
Kxyz = min(Kxyz,-0.0001); % limit Kxyz to avoid division by 0

maxSigma = max(Kxyz);
minSigma = -norm(Kxyz);
sigma = linspace(minSigma-0.01, maxSigma+0.01,1000);

H = analyticDampingDensity(sigma,Kxyz,V);

H = H / (4*pi); % this is an unexplained tuning factor

% uniform sampling of damping density for the decay envelope
time = (1:max(maxTime)*fs).'/ fs;
envelope = sqrt( exp(c*time.*sigma)*H' .* mean(diff(sigma)));

% shape noise
h = envelope .* randn(size(time));

% apply pressure source to match the color, but compensate the energy loss
if usePressureSource
    h = applyPressureSource(h);
end