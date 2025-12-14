function [ b_bp, a_bp, N ,f0] = bandpass_analogico_manual( fs1,fp1, fp2, fs2,  Ap, As)
%--------------------------------------------------------------------------
% bandpass_analogico_manual
%
% Diseña un filtro pasa banda analógico Butterworth a partir de las
% especificaciones de plantilla, utilizando el método manual basado en
% el prototipo pasa bajos normalizado y la transformación de frecuencia.
%
% especificaciones:
%   fs1 : Frecuencia de rechazo inferior [Hz]
%   fp1 : Frecuencia de paso inferior [Hz]
%   fp2 : Frecuencia de paso superior [Hz]
%   fs2 : Frecuencia de rechazo superior [Hz]
%   Ap  : Atenuación máxima en la banda de paso [dB]
%   As  : Atenuación mínima en la banda de rechazo [dB]
%
% devuelve:
%   b_bp : Coeficientes del numerador del filtro pasa banda analógico H(s)
%   a_bp : Coeficientes del denominador del filtro pasa banda analógico H(s)
%   N    : Orden del filtro pasa banda resultante(2*Orden del filtro pasa
%          bajo normalizado)
%   f0   : frecuancia cental del filtro
%--------------------------------------------------------------------------

ws1=2*pi*fs1;
ws2=2*pi*fs2;
f0 =(fp1*fp2)^(1/2);    w0=2*pi*f0;
B = 2*pi*(fp2 - fp1);

omega_s1 = abs((ws1^2-w0^2)/(B*ws1));
omega_s2 = abs((ws2^2-w0^2)/(B*ws2));
omega_s = min(omega_s2,omega_s1);

N_lp = ceil(.5*log10((10^(As/10)-1)/(10^(Ap/10)-1))/log10(omega_s));
[b, a] = butter(N_lp,1,'s'); % Lowpass Normalizado 
[b_bp, a_bp] = lp2bp(b, a, w0, B);  % lp2bp = Lowpass to Bandpass
N = 2*N_lp;
end

