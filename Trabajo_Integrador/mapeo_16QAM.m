function [ a_k, b_k ] = mapeo_16QAM( grupos_bits )
%mapeo_16QAM Convierte grupos de 4 bits a símbolos 16-QAM.
%   Realiza el mapeo binario a amplitudes en cuadratura correspondiente a 
%   una modulación 16-QAM (Quadrature Amplitude Modulation).
%   Cada símbolo de 4 bits se divide en dos pares de 2 bits:
%       - Los 2 bits más significativos (MSB) definen la componente en 
%         fase (I)
%       - Los 2 bits menos significativos (LSB) definen la componente en
%         cuadratura (Q)
%
%   ENTRADA:
%       grupos_bits : Celda de 12 elementos, donde cada elemento es una 
%                     cadena de 4 caracteres binarios ('0' o '1'),
%                     e.g. {'1100','0101',...}
%
%   SALIDA:
%       a_k : Vector fila (1x12) con las amplitudes mapeadas para el eje 
%             en fase.
%       b_k : Vector fila (1x12) con las amplitudes mapeadas para el eje 
%             en cuadratura.
%
%   MAPEADO PAM UTILIZADO (Gray-like):
%       '11' -> -3
%       '10' -> -1
%       '00' -> +1
%       '01' -> +3
%
%   Ejemplo:
%       grupos_bits = {'1100','0101','0001','1111',...};
%       [a_k,b_k] = mapeo_16QAM(grupos_bits);
%
%       -> a_k = [-3, +3, +1, -3, ...]
%       -> b_k = [+1, +3, +3, -3, ...]

pam_map = containers.Map({'11','10','00','01'}, [-3,-1,1,3]);
a_k = zeros(1,12);
b_k = zeros(1,12);
    for kch = 1:12
        bits4 = grupos_bits{kch};
        pair1 = bits4(1:2);
        pair2 = bits4(3:4);
        a_k(kch) = pam_map(pair1);
        b_k(kch) = pam_map(pair2);
    end
end

