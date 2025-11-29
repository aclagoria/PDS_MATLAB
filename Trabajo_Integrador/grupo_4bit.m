function [ grupos_bits ] = grupo_4bit( bin12 )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
% %   Entrada:
%     x: señal de 12 bits
%     Salida:
%     grupos_bits: vector columna de 3 filas y cada una contiene 4 bits  
grupos_bits = cell(1,3);   % 3 grupos de 4 bits (4 señales * 3 grupos)
for g = 1:3
	bits4 = bin12(4*(g-1)+1 : 4*g);
	grupos_bits{g} = bits4;
end
end

