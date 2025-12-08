clear all
close all

fp=2.4e3;
fb=4.8e3;


%% Atenuación máxima en la banda de paso
%% Diseño manual
    Ap=3;
    Ab=30;

    fc=fp;
    wb=fb/fp;
    orden = ceil(.5*log10((10^(Ab/10)-1)/(10^(Ap/10)-1))/log10(wb));

    [b, a] = butter(orden,1,'s'); % Normalizado
    [B, A] =lp2lp(b,a,2*pi*fc);

    % Analógico (respuesta en frecuencia vs frecuencia analógica)
    [Ha, fa] = freqs(B, A, 1024); % dominio s, 1024 puntos
    figure;
    subplot(2,1,1);
    plot(fa/(2*pi*1e3), 20*log10(abs(Ha)));
    xlabel('Frecuencia [kHz]'); ylabel('Magnitud [dB]');
    title('Filtro analógico Butterworth - Diseño manual- Ap =3 dB ');
    grid on; xlim([0 6]); set(gca, 'XTick', 0:1.2:6); 

% fvtool(b, a) % esta se usa en filtros digitales no sirve aquí
%% Diseño con herramientas de Matlab
    Wp = 2*pi*fp;
    Ws = 2*pi*fb;

    [N, Wn] = buttord(Wp, Ws, Ap, Ab, 's');
    [b_butt, a_butt] = butter(N, Wn,'s');

    % Analógico (respuesta en frecuencia vs frecuencia analógica)
    [Ha_butt, fa_butt] = freqs(b_butt, a_butt, 1024); % dominio s, 1024 puntos
    subplot(2,1,2);
    plot(fa_butt/(2*pi*1e3), 20*log10(abs(Ha_butt)));
    xlabel('Frecuencia [kHz]'); ylabel('Magnitud [dB]');
    title('Filtro analógico Butterworth - Diseño directo - Ap=3 dB');
    grid on; xlim([0 6]); set(gca, 'XTick', 0:1.2:6); 


%% Caso general
%
Ap=1;
Ab=30;
%% Diseño manual
    wb=fb/fp;
    orden =ceil(.5*log10((10^(Ab/10)-1)/(10^(Ap/10)-1))/log10(wb));
    % Al redondearce el valor al entero mayor, en la zona de trancisión se
    % tendrá una atenuación mayor que la diferncia especificada Ab-Ap. Se 
    % tiene 2 alternativas:
    %       1: Se fija para la frecuencia de fp la atenuación Ap y se
    %          obtiene para fb una atenuacion  >Ab
    %       2: Se fija para la frecuencia de fb la atenuación Ab y se
    %          obtiene para fp una atenuacion  <Ap
    % Para ambas alternativas se parte de calcular la frecuencia de corte
    % caso 1: fc = fp/(10^(Ap/10)-1)^(1/2N)
    % caso 2: fc = fb/(10^(Ab/10)-1)^(1/2N)

    fc_1 = fp/((10^(Ap/10))-1)^(1/(2*orden));
    fc_2 = fb/((10^(Ab/10))-1)^(1/(2*orden));

    % Con caso 1
    [b, a] = butter(orden,1,'s'); % Normalizado
    [B_1, A_1] =lp2lp(b,a,2*pi*fc_1);

    % Analógico (respuesta en frecuencia vs frecuencia analógica)
    [Ha, fa] = freqs(B_1, A_1, 1024); % dominio s, 1024 puntos
    figure;
    subplot(3,1,1);
    plot(fa/(2*pi*1e3), 20*log10(abs(Ha)));
    xlabel('Frecuencia [kHz]'); ylabel('Magnitud [dB]');
    title('Filtro analógico Butterworth - Diseño manual- Ap=1dB, caso 1 ');
    grid on; xlim([0 6]);ylim([-45 5]); set(gca, 'XTick', 0:1.2:6); 

    % Con caso 2
    [b, a] = butter(orden,1,'s'); % Normalizado
    [B_2, A_2] =lp2lp(b,a,2*pi*fc_2);

    % Analógico (respuesta en frecuencia vs frecuencia analógica)
    [Ha, fa] = freqs(B_2, A_2, 1024); % dominio s, 1024 puntos
    subplot(3,1,2);
    plot(fa/(2*pi*1e3), 20*log10(abs(Ha)));
    xlabel('Frecuencia [kHz]'); ylabel('Magnitud [dB]');
    title('Filtro analógico Butterworth - Diseño manual- Ap=1dB, caso 2 ');
    grid on; xlim([0 6]);ylim([-45 5]); set(gca, 'XTick', 0:1.2:6); 


%% Diseño con herramientas de Matlab = Diseño directo
    Wp = 2*pi*fp;
    Ws = 2*pi*fb;

    [N, Wn] = buttord(Wp, Ws, Ap, Ab, 's');
    [b_butt, a_butt] = butter(N, Wn,'s');

    % Analógico (respuesta en frecuencia vs frecuencia analógica)
    [Ha_butt, fa_butt] = freqs(b_butt, a_butt, 1024); % dominio s, 1024 puntos
    subplot(3,1,3);
    plot(fa_butt/(2*pi*1e3), 20*log10(abs(Ha_butt)));
    xlabel('Frecuencia [kHz]'); ylabel('Magnitud [dB]');
    title('Filtro analógico Butterworth - Diseño directo- Ap=1dB');
    grid on; xlim([0 6]); ylim([-45 5]); set(gca, 'XTick', 0:1.2:6); 

