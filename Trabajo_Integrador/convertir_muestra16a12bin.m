function [bin12] = convertir_muestra16a12bin(muestra)
% convertir_audio16a12bin Convierte una muestra de audio en coma flotante 
%                         (-1 a +1, 16 bits) a su equivalente binario de 
%                         12 bits efectivos, descartando los 4 bits menos 
%                         significativos.
%
% Entrada:
%   muestra: valor decimal entre -1 y +1 (una muestra del audio original 
%            de 16 bits)
% Salida:
%   bin12: cadena de 12 caracteres con los bits efectivos.
  
m_16 = int16(muestra * 32768); % Convierte la muestra original al rango de 
                               % [-1,1] a enteros con signo 
                               % de 16 bits [-32768, 32767]`.

m_12 = bitshift(m_16, -4); % Desplaza los bits 4 posiciones a la derecha 
                           % (divide entre 16), eliminando los 4 bits (LSB)
                           % dejando los 12 bits MSB, que representan los 
                           % 12 bits efectivos del ADC original.

m_12 = double(m_12);% Convierte el resultado a double para evitar problemas
                % al operar con funciones que no aceptan enteros con signo.

muestra_esc = uint16(m_12); % Convierte el valor a entero sin signo de 16 
                            % bits, necesario para las operaciones con bits
                            % posteriores (`bitand`, `dec2bin`).

bin12 = dec2bin(bitand(muestra_esc, 4095), 12);% Aplica una máscara binaria 
            % para quedarse solo con los 12 bits LSB del valor resultante,
            % y luego los convierte en una cadena binaria de 12 caracteres.
end