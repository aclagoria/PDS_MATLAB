

% load('senal.mat');        % Debe contener x
% load('coeficientes.mat'); % Debe contener A y B

function y = aplicar_filtro(x, A, B)
    % x: señal de entrada
    % A: coeficientes del numerador (A0, A1, ..., AN)
    % B: coeficientes del denominador (B0,B1, B2, ..., BN)
    
    N = length(A) - 1;         % Orden del filtro
    L = length(x);             % Longitud de la señal
    y = zeros(1, L);           % Inicializar salida

    for n = 1:L
        sumaA = 0;
        sumaB = 0;

        % Parte del numerador (A)
        for k = 0:N
            if (n - k) >= 1
                sumaA = sumaA + A(k + 1) * x(n - k);
            end
        end

        % Parte del denominador (B)
        for k = 1:N
            if (n - k) >= 1
                sumaB = sumaB + B(k) * y(n - k);
            end
        end

        y(n) = sumaA - sumaB;
    end
end