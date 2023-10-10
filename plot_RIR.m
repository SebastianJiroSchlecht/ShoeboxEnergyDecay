% Sebastian J. Schlecht, Saturday, 29 July 2023
clear; clc; close all;
plottingParameters
exampleRoom

rng(1)
fs = 48000;                     % Sample frequency (samples/s)
limitsTime = .3;                % lenght of impulse response (seconds)
time = (1:limitsTime*fs).'/fs;  % seconds

%% stochastic RIR
[h.stochastic,env.stochastic] = stochasticRIR(limitsTime,beta,L,c,fs,'usePressureSource',true);

%% image sources
h.ism = averageISM(1,c, fs, L, beta, limitsTime);

%% combined
cuton = round(0.10*limitsTime*fs);
h.combined = [h.ism(1:cuton); h.stochastic(cuton+1:end)];

%% Plot
lineOption = {'LineWidth',1.3};
figure('Units','centimeters','Position',[0 0 8.9 5]); hold on; grid on;
plot(time,edc(h.ism,cuton),'-');
plot(time,edc(h.stochastic,cuton),'--');
ylim([-100, 20])
ylabel('Energy decay curve (dB)')
xlabel('Time (seconds)')
legend('ISM EDC','Stochastic EDC','Location','SouthWest')
exportgraphics(gca,'./results/Fig5.pdf');

%% Plot
figure('Units','centimeters','Position',[0 0 8.9 7]); hold on; grid on;
offset = 0.2;
plot(time, (h.ism), lineOption{:})
plot(time, (h.stochastic) - offset, lineOption{:})
plot(time, (h.combined) - 2*offset, lineOption{:})

ylabel('Sound pressure (linear)')
xlabel('Time (seconds)') 
leg = legend('ISM','Stochastic RIR','Combined RIR','Location','northoutside','NumColumns',3);
exportgraphics(gca,'./results/Fig4.pdf');

%% Play RIR sound
% soundsc([h.ism; h.stochastic; h.combined])