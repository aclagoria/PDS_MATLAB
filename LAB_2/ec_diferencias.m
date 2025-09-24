function y = ec_diferencias(x, A, B)
% apply_custom_iir Aplica la ecuacion en diferencia de orden N.
%   x : vector columna (o fila) de la señal de entrada
%   A : vector [A0 A1 ... AN] (1 x (N+1)) o ((N+1) x 1)
%   B : vector [B1 B2 ... BN] (1 x N) or (N x 1)
%   y : salida (mismo tamaño que x)
%
% Nota: la ecuacion asume y[n] = sum(Ak * x[n-k]) - sum(Bk * y[n-k]).
%       La función maneja condiciones iniciales en cero.

    x = x(:);              % columna
    A = A(:).';            % fila
    B = B(:).';            % fila
    N_A = length(A)-1;     % N
    N_B = length(B);       % podría ser igual a N_A
    N = max(N_A, N_B);     % orden efectivo
    L = length(x);
    y = zeros(L,1);

    % pad x with zeros for negative indexes
    xpad = [zeros(N,1); x];
    ypad = zeros(N,1);

    for n = 1:L
        % indices en xpad: current sample corresponde a index n+N
        xn_index = n + N;
        % suma de A_k * x[n-k]
        accx = 0;
        for k = 0:N_A
            accx = accx + A(k+1) * xpad(xn_index - k);
        end
        % suma de B_k * y[n-k]
        accy = 0;
        for k = 1:N_B
            if (n-k) <= 0
                y_prev = 0;
            else
                y_prev = y(n-k);
            end
            accy = accy + B(k) * y_prev;
        end
        y(n) = accx - accy;
    end
end
