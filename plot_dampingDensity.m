% Sebastian J. Schlecht, Friday, 28 July 2023
%
% Plot Fig 2, 3, and 8
clear; clc; close all;
plottingParameters

%% parameter

exampleRoom

Kx = log(prod(beta(1:2))) / L(1);
Ky = log(prod(beta(3:4))) / L(2);
Kz = log(prod(beta(5:6))) / L(3);

Kxyz = [Kx,Ky,Kz];

maxSigma = max(Kxyz);
minSigma = -norm(Kxyz);

%% special points
special_points = ([Kx, Ky, Kz,-norm([Kx Ky]), -norm([Kx Kz]), -norm([Ky Kz]),-norm(Kxyz)])


%% numerical integration over octant
theta = linspace(0,pi/2,4000);
phi = linspace(0,pi/2,4000).';

M = Kx * abs(cos(theta).*sin(phi)) + ...
    Ky * abs(sin(theta).*sin(phi)) + ...
    Kz * abs(cos(theta*0).*cos(phi));

% weighted by integration area
W = theta.^0 .* sin(phi) .* mean(diff(theta)) .* mean(diff(phi));

[histw, histB, histv] = histwv(M(:), W(:), minSigma-0.01, maxSigma+0.01, 1000);
histw = histw * 8 / (4*pi*V) / mean(diff(histB)); % weighted by histogram bin width

%% analytical integration
sigma = linspace(minSigma-0.01, maxSigma+0.01,10000);
[H, p] = analyticDampingDensity(sigma,Kxyz,V);



%% Fig. 3; plot analytic damping
figure('Units','centimeters','Position',[0 0 8.9 5]); hold on; grid on;
bar(histB,histw);
plot(sigma, H)
xlabel('$\sigma$')
ylabel('$H(\sigma)$')

[HSpecial] = analyticDampingDensity(special_points+1e-6,Kxyz,V);
plot(special_points,HSpecial,'.k','MarkerSize',10)


exportgraphics(gca,'Fig3.pdf');

%% Fig. 8; integration limits

ind0 = sigma > -sqrt(Kx^2 + Ky^2 + Kz^2);
ind1 = sigma > -sqrt(Kx^2 + Kz^2);
ind2 = sigma > -sqrt(Ky^2 + Kz^2);

alpha = Kx .* sin(phi);
beta = Ky .* sin(phi);
gamma = Kz .* cos(phi);

figure('Units','centimeters','Position',[0 0 8.9 7]); hold on; grid on;
plot(sigma(ind0), p(ind0,1))
plot(sigma(ind1), p(ind1,3))
plot(sigma(ind2), p(ind2,5))
set(gca,'ColorOrderIndex',1)
plot(sigma(ind0), p(ind0,2),'--')
plot(sigma(ind1), p(ind1,4),'--')
plot(sigma(ind2), p(ind2,6),'--')

h_shade = shade(phi,-sqrt(alpha.^2 + beta.^2) + gamma,phi,alpha + gamma,'FillType',[2 1],'FillColor',{'blue'},'FillAlpha',0.1);
h_shade(3).Vertices = h_shade(3).Vertices(:,[2 1]);
delete(h_shade([1 2]))
hatchfill(h_shade(3),'single', -45, 3)

h_shade = shade(phi,-sqrt(alpha.^2 + beta.^2) + gamma,phi,beta + gamma,'FillType',[2 1],'FillColor',{'red'},'FillAlpha',0.1);
h_shade(3).Vertices = h_shade(3).Vertices(:,[2 1]);
delete(h_shade([1 2]))
hatchfill(h_shade(3),'single', 45, 3)

ylabel('$\varphi$')
xlabel('$\sigma$')
legend({'${\varphi}^{+}_0$','$\varphi^{+}_{1}$','$\varphi^{+}_{2}$','${\varphi}^{-}_0$','$\varphi^{-}_{1}$','$\varphi^{-}_{2}$'},'Location','SouthEast')
ylim([0 pi/2])
xlim([min(sigma),max(sigma)]);

exportgraphics(gca,'Fig8.pdf');

%% Fig. 2; compute horizontal integration
phi = pi ./ [2 2.5 4 8].';
[H2D] = analyticDampingDensity2D(sigma,Kxyz,V,phi);

figure('Units','centimeters','Position',[0 0 8.9 5]); hold on; grid on;
plot(sigma, H2D)
xlabel('$\sigma$')
ylabel('$H_{\varphi}(\sigma)$')
legend({'$\varphi = \pi/2$', '$\varphi = \pi/2.5$', '$\varphi = \pi/4$', '$\varphi = \pi/8$'},'NumColumns',2, 'Location','northoutside')
ylim([0 1]);
xlim([min(sigma),max(sigma)]);

exportgraphics(gca,'Fig2.pdf');
