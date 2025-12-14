function [ b_lp, a_lp, N ] = lowpass_analogico_manual( fp, fb, Ap, Ab, caso)
%--------------------------------------------------------------------------
% lowpass_analogico_manual
%
% Diseña un filtro pasa bajos analógico Butterworth a partir de las
% especificaciones:
%   fp : frecuencia de paso [Hz]
%   fb : frecuencia de bloqueo [Hz]
%   Ap : atenuación máxima en banda de paso [dB]
%   Ab : atenuación mínima en banda de rechazo [dB]
%   caso : (opcional)
%       1 -> fija Ap en fp (por defecto)
%       2 -> fija Ab en fb
%
% Devuelve:
%   b_lp, a_lp : coeficientes del filtro analógico (dominio s)
%   N          : orden del filtro
%
%--------------------------------------------------------------------------
% Cálculo del orden mínimo del filtro
wb=fb/fp;
N =ceil(.5*log10((10^(Ab/10)-1)/(10^(Ap/10)-1))/log10(wb));

if nargin < 5
    caso = 1;
end

% Cálculo de frecuencias de corte filtro
fc_1 = fp/((10^(Ap/10))-1)^(1/(2*N));
fc_2 = fb/((10^(Ab/10))-1)^(1/(2*N));

[b, a] = butter(N,1,'s'); % Filtro Butterworth Normalizado (wc=1 rad/s)

if caso==2
    [b_lp, a_lp] =lp2lp(b,a,2*pi*fc_2); %
else
    [b_lp, a_lp] =lp2lp(b,a,2*pi*fc_1);
end
end

