function [ periodo,NF ] = esPeriodica( x )
%Analiza una secuencia discreta finita y determina si presenta periodicidad.
%   Parámetros de entrada
%        x ? vector que representa la señal discreta a analizar.
%   Parámetros de salida
%       periodo ? valor entero que indica el período fundamental N0 de la 
%                 señal.
%                 Si es 0, significa que la señal no es periódica dentro 
%                 del rango analizado.
%       NF ? vector que contiene un segmento de la señal correspondiente a
%            un período completo.
%            El primer valor corresponde al inicio de la señal (n=0).

periodo=0;              % Inicializa el período como 0 (por defecto: no periódica)
NF=[];                  % Inicializa el vector que contendrá un ciclo de la señal
error= 1e-10;           % Tolerancia para comparar valores (evita errores numéricos)
N=length(x);            % Número total de muestras en la señal
M=(N/2);                % Límite superior para buscar el período (no puede ser mayor que N/2)

for p=(1:M);            % Recorre posibles valores de período p, desde 1 hasta M
    n=1;                % Reinicia el índice n en cada intento de período
    while n<N-p         % Mientras no se haya alcanzado el final de la señal desplazada
        if abs(x(n)-x(n+p))<= error  % Compara el valor actual con el desplazado p muestras
            n=n+1;      % Si son iguales (dentro del error), avanza al siguiente índice
        else
            n=N;        % Si no coinciden, fuerza la salida del bucle while
        end
        
        if n==N-p       % Si se llegó al final verificando coincidencia en todo el rango
            periodo=p;  % Se encontró un período válido
            NF=x(n:n+p-1); % Extrae el segmento correspondiente a un ciclo de la señal
            return      % Termina la función y devuelve resultados
        end
    end
end

