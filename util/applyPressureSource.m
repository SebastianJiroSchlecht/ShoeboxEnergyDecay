function ism2 = applyPressureSource(ism)
% Convolve the ISM with a high-pass filte which corresponds to a pressure
% source. Please see our WASPAA paper for details.

len = 10000;
M = ceil(len/2);
H1 = 1i*linspace(0,1,M).';
H = [H1; conj(flip(H1(2:end),1))];
h = ifft(H);
h = circshift(h,M);
h = h(floor((-100:100)+len/2));

h = h / norm(h);

ism2 = conv(ism,h,'same');