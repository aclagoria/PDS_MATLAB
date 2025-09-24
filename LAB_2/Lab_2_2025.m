clear all
close all

info= audioinfo('fati.wav');
info2=audioinfo('caro.wav');
% 1)

[x1, Fs1]=audioread('fati.wav');

N=length(x1);
Y=fft(x1)/N;
f1=(0:N-1)*(Fs1/N);
mag1=abs(Y);

% subplot(2,1,1);
stem(f1,mag1);
xlabel('frecuencia Hz');
ylabel('Magnitud');
title('Espectro del audio Fátima');
grid on;

% subplot(2,1,2);
% stem(f1,mag1);
% xlabel('frecuencia Hz');
% ylabel('Magnitud');
% title('Espectro del audio Fátima');
% grid on;

% [x2, Fs2]=audioread('caro.wav');
% 
% N=length(x2);
% Y=fft(x2)/N;
% f2=(0:N-1)*(Fs2/N);
% mag2=abs(Y);
% figure
% stem(f2,mag2);
% xlabel('frecuencia Hz');
% ylabel('Magnitud');
% title('Espectro del audio Carolina');
% grid on;

% 2)
load('filcoef.mat');

%y1=filter(A,B,x1); % no usar hacer paso por paso
%y1=filtro(x1,A,B); % no usar hacer paso por paso
%y1=ec_diferencias(x1,A,B); % no usar hacer paso por paso
y1=aplicar_ecuacion_diferencias(x1,A,B);
%y1=aplicar_filtro(x1,A,B);
%N=length(y1);


Y1= fft(y1);
N=length(Y1);

f1=(0:N-1)*(1/N);
mag1=abs(Y1);

figure
stem(f1,mag1);
xlabel('frecuencia Hz');
ylabel('Magnitud');
title('Espectro del audio filtrada Fátima');
grid on;
