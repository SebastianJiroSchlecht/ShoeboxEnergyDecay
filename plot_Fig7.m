% Plot Figure 7
%
% author: % K.P. 17.08.2023
%
% update by SJS, 2023-09-26
%

clear; clc; close all;
startup
plottingParameters
exampleRoom

rng(2);
fs = 48000;                    % Sample frequency (samples/s)
limitsTime = 1.5;              % lenght of impulse response (seconds)
time = (1:limitsTime*fs).'/fs; % seconds
cuton = round(0.05*fs);

beta = db2mag(zeros(1,6)); % lossless case

%% image sources
h.ism = averageISM(1,c, fs, L, beta, limitsTime); % average over positions

%% stochastic RIR
[h.stochastic,env.stochastic] = stochasticRIR(time,beta,L,c,fs,'usePressureSource',true);

%% Lehmann
[h.lehmann, env.lehmann] = averageLehmann(1,c, fs, L, beta, limitsTime);

%% reverberation time (after cuton! this stabilizes the estimate)
EDC.ism = edc(h.ism,cuton);
EDC.stochastic = edc(h.stochastic,cuton);
EDC.lehmann = edc(h.lehmann,cuton);

%% plot
figure;
subplot(2,1,1); hold on; grid on; box on
plot(time,edc(h.ism,cuton),'-');
plot(time,edc(h.stochastic,cuton),'--');
plot(time,edc(h.lehmann,cuton),'-.');
ylabel('Magnitude (dB)')
xlabel('Time (seconds)')
ylim([-60 20])
legend('ISM', 'Stochastic RIR', 'Lehmann', 'Location','southwest')

subplot(2,1,2); hold on; grid on; box on
win = ones(2^10,1); win = win / norm(win);
shortTimeAvg = @(h) db(conv(h.^2,win,'same'));
lineOption = {'LineWidth',1.3};
plot(time, shortTimeAvg(h.ism))
plot(time, shortTimeAvg(h.stochastic)-0)
plot(time, shortTimeAvg(h.lehmann)-20);
ylabel('Sound pressure (dB)')
xlabel('Time (seconds)')
legend('ISM', 'Stochastic RIR', 'Lehmann', 'numcolumns', 3, 'Location','northoutside')
ylim([-50 5])

set(gcf,'Units', 'inches', 'Position', [0 0 3.5 4.5]);
exportgraphics(gcf,'./results/Fig7.pdf')
