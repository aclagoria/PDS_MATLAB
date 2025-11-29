clear all
close all
%[y_recortado, Fs] = partir_audio('fati_Fs8k_12bit.wav',1,1.22);
[y_recortado, Fs] = partir_audio('caro_Fs8k_12bit.wav',1,1.2);
% Escuchar el resultado
sound(y_recortado, Fs);
