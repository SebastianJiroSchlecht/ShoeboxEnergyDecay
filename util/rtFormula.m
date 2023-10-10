function rt60 = rtFormula(L,beta)
% author: Karolina Prawda

c = 343;

%% Geometry
Lx = L(1);
Ly = L(2);
Lz = L(3);

V = Lz*Lx*Ly;

gamma = 0.363;
Stot = 2*(Lx.*Ly + Lx.*Lz + Ly.*Lz);

% wall areas (for Fitzroy, e.g.)
SW(:,1) = Lz.*Ly;
SW(:,2) = Lz.*Ly;
SW(:,3) = Lz.*Lx;
SW(:,4) = Lz.*Lx;
SW(:,5) = Lx.*Ly;
SW(:,6) = Lx.*Ly;

%% absorption coefficients
a = 1 - abs(beta).^2;

% average alpha for Sabine and Eyring
a_Sab = sum(a.*SW)/Stot; 

% for Fitzroy
avgAlphaX_ = (a(1) + a(2)) / 2;
avgAlphaY_ = (a(3) + a(4)) / 2;
avgAlphaZ_ = (a(5) + a(6)) / 2;

%% Compute
rt60.Sabine = Sabine_RT60(Stot, V, a_Sab,c);
rt60.Eyring = Eyring_RT60(  V, Stot, a_Sab,c);
rt60.Fitzroy = Fitzroy_RT60(V,SW,Stot, avgAlphaX_,avgAlphaY_,avgAlphaZ_,c); % really overshoots the values
rt60.Kuttruff = Kuttruff_RT60(V, Stot, a_Sab, gamma,c);