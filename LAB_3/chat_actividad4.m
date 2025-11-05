% --- Cargar datos ---
load('dolarblue');        % debe cargar la variable 'valor'
N = length(valor);
n = 1:N;

% --- Filtros ---
M = 7;                                % ventana de 7 muestras
h_mean = ones(1,M)/M;                 % coeficientes del promedio móvil (FIR)
yg_mean = conv(valor, h_mean, 'same');% promedio móvil (a) - misma longitud
yg_med  = medfilt1(valor, M);         % mediana móvil (b) - ya lo tenías

% --- Gráficas de series en el tiempo ---
figure('Color',[1 1 1]);
plot(n, valor, '-','DisplayName','Original'); hold on;
plot(n, yg_mean, '-','LineWidth',1.5,'DisplayName','Promedio móvil (M=7)');
plot(n, yg_med,  '-','LineWidth',2,'DisplayName','Mediana móvil (M=7)');
xlabel('Muestra n'); ylabel('Valor (ARS)');
title('Dólar Blue: original y filtros (promedio y mediana, ventana 7)');
legend('Location','best'); grid on;
xlim([1 N]);   % o ajustar manualmente si preferís
hold off;

% --- Respuesta en frecuencia del filtro promedio móvil (c) ---
% Usamos freqz para mostrar H(e^j?)
figure('Color',[1 1 1]);
[H,w] = freqz(h_mean,1,512);   % 512 puntos de frecuencia
subplot(2,1,1);
plot(w/pi, abs(H)); xlabel('Frecuencia normalizada (\times\pi rad/muestra)');
ylabel('|H(e^{j\omega})|'); title('Magnitud de la respuesta en frecuencia (Promedio móvil)');
grid on;
subplot(2,1,2);
plot(w/pi, 20*log10(abs(H))); xlabel('Frecuencia normalizada (\times\pi rad/muestra)');
ylabel('Magnitud (dB)'); title('Respuesta en dB (Promedio móvil)');
grid on;

% --- FFTs (d) ---
% Calculamos FFT con cero padding para mejor resolución
Nfft = 2^nextpow2(N*4);  % padding para más resolución
f_axis = (0:Nfft-1)/Nfft; % frecuencia normalizada 0..1 (ciclos/muestra)

% FFTs (magnitud)
FFT_orig = fft(valor, Nfft);
FFT_mean = fft(yg_mean, Nfft);
FFT_med  = fft(yg_med, Nfft);

% Solo tomamos mitad (parte positiva) para graficar
half = 1:floor(Nfft/2);
figure('Color',[1 1 1]);
plot(f_axis(half), abs(FFT_orig(half))/N, 'DisplayName','Original'); hold on;
plot(f_axis(half), abs(FFT_mean(half))/N, 'DisplayName','Promedio móvil');
plot(f_axis(half), abs(FFT_med(half))/N,  'DisplayName','Mediana móvil');
xlabel('Frecuencia (ciclos/muestra)'); ylabel('Magnitud');
title('Espectro (magnitud) - Original y series filtradas');
legend('Location','northeast'); grid on; hold off;

% --- Análisis de energía espectral (opcional) ---
E_orig = sum(abs(FFT_orig(half)).^2);
E_mean = sum(abs(FFT_mean(half)).^2);
E_med  = sum(abs(FFT_med(half)).^2);
fprintf('Energía (mitad espectro): original=%.2e, promedio=%.2e, mediana=%.2e\n',E_orig,E_mean,E_med);

% --- Pruebas simples de Linealidad (e) ---
% Prueba de superposición para el promedio móvil (LTI esperado)
% Elegimos dos señales x1,x2 (subvectores) y comprobamos:
x1 = zeros(N,1); x2 = zeros(N,1);
x1(1:10) = valor(1:10);              % trozo de señal
x2(11:20) = valor(11:20);
y1 = conv(x1, h_mean, 'same');
y2 = conv(x2, h_mean, 'same');
y_sum = conv(x1+x2, h_mean, 'same');
if max(abs(y1 + y2 - y_sum)) < 1e-10
    disp('Promedio móvil: la prueba numérica indica que es LINEAL (dentro de tolerancia).');
else
    disp('Promedio móvil: falla la prueba numérica de linealidad.');
end

% Prueba de superposición para la mediana (esperamos falla)
y1m = medfilt1(x1, M);
y2m = medfilt1(x2, M);
y_sum_m = medfilt1(x1+x2, M);
fprintf('Max diferencia (mediana): %.3e\n', max(abs(y1m + y2m - y_sum_m)));

% Prueba de invariancia temporal: desplazar señal y comparar desplazamiento de salida
shift = 5;
orig_shifted = circshift(valor, shift);
out_orig = conv(valor, h_mean, 'same');
out_shift = conv(orig_shifted, h_mean, 'same');
% Si LTI, out_shift debe ser circshift(out_orig,shift)
fprintf('Max diferencia invariancia (promedio): %.3e\n', max(abs(circshift(out_orig,shift) - out_shift)));

out_orig_med = medfilt1(valor, M);
out_shift_med = medfilt1(orig_shifted, M);
fprintf('Max diferencia invariancia (mediana): %.3e\n', max(abs(circshift(out_orig_med,shift) - out_shift_med)));
