clear all
close all

% info= audioinfo('fati.wav');
% info2=audioinfo('caro.wav');
%% Actividad 1)

[x1, Fs1]=audioread('fati.wav'); % fati.wav audio generado en simulink
                                 % con Fs=32000 y de 24 bits

N=length(x1);
X1=fft(x1)/N;
f1=(0:N-1)*(Fs1/N);
mag1=abs(X1);


subplot(2,1,1);
stem(f1,mag1);
xlabel('frecuencia Hz');
ylabel('Magnitud');
title('Espectro del audio Fátima');
grid on;


[x2, Fs2]=audioread('caro.wav'); % caro.wav audio generado en simulink
                                 % con Fs=32000 y de 24 bits

N=length(x2);
X2=fft(x2)/N;
f2=(0:N-1)*(Fs2/N);
mag2=abs(X2);

subplot(2,1,2);
stem(f2,mag2);
xlabel('frecuencia Hz');
ylabel('Magnitud');
title('Espectro del audio Carolina');
grid on;

%% Actividad 2)
load('filcoef.mat');

%y1_fcionfilter=filter(A,B,x1); % no usar hacer paso por paso
% Y1_filtro= fft(y1_fcionfilter);
% N=length(Y1_filtro);
% 
% f1=(0:N-1)*(1/N);
% mag2=abs(Y1_filtro);
% 
% figure
% stem(f1,mag2);
% xlabel('frecuencia Hz');
% ylabel('Magnitud');
% title('Espectro del audio filtrada Fátima con funcion filter');
% grid on;

y1=ecuacion_de_diferencias(x1,A,B);

Y1= fft(y1);
N=length(Y1);

f1=(0:N-1)*(1/N);
mag1=abs(Y1);

figure
subplot(2,1,1);
stem(f1,mag1);
xlabel('frecuencia Hz');
ylabel('Magnitud');
title('Espectro del audio filtrada Fátima');
grid on;

y2=ecuacion_de_diferencias(x2,A,B);

Y2= fft(y2);
N=length(Y2);

f2=(0:N-1)*(1/N);
mag2=abs(Y2);

subplot(2,1,2);
stem(f2,mag2);
xlabel('frecuencia Hz');
ylabel('Magnitud');
title('Espectro del audio filtrada Carolina');
grid on;

%% Actividad 3)

[fati_12bit, Fs_nuevo]= generar_registro(y1,Fs1); % utilizo la señal filtrada 

% Guardar en formato WAV, el formato WAV tiene bits de salida por muestra
% de 8, 16, 24, 32 y 64. Entonces guardamos en 16 bit, pero por lo
% realizado anteriormente se tiene una resolución efectiva de 12
audiowrite('fati_Fs8k_12bit.wav', fati_12bit, Fs_nuevo, 'BitsPerSample', 16);


[caro_12bit, Fs_nuevo]= generar_registro(y2,Fs2);
% Guardar en formato WAV, el formato WAV tiene bits de salida por muestra
% de 8, 16, 24, 32 y 64. Entonces guardamos en 16 bit, pero por lo
% realizado anteriormente se tiene una resolución efectiva de 12
audiowrite('caro_Fs8k_12bit.wav', caro_12bit, Fs_nuevo, 'BitsPerSample', 16);



%% Actividad 4)
[s1, Fs1]=audioread('senal_160.wav'); % leo audio generedo en Lab1
                                

N=length(s1);
S1=fft(s1)/N;
f1=(0:N-1)*(Fs1/N);
magS1=abs(S1);

figure;
subplot(2,1,1);
stem(f1,magS1);
xlabel('frecuencia Hz');
ylabel('Magnitud');
title('Espectro del audio senal_160');
grid on;