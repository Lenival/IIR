
Ars_grilo = 80;

% Filtro passa grilo 1
[N_passa_grilo1, Wp_passa_grilo1] = ellipord([3000 9000]/(Fs/2),[2950 9050]/(Fs/2),Arp,Ars_grilo);
[z_passa_grilo1,p_passa_grilo1,k_passa_grilo1] = ellip(N_passa_grilo1,Arp,Ars_grilo,Wp_passa_grilo1,'bandpass');
[sos_passa_grilo1,g_passa_grilo1] = zp2sos(z_passa_grilo1,p_passa_grilo1,k_passa_grilo1);
sos_passa_grilo1(1,1:3) = sos_passa_grilo1(1,1:3).*real(g_passa_grilo1);
y_passa_grilo1 = sosfilt(sos_passa_grilo1,y(:,1));

% Filtro passa grilo 2
[N_passa_grilo2, Wp_passa_grilo2] = ellipord([6000 9000]/(Fs/2),[5950 9050]/(Fs/2),Arp,Ars_grilo);
[z_passa_grilo2,p_passa_grilo2,k_passa_grilo2] = ellip(N_passa_grilo2,Arp,Ars_grilo,Wp_passa_grilo2,'bandpass');
[sos_passa_grilo2,g_passa_grilo2] = zp2sos(z_passa_grilo2,p_passa_grilo2,k_passa_grilo2);
sos_passa_grilo2(1,1:3) = sos_passa_grilo2(1,1:3).*real(g_passa_grilo2);
y_passa_grilo2 = sosfilt(sos_passa_grilo2,y(:,1));

% Filtro rejeita grilo
[N_r_grilo, Wp_r_grilo] = ellipord([4500 9000]/(Fs/2),[4450 9050]/(Fs/2),Arp,Ars_grilo);
[z_r_grilo,p_r_grilo,k_r_grilo] = ellip(N_r_grilo,Arp,Ars_grilo,Wp_r_grilo,'stop');
[sos_r_grilo,g_r_grilo] = zp2sos(z_r_grilo,p_r_grilo,k_r_grilo);
sos_r_grilo(1,1:3) = sos_r_grilo(1,1:3).*real(g_r_grilo);
y_r_grilo = sosfilt(sos_r_grilo,y(:,1));

figure;subplot(3,1,2);plot(f,abs(fftshift(fft(y_passa_grilo1)))/L);subplot(3,1,3);plot(f,abs(fftshift(fft(y_passa_grilo2)))/L);subplot(3,1,1);plot(f,abs(fftshift(fft(y(:,1))))/L)

% Reproduz audio
p = audioplayer(y(:,1), Fs);
play(p);
pause(8);
% Reproduz grilo
q_passa_grilo1 = audioplayer(20*y_passa_grilo1, Fs);
play(q_passa_grilo1);
pause(8);
% Reproduz grilo
q_passa_grilo2 = audioplayer(20*y_passa_grilo2, Fs);
play(q_passa_grilo2);
pause(8);
% Reproduz voz sem grilo
q_r_grilo = audioplayer(y_r_grilo, Fs);
play(q_r_grilo);