function [ x_reconstruida ] = encontrar_STF( periodo, x )
%Reconstruye una señal periódica de tiempo discreto a partir de los 
%coeficientes de su Serie de Fourier en Tiempo Discreto (SFTD)
%   Entradas   
%       periodo: Longitud del periodo fundamental de la señal (N).
%       x :      Segmento de la señal correspondiente a un periodo.      
%   Salida
%       x_reconstruida: Señal reconstruida usando la STFD
%

N=periodo;
X=fft(x); % Transformada del segmento de la señal correspondiente a un periodo
          % Coeficientes de la TFD

% Buscar los coeficientes de la STF
% C[k]=X[k]/N  ( C: coef STF, X: coef TFD)entonces:
C=X/N; % Coef de la serie
K=N-1;
x_reconstruida=zeros(N,1);
for n=(1:N);
    suma=0;
    for k = 0:K
        suma= suma + C(k+1)* exp(1i*2*pi*k*(n-1)/N);
    end
    x_reconstruida(n)=suma;   
end

end

