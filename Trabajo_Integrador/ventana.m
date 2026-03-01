close all
clear all

Hz_chan = [1 0 0.9];
% Respuesta al impulso ideal (IIR)
N_ideal = 200;
h_ideal = impz(1, Hz_chan, N_ideal);
n_ideal = 0: length(h_ideal)-1;

% Método por ventana
M = 128; % Orden del filtro FIR

h_trunc = impz(1, Hz_chan, M+1);

win = rectwin(M+1);

h_window = h_trunc .* win;
%n_window = 0: length(h_window)-1;

win1 = triang(M+1);
h_window1 = h_trunc .* win1;

win2 = hann(M+1);
h_window2 = h_trunc .* win2;

win3 = hamming(M+1); 
h_window3 = h_trunc .* win1;

win4 = blackman(M+1);
h_window4 = h_trunc .* win1;

% Respuesta original vs Aproximaciones
[H_orig, w] = freqz(1,Hz_chan, 512);
H_win = freqz(h_window, 1, 512);
H_win1 = freqz(h_window1, 1, 512);
H_win2 = freqz(h_window2, 1, 512);
H_win3 = freqz(h_window3, 1, 512);
H_win4 = freqz(h_window4, 1, 512);

figure;% grafica 3
plot(w/pi, abs(H_orig), 'k--', 'LineWidth', 2); hold on;
plot(w/pi, abs(H_win), 'r','LineWidth',1);
plot(w/pi, abs(H_win1),'c','LineWidth',1);
plot(w/pi, abs(H_win2), 'm','LineWidth',1);
plot(w/pi, abs(H_win3), 'b','LineWidth',1);
plot(w/pi, abs(H_win4), 'g','LineWidth',1);
legend('Ideal (IIR)', 'Rectangular','Triangular', 'Hann', 'Hamming','Blackman');
grid on;


    figure('Name', 'Comparación Completa: Magnitud y Fase');
    subplot(2,1,1); 
    plot(w/pi, 20*log10(abs(H_orig)), 'k--', 'LineWidth', 2); hold on;
    plot(w/pi, 20*log10(abs(H_win)), 'r', 'LineWidth', 1);
    plot(w/pi, 20*log10(abs(H_win1)),'c','LineWidth',1);
    plot(w/pi, 20*log10(abs(H_win2)), 'm','LineWidth',1);
    plot(w/pi, 20*log10(abs(H_win3)), 'b','LineWidth',1);
    plot(w/pi, 20*log10(abs(H_win4)), 'g','LineWidth',1);
    grid on;
    title('Respuesta en Magnitud');
    ylabel('Magnitud (dB)');
    legend('Ideal (IIR)', 'Rectangular','Triangular', 'Hann', 'Hamming','Blackman');


    subplot(2,1,2); % 
    % angle() da radianes, multiplicamos por 180/pi para grados
    plot(w/pi, unwrap(angle(H_orig))*180/pi, 'k--', 'LineWidth', 2); hold on;
    plot(w/pi, unwrap(angle(H_win))*180/pi, 'r', 'LineWidth', 1.5);
    plot(w/pi, unwrap(angle(H_win1))*180/pi, 'c', 'LineWidth', 1.5);
    plot(w/pi, unwrap(angle(H_win2))*180/pi, 'm', 'LineWidth', 1.5);
    plot(w/pi, unwrap(angle(H_win3))*180/pi, 'b', 'LineWidth', 1.5);
    plot(w/pi, unwrap(angle(H_win4))*180/pi, 'g', 'LineWidth', 1.5);
    grid on;
    title('Respuesta de Fase');
    ylabel('Fase (grados)');
    xlabel('Frecuencia Normalizada (\times\pi rad/muestra)');
    
    
    figure('Name', 'Comparación Completa: Magnitud y Fase');
    subplot(2,1,1); 
    plot(w/pi, 20*log10(abs(H_orig)), 'k--', 'LineWidth', 2); hold on;
    plot(w/pi, 20*log10(abs(H_win)), 'r', 'LineWidth', 1);
    plot(w/pi, 20*log10(abs(H_win1)),'c','LineWidth',1);
    grid on;
    title('Respuesta en Magnitud');
    ylabel('Magnitud (dB)');
    legend('Ideal (IIR)', 'Rectangular','Triangular');%, 'Hann', 'Hamming','Blackman');


    subplot(2,1,2); % 
    % angle() da radianes, multiplicamos por 180/pi para grados
    plot(w/pi, unwrap(angle(H_orig))*180/pi, 'k--', 'LineWidth', 2); hold on;
    plot(w/pi, unwrap(angle(H_win))*180/pi, 'r', 'LineWidth', 1.5);
    plot(w/pi, unwrap(angle(H_win1))*180/pi, 'c', 'LineWidth', 1.5);
    grid on;
    title('Respuesta de Fase');
    ylabel('Fase (grados)');
    xlabel('Frecuencia Normalizada (\times\pi rad/muestra)');

    figure('Name', 'Comparación Completa: Magnitud y Fase');
    subplot(2,1,1); 
    plot(w/pi, 20*log10(abs(H_orig)), 'k--', 'LineWidth', 2); hold on;
    plot(w/pi, 20*log10(abs(H_win)), 'r', 'LineWidth', 1);
    plot(w/pi, 20*log10(abs(H_win2)), 'm','LineWidth',1);
    grid on;
    title('Respuesta en Magnitud');
    ylabel('Magnitud (dB)');
    legend('Ideal (IIR)', 'Rectangular','Hann');%, 'Hamming','Blackman');


    subplot(2,1,2); % 
    % angle() da radianes, multiplicamos por 180/pi para grados
    plot(w/pi, unwrap(angle(H_orig))*180/pi, 'k--', 'LineWidth', 2); hold on;
    plot(w/pi, unwrap(angle(H_win))*180/pi, 'r', 'LineWidth', 1.5);
    plot(w/pi, unwrap(angle(H_win2))*180/pi, 'm', 'LineWidth', 1.5);
    grid on;
    title('Respuesta de Fase');
    ylabel('Fase (grados)');
    xlabel('Frecuencia Normalizada (\times\pi rad/muestra)');

    figure('Name', 'Comparación Completa: Magnitud y Fase');
    subplot(2,1,1); 
    plot(w/pi, 20*log10(abs(H_orig)), 'k--', 'LineWidth', 2); hold on;
    plot(w/pi, 20*log10(abs(H_win)), 'r', 'LineWidth', 1);
    plot(w/pi, 20*log10(abs(H_win3)), 'b','LineWidth',1);
    grid on;
    title('Respuesta en Magnitud');
    ylabel('Magnitud (dB)');
    legend('Ideal (IIR)', 'Rectangular', 'Hamming');%,'Blackman');


    subplot(2,1,2); % 
    % angle() da radianes, multiplicamos por 180/pi para grados
    plot(w/pi, unwrap(angle(H_orig))*180/pi, 'k--', 'LineWidth', 2); hold on;
    plot(w/pi, unwrap(angle(H_win))*180/pi, 'r', 'LineWidth', 1.5);
    plot(w/pi, unwrap(angle(H_win3))*180/pi, 'b', 'LineWidth', 1.5);
    grid on;
    title('Respuesta de Fase');
    ylabel('Fase (grados)');
    xlabel('Frecuencia Normalizada (\times\pi rad/muestra)');

figure('Name', 'Comparación Completa: Magnitud y Fase');
    subplot(2,1,1); 
    plot(w/pi, 20*log10(abs(H_orig)), 'k--', 'LineWidth', 2); hold on;
    plot(w/pi, 20*log10(abs(H_win)), 'r', 'LineWidth', 1);
    plot(w/pi, 20*log10(abs(H_win4)), 'g','LineWidth',1);
    grid on;
    title('Respuesta en Magnitud');
    ylabel('Magnitud (dB)');
    legend('Ideal (IIR)', 'Rectangular','Blackman');


    subplot(2,1,2); % 
    % angle() da radianes, multiplicamos por 180/pi para grados
    plot(w/pi, unwrap(angle(H_orig))*180/pi, 'k--', 'LineWidth', 2); hold on;
    plot(w/pi, unwrap(angle(H_win))*180/pi, 'r', 'LineWidth', 1.5);
    plot(w/pi, unwrap(angle(H_win4))*180/pi, 'g', 'LineWidth', 1.5);
    grid on;
    title('Respuesta de Fase');
    ylabel('Fase (grados)');
    xlabel('Frecuencia Normalizada (\times\pi rad/muestra)');
    
