function [ audio_recortado , Fs ] = partir_audio( audio, t_recorte, t_inicio)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
%   Entradas:
%         audio: archivo .wav
%         t_recorte:duraci+on deseada en segundos
%         t_inicio: tiempo de inicio en segundos 
%     Salidas:
%         audio_recortado: vector columna 
%         Fs: frecuencia de muestreo

% Leer el audio
[audio_in, Fs] = audioread(audio);

% Calcular la cantidad de muestras correspondientes a 1 segundo
N = round(t_recorte * Fs);

% Calcular la cantidad de muestras correspondientes a el tiempo en segundo
%en el que quiero que inicie 
inicio=round(t_inicio*Fs);

% Recortar el audio 
audio_recortado = audio_in(inicio:inicio+N, :);

end

