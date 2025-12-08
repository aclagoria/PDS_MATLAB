clear all
close all

fp1=38.4e3;
fp2=40.65e3;
fs1=37.5e3;
fs2=41.5e3;

wp1=2*pi*fp1;
wp2=2*pi*fp2;
ws1=2*pi*fs1;
ws2=2*pi*fs2;



%% Atenuación máxima en la banda de paso
%%
Ap=3;
As=30;
%% Diseño manual
    f0 =(fp1*fp2)^(1/2);        w0=2*pi*f0;
    B = 2*pi*(fp2 - fp1);

    omega_p  = 1; % no se usa este valor despues pero es para ejemplificar 
                  % todoel proceso teórico, corresponde a la frecuencia de 
                  % paso normalizada

    omega_s1 = abs((ws1^2-w0^2)/(B*ws1)); % frecuencia de rechazo inferior 
                                          % normalizada
    omega_s2 = abs((ws2^2-w0^2)/(B*ws2)); % frecuencia de rechazo superior 
                                          % normalizada
    omega_s = min(omega_s2,omega_s1);    % frecuencia normalizada peor caso
    %Justificación: cuanto menor sea más cerca está la zona de rechazo, y  
    %por lo tanto, más exigente será el filtro (necesita mayor orden N).

    orden = ceil(.5*log10((10^(As/10)-1)/(10^(Ap/10)-1))/log10(omega_s));

    [b, a] = butter(orden,1,'s');       % Lowpass Normalizado 
    [b_bp, a_bp] = lp2bp(b, a, w0, B);  % lp2bp = Lowpass to Bandpass
    % Crear la función transferencia analógica H(s)
    Ha_s = tf(b_bp, a_bp);
    % % Mostrar H(s)
    % disp('Función transferencia analógica H(s):');
    % Ha_s

%% Diseño directo pasa banda analógico con buttord/butter
    Wp = [wp1 wp2];   % Frecuencias de paso en rad/s
    Ws = [ws1 ws2];   % Frecuencias de rechazo en rad/s

    [N, Wn] = buttord(Wp, Ws, Ap, As, 's');
    [b_butt, a_butt] = butter(N, Wn, 'bandpass', 's');

    % Crear la función transferencia analógica H(s)
    Ha1_s = tf(b_butt, a_butt);
    % % Mostrar H(s)
    % disp('Función transferencia analógica H(s):');
    % Ha1_s
%% Gráficas
% Analógico (respuesta en frecuencia vs frecuencia analógica)
[Ha, fa] = freqs(b_bp, a_bp, 1024); % dominio s, 1024 puntos
figure;
subplot(2,1,1);
plot(fa/(2*pi*1e3), 20*log10(abs(Ha)));
xlabel('Frecuencia [kHz]'); ylabel('Magnitud [dB]');
title('Filtro analógico Butterworth diseño manual');
legend('Ap = 3 dB y As = 30 dB');
grid on; 
xlim([f0/2e3 f0*2/1e3]); ylim([-300 0]); set(gca, 'XTick', 38.4:2.25:40.65); 

% Analógico (respuesta en frecuencia vs frecuencia analógica)
[Ha_butt, fa_butt] = freqs(b_butt, a_butt, 1024); % dominio s, 1024 puntos
subplot(2,1,2);
plot(fa_butt/(2*pi*1e3), 20*log10(abs(Ha_butt)));
xlabel('Frecuencia [kHz]'); ylabel('Magnitud [dB]');
title('Filtro analógico Butterworth diseño directo');
legend('Ap = 3 dB y As = 30 dB');
grid on;  
xlim([f0/2e3 f0*2/1e3]); ylim([-300 0]); set(gca, 'XTick', 38.4:2.25:40.65); 

