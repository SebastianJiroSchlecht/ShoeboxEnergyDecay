function [H, p] = analyticDampingDensity(sigma,K,V)
% Compute the damping density for K and V at the damping points sigma
% comments show which equations those represent, paper version Friday, 17 November 2023
Kx = K(1);
Ky = K(2);
Kz = K(3);

A = -(Kx.^2 + Ky.^2 + Kz.^2); % (20)
B = 2 * sigma .* Kz; % (20)
C = Kx.^2 + Ky.^2 - sigma.^2; % (20)
Delta = sqrt(clip(B.^2 - 4 * A.*C,[0,Inf])); % (20), clip negative arguments

a0 = -sqrt(Kx.^2 + Ky.^2); % (21)
a1 = Kx;
a2 = Ky;
b = Kz;
c = sigma;

% clip acos argument to [-1,1]
p = @(a) clip([1; -1].*acos(clip(- c ./ sqrt(a.^2 + b.^2),[-1,1])) - atan(-a./b),[0,pi/2]); % (21)
p0 = p(a0);
p1 = p(a1);
p2 = p(a2);

F = @(phi) -1./sqrt(-A) * asin( (2.*A.*cos(phi) + B)./ (Delta+eps) ); % (20)
Fint = @(p_up,p_low) ( F(p_up) - F(p_low) );

H0 = Fint(p0(2,:),p0(1,:));
H1 = Fint(p1(2,:),p1(1,:));
H2 = Fint(p2(2,:),p2(1,:));

H = 8/(4*pi*V) .* (2*H0 - H1 - H2 ); % (19)

% only as return values
p = [p0; p1; p2].';

end