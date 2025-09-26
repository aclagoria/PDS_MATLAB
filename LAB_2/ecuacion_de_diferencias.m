function [ y ] = ecuacion_de_diferencias( x, A, B )
%función que implementa la ecuación de diferencias
% y[n]=(a0 x[n]+a1 x[n-1]+...+ak x[n-k]-b1 y[n-1]-b2 y[n-2]-...-bk y[n-k])/b0
% x: señal de entrada
% A: coeficientes del numerador
% B: coeficientes del denominador
% y: señal de salida
%   Detailed explanation goes here
N=length(x);
y=zeros(N,1);
K=length(A);

for n = 1:N
    suma_A=0;
    suma_B=0;
    for k = 1:K
        if (n-(k-1)) > 0
            suma_A = suma_A + A(k)*x(n-(k-1));
        end
    end
    
    for k = 2:K
        if (n-(k-1)) > 0
            suma_B = suma_B + B(k)*y(n-(k-1));
        end
    end
    y(n)=(suma_A-suma_B)/B(1);

            
end

