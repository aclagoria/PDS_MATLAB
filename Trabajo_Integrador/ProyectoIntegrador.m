clear all;
close all;
%% Actividad 1 - Preparar la señal digital a transmitir
% • Se toman 80 muestras de cada una de las 4 señales de voz adquiridas en 
%   la Práctica de Laboratorio N°2, fs=8 kHz, resolución de 12 bits. 
%   Se deben tomar segmentos en los que haya actividad de voz.
% • Cada símbolo transmitido consistirá en 48 bits, resultantes de tomar 
%   una muestra de cada una de las señales de voz.
% • Se divide cada símbolo (conversor serie a paralelo) en doce grupos de 
%   4 bits cada uno.

%--------------------------------Desarrollo--------------------------------

%       Generación de audios de 1 segundo a partir de tiempos en los que
%       sabemos que hay actividad de voz. 
[ch1, Fs1]= partir_audio('fati_Fs8k_12bit.wav',1,1.22);

[ch2, Fs2]= partir_audio('fati_Fs8k_12bit.wav',1,2.9);

[ch3, Fs3]= partir_audio('caro_Fs8k_12bit.wav',1,1.2);

[ch4, Fs4]= partir_audio('caro_Fs8k_12bit.wav',1,2.65);
%       Esta partición nos da 8001 muestras de cada audio entonces los
%       limitamos a solo las 80 primeras
L = 80;

%       Generacion del símbolo
muestras_totales = zeros(L,4); % para ver todas las muestras juntas
CH = 4;
K=12;
grupos_bit = cell(L,12); % cada fila corresponde a un símbolo y cada 
                         % columna es un grupo 4 bit de la muestra
a_k = zeros(L,12);   % fila -> símolo 
                     % columna-> valor en fase de cada grupo de 4 bit
b_k = zeros(L,12);   % columna-> valor en cuadratura de cada grupo de 4 bit
IyQ= zeros(L,12);  %

for l = 1:L
    muestras_actuales = [ch1(l), ch2(l), ch3(l), ch4(l)];
    muestras_totales(l,:)= muestras_actuales;
    for ch = 1:CH
        bin12 = convertir_muestra16a12bin(muestras_actuales(ch));
        g4bit_ch = [grupo_4bit(bin12)];
        grupos_bit(l,((ch-1)*3+1):((ch-1)*3+3))= g4bit_ch;
    end 
    [a_k(l,:),b_k(l,:)] = mapeo_16QAM(grupos_bit(l,:));
    IyQ(l,:) = a_k(l,:)+ 1j*b_k(l,:);
end
conj_IyQ=conj(IyQ);
espejo=conj_IyQ(:, end:-1:1);

%% Actividad 2 – Generar la señal modulada en Frecuencia Intermedia utilizando la IFFT         
%
% • Para la señal modulada en Frecuencia Intermedia se utiliza una 
%   frecuencia de muestreo fs=4,8 kHz
% • Por la eficiencia de la IFFT se toman 16 canales, para cada símbolo se 
%   obtienen 32 muestras de la señal en el tiempo. A los canales no 
%   utilizados se asignan valores nulos.
% • Justificar que no se puede usar el primer canal.
% • Se utiliza la misma constelación usada en la Práctica de Laboratorio 
%   N°4 para la modulación QAM de cada canal.
% • En la señal modulada en Frecuencia Intermedia, al primer canal le 
%  corresponde la frecuencia de 300 Hz. Los canales están separados 150 Hz.
% • Graficar la señal correspondiente a los primeros cuatro símbolos.
% • Utilizando la FFT graficar el espectro de la señal correspondiente a 
%   los 80 símbolos.

%--------------------------------Desarrollo--------------------------------

fs= 4.8e3;
delta_f = 150;
Tsym=1/delta_f;
N=round(Tsym * fs); % 32

X=zeros(L,N);
x=zeros(L,N);
for l=1 : L
    X(l,3:14) = IyQ(l,:);
    X(l,20:31)= espejo(l,:);
    x(l,:)= N* ifft(X(l,:))/2;
end
x = x';
x = x(:);

% Para graficar la señal correxpondiente a los primero 4 símbolos debemos
% tomar los primeros 4*N elementos de x_1
e =(0:4*N-1);
x_4simb=x(1:4*N);

figure;
stem (e,x_4simb, 'fill', 'Color', 'b','LineWidth',0.5 );   % grosor
xlabel('numero de muesta de s');
ylabel('Amplitud');
title('Señal de los primeros 4 símbolos');
set(gca, 'XTick', 0:32:128); 
grid on;

% Gráfica del espectro de la señal correspondiente a los 80 símbolos
Nfft = length(x);  

X = fft(x, Nfft);   % Transformada de Fourier

X_norm= X/Nfft;     % Transformada de Fourier normalizada

f = (0:Nfft-1)*(fs/Nfft)/1e3; % Vector de frecuencias (en kHz)

X_dB = 20*log10(abs(X));% Magnitud en dB

figure;
plot(f, X_dB, 'LineWidth', 1, 'Color', 'b');
xlabel('Frecuencia [kHz]');
ylabel('Magnitud [dB]');
title('Espectro de la señal OFDM');
xlim([-0.150 4.95]);
set(gca, 'XTick', 0:0.15*2:4.8); 
set(gca, 'YTick', -80:20:80); 
set(gca, 'LineWidth', 1, 'FontSize', 9);
grid on;


figure;
stem(f, abs(X_norm));
title('Espectro de la señal');
xlabel('Frecuencia [kHz]');
ylabel('Magnitud en veces');
grid on;


%% Actividad 3 – Obtener la señal modulada en la frecuencia portadora
%
% • El traslado en frecuencia y el filtrado posterior de la señal para 
%   eliminar la banda lateral inferior es realizada por un sistema analógico.
% • A la salida del Conversor Digital Analógico se aplica un filtro 
%   analógico pasa bajos, obteniéndose la señal x(t).
% • El traslado en frecuencia se hace utilizando un oscilador local de 
%   frecuencia f0=38,4 kHz. s(t)=x(t)cos(2pi*f0*t)
% • El filtro pasa banda que elimina la banda lateral inferior también debe
%   adecuar la señal al espectro asignado, que va de 38,4 kHz a 40,65 kHz
% • La señal recibida por el receptor es afectada por el canal de 
%   transmisión, al que se asigna un sistema equivalente con la función de 
%   transferencia H(z)=1+0,9z^?2, correspondiente a la frecuencia de muestreo 
%   fs=153,6 kHz.
% • Simular el sistema analógico, implementando el filtro pasa bajos, el 
%   traslado en frecuencia y el filtro pasa banda y el canal de transmisión 
%   con una frecuencia de muestreo fs=153,6 kHz.
% • Graficar el espectro de la señal, utilizando la FFT, en cada una de las
%   etapas.
% • Justificar si se puede evitar el filtro pasa bajos.


%--------------------------------Desarrollo--------------------------------

% Para simular el CDA aumentamos la frecuencia de muestreo (sobremuestrear)

fs_rf = 153.6e3; % frecuencia de muestreo de señal de RF
    factor=fs_rf/fs; % factor  de remuestreo
    x1=zeros(factor*length(x),1);
    for n=1 : length(x)
        for i=1: factor
            x1(((n-1)*factor+1):factor*n)=x(n);
        end
    end

    m=(0: length(x)-1);
    m1=(0: length(x1)-1);

    % Gráfica de la señal del primer símbolo
    figure;
    subplot(2,1,1);
    stem(m, x);  
    xlabel('numero de muesta de x');
    ylabel('Amplitud');
    title('Señal del primer símbolo fs=4,8kHz');
    xlim([0 N]);
    grid on;

    subplot(2,1,2);
    stem(m1, x1);
    xlabel('numero de muesta de x1');
    ylabel('Amplitud');
    title('Señal del primer símbolo fs=153,6kHz');
    xlim([0 N*N]);
    set(gca, 'XTick', 0:32:3*N); 
    grid on;

    % Gráfica de espectro antes del filtro pasa bajo 
    Nfft1 = length(x1);  

    X1 = fft(x1, Nfft1);   % Transformada de Fourier

    X1_norm= X1/Nfft1;     % Transformada de Fourier normalizada

    f1 = (0:Nfft1-1)*(fs_rf/Nfft1)/1e3; % Vector de frecuencias (en kHz)

    X1_dB = 20*log10(abs(X1));% Magnitud en dB


    figure;
    plot(f1, X1_dB, 'LineWidth', 1, 'Color', 'b');
    xlabel('Frecuencia [kHz]');
    ylabel('Magnitud [dB]');
    title('Espectro x1 ');
    set(gca, 'XTick', 0:4.8:3*4.8); 
    grid on;

    figure;
    stem(f1, abs(X1_norm));
    title('Espectro de la señal x1');
    xlabel('Frecuencia [kHz]');
    ylabel('Magnitud en veces');
    grid on;

