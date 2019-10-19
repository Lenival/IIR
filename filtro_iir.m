%% Projeto de Filtros IIR para disciplina Processamento Digital de Sinais
%  Aluno: José Lenival Gomes de França
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Preparação do sinal
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Trecho para captura de audio

% Fs = 44100;minha_voz = audiorecorder(Fs, 24, 2);
% record(minha_voz);pause(5);pause(minha_voz);stop(minha_voz);
% audiowrite('audio_gravado.wav',minha_voz.getaudiodata,Fs)
clear; clc;
% Leitura a partir de arquivo
[y,Fs] = audioread('audio_teste.wav');
%sound(y,Fs)                    
T = 1/Fs;                       % Período de amostragem
L = length(y(:,1));             % Comprimento do sinal
t = (0:1:L-1)'*T;                % Eixo do tempo
f = (Fs/L)*(-L/2:L/2-1)';


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Especificações do filtro
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Frequência de corte e passagem normalizadas [rad/s]
w_s = [1850 2150]./(Fs/2);
w_p = [1800 2200]./(Fs/2);

% Cálculo das frequências de corte
w_c = [(w_p(1) + w_s(1))/2 (w_s(2) + w_p(2))/2];

% Região de transição
delta_w = [abs(w_s(1) - w_p(1)) abs(w_p(2) - w_s(2))];

% Determinando região de transição mais estreita
delta_w_min = min(delta_w(1),delta_w(2));

% Determinando a mínima ondulação máxima e o Ar 
delta_min = 0.01;
Ar = -20*log10(delta_min);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Preparação do ruído
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Criando um ruído AWG
N_0 = 0.1;
ruido = N_0*randn(L,1);

% Filtro limitador de ruído
b = remez(1500,[0 w_s(1) w_s(1)+(25/(Fs/2)) w_s(2)-(25/(Fs/2)) w_s(2) 1],[0 0 1 1 0 0]);
% b = remez(1500,[0 1.85e3/(Fs/2) 1.90e3/(Fs/2) 2.1e3/(Fs/2) 2.15e3/(Fs/2) 1],[0 0 1 1 0 0]);


% Limitando o espectro do ruído
ruido_limitado = filter(b,1,ruido);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Projeto do Butterworth
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[N_b,Wp_b] = buttord(w_p*(Fs/2),w_s*(Fs/2),3,Ar,'s');
[Z_b,P_b,K_b] = butter(N_b/2,w_c*(Fs/2),'stop','s'); % Para stop retorna 2n
[B_b,A_b] = zp2tf(Z_b,P_b,K_b);
[z_b,p_b,k_b] = bilinear(Z_b,P_b,K_b,Fs/2,9400);
sos_b = zp2sos(z_b,p_b,k_b);


%[B_b,A_b] = butter(N_b,w_c*(Fs/2),'stop','s');     % Gera polos instáveis
%[b_b,a_b] = bilinear(B_b,A_b,Fs);
% As freqências não estão correspondendo

%[bb,ab] = zp2tf(zb,pb,kb);         %afetado por erro numérico
%fvtool(sos_b)
% N = (1/2)*(ln(((1-(1-eps)^2)*delta_min^2)/(1-delta_min^2)))

%syms N w_c

% Equações de projeto de filtros Butterworth
%eq1 = (w_s(1)/w_c)^(2*N)==(1-delta_min^2)/delta_min^2;
%eq2 = (w_p(1)/w_c)^(2*N)==(1-(1-delta_min)^2)/(1-delta_min)^2;

%par = solve(eq1,eq2,w_c,N);

% Calculo do novo omega a apartir da ordem mínima inteira
%omega_apr = w_s(1)*((1-delta_min^2)/delta_min^2)^(-1/ceil(par.N));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Projeto do Chebyshev I  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Projeto do Chebyshev II
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Projeto do Elíptico
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[N_e,Wp_e] = ellipord(w_p*(Fs/2),w_s*(Fs/2),3,Ar,'s');
[Z_e,P_e,K_e] = ellip(N_e,3,Ar,w_p*(Fs/2),'stop','s'); % Para stop retorna 2n
[B_e,A_e] = zp2tf(Z_e,P_e,K_e);
[z_e,p_e,k_e] = bilinear(Z_e,P_e,K_e,Fs/2);
sos_e = zp2sos(z_e,p_e,k_e);