figure;
semilogx(fa/(2*pi*1e3), 20*log10(abs(Ha)), 'b', 'LineWidth',1.5); hold on;
semilogx(fa_butt/(2*pi*1e3), 20*log10(abs(Ha_butt)), '--r', 'LineWidth',1.5);
legend('Manual (lp2bp)', 'MATLAB (buttord/butter)');
xlabel('Frecuencia [kHz]'); ylabel('Magnitud [dB]');
title('Comparación de filtros pasa banda analógicos');
grid on; 
xlim([f0/2e3 f0*2/1e3]); ylim([-300 0]); set(gca, 'XTick', 38.4:2.25:40.65); 


%% Conclusión:
%             de manera manual sale distinto que de usando las herramientas
%             de Matlab y según las graficas conviene usar las herramientas 
%% Caso general
%%
Ap=1;
As=35;
%
%% Diseño manual
    omega_p  = 1;
    omega_s1 = abs((ws1^2-w0^2)/(B*ws1));
    omega_s2 = abs((ws2^2-w0^2)/(B*ws2));
    omega_s = min(omega_s2,omega_s1);

    orden = ceil(.5*log10((10^(As/10)-1)/(10^(Ap/10)-1))/log10(omega_s));

    [b_lp, a_lp] = butter(orden,1,'s'); % Normalizado

    [b_bp, a_bp] = lp2bp(b_lp, a_lp, w0, B);  % lp2bp = Lowpass to Bandpass
    % Crear la función transferencia analógica H(s)
    Ha2_s = tf(b_bp, a_bp);
%     % Mostrar H(s)
%     disp('Función transferencia analógica H(s):');
%     Ha2_s

%% Diseño directo pasa banda analógico con buttord/butter
    Wp = [wp1 wp2];   % Frecuencias de paso en rad/s
    Ws = [ws1 ws2];   % Frecuencias de rechazo en rad/s

    [N, Wn] = buttord(Wp, Ws, Ap, As, 's');
    [b_butt, a_butt] = butter(N, Wn, 'bandpass', 's');

    % Crear la función transferencia analógica H(s)
    Ha3_s = tf(b_butt, a_butt);
%     % Mostrar H(s)
%     disp('Función transferencia analógica H(s):');
%     Ha3_s

%% Gráficas
% Analógico (respuesta en frecuencia vs frecuencia analógica)
[Ha, fa] = freqs(b_bp, a_bp, 1024); % dominio s, 1024 puntos
figure;
subplot(2,1,1);
plot(fa/(2*pi*1e3), 20*log10(abs(Ha)));
xlabel('Frecuencia [kHz]'); ylabel('Magnitud [dB]');
title('Filtro analógico Butterworth diseño manual');
legend('Ap = 1 dB y As = 25 dB');
grid on; 
xlim([f0/2e3 f0*2/1e3]); ylim([-40 5]); set(gca, 'XTick', 38.4:2.25:40.65); 

% Analógico (respuesta en frecuencia vs frecuencia analógica)
[Ha_butt, fa_butt] = freqs(b_butt, a_butt, 1024); % dominio s, 1024 puntos
subplot(2,1,2);
plot(fa_butt/(2*pi*1e3), 20*log10(abs(Ha_butt)));
xlabel('Frecuencia [kHz]'); ylabel('Magnitud [dB]');
title('Filtro analógico Butterworth diseño directo');
legend('Ap = 1 dB y As = 25 dB');
grid on; 
xlim([f0/2e3 f0*2/1e3]); ylim([-40 5]); set(gca, 'XTick', 38.4:2.25:40.65); 

figure;
semilogx(fa/(2*pi*1e3), 20*log10(abs(Ha)), 'b', 'LineWidth',1.5); hold on;
semilogx(fa_butt/(2*pi*1e3), 20*log10(abs(Ha_butt)), '--r', 'LineWidth',1.5);
legend('Manual (lp2bp)', 'MATLAB (buttord/butter)');
xlabel('Frecuencia [kHz]'); ylabel('Magnitud [dB]');
title('Comparación de filtros pasa banda analógicos');
grid on; 
xlim([f0/2e3 f0*2/1e3]); ylim([-40 5]); set(gca, 'XTick', 38.4:2.25:40.65); 
