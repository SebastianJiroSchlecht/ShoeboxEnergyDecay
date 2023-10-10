function t60 = Sabine_RT60( Stot, V, avgAlpha, c)
% W. C. Sabine,Collected Papers on Acoustics.Cam-bridge, MA, USA: Harvard University Press, 1922
const = log(10^6)/c;

t60 = const*V*4./(Stot*avgAlpha);
