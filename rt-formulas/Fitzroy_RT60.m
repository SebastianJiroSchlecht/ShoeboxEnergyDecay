function t60 = Fitzroy_RT60(V,SW,Stot, avgAlphaX,avgAlphaY,avgAlphaZ,c)
% D.  Fitzroy,  “Reverberation  formula  which  seems  tobe more accurate 
% with nonuniform distribution of absorption,”Journal of Acoustical Society of America,vol. 31, no. 7, pp. 893–897, 1959
const = log(10^6)/c;
t60 = const*(4*V/(Stot^2)).*( ...
    - (SW(1) + SW(2))./log(1-avgAlphaX) ...
    - (SW(3) + SW(4))./log(1-avgAlphaY) ...
    - (SW(5) + SW(6))./log(1-avgAlphaZ));
end

