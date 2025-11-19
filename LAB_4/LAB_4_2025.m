clear all
close all


fs = 153.6e3;       % Frecuencia de muestreo de la señal modulada 156.6 kHz
k = (0:11)';          % Índices de los 12 canales 
f_k = (38.7 + 0.15 * k) * 1e3; % Frecuencias de portadora en Hz 
delta_f = 0.15e3;     % Separación de frecuencia (150 Hz) entre canales
Tsym = 1 / delta_f;   % Período de símbolo (~6.667 ms)

N = round(Tsym * fs); % cantidad de muestras de la señal portadora (1024)
t = (0:N-1) / fs; % Vector de tiempo para un símbolo

CH = 4;               % n° de canales  de 12 bits
K = 12;
%% Actividad 1

% Costruccion de señales de 12 bit en forma de columna
L = 10;               % muestras por canal

ch1 = round(linspace(0, 4095, L))';   % Canal 1: Rampa lineal (de 0 a 4095)

ch2 = mod(round(linspace(0, 8190, L))', 4096);  % Canal 2: Diente de sierra 

ch3 = ones(L, 1) * 2048;   % Canal 3: Constante (valor medio)

ch4 = randi([0, 4095], L, 1);  % Canal 4: Aleatoria (valores 12 bit)


bin12 = cell(L, CH);  % matriz de celdas 10x4
g_bit = cell(L,12);
a_k = zeros(1,12);
b_k = zeros(1,12);
s_k = zeros(N,K);
s= zeros(L*N,1);
for l = 1:L
    muestras_actuales = [ch1(l), ch2(l), ch3(l), ch4(l)];
    g4bit_ch = cell(1,3);
    grupos_bit = cell(1,12);
    for ch = 1:CH
        bin12{l, ch} = dec2bin(muestras_actuales(ch), 12);
        g4bit_ch = [grupo_4bit(bin12{l, ch})];
        grupos_bit(((ch-1)*3+1):((ch-1)*3+3))= g4bit_ch;
    end
    g_bit(l,:) = grupos_bit;  
    [a_k,b_k] = mapeo_16QAM(grupos_bit);
    for k=1:K
         s_k(:,k)= a_k(k)* cos(2*pi*f_k(k) * t )- 1j* b_k(k)* sin(2*pi*f_k(k)* t) ; 
    end
    suma=sum(s_k,2);
    inicio=(l-1)*N+1;
    fin=l*N;
    s(inicio:fin)= suma;
end
