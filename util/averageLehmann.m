function [h,envelope] = averageLehmann(num,c, fs, L, beta, limitsTime)

time = (1:limitsTime*fs).'/fs; % seconds

% for it = 1:num    
%     rec = rand(1,3) .* L;
%     src = rand(1,3) .* L;
%     h_temp = fast_ISM_RoomResp(fs,beta,'t60',limitsTime,src,rec,L);   
% endm

rirPower =  ISM_RIRpow_approx(1-beta.^2,L,c,time,'t60');
envelope = sqrt(rirPower(:));

h = envelope.*logistic_rnd(fs*limitsTime,1,0,sqrt(3)/pi);
h = h(:);
h = applyPressureSource(h);