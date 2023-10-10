function t60 = Kuttruff_RT60(  V,  Stot, avgAlpha, gamma, c)
% H.  Kuttruff,Room Acoustics.London,  UK:  SponPress, 2009
const = log(10^6)/c;
t60 = -const*4*V./(Stot*log(1-avgAlpha).*(1+0.5*(gamma^2)*log(1-avgAlpha)));