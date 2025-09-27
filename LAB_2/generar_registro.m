function [ audio12bit_esc, Fs_nuevo ] = generar_registro( audio24bit, Fs )
%Recibe  una se�al de audio en formato digital de 24 bits y con frecuencia 
%de muestreo inicial Fs y devuelve una versi�n procesada con 8 kHz de 
% frecuencia de muestreo y con una resoluci�n efectiva de 12 bits
%   Entradas:
%       audio24bit: vector que contiene la se�al de audio de entrada
%       Fs: frecuencia de muestreo de la se�al de entrada.
%   Salidas:
%       audio12bit_esc: se�al procesada, cuantizada a 12 bits y reescalada 
%                       al rango din�mico original de la se�al de entrada.
%       Fs_nuevo: frecuencia de muestreo de salida, fijada en 8000 Hz.


% Cambiar la frecuencia de muestreo de 32 kHz a 8 KHz
Fs_nuevo= 8000;
audio_Fs_8k = resample(audio24bit, Fs_nuevo, Fs);% remuestreo a 8kHZ

% Cambiar el numero de bits de 24 a 12
%   Obtener valore m�nimo y m�ximp para escalar la se�al
    min_val = min(audio_Fs_8k); 
    max_val = max(audio_Fs_8k);
    rango=max_val-min_val;
%   Desplazar la se�al para que arranque en 0
    audio24bit_desplazado= audio_Fs_8k- min_val;
%   Escalado de la se�al 
    audio24bit_escalado= audio24bit_desplazado * ((2^24-1)/(rango));
%   Cuantizar a 12 bits 
    audio12bit=round(audio24bit_escalado/(2^12)); %redondeo
%   Esacalar al rango original
    audio12bit_esc=(audio12bit*rango/(2^12-1))+min_val;
end

