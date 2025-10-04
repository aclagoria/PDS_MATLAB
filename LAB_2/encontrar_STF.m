function [ x_reconstruida ] = encontrar_STF( periodo, x )
%Reconstruye una se�al peri�dica de tiempo discreto a partir de los 
%coeficientes de su Serie de Fourier en Tiempo Discreto (SFTD)
%   Entradas   
%       periodo: Longitud del periodo fundamental de la se�al (N).
%       x :      Segmento de la se�al correspondiente a un periodo.      
%   Salida
%       x_reconstruida: Se�al reconstruida usando la STFD
%

N=periodo;
X=fft(x); % Transformada del segmento de la se�al correspondiente a un periodo
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

