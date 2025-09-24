function y = aplicar_ecuacion_diferencias(x, A, B)
    % x: señal de entrada (vector columna o fila)
    % A: coeficientes [A0 A1 ... AN]
    % B: coeficientes [B1 B2 ... BN]
    %
    % Implementa y[n] = sum(Ak * x[n-k]) - sum(Bk * y[n-k])

    x = x(:);                % asegurar columna
    na = length(A);     % orden por coeficientes A
    nb = length(B);         % orden por coeficientes B
    L = length(x);           % longitud señal

    y = zeros(L,1);          % inicializar salida

    for n = 1:L
        % parte de la entrada (x)
        accX = 0;
        for k = 0:nb
            if (n-k+1) > 0
                accX = accX + B(k) * x(n-k+1);
            end
        end

        % parte de la retroalimentación (y)
        accY = 0;
        for k = 2:na
            if (n-k+1) > 0
                accY = accY + A(k) * y(n-k+1);
            end
        end

        % resultado
        y(n) = accX - accY/A(1);
    end
end
