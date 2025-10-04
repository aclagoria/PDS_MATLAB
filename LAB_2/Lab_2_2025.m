clear all
close all


%% Actividad 1)

[x1, Fs1]=audioread('fati.wav'); % fati.wav audio generado en simulink
                                 % con Fs=32000 y de 24 bits

N=length(x1);
X1=fft(x1)/N;
f1=(0:N-1)*(Fs1/N);
mag1=abs(X1);


% subplot(2,1,1);
% stem(f1,mag1);
% xlabel('frecuencia Hz');
% ylabel('Magnitud');
% title('Espectro en Frecuencia – Audio Fátima (original)');
% grid on;


[x2, Fs2]=audioread('caro.wav'); % caro.wav audio generado en simulink
                                 % con Fs=32000 y de 24 bits

N=length(x2);
X2=fft(x2)/N;
f2=(0:N-1)*(Fs2/N);
mag2=abs(X2);

% subplot(2,1,1);
% stem(f2,mag2);
% xlabel('frecuencia Hz');
% ylabel('Magnitud');
% title('Espectro en Frecuencia – Audio Carolina (original)');
% grid on;

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

f1=(0:N-1)*(Fs1/N);
mag1=abs(Y1);

% subplot(2,1,2);
% %figure
% %subplot(2,1,1);
% stem(f1,mag1);
% xlabel('frecuencia Hz');
% ylabel('Magnitud');
% title('Espectro en Frecuencia – Audio Fátima (filtrado)');
% grid on;

y2=ecuacion_de_diferencias(x2,A,B);

Y2= fft(y2);
N=length(Y2);

f2=(0:N-1)*(Fs2/N);
mag2=abs(Y2);

% subplot(2,1,2);
% stem(f2,mag2);
% xlabel('frecuencia Hz');
% ylabel('Magnitud');
% title('Espectro en Frecuencia – Audio Carolina (filtrado)');
% grid on;



%% Actividad 3)

[fati_12bit, Fs_nuevo]= generar_registro(y1,Fs1); % utilizo la señal filtrada 

% Guardar en formato WAV, el formato WAV tiene bits de salida por muestra
% de 8, 16, 24, 32 y 64. Entonces guardamos en 16 bit, pero por lo
% realizado anteriormente se tiene una resolución efectiva de 12

%audiowrite('fati_Fs8k_12bit.wav', fati_12bit, Fs_nuevo, 'BitsPerSample', 16);


[caro_12bit, Fs_nuevo]= generar_registro(y2,Fs2);
% Guardar en formato WAV, el formato WAV tiene bits de salida por muestra
% de 8, 16, 24, 32 y 64. Entonces guardamos en 16 bit, pero por lo
% realizado anteriormente se tiene una resolución efectiva de 12

%audiowrite('caro_Fs8k_12bit.wav', caro_12bit, Fs_nuevo, 'BitsPerSample', 16);



%% Actividad 4)

audios = {'senal_160.wav','senal_325.wav','senal_110.wav','senal_323.wav'};

for k=1:length(audios)
    
    [x, Fs]=audioread(audios{k}); % leo cada audio generedo en Lab1

    [N, nf]= esPeriodica(x); % nf=segmento de la señal correspondiente a un periodo

    if isempty(N) || N == 0 % verifico que la señal sea periódica
        fprintf('La señal %s no es periódica. No se reconstruye.\n', audios{k});
        continue; % pasar al siguiente audio
    end
    x_stf=encontrar_STF(N,nf);
    t=(0:N-1)/Fs; % vector tiempo

    figure;
    subplot(2,1,1);
    stem(t,nf);
    xlabel('tiempo [s]');
    ylabel('Amplitud');
    title(['Segmento periódico de la señal: ', audios{k}]);
    grid on;               

    subplot(2,1,2);
    stem(t,x_stf);
    xlabel('tiempo [s]');
    ylabel('Amplitud');
    title(['Reconstrucción con STFD: ',audios{k}]);
    grid on;               
end
