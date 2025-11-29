clear all
close all

% Actividad 1 - Preparar la señal digital a transmitir
% • Se toman 80 muestras de cada una de las 4 señales de voz adquiridas en 
%   la Práctica de Laboratorio N°2, fs=8 kHz, resolución de 12 bits. 
%   Se deben tomar segmentos en los que haya actividad de voz.
% • Cada símbolo transmitido consistirá en 48 bits, resultantes de tomar 
%   una muestra de cada una de las señales de voz.
% • Se divide cada símbolo (conversor serie a paralelo) en doce grupos de 
%   4 bits cada uno.
%
% --------------------- Desarrollo--------------------
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
for k=1: 13
    
end
% Actividad 2 – Generar la señal modulada en Frecuencia Intermedia          
%               utilizando la IFFT
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
x_1 = x';
x_1 = x_1(:);

% Para graficar la señal correxpondiente a los primero 4 símbolos debemos
% tomar los primeros 4*N elementos de x_1
e =(0:4*N-1);
x_2=x_1(1:4*N);

figure;
stem (e,x_2, 'fill', 'Color', 'b','LineWidth',0.5 );   % grosor
xlabel('numero de muesta de s');
ylabel('Amplitud');
title('Señal de los primeros 4 símbolos');
set(gca, 'XTick', 0:32:128); 
grid on;

% Gráfica del espectro de la señal correspondiente a los 80 símbolos
Nfft = length(x_1);  

X1 = fft(x_1, Nfft);   % Transformada de Fourier

X1_norm= X1/Nfft;     % Transformada de Fourier normalizada

f = (0:Nfft-1)*(fs/Nfft)/1e3; % Vector de frecuencias (en kHz)

X1_dB = 20*log10(abs(X1));% Magnitud en dB

figure;
plot(f, X1_dB, 'LineWidth', 1, 'Color', 'b');
xlabel('Frecuencia [kHz]');
ylabel('Magnitud [dB]');
title('Espectro de la señal OFDM');
xlim([-0.150 4.95]);
set(gca, 'XTick', 0:0.15:4.8); 
set(gca, 'YTick', -80:20:80); 
set(gca, 'LineWidth', 1, 'FontSize', 9);
%set(gcf, 'Color', [1 1 1]);
grid on;

% Configurar orientación y tamaño de papel
set(gcf, 'PaperOrientation', 'landscape');    % Hoja horizontal
set(gcf, 'PaperUnits', 'centimeters');        % Unidades en cm
set(gcf, 'PaperSize', [29.7 21.0]);           % Tamaño A4 (ancho x alto)
set(gcf, 'PaperPosition', [0.5 0.5 28.7 20.0]);   % Márgenes de 1 cm aprox.

% Exportar como PDF (usa toda la hoja)
print(gcf, '-dpdf', 'Espectro_OFDM.pdf');

figure;
stem(f, abs(X1_norm));
title('Espectro de la señal');
xlabel('Frecuencia [kHz]');
ylabel('Magnitud en veces');
grid on;


