
%% Audio original no tempo
figure1 = figure;
plot(t,y(:,1));         % ,'DurationTickFormat','mm:ss'
title('Audio original')
xlabel('t (s)')
ylabel('y(t)')
grid on
grid minor
print('audio_t','-dpng','-r700')
%saveas(figure1,'audio.png')

%% Audio original na frequência
figure2 = figure;
plot(f,abs(Y),'k');         % ,'DurationTickFormat','mm:ss'
xlabel('f (Hz)')
xlim([0 3000]);
ylabel('Y(f)')
grid on
grid minor
print('audio_f','-dpng','-r700')
%saveas(figure1,'audio.png')

%% Ruído Limitado em faixa
figure3 = figure;
plot(t,ruido_limitado);        
title('Ruído Limitado em faixa')
xlabel('t (s)')
ylabel('r(t)')
grid on
grid minor
print('ruido_limitado_t','-dpng','-r700')

%% Espectro do ruído Limitado em faixa
figure4 = figure;
plot(f,abs(R_limitado),'k');        
title('Espectro do ruído Limitado em faixa')
xlabel('f (Hz)')
xlim([0 3000]);
ylabel('R(f)')
grid on
grid minor
print('ruido_limitado_f','-dpng','-r700')

%% Sinal degradado
figure5 = figure;
plot(t,yn);        
title('Sinal degradado')
xlabel('t (s)')
ylabel('(y+r)(t)')
grid on
grid minor
print('sinal_ruido_t','-dpng','-r700')

%% Espectro do sinal degradado
figure6 = figure;
plot(f,abs(YN),'k')  
title('Espectro do sinal degradado')
xlabel('f (Hz)')
xlim([0 3000]);
ylabel('(Y+R)(f)')
grid on
grid minor
print('sinal_ruido_f','-dpng','-r700')

%% Sinais filtrados
figure7 = figure;
subplot(2,2,1)
plot(t,y_b);title('Sinal após o filtro Butterworth');xlabel('t (s)');ylim([-0.03 0.05]);ylabel('y_{Butter}(t)');grid on;grid minor;

subplot(2,2,2)
plot(t,y_c1);title('Sinal após o filtro Chebyshev I');xlabel('t (s)');ylim([-0.03 0.05]);ylabel('y_{ChebyI}(t)');grid on;grid minor;

subplot(2,2,3)
plot(t,y_c2);title('Sinal após o filtro Chebyshev II');xlabel('t (s)');ylim([-0.03 0.05]);ylabel('y_{ChebyII}(t)');grid on;grid minor;

subplot(2,2,4)
plot(t,y_e);title('Sinal após o filtro Elíptico');xlabel('t (s)');ylim([-0.03 0.05]);ylabel('y_{Ellip}(t)');grid on;grid minor;

print('filtrados_t','-dpng','-r700')

%% Espectros filtrados
figure8 = figure;
subplot(2,2,1) 
Y_b = fftshift(fft(y_b));
plot(f,abs(Y_b),'k');title('Sinal após o filtro Butterworth');xlim([0 3000]);xlabel('f (Hz)');ylabel('Y_{Butter}(\omega)');grid on;grid minor;

subplot(2,2,2)
Y_c1 = fftshift(fft(y_c1));
plot(f,abs(Y_c1),'k');title('Sinal após o filtro Chebyshev I');xlim([0 3000]);xlabel('f (Hz)');ylabel('Y_{ChebyI}(\omega)');grid on;grid minor;

subplot(2,2,3)
Y_c2 = fftshift(fft(y_c2));
plot(f,abs(Y_c2),'k');title('Sinal após o filtro Chebyshev II');xlim([0 3000]);xlabel('f (Hz)');ylabel('Y_{ChebyII}(\omega)');grid on;grid minor;

subplot(2,2,4)
Y_e = fftshift(fft(y_e));
plot(f,abs(Y_e),'k');title('Sinal após o filtro Elíptico');xlim([0 3000]);xlabel('f (Hz)');ylabel('Y_{Ellip}(\omega)');grid on;grid minor;

print('filtrados_f','-dpng','-r700')













