function [ y ] = filtro(x,A,B)
% x: señal de entrada
    % A: coeficientes del numerador (A0, A1, ..., AN)
    % B: coeficientes del denominador (B1, B2, ..., BN)
    
    N = length(A) - 1;  % Orden del filtro
    L= length(x);
    y = zeros(size(x)); % Inicializar salida

    for n = 1:L
        % Parte del numerador (con coeficientes A)
        for k = 0:N
            if n-k > 0
                y(n) = y(n) + A(k+1) * x(n-k);
            end
        end

        % Parte del denominador (con coeficientes B)
        for k = 1:N
            if n-k > 0
                y(n) = y(n) - B(k) * y(n-k);
            end
        end
    end

end

