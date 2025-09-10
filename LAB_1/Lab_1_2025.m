clear all
clear
close all

%% a
f = 30;
n0= -65;
N = 89;
fs= 160;
fi= 0;

[x1,n]=Generador_senal(f,n0,N,fs,fi);

%
f=40;
fi=pi/2;

[x2,n]=Generador_senal(f,n0,N,fs,fi);
%
f=60;
fi=pi/4;

[x3,n]=Generador_senal(f,n0,N,fs,fi);

%
senal_160=5+x1+x2+x3;
figure
stem(n,senal_160);
figure
plot(n,senal_160);
%audiowrite('senal_160.wav', senal_160, fs);
figure
stem(n,x1);
figure
plot(n,x1);
[periodo160,NF160]=esPeriodica(senal_160);

% % %Recuperacion de señal en wav
% % [y,Fs]= audioread('senal_160.wav');
% % tam= length(y);
% % figure
% % stem(tam,y);
% 
%% b
f = 30;
n0= -65;
N = 89;
fs= 325;
fi= 0;

[x1,n]=Generador_senal(f,n0,N,fs,fi);

%
f=40;
fi=pi/2;

[x2,n]=Generador_senal(f,n0,N,fs,fi);
%
f=60;
fi=pi/4;

[x3,n]=Generador_senal(f,n0,N,fs,fi);

%
senal_325=5+x1+x2+x3;
figure;
stem(n,senal_325);
%audiowrite('senal_325.wav', senal_325, fs);
[periodo325,NF325]=esPeriodica(senal_325);
%% c
f = 30;
n0= -65;
N = 89;
fs= 110;
fi= 0;

[x1,n]=Generador_senal(f,n0,N,fs,fi);

%
f=40;
fi=pi/2;

[x2,n]=Generador_senal(f,n0,N,fs,fi);
%
f=60;
fi=pi/4;

[x3,n]=Generador_senal(f,n0,N,fs,fi);

%
senal_110=5+x1+x2+x3;
figure;
stem(n,senal_110);
%audiowrite('senal_110.wav', senal_110, fs);
[periodo110,NF110]=esPeriodica(senal_110);
%% d
f = 30;
n0= -65;
N = 89;
fs= 323;
fi= 0;

[x1,n]=Generador_senal(f,n0,N,fs,fi);

%
f=40;
fi=pi/2;

[x2,n]=Generador_senal(f,n0,N,fs,fi);
%
f=60;
fi=pi/4;

[x3,n]=Generador_senal(f,n0,N,fs,fi);

%
senal_323=5+x1+x2+x3;
figure;
stem(n,senal_323);
%audiowrite('senal_323.wav', senal_323, fs);
% 
[periodo323,NF323]=esPeriodica(senal_323);