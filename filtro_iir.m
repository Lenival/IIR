%% Projeto de Filtros IIR para disciplina Processamento Digital de Sinais
%  Aluno: Jos� Lenival Gomes de Fran�a
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Prepara��o do sinal
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Trecho para captura de audio

% Fs = 44100;minha_voz = audiorecorder(Fs, 24, 2);
% record(minha_voz);pause(5);pause(minha_voz);stop(minha_voz);
% audiowrite('audio_gravado.wav',minha_voz.getaudiodata,Fs)
clear; clc;
% Leitura a partir de arquivo
[y,Fs] = audioread('audio_teste.wav');
%sound(y,Fs)                    
T = 1/Fs;                       % Per�odo de amostragem
L = length(y(:,1));             % Comprimento do sinal
t = (0:1:L-1)'*T;                % Eixo do tempo
f = (Fs/L)*(-L/2:L/2-1)';


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Especifica��es do filtro
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Frequ�ncia de corte e passagem normalizadas [rad/s]
w_s = [1850 2150]./(Fs/2);
w_p = [1800 2200]./(Fs/2);

% C�lculo das frequ�ncias de corte
w_c = [(w_p(1) + w_s(1))/2 (w_s(2) + w_p(2))/2];

% Regi�o de transi��o
delta_w = [abs(w_s(1) - w_p(1)) abs(w_p(2) - w_s(2))];

% Determinando regi�o de transi��o mais estreita
delta_w_min = min(delta_w(1),delta_w(2));

% Determinando a m�nima ondula��o m�xima e o Ar 
delta_min = 0.01;
Ar = -20*log10(delta_min);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Prepara��o do ru�do
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Criando um ru�do AWG
N_0 = 0.1;
ruido = N_0*randn(L,1);

% Filtro limitador de ru�do
b = remez(1500,[0 w_p(1) w_s(1) w_s(2) w_p(2) 1],[0 0 1 1 0 0]);
% b = remez(1500,[0 1.85e3/(Fs/2) 1.90e3/(Fs/2) 2.1e3/(Fs/2) 2.15e3/(Fs/2) 1],[0 0 1 1 0 0]);


% Limitando o espectro do ru�do
ruido_limitado = filter(b,1,ruido);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Projeto do Butterworth
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[N_b,Wp_b] = buttord(w_p*(Fs/2),w_s*(Fs/2),3,Ar,'s');
%[B_b,A_b] = butter(N_b,w_c*(Fs/2),'stop','s');     % Gera polos inst�veis
[Z_b,P_b,K_b] = butter(N_b/2,w_c*(Fs/2),'stop','s'); % Para stop retorna 2n
[B_b,A_b] = zp2tf(Z_b,P_b,K_b);
%[b_b,a_b] = bilinear(B_b,A_b,Fs);
[z_b,p_b,k_b] = bilinear(Z_b,P_b,K_b,Fs);

%[bb,ab] = zp2tf(zb,pb,kb);

% N = (1/2)*(ln(((1-(1-eps)^2)*delta_min^2)/(1-delta_min^2)))

%syms N w_c

% Equa��es de projeto de filtros Butterworth
%eq1 = (w_s(1)/w_c)^(2*N)==(1-delta_min^2)/delta_min^2;
%eq2 = (w_p(1)/w_c)^(2*N)==(1-(1-delta_min)^2)/(1-delta_min)^2;

%par = solve(eq1,eq2,w_c,N);

% Calculo do novo omega a apartir da ordem m�nima inteira
%omega_apr = w_s(1)*((1-delta_min^2)/delta_min^2)^(-1/ceil(par.N));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Projeto do Chebyshev I  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Projeto do Chebyshev II
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Projeto do El�ptico
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% [n,Wp] = ellipord(Wp,Ws,Rp,Rs,'s')
[N_e,Wp_e] = ellipord(w_p*(Fs/2),w_s*(Fs/2),3,Ar,'s');
[B_e,A_e] = ellip(N_e,3,Ar,w_p*(Fs/2),'stop','s');
[b_e,a_e] = bilinear(B_e,A_e,Fs);

% freqs(poly(Z_b),poly(P_b))
%wvtool(w)
%stem(h_n)
%freqz(h_n)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Adi��o do sinal e ru�do
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

yn = y(:,1)+ruido_limitado;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Filtragem do sinal
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
y_b = filter(b_b,a_b,yn);% Projeto do Butterworth
%y_c1 = filter(b_c1,a_c1,yn);% Projeto do Chebyshev I
%y_c2 = filter(b_c2,a_c2,yn);% Projeto do Chebyshev II
y_e = filter(b_e,a_e,yn);% Projeto do El�ptico



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plotagem do gr�ficos
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
title('Ru�do branco')
xlim([0 Fs/2])
xlabel('f (Hz)')
ylabel('R(\omega)')

subplot(2,2,3)
R_limitado = fftshift(fft(ruido_limitado));
plot(f,abs(R_limitado),'g')
title('Ru�do limitado em banda')
xlim([0 Fs/2])
xlabel('f (Hz)')
ylabel('R_{lim}(\omega)')

%figure;
subplot(2,2,4)
YN = fftshift(fft(yn));
plot(f,abs(YN),'b')
title('Sinal corrompido por ru�do AWG')
xlim([0 Fs/2])
xlabel('f (Hz)')
ylabel('Y(\omega) + R_{lim}(\omega)')

% Espectro do filtro e do sinal ap�s filtrado
figure;
% subplot(2,1,1)
% HN = fftshift(fft(h_n));
% omega = (Fs/M)*(-M/2:M/2-1);	% Eixo ajustado ao tamanho do filtro
% plot(omega,abs(HN),'r')
% title('Filtro notch projetado por janela de Kaiser')
% xlim([0 Fs/2])
% xlabel('f (Hz)')
% ylabel('H(\omega)')
% 
% subplot(2,1,2)
 
 Y_b = fftshift(fft(y_b));
 plot(f,abs(Y_b),'g')
 title('Sinal ap�s o filtro el�ptico')
 xlim([0 Fs/2])
 xlabel('f (Hz)')
 ylabel('Y_{b}(\omega)')

 
% Y_e = fftshift(fft(y_e));
% plot(f,abs(Y_e),'g')
% title('Sinal ap�s o filtro el�ptico')
% xlim([0 Fs/2])
% xlabel('f (Hz)')
% ylabel('Y_{e}(\omega)')

% Espectro da resposta desejada
% figure;
% HD = fftshift(fft(h_d));
% plot(omega,abs(HD),'r')
% title('Filtro notch desejado')
% xlim([0 Fs/2])
% xlabel('f (Hz)')
% ylabel('H(\omega)')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Reprodu��o do �udio
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% p = audioplayer(yn, Fs);
% play(p);
% pause(7)
% q = audioplayer(yf, Fs);
% play(q);



















