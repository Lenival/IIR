%% Projeto de Filtros IIR para disciplina Processamento Digital de Sinais
%  Aluno: Jos� Lenival Gomes de Fran�a
%%
% Este s
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
w_s = 2*pi*[1850 2150];
w_p = 2*pi*[1800 2200];
% C�lculo das frequ�ncias de corte
w_c = [(w_p(1) + w_s(1))/2 (w_s(2) + w_p(2))/2];
% Determinando a m�nima ondula��o m�xima e o Ar 
delta_min = 0.01;
Arp = -20*log10(1-delta_min);
Ars = -20*log10(delta_min);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Adicionando sinal ao ru�do AWG
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

N_0 = 0.001;                                 % Densidade espectral do ru�do
ruido = N_0.*randn(L,1);                     % Ru�do AWG
[z_n,p_n,k_n] = ellip(50,Arp,Ars,w_s/(Fs*pi),'bandpass');
[sos_n,g_n] = zp2sos(z_n,p_n,k_n);
ruido_limitado = sosfilt(sos_n*real(g_n),ruido);
yn = y(:,1)+ruido_limitado;                 % Adicionando sial e ru�do


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Projeto do Butterworth
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[N_b,Wp_b] = buttord(w_p,w_s,Arp,Ars,'s');
[Z_b,P_b,K_b] = butter(N_b,Wp_b,'stop','s'); % Para stop retorna 2n
[B_b,A_b] = zp2tf(Z_b,P_b,K_b);  %Gera erros num�ricos com N alto
[z_b,p_b,k_b] = bilinear(Z_b,P_b,K_b,Fs,2000);
[sos_b,g_b] = zp2sos(z_b,p_b,k_b);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Projeto do Chebyshev I  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[N_c1,Wp_c1] = cheb1ord(w_p,w_s,Arp,Ars,'s');
[Z_c1,P_c1,K_c1] = cheby1(N_c1,Arp,Wp_c1,'stop','s'); % Para stop retorna 2n
% [B_c1,A_c1] = zp2tf(Z_c1,P_c1,K_c1);    Gera erros num�ricos com N alto
[z_c1,p_c1,k_c1] = bilinear(Z_c1,P_c1,K_c1,Fs,2000);
[sos_c1,g_c1] = zp2sos(z_c1,p_c1,k_c1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Projeto do Chebyshev II
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[N_c2,Wp_c2] = cheb2ord(w_p,w_s,Arp,Ars,'s');
[Z_c2,P_c2,K_c2] = cheby2(N_c2,Ars,Wp_c2,'stop','s'); % Para stop retorna 2n
% [B_c2,A_c2] = zp2tf(Z_c2,P_c2,K_c2);  Gera erros num�ricos com N alto
[z_c2,p_c2,k_c2] = bilinear(Z_c2,P_c2,K_c2,Fs,2000);
[sos_c2,g_c2] = zp2sos(z_c2,p_c2,k_c2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Projeto do El�ptico
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[N_e,Wp_e] = ellipord(w_p,w_s,Arp,Ars,'s');
[Z_e,P_e,K_e] = ellip(N_e,Arp,Ars,Wp_e,'stop','s'); % Para stop retorna 2n
% [B_e,A_e] = zp2tf(Z_e,P_e,K_e);    Gera erros num�ricos com N alto
[z_e,p_e,k_e] = bilinear(Z_e,P_e,K_e,Fs,2000);
[sos_e,g_e] = zp2sos(z_e,p_e,k_e);

fvtool(sos_b,sos_c1,sos_c2,sos_e);


%wvtool(w)
%stem(h_n)
%freqz(h_n)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Projeto do Butterworth errado
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% [N_b,Wp_b] = buttord(w_p*(Fs/2),w_s*(Fs/2),Arp,Ars,'s')
% [B_b,A_b] = butter(N_b,Wp_b,'stop','s'); % Para stop retorna 2n
[b_b,a_b] = bilinear(B_b,A_b,Fs,2000);
y_berro = filter(b_b,a_b,yn);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Filtragem do sinal
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Retirando parte imagin�ria decorrente de erro num�rico
sos_b(1,1:3) = sos_b(1,1:3).*real(g_b);
sos_c1(1,1:3) = sos_c1(1,1:3).*real(g_c1);
sos_c2(1,1:3) = sos_c2(1,1:3).*real(g_c2);
sos_e(1,1:3) = sos_e(1,1:3).*real(g_e);

y_b = sosfilt(sos_b,yn);% Projeto do Butterworth
y_c1 = sosfilt(sos_c1,yn);% Projeto do Chebyshev I
y_c2 = sosfilt(sos_c2,yn);% Projeto do Chebyshev II
y_e = sosfilt(sos_e,yn);% Projeto do El�ptico


% syms s z
% f_zk = @(z,sk,Ts) (((z*Ts/2)+1)/((z*Ts/2)-1))-sk;
% f_sk = @(s,zk,Ts) (2/Ts)*((s-1)/(s+1))-zk;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plotagem do gr�ficos
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Espectro dos sinais a serem processados
subplot(2,2,1)
Y = fftshift(fft(y));
plot(f,abs(Y),'r');title('Espectro do sinal original');xlim([0 Fs/2]);xlabel('f (Hz)');ylabel('Y(\omega)')

subplot(2,2,2)
R = fftshift(fft(ruido));
plot(f,abs(R),'g');title('Ru�do branco');xlim([0 Fs/2]);xlabel('f (Hz)');ylabel('R(\omega)')

subplot(2,2,3)
R_limitado = fftshift(fft(ruido_limitado));
plot(f,abs(R_limitado),'g');title('Ru�do limitado em banda');xlim([0 Fs/2]);xlabel('f (Hz)');ylabel('R_{lim}(\omega)')

subplot(2,2,4)
YN = fftshift(fft(yn));
plot(f,abs(YN),'b');title('Sinal corrompido por ru�do AWG');xlim([0 Fs/2]);xlabel('f (Hz)');ylabel('Y(\omega) + R_{lim}(\omega)')


% Espectros dos sinais ap�s filtrados
figure;
subplot(2,2,1) 
Y_b = fftshift(fft(y_b));
plot(f,abs(Y_b),'k');title('Sinal ap�s o filtro Butterworth');xlim([0 Fs/2]);xlabel('f (Hz)');ylabel('Y_{Butter}(\omega)')

subplot(2,2,2)
Y_c1 = fftshift(fft(y_c1));
plot(f,abs(Y_c1),'k');title('Sinal ap�s o filtro Chebyshev I');xlim([0 Fs/2]);xlabel('f (Hz)');ylabel('Y_{ChebyI}(\omega)')

subplot(2,2,3)
Y_c2 = fftshift(fft(y_c2));
plot(f,abs(Y_c2),'k');title('Sinal ap�s o filtro Chebyshev II');xlim([0 Fs/2]);xlabel('f (Hz)');ylabel('Y_{ChebyII}(\omega)')

subplot(2,2,4)
Y_e = fftshift(fft(y_e));
plot(f,abs(Y_e),'k');title('Sinal ap�s o filtro El�ptico');xlim([0 Fs/2]);xlabel('f (Hz)');ylabel('Y_{Ellip}(\omega)')

print('filtrados_f','-dpng','-r700')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Reprodu��o do �udio
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

p = audioplayer(yn, Fs);
play(p);
pause(8)
q_b = audioplayer(y_b, Fs);
play(q_b);
% pause(8)
% q_c1 = audioplayer(y_c1, Fs);
% play(q_c1);
% pause(8)
% q_c2 = audioplayer(y_c2, Fs);
% play(q_c2);
% pause(8)
% q_e = audioplayer(y_e, Fs);
% play(q_e);



