% [n,Wp] = ellipord(Wp,Ws,Rp,Rs,'s')
% [N_e,Wp_e] = ellipord(w_p*(Fs/2),w_s*(Fs/2),3,Ar,'s');
% [B_e,A_e] = ellip(N_e,3,Ar,w_p*(Fs/2),'stop','s');
% [b_e,a_e] = bilinear(B_e,A_e,Fs);

% freqs(poly(Z_b),poly(P_b))
%wvtool(w)
%stem(h_n)
%freqz(h_n)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Adição do sinal e ruído
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

yn = y(:,1)+ruido_limitado;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Filtragem do sinal
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
y_b = sosfilt(sos_b,yn);% Projeto do Butterworth
%y_c1 = filter(b_c1,a_c1,yn);% Projeto do Chebyshev I
%y_c2 = filter(b_c2,a_c2,yn);% Projeto do Chebyshev II
y_e = sosfilt(sos_e,yn);% Projeto do Elíptico



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plotagem do gráficos
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Espectro dos sinais a serem processados
subplot(2,2,1)
Y = fftshift(fft(y));
plot(f,abs(Y),'r')
title('Espectro do sinal original')
xlim([0 Fs/2])
xlabel('f (Hz)')
ylabel('Y(\omega)')

subplot(2,2,2)
R = fftshift(fft(ruido));
plot(f,abs(R),'g')
title('Ruído branco')
xlim([0 Fs/2])
xlabel('f (Hz)')
ylabel('R(\omega)')

subplot(2,2,3)
R_limitado = fftshift(fft(ruido_limitado));
plot(f,abs(R_limitado),'g')
title('Ruído limitado em banda')
xlim([0 Fs/2])
xlabel('f (Hz)')
ylabel('R_{lim}(\omega)')

%figure;
subplot(2,2,4)
YN = fftshift(fft(yn));
plot(f,abs(YN),'b')
title('Sinal corrompido por ruído AWG')
xlim([0 Fs/2])
xlabel('f (Hz)')
ylabel('Y(\omega) + R_{lim}(\omega)')

% Espectro do filtro e do sinal após filtrado
figure;
subplot(2,2,1)
YN = fftshift(fft(yn));
plot(f,abs(YN),'b')
title('Sinal corrompido por ruído AWG')
subplot(2,2,3)
plot(f,unwarp(YN),'b')
xlim([0 Fs/2])
xlabel('f (Hz)')
ylabel('Y(\omega) + R_{lim}(\omega)')
% HN = fftshift(fft(h_n));
% omega = (Fs/M)*(-M/2:M/2-1);	% Eixo ajustado ao tamanho do filtro
% plot(omega,abs(HN),'r')
% title('Filtro notch projetado por janela de Kaiser')
% xlim([0 Fs/2])
% xlabel('f (Hz)')
% ylabel('H(\omega)')
% 
% subplot(2,2,2)
 
% Y_b = fftshift(fft(y_b));
% plot(f,abs(Y_b),'g')
% title('Sinal após o filtro butterworth')
% xlim([0 Fs/2])
% xlabel('f (Hz)')
% ylabel('Y_{b}(\omega)')

subplot(2,2,2)
Y_e = fftshift(fft(y_e));
plot(f,abs(Y_e),'m')
title('Sinal após o filtro elíptico')
subplot(2,2,4)
plot(f,unwarp(Y_e),'m')
xlim([0 Fs/2])
xlabel('f (Hz)')
ylabel('Y_{e}(\omega)')

% Espectro da resposta desejada
% figure;
% HD = fftshift(fft(h_d));
% plot(omega,abs(HD),'r')
% title('Filtro notch desejado')
% xlim([0 Fs/2])
% xlabel('f (Hz)')
% ylabel('H(\omega)')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Reprodução do áudio
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

p = audioplayer(yn, Fs);
play(p);
pause(7)
q = audioplayer(Y_e, Fs);
play(q);



















