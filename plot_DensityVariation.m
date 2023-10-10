% Sebastian J. Schlecht, Tuesday, 03 October 2023
clear; clc; close all;
plottingParameters
exampleRoom

rng(1)
fs = 48000;                    % Sample frequency (samples/s)
limitsTime = 1.5;              % lenght of impulse response (seconds)
time = (1:limitsTime*fs).'/fs; % seconds
cuton = round(0.01*fs);

sigma2RT = @(s) -6.9078 ./ (c*s); % same as: sigma2RT = @(s) -60 ./ mag2db((exp(c*s)));
findRT = @(edc,DR) (-60/DR)*time(find(edc < DR,1,'first')); % T with DR in dB

% uniform reflection coefficients
beta(:) = db2mag(-1);

% room sizes
LL = [3 3 3;
      4 4 4;
      3 5 4;
      2 2 10;
      ];

%% Comparing damping densities for different room sizes
for it = 1:size(LL,1)
    L = LL(it,:);
    [h(:, it),envelope,H(:,it),sigma(:,it)] = stochasticRIR(limitsTime,beta,L,c,fs); 
end
H = H * (4*pi);

%% plot the figure
figure(1);
subplot(2,1,1); hold on; grid on; box on
plot(sigma,H)
xlabel('$\sigma$')
ylabel('$H(\sigma)$')

strCell = arrayfun(@(x) num2str(x), LL, 'UniformOutput', false);
legendStrings = cellfun(@(x,y,z) sprintf('L = [%s, %s, %s]', x, y, z), strCell(:,1), strCell(:,2), strCell(:,3), 'UniformOutput', false);
legend(legendStrings)
subplot(2,1,2); hold on; grid on; box on
plot(time, edc(h,1))
xlabel('Time (seconds)')
ylabel ('Energy decay curve (dB)')
ylim([-60 5])

strCell = arrayfun(@(x) num2str(x), LL, 'UniformOutput', false);
legendStrings = cellfun(@(x,y,z) sprintf('L = [%s, %s, %s]', x, y, z), strCell(:,1), strCell(:,2), strCell(:,3), 'UniformOutput', false);
legend(legendStrings)

set(gcf,'Units', 'inches', 'Position', [0 0 3.5 4.5]);
exportgraphics(gcf,'./results/DensityVariation.pdf');
 
