% Sebastian J. Schlecht, Saturday, 30 September 2023
clear; clc; close all;
plottingParameters
exampleRoom

rng(1)
fs = 48000;                    % Sample frequency (samples/s)
limitsTime = 1.5;              % Lengths of RIR 
time = (1:limitsTime*fs).'/fs; % seconds
cuton = round(0.01*fs);        % Cut on time for RIR energy

sigma2RT = @(s) -6.9078 ./ (c*s);  % same as: sigma2RT = @(s) -60 ./ mag2db((exp(c*s)));
findRT = @(edc,DR) (-60/DR)*time(find(edc < DR,1,'first')); % T with DR in dB

%% RT based on stochastic RIR
[h,envelope,H,sigma] = stochasticRIR(limitsTime,beta,L,c,fs);
H = H * (4*pi);
EDC = edc(h,cuton);
RT20 = findRT(EDC,-20);
RT60 = findRT(EDC,-60);

%% Classic RT Formulas
rt60 = rtFormula(L,beta);

%% Plot RT density for example room
figure('Units','centimeters','Position',[0 0 8.9 5]); hold on; grid on;
plot(sigma2RT(sigma),(H) )
plotDottedLineWithLabel(RT20, 0.1, '$T_{20}$');
plotDottedLineWithLabel(RT60, 0.15, '$T_{60}$');
plotDottedLineWithLabel(rt60.Sabine, 0.15, 'Sabine');
plotDottedLineWithLabel(rt60.Eyring, 0.07, 'Eyring');
plotDottedLineWithLabel(rt60.Kuttruff, 0.15, 'Kuttruff');
plotDottedLineWithLabel(rt60.Fitzroy, 0.07, 'Fitzroy');
xlabel('Reverberation Time (seconds)')
ylabel('Density (linear)')
xlim([0.05 0.4])
exportgraphics(gca,'./results/RTdensity.pdf');
 

%% Comparing RT formula for corridor 

% make a corridor
numberOfSettings = 20;
LL = L .* ones(numberOfSettings,1);
LL(:,1) = linspace(1,30,numberOfSettings);
VV = prod(LL,2);
for it = 1:numberOfSettings
    L = LL(it,:);
    [h,envelope] = stochasticRIR(limitsTime,beta,L,c,fs);
    edc2(:,it) = edc(h,cuton);
    rt60.stochastic(it) = findRT(edc2(:,it),-60);
    rt60.stochastic20(it) = findRT(edc2(:,it),-20);

    rt60_temp = rtFormula(L,beta);
    rt60.Sabine(it) = rt60_temp.Sabine;
    rt60.Eyring(it) = rt60_temp.Eyring;
    rt60.Kuttruff(it) = rt60_temp.Kuttruff;
    rt60.Fitzroy(it) = rt60_temp.Fitzroy;
end

% Convert struct to matrix
rt60_matrix = cell2mat(struct2cell(rt60));

% Plot RT of corridor
figure('Units','centimeters','Position',[0 0 8.9 7]); hold on; grid on;
plot(LL(:,1),rt60_matrix)
legend({'Sabine','Eyring','Fitzroy','Kuttruff','Stochastic $T_{60}$','Stochastic $T_{20}$'},'NumColumns',2,'Location','northoutside')
xlabel('Room Length (m)')
ylabel('Predicted Reverberation time (seconds)')
exportgraphics(gca,'./results/RTCorridor.pdf');