% Diseño de filtro pasa bajo

    % Diseño de filtro analógico pasa bajo de manera manual
    fp=2.4e3;
    fb=2.85e3;
    Ap=1.5; % Como luego debe filtrarce con un pasa banda se elige una  
        	% atenuación de 1.5 dB, proyectando que entre los dos filtros
			% haya una atenuacion total de 3dB en la banda de interés. 
         
    Ab=30;
    
    [b_a, a_a, N_lp] =lowpass_analogico_manual(fp, fb, Ap, Ab);
	N_lp
    
    % Como el orden del filtro pasa bajo diseñado es muy alto (N_lp = 23)y
    % dado que posteriormente se va a utilizar un filtro pasa banda, este
    % filtro puede no usarse.

x1_filt = x1;

% Traslado en frecuencia
f0 = 38.4e3;   % frecuencia del oscilador local

    I = length(x1_filt);
    s = zeros(size(x1_filt));
    block = 1e6; % procesa de a un millón de muestras (ajustá si hace falta)

    for i = 1:block:I
        idx = i:min(i+block-1, I);
        t_blk = (idx-1)'/fs_rf;  % <-- transpuesta: vector columna
        s(idx) = 2 .* x1_filt(idx) .* cos(2*pi*f0*t_blk);
    end
    % Lo anterior se hizo en vez de :
    % t=(0:length(x1_filter)-1)/fs_rf;
    % s = 2 .* x1_filt .* cos(2*pi*f0*t);
    % Porque al ejecutar aparecía un ERROR debido a que intenta multiplicar
    % dos vectores gigantescos:x1_filt (que ya tiene millones de muestras) 
    % y cos(2*pi*f0*t)(que MATLAB genera del mismo tamaño).
    
    % Gráficas de espectros de señal trasladada
    Nfft_s = length(s);
    S = fft(s, Nfft_s);   % Transformada de Fourier
    S_norm= S/Nfft_s;     % Transformada de Fourier normalizada
    f = (0:Nfft_s-1)*(fs_rf/Nfft_s)/1e3; % Vector de frecuencias (en kHz)
    S_dB = 20*log10(abs(S));% Magnitud en dB

    figure;
    plot(f, S_dB, 'LineWidth', 1, 'Color', 'b');
    xlabel('Frecuencia [kHz]');
    ylabel('Magnitud [dB]');
    title('Espectro s ');
    xlim([25 125]);
    set(gca, 'XTick', 38.4:2.25:40.65); 
    grid on;

    figure;
    stem(f, abs(S_norm));
    title('Espectro de la señal s');
    xlabel('Frecuencia [kHz]');
    ylabel('Magnitud en veces');
    grid on;

% Diseño de filtro pasa banda
    % Diseño de filtro analógico pasa banda de manera manual
    % Como no se utiliza el filtro pasa bajo, para que el orden del pasa 
    % banda no sea alto (un número aceptable es de hasta 16) la atenuacion 
    % en la banda de paso la tomamos como máxima de 3dB.          
    fp1 = 38.7e3;    fp2 = 40.35e3;     Ap = 3;    % frecuencias de paso   
    fs1 = 38.4e3;   fs2 = 40.65e3;     As = 30;   % frecuencias de rechazo
          
    [b_a_bp, a_a_bp,N_bp,f0_bp] = bandpass_analogico_manual( fs1,fp1, fp2, fs2,  Ap, As);
    N_bp
	% El orden nos da de 23, lo que no es aceptable. Entonces ajustamos
    % las frecuencias de rechazo alejandolas de la banda pasante
    fs1 = 37.95e3;   fs2 = 41.25e3;  
    [b_a_bp, a_a_bp,N_bp,f0_bp] = bandpass_analogico_manual( fs1,fp1, fp2, fs2,  Ap, As);
    N_bp
	% El orden que nos da ahora es de 12, lo que ya es aceptable.
    
    % Filtro digital a partir de filto analogico con respuesta invariante
    % al impulso
    [b_d_bp, a_d_bp] = impinvar(b_a_bp, a_a_bp, fs_rf);

    s_filt = filter(b_d_bp, a_d_bp, s); % filtrado de señal

    % Gráficas de espectros de señal filtrada con el pasa banda digital
    Nfft_s_filt = length(s_filt);
    S_filt = fft(s_filt, Nfft_s_filt)/Nfft_s_filt; % normalizado
    f = (0:Nfft_s_filt-1)*(fs_rf/Nfft_s_filt)/1e3; % en kHz
    figure;
    plot(f, abs(S_filt));
    xlabel('Frecuencia [kHz]');
    ylabel('Magnitud en veces');
    title('Espectro señal filtrada FBP');
    grid on; set(gca, 'XTick', 38.4:2.25:40.65);

    figure;
    plot(f, 20*log10(abs(S_filt)));
    xlabel('Frecuencia [kHz]');
    ylabel('Magnitud [dB]');
    title('Espectro señal filtrada FBP');
    grid on; set(gca, 'XTick', 38.4:2.25:40.65);
    grid on; set(gca, 'YTick', -12:3:0);

    % Gráficas respuesta en frecuencia: FBP Analógico Vs FBP Digital 
    % gráfica opcional
    [Ha_bp, wa_bp] = freqs(b_a_bp, a_a_bp, 100*1024); % Dominio s, 102400 
                                                  % puntos,wa_bp=2*pi*fa_bp
    figure;
    subplot(2,1,1);
    plot(wa_bp/(2*pi*1e3), 20*log10(abs(Ha_bp)));
    xlabel('Frecuencia [kHz]'); ylabel('Magnitud [dB]');
    title('Filtro analógico  Pasa Banda Butterworth');
    grid on; 
    xlim([37.35 41.7]);  
    ylim([-6 1]); 
    set(gca, 'XTick', (38.4-0.3):0.15*2:(41.25)); 

    [Hd_bp, fd_bp] = freqz(b_d_bp, a_d_bp, 10*1024, fs_rf); % Dominio z
    subplot(2,1,2);
    plot(fd_bp/1e3, 20*log10(abs(Hd_bp)));
    xlabel('Frecuencia [kHz]'); ylabel('Magnitud [dB]');
    title('Filtro digital Pasa Banda equivalente (impinvar)');
    grid on;
    xlim([37.35 41.7]);  
    ylim([-6 1]); 
    set(gca, 'XTick', (38.4-0.3):0.15*2:(41.25)); 
    
    figure;
    subplot(2,1,1);
    plot(wa_bp/(2*pi*1e3), unwrap(angle(Ha_bp))*180/pi);
    xlabel('Frecuencia [Hz]');
    ylabel('Fase [°]');
    title('Filtro analógico  Pasa Banda Butterworth');
    grid on;
    xlim([37.35 41.7]);
    set(gca, 'XTick', (38.4-0.3):0.15*2:(41.25));
    
    subplot(2,1,2);
    plot(fd_bp/1e3, unwrap(angle(Hd_bp))*180/pi);
    xlabel('Frecuencia [Hz]');
    ylabel('Fase [°]');
    title('Filtro digital Pasa Banda equivalente (impinvar)');
    grid on;
    xlim([37.35 41.7]);
    set(gca, 'XTick', (38.4-0.3):0.15*2:(41.25));
    
    
    % Gráficas conjuntas
    figure;
    plot(wa_bp/(2*pi*1e3), 20*log10(abs(Ha_bp))); hold on;
    plot(fd_bp/1e3, 20*log10(abs(Hd_bp)),'r--', 'LineWidth', 1);
    xlabel('Frecuencia [kHz]'); ylabel('Magnitud [dB]');
    title('Filtro analógico Butterworth diseño manual Vs Filtro digital Pasa Banda equivalente');
    grid on; 
    xlim([(f0_bp*9.6/10)/1e3 (f0_bp*10.4/10)/1e3]); ylim([-6 1]); set(gca, 'XTick', 38.7:(40.35-38.7):40.35);
    legend('Filtro analogico', 'Filtro digital');
    
    figure;
    plot(wa_bp/(2*pi*1e3), unwrap(angle(Ha_bp))*180/pi,'LineWidth', 1); hold on;
    plot(fd_bp/1e3, unwrap(angle(Hd_bp))*180/pi, 'r--', 'LineWidth', 1);
    xlabel('Frecuencia [Hz]');
    ylabel('Fase [°]');
    title('Filtro analógico Butterworth diseño manual Vs Filtro digital Pasa Banda equivalente');
    grid on;
    xlim([(f0_bp*7/10)/1e3 (f0_bp*12/10)/1e3]);
    set(gca, 'XTick', 38.7:(40.35-38.7):40.35);
    legend('Filtro analogico', 'Filtro digital');
	
	figure;
zplane(b_d_bp, a_d_bp);
title('Polos y ceros del filtro pasa banda');

% Canal de transmisión --> función de transferencia H(z)=1+0,9z^2,
% correspondiente a la frecuencia de muestreo fs=153,6 kHz.

    % Coeficientes del canal
    Hz_chan = [1 0 0.9];  % 
    s_rx = filter(Hz_chan, 1, s_filt); % filtrar la señal por el canal
    
    figure;
    zplane(Hz_chan, 1);
    title('Polos y ceros del canal');
    
    % Gráficas de espectro de la señal recibida
    Nfft_rx = length(s_rx);
    S_rx = fft(s_rx, Nfft_rx)/Nfft_rx;  % FFT normalizada
    f = (0:Nfft_rx-1)*(fs_rf/Nfft_rx)/1e3;  % vector de frecuencia en kHz

    figure;
    plot(f, abs(S_rx));
    xlabel('Frecuencia [kHz]');
    ylabel('Magnitud en veces');
    title('Espectro señal salida del canal s_r_x');
    grid on; 
    xlim([37 42]);
    set(gca, 'XTick', 38.4:0.15*2:40.65);

    figure;
    plot(f, 20*log10(abs(S_rx)));
    xlabel('Frecuencia [kHz]');
    ylabel('Magnitud [dB]');
    title('Espectro señal salida del canal s_r_x');
    grid on; 
    xlim([37 42]);
    set(gca, 'XTick', 38.4:0.15*2:40.65);   


%% Actividad 4 – Implementar la ecualización de la señal en la frecuencia 
% portadora
% • Conociendo la función de transferencia de los sistemas desde el CDA 
%   hasta el receptor, diseñar un ecualizador con un filtro FIR que tenga 
%   como respuesta al impulso la respuesta al impulso limitada en el tiempo
%   del sistema que hace el filtrado inverso.
% • Justificar si se debe aplicar una ventana que no sea rectangular para 
%   recortar la respuesta al impulso en el tiempo.
% • En la señal correspondiente a cada símbolo implementar el filtro 
%   ecualizador FIR utilizando la FFT.
% • Utilizando la FFT, graficar el espectro de la señal de salida.
% • Justificar que se puede demodular la señal en la implementación 
%   del filtro FIR.

%--------------------------------Desarrollo--------------------------------
% Buscamos la función de transferencia total del sistema de la actividad 
% anterior H_total = H_bp * H_ch , como punto de partida para diseñar el
% ecualizador, este busca compensar las distorsiones aplicando un sistema
% inverso H_eq * H_total = 1
% Como el filtro pasa banda presenta ceros fuera del círculo unitario si lo
% invertimos directamente se genera inestabilidad, el inverso de un cero
% fuera del círculo es un polo fuera del círculo. Entonces se opta por
% hacer el diseño para compensar solamente la distorsión que provoca el
% canal de transmisión.

[H_ch_f, f_H] = freqz(Hz_chan, 1, 1024, fs_rf);       % Canal

% Gráfica 
figure;
plot(f_H/1e3, 20*log10(abs(H_ch_f)));
title('Respuesta en frecuencia del canal');
xlabel('Frecuencia [kHz]');
ylabel('Magnitud [dB]');

    % Diseño del filtro FIR
    % Respuesta al impulso ideal (IIR)
    N_ideal = 200;
    h_ideal = impz(1, Hz_chan, N_ideal);
    n_ideal = 0: length(h_ideal)-1;

    % Método por muestreo de frecuencia
    M1 = 25; % 
    [H_inv_f, w_inv] =freqz(1, Hz_chan, M1);%, fs_rf);
    recorte=H_inv_f(2:end);
    H_inv_f_conj= conj(recorte);
    H_inv_f_conj_espejo=H_inv_f_conj( end:-1:1,:); % Espejo

    H_muestreo =[H_inv_f;0.5263;H_inv_f_conj_espejo]; % La ifft trabaja sobre
                                   % secuencias periódicas reales si 
                                   % H_inverso no es simetrico conjugado 
                                   % respecto de 0 y Nyquist, su ifft da 
                                   % una señal compleja en el tiempo, que 
                                   % no representa una respuesta física 
                                   % real, por ello se construye H_inverso 
                                   % concatenando el vector inverso y su 
                                   % conjugado en espejo.

    h_muestreo = ifft(H_muestreo);
    n_muestreo = 0: length(h_muestreo)-1;
    ordenFIR1 = length(h_muestreo)-1;

    
    M2 = 50; % doble de la frecuencia anterior
    [H_inv_f2, w_inv2] =freqz(1, Hz_chan, M2);%, fs_rf);
    recorte2=H_inv_f2(2:end);
    H_inv_f_conj2= conj(recorte2);
    H_inv_f_conj_espejo2=H_inv_f_conj2( end:-1:1,:); % Espejo

    H_muestreo2 =[H_inv_f2;0.5263;H_inv_f_conj_espejo2]; 
    h_muestreo2 = ifft(H_muestreo2);
    n_muestreo2 = 0: length(h_muestreo2)-1;
    ordenFIR2 = length(h_muestreo2)-1;

    % Método por ventana
    M3 = 49; % Orden del filtro FIR

    h_trunc = impz(1, Hz_chan, M3+1);

    win = rectwin(M3+1);

    h_window = h_trunc .* win;
    n_window = 0: length(h_window)-1;


    figure;% 
    stem(n_ideal, h_ideal, 'k--','LineWidth', 1.5); hold on;
    stem(n_window, h_window,'b');
    stem(n_muestreo, h_muestreo, 'r');
    title('Comparación de respuesta al impulso');
    xlabel('Muestra');
    ylabel('Amplitud');
    legend('Ideal (IIR)', 'Ventana', 'Muestreo Frec.');



    M4 = 99; % Orden del filtro FIR

    h_trunc2 = impz(1, Hz_chan, M4+1);

    win2 = rectwin(M4+1);

    h_window2 = h_trunc2 .* win2;


    % Respuesta original vs Aproximaciones
    [H_orig, w] = freqz(1,Hz_chan, 512);
    H_win = freqz(h_window, 1, 512);
    H_win2 = freqz(h_window2, 1, 512);
    H_muesfrec = freqz(h_muestreo, 1, 512);
    H_muesfrec2 = freqz(h_muestreo2, 1, 512);

    figure; 
    plot(w/pi, abs(H_orig), 'k--', 'LineWidth', 2); hold on;
    plot(w/pi, abs(H_win), 'r','LineWidth',1);
    plot(w/pi, abs(H_win2), 'm','LineWidth',1);
    plot(w/pi, abs(H_muesfrec), 'b','LineWidth',1);
    plot(w/pi, abs(H_muesfrec2), 'g','LineWidth',1);
    title('Comparación de Filtro IIR Original vs. Aproximaciones FIR');
    xlabel('Frecuencia Normalizada (\times\pi rad/muestra)');
    ylabel('Magnitud |H(\omega)|');
    legend('Ideal (IIR)', 'Ventana (rectangular)M=49','Ventana (rectangular)M=99', 'Muestreo Frec. 25 muestras', 'Muestreo Frec. 50 muestras');
    grid on;



    figure('Name', 'Comparación Completa: Magnitud y Fase');
    subplot(2,1,1); 
    plot(w/pi, 20*log10(abs(H_orig)), 'k--', 'LineWidth', 2); hold on;
    plot(w/pi, 20*log10(abs(H_win)), 'r', 'LineWidth', 1.2);
    plot(w/pi, 20*log10(abs(H_win2)), 'm','LineWidth',1);
    plot(w/pi, 20*log10(abs(H_muesfrec)), 'b', 'LineWidth', 1);
    plot(w/pi, 20*log10(abs(H_muesfrec2)), 'g','LineWidth',1);
    grid on;
    title('Respuesta en Magnitud');
    ylabel('Magnitud (dB)');
    legend('Ideal (IIR)', 'Ventana orden 49','Ventana orden 99', 'Muestreo Frec. 25 muestras', 'Muestreo Frec. 50 muestras');


    subplot(2,1,2); % 
    % angle() da radianes, multiplicamos por 180/pi para grados
    plot(w/pi, unwrap(angle(H_orig))*180/pi, 'k--', 'LineWidth', 2); hold on;
    plot(w/pi, unwrap(angle(H_win))*180/pi, 'r', 'LineWidth', 1.5);
    plot(w/pi, unwrap(angle(H_muesfrec))*180/pi, 'b', 'LineWidth', 1);
    grid on;
    title('Respuesta de Fase');
    ylabel('Fase (grados)');
    xlabel('Frecuencia Normalizada (\times\pi rad/muestra)');

    % Aplicación del Filtro 
        %Eleccion del metodo
