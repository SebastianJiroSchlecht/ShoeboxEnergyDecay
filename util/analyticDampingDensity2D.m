function [H] = analyticDampingDensity2D(sigma,K,V,phi)
% comments show which equations those represent, paper version Sunday, 09 July 2023
Kx = K(1);
Ky = K(2);
Kz = K(3);

alpha = Kx * sin(phi);
beta = Ky * sin(phi);
gamma = Kz * cos(phi);

ab = -sqrt(alpha.^2 + beta.^2);
sg = sigma-gamma;

mu = (ab < sg & sg < alpha) + (ab < sg & sg < beta);

H = 8/(4*pi*V) .* mu ./ sqrt(alpha.^2 + beta.^2 - (sigma - gamma).^2);


end