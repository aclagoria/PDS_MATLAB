function [ periodo,NF ] = esPeriodica( x )
%Analiza una secuencia discreta finita y determina si presenta periodicidad.
%   Par�metros de entrada
%        x ? vector que representa la se�al discreta a analizar.
%   Par�metros de salida
%       periodo ? valor entero que indica el per�odo fundamental N0 de la 
%                 se�al.
%                 Si es 0, significa que la se�al no es peri�dica dentro 
%                 del rango analizado.
%       NF ? vector que contiene un segmento de la se�al correspondiente a
%            un per�odo completo.
%            El primer valor corresponde al inicio de la se�al (n=0).

periodo=0;              % Inicializa el per�odo como 0 (por defecto: no peri�dica)
NF=[];                  % Inicializa el vector que contendr� un ciclo de la se�al
error= 1e-10;           % Tolerancia para comparar valores (evita errores num�ricos)
N=length(x);            % N�mero total de muestras en la se�al
M=(N/2);                % L�mite superior para buscar el per�odo (no puede ser mayor que N/2)

for p=(1:M);            % Recorre posibles valores de per�odo p, desde 1 hasta M
    n=1;                % Reinicia el �ndice n en cada intento de per�odo
    while n<N-p         % Mientras no se haya alcanzado el final de la se�al desplazada
        if abs(x(n)-x(n+p))<= error  % Compara el valor actual con el desplazado p muestras
            n=n+1;      % Si son iguales (dentro del error), avanza al siguiente �ndice
        else
            n=N;        % Si no coinciden, fuerza la salida del bucle while
        end
        
        if n==N-p       % Si se lleg� al final verificando coincidencia en todo el rango
            periodo=p;  % Se encontr� un per�odo v�lido
            NF=x(n:n+p-1); % Extrae el segmento correspondiente a un ciclo de la se�al
            return      % Termina la funci�n y devuelve resultados
        end
    end
end