%         h_eq = h_muestreo; %Eleccion del metodo
%         h_eq = h_muestreo2;
%          h_eq = h_window;
        h_eq = h_window2;
        
        figure('Name', 'Diagrama de Polos y Ceros - Ventana Rectangular');
        zplane(h_eq, 1);
        grid on;
        title('Polos y Ceros: Método de Ventana Rectangular');
        xlabel('Parte Real');
        ylabel('Parte Imaginaria');
        
      Nfft_eq = length(s_rx) + length(h_eq) - 1;  % Cuando se realiza la 
                                     % multiplicación en frecuencia con 
                                     % la fft y luego se aplica la ifft, 
                                     % lo que se obtiene es la convolución 
                                     % circular, donde la respuesta al 
                                     % impulso se superpone con el inicio 
                                     % de la secuencia y genera distorsión, 
                                     % para evitarla hay que rellenar 
                                     % con ceros a ambas secuencias a un
                                     % tamaño de por lo menos la suma de 
                                     % las longitudes de cada
                                     % una menos 1. 

    H_eq_f = fft(h_eq, Nfft_eq);     % Al aplicar la fft con un 
                                     % Nfft > tamano de h_eq se rellena 
                                     % con ceros.

    % Gráfica de respuesta en frecuencia
    f_eq =(0: length(H_eq_f)-1)*(fs_rf/Nfft_eq)/1e3;
    H_eq_f_dB = 20*log10(abs(H_eq_f));

    figure;% 
    plot(f_eq, H_eq_f_dB);%
    title('Respuesta en frecuencia del ecualizador');
    xlabel('Frecuencia [kHz]');
    ylabel('Magnitud [dB]');
    xlim([0 100]);

    S_rx_f = fft(s_rx, Nfft_eq);  

    S_eq_f = S_rx_f .* H_eq_f;  % Como S_rx_f y H_eq_f provienen de señales
                                % reales (o casi reales) su producto
                                % mantiene la simetría conjugada

    s_eq = ifft(S_eq_f); % La señal a la salida del ecualizador es real


    % FFTs para comparación
    Nfft_eval = length(s_rx);
    Sfilt_fft  = fft(s_filt, Nfft_eval) / Nfft_eval; % señal ideal           
    Srx_fft = fft(s_rx, Nfft_eval) / Nfft_eval;      % señal recibida
    Seq_fft = fft(s_eq, Nfft_eval) / Nfft_eval;      % señal ecualizada
    f_eval  = (0:Nfft_eval-1)*(fs_rf/Nfft_eval)/1e3; % vector frecuencia [kHz]

    % Magnitudes en dB
    Sfilt_dB  = 20*log10(abs(Sfilt_fft)  + eps);
    Srx_dB = 20*log10(abs(Srx_fft) + eps);
    Seq_dB = 20*log10(abs(Seq_fft) + eps);

    % Gráfica comparativa
    figure;% 
    plot(f_eval, Sfilt_dB,  'k',  'LineWidth',1.4); hold on;
    plot(f_eval, Srx_dB, 'r--','LineWidth',1.2);
    plot(f_eval, Seq_dB, 'b',  'LineWidth',1.2);
    xlabel('Frecuencia [kHz]');
    ylabel('Magnitud [dB]');
    title('Comparación de espectros: Original, Recibida y Ecualizada');
    legend('Original s_{filt} (ideal)', 'Recibida s_{rx}', 'Ecualizada s_{eq}');
    xlim([37 42]); grid on;



