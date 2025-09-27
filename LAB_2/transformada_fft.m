function [ magnitud , frecuencia  ] = transformada_fft( x, Fs )
%Recibe como entrada una señal discreta y su frecuencia de muestreo,
%y devuelve el espectro de magnitud de la señal junto con el eje de 
%frecuencias en Hz.
%   Entrada:
%       x: vector con la señal discreta de entrada
%       Fs: frecuencia de muestreo en Hz, asociada a la señal de entrada.
%   Salida:
%       magnitud: vector con los valores de magnitud del espectro de Fourier
%       frecuencia: vector con los valores de frecuencia en Hz 
%                   correspondientes a cada componente de magnitud.

N=length(x);
X=fft(x)/N;
frecuencia=(0:N-1)*(Fs/N);
magnitud=abs(X1);

end

