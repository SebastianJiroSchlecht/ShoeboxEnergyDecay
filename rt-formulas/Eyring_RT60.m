function [t60, aa] = Eyring_RT60(  V, Stot, avgAlpha, c )
% C.  F.  Eyring,  “Reverberation  time  in  dead  rooms,”Journal of
% Acoustical Society of America, vol. 1, no. 2,pp. 217–241, 1930
const = log(10^6)/c;
t60 = const*4*V./(Stot*(-log(1-avgAlpha)));
