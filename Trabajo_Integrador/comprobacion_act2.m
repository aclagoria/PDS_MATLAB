clear all
close all

fs = 4.8e3;       % Frecuencia de muestreo de la señal modulada 156.6 kHz
k = (0:11)';          % Índices de los 12 canales 
f_k = (0.3 + 0.15 * k) * 1e3; % Frecuencias de portadora en Hz 
delta_f = 0.15e3;     % Separación de frecuencia (150 Hz) entre canales
Tsym = 1 / delta_f;   % Período de símbolo (~6.667 ms)

N = round(Tsym * fs); % cantidad de muestras de la señal portadora (1024)
t = (0:N-1) / fs; % Vector de tiempo para un símbolo

CH = 4;               % n° de canales  de 12 bits
K = 12;
[ch1, Fs1]= partir_audio('fati_Fs8k_12bit.wav',1,1.22);

[ch2, Fs2]= partir_audio('fati_Fs8k_12bit.wav',1,2.9);

[ch3, Fs3]= partir_audio('caro_Fs8k_12bit.wav',1,1.2);

[ch4, Fs4]= partir_audio('caro_Fs8k_12bit.wav',1,2.65);
%       Esta partición nos da 8001 muestras de cada audio entonces los
%       limitamos a solo las 80 primeras
L = 80;

g4bit_ch = cell(1,3);
grupos_bit = cell(1,12);
a_k = zeros(1,12);
b_k = zeros(1,12);
s= zeros(L*N,1); % Señal modulada
for l = 1:L
    muestras_actuales = [ch1(l), ch2(l), ch3(l), ch4(l)];
    for ch = 1:CH
        bin12 = convertir_muestra16a12bin(muestras_actuales(ch));
        g4bit_ch = [grupo_4bit(bin12)];
        grupos_bit(((ch-1)*3+1):((ch-1)*3+3))= g4bit_ch;
    end
    [a_k,b_k] = mapeo_16QAM(grupos_bit);
    s_k = zeros(N,K);
    for k=1:K
         s_k(:,k)= a_k(k)* cos(2*pi*f_k(k) * t )-  b_k(k)* sin(2*pi*f_k(k)* t) ; 
    end
    suma=sum(s_k,2); % suma los elementos a lo largo de las columnas osea
                     % suma fila por fila 
    inicio=(l-1)*N+1;
    fin=l*N;
    s(inicio:fin)= suma;
end