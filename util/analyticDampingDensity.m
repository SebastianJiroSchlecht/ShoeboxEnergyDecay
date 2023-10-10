function [H, p] = analyticDampingDensity(sigma,K,V)
% comments show which equations those represent, paper version Sunday, 09 July 2023
Kx = K(1);
Ky = K(2);
Kz = K(3);

A = -(Kx.^2 + Ky.^2 + Kz.^2); % (21)
B = 2 * sigma .* Kz; % (21)
C = Kx.^2 + Ky.^2 - sigma.^2; % (21)
Delta = sqrt(B.^2 - 4 * A.*C); % (21)

a0 = -sqrt(Kx.^2 + Ky.^2); % (22)
a1 = Kx;
a2 = Ky;
b = Kz;
c = sigma;

p = @(a) clip(real([1; -1].*acos(- c ./ sqrt(a.^2 + b.^2)) - atan(-a./b)),[0,pi/2]); 
p0 = p(a0);
p1 = p(a1);
p2 = p(a2);

F = @(phi) -1./sqrt(-A) * asin( (2.*A.*cos(phi) + B)./Delta ); % (21)
Fint = @(p_up,p_low) real( F(p_up) - F(p_low) );

H0 = Fint(p0(2,:),p0(1,:));
H1 = Fint(p1(2,:),p1(1,:));
H2 = Fint(p2(2,:),p2(1,:));

H = 8/(4*pi*V) .* (2*H0 - H1 - H2 ); % (20)

% only as return values
p = [p0; p1; p2].';

end