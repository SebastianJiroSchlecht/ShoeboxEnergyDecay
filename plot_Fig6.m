% Plot Figure 6
%
% author: % Sebastian J. Schlecht, Saturday, 29 July 2023
% updated by K.P. 17.08.2023
% randomized source and receiver positions while the geometry and
% absorption data is constant
% also added Lehmann to the comparison
%
% update by SJS, 2023-09-26
%

clear; clc; close all;
plottingParameters
startup
exampleRoom

fs = 48000;                    % Sample frequency (samples/s)
limitsTime = 3;                % lenght of impulse response (seconds)
time = (1:limitsTime*fs).'/fs; % seconds
cuton = round(0.05*fs);

numberOfSettings = 11; % number of iterations
rng(0)
maxBeta = [-0.97   -1.08   -0.15   -1.09   -0.75   -0.11]/6;
betas = maxBeta .* linspace(1,21,numberOfSettings).';
avgBetas = mean(betas,2);

switch 'load' % choose 'compute' for computing the RIR with ISM
    case 'compute'
        %% Compute different beta settings
        for it = 1:numberOfSettings
            beta = db2mag(betas(it,:));

            %% stochastic RIR
            tic
            [h.stochastic,envelope] = stochasticRIR(limitsTime,beta,L,c,fs,'usePressureSource',true);
            elapsedTime.stochastic(it) = toc;

            h.stochastic = envelope;

            %% image sources
            tic
            h.ism = averageISM(3,c, fs, L, beta, limitsTime); % average over positions
            elapsedTime.ism(it) = toc;

            %% Lehmann
            [~,h.lehmann] = averageLehmann(1,c, fs, L, beta, limitsTime);

            %% reverberation time (after cuton! this stabilizes the estimate)
            EDC.ism(:,it) = edc(h.ism,cuton);
            EDC.stochastic(:,it) = edc(h.stochastic,cuton);
            EDC.lehmann(:,it) = edc(h.lehmann,cuton);

        end

        %% RT
        findRT = @(edc) 2*time(find(edc < -30,1,'first')); % T30
        for it = 1:numberOfSettings
            RT.ism(it) = findRT(EDC.ism(:,it));
            RT.stochastic(it) = findRT(EDC.stochastic(:,it));
            RT.lehmann(it) = findRT(EDC.lehmann(:,it));
        end

        %% save
        save('RT_MonteCarlo.mat',"betas","EDC","RT","h");
    case 'load'
        load('RT_MonteCarlo.mat');
end

%% plot RT fig 6 in the paper
f = figure(6); clf; hold on; grid on; box on
subplot(2,1,1);hold on; grid on; box on
plot(avgBetas, RT.ism, '-o', 'markersize', 3)
plot(avgBetas,RT.stochastic,  '-','markersize', 2)
plot(avgBetas,RT.lehmann,  '-','markersize', 2)
ylabel('RT (s)')
xlabel('Average $\beta$ (dB)')
legend('ISM', 'Stochastic RIR', 'Lehmann', 'numcolumns', 3, 'location', 'northoutside')
ylim([0 2.5])
xlim([min(avgBetas) max(avgBetas)])

subplot(2,1,2); hold on; grid off; grid on; box on
plot([inf inf], [inf inf], 'HandleVisibility','off')

rtDifference = @(rt1,rt2) 100*((rt2-rt1)./rt1);
plot(avgBetas,rtDifference(RT.ism,RT.stochastic), '-o','markersize', 2)
plot(avgBetas,rtDifference(RT.ism,RT.lehmann), '-o','markersize', 2)
ylabel('RT difference ($\%$)')
xlabel('Average $\beta$ (dB)')
legend( 'Stochastic RIR', 'Lehmann', 'numcolumns', 3, 'location', 'southwest')
ylim([-23 10])
xlim([min(avgBetas) max(avgBetas)])

set(gcf,'Units', 'inches', 'Position', [0 0 3.5 4.5]);
exportgraphics(gcf,'./results/Fig6.pdf')

