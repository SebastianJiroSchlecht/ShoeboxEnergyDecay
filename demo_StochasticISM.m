% Sebastian J. Schlecht, Wednesday, 27 September 2023
%
% This scripts demonstrate the usage for the proposed energy decay method
% to synthesize late reverberation similar to the Image Source Method, but
% at a fraction of the computational complexity.
clear; clc; close all;

plottingParameters
exampleRoom

rng(1)
fs = 48000;                       % Sample frequency (samples/s)

rec = L .* [0.41 0.23 0.41];       % relative Receiver position [x y z]
src = L .* [0.82 0.64 0.55];       % relative Source position [x y z]

rt60 = [1.0 0.8 0.7 0.6 0.5 0.4]*2; % per octave band
nBands = length(rt60);
beta = sqrt(1 - findAbsCoeffsFromRT(L, rt60));
beta = db2mag(mag2db(beta) + 0.1*(rand(size(beta))-0.5));
maxTime = max(rt60);                % lenght of impulse response (seconds)
limitsTime = ones(1,nBands)*maxTime;                

band_centerfreqs(1) = 125; % lowest octave band
for (nb=2:nBands) band_centerfreqs(nb) = 2*band_centerfreqs(nb-1); end

%% stochastic RIR
for it = 1:nBands
    [h_temp2(:,it)] = stochasticRIR(maxTime,beta(it,:),L,c,fs);
end
h.stochastic = filter_rir(h_temp2, band_centerfreqs, fs);

%% image sources
[abs_echograms, rec_echograms, echograms] = compute_echograms_mics(L, src, rec, 1-beta.^2, limitsTime);
h_temp = render_mic_rirs(abs_echograms, band_centerfreqs, fs);
h.ism = h_temp(1:length(h.stochastic));

%% combined
cuton = round(0.10*fs);
h.combined = [h.ism(1:cuton); h.stochastic(cuton+1:end)];

%% plot
close all
print_spectrogram(h.ism,fs,'./results/Fig9a.png');
print_spectrogram(h.stochastic,fs,'./results/Fig9b.png');
print_spectrogram(h.combined,fs,'./results/Fig9c.png');

%% sound
% soundsc([h.ism; h.combined],fs);
audiowrite('./results/ism.wav',h.ism,fs);
audiowrite('./results/stochastic.wav',h.stochastic,fs);
audiowrite('./results/combined.wav',h.combined,fs);


