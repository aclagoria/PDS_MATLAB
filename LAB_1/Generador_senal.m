function [ valores ,n ] = Generador_senal( f,inicio,muestra,fs,fi )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

n=(inicio:(muestra));
valores=sin(2*pi*f*(n/fs)+fi);

end

