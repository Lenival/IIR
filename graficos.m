
%% Audio original no tempo
figure1 = figure;
plot(t,y(:,1));         % ,'DurationTickFormat','mm:ss'
title('Audio original')
xlabel('t (s)')
ylabel('y(t)')
grid on
grid minor
print('graficos\audio_t','-dpng','-r700')
%saveas(figure1,'audio.png')

%% Audio original na frequência
figure2 = figure;
plot(f,abs(Y),'k');         % ,'DurationTickFormat','mm:ss'
title('Espectro do audio origina')
xlabel('f (Hz)')
xlim([0 3000]);
ylabel('Y(f)')
grid on
grid minor
print('graficos\audio_f','-dpng','-r700')
%saveas(figure1,'audio.png')

%% Ruído Limitado em faixa
figure3 = figure;
plot(t,ruido_limitado);        
title('Ruído Limitado em faixa')
xlabel('t (s)')
ylabel('r(t)')
grid on
grid minor
print('graficos\ruido_limitado_t','-dpng','-r700')

%% Espectro do ruído Limitado em faixa
figure4 = figure;
plot(f,abs(R_limitado),'k');        
title('Espectro do ruído Limitado em faixa')
xlabel('f (Hz)')
xlim([0 3000]);
ylabel('R(f)')
grid on
grid minor
print('graficos\ruido_limitado_f','-dpng','-r700')

%% Sinal degradado
figure5 = figure;
plot(t,yn);        
title('Sinal degradado')
xlabel('t (s)')
ylabel('(y+r)(t)')
grid on
grid minor
print('graficos\sinal_ruido_t','-dpng','-r700')

%% Espectro do sinal degradado
figure6 = figure;
plot(f,abs(YN),'k')  
title('Espectro do sinal degradado')
xlabel('f (Hz)')
xlim([0 3000]);
ylabel('(Y+R)(f)')
grid on
grid minor
print('graficos\sinal_ruido_f','-dpng','-r700')

%% Sinais filtrados
figure7 = figure;
%subplot(2,2,1)
plot(t,y_b);title('Sinal após o filtro Butterworth');xlabel('t (s)');ylim([-0.03 0.05]);ylabel('y_{Butter}(t)');grid on;grid minor;
print('graficos\filtrados_t_b','-dpng','-r700')


figure8 = figure;
%subplot(2,2,2)
plot(t,y_c1);title('Sinal após o filtro Chebyshev I');xlabel('t (s)');ylim([-0.03 0.05]);ylabel('y_{ChebyI}(t)');grid on;grid minor;
print('graficos\filtrados_t_c1','-dpng','-r700')


figure9 = figure;
%subplot(2,2,3)
plot(t,y_c2);title('Sinal após o filtro Chebyshev II');xlabel('t (s)');ylim([-0.03 0.05]);ylabel('y_{ChebyII}(t)');grid on;grid minor;
print('graficos\filtrados_t_c2','-dpng','-r700')


figure10 = figure;
%subplot(2,2,4)
plot(t,y_e);title('Sinal após o filtro Elíptico');xlabel('t (s)');ylim([-0.03 0.05]);ylabel('y_{Ellip}(t)');grid on;grid minor;
print('graficos\filtrados_t_e','-dpng','-r700')

%% Espectros filtrados
figure11 = figure;
%subplot(2,2,1) 
Y_b = fftshift(fft(y_b));
plot(f,abs(Y_b),'k');title('Sinal após o filtro Butterworth');xlim([0 3000]);xlabel('f (Hz)');ylabel('Y_{Butter}(\omega)');grid on;grid minor;
print('graficos\filtrados_f_b','-dpng','-r700')


figure12 = figure;
%subplot(2,2,2)
Y_c1 = fftshift(fft(y_c1));
plot(f,abs(Y_c1),'k');title('Sinal após o filtro Chebyshev I');xlim([0 3000]);xlabel('f (Hz)');ylabel('Y_{ChebyI}(\omega)');grid on;grid minor;
print('graficos\filtrados_f_c1','-dpng','-r700')


figure13 = figure;
%subplot(2,2,3)
Y_c2 = fftshift(fft(y_c2));
plot(f,abs(Y_c2),'k');title('Sinal após o filtro Chebyshev II');xlim([0 3000]);xlabel('f (Hz)');ylabel('Y_{ChebyII}(\omega)');grid on;grid minor;
print('graficos\filtrados_f_c2','-dpng','-r700')


figure14 = figure;
%subplot(2,2,4)
Y_e = fftshift(fft(y_e));
plot(f,abs(Y_e),'k');title('Sinal após o filtro Elíptico');xlim([0 3000]);xlabel('f (Hz)');ylabel('Y_{Ellip}(\omega)');grid on;grid minor;
print('graficos\filtrados_f_e','-dpng','-r700')


%% Filtro com prolblema de ordem

figure15 = figure;
[hz1, hp1, ht1] = zplane(Z_b,P_b);
hold on
set(findobj(hz1, 'Type', 'line'), 'Color', 'r');
set(findobj(hp1, 'Type', 'line'), 'Color', 'r');

[hz2, hp2, ht2] = zplane(B_b,A_b);
set(findobj(hz2, 'Type', 'line'), 'Color', 'k');
set(findobj(hp2, 'Type', 'line'), 'Color', 'k');

xlim([-5000 5500])
ylim([9000 17000])
% 
% hz1.DisplayName = 'fatorado';
% hz2.DisplayName = 'polinômio';
% hp1.DisplayName = 'fatorado';
% hp2.DisplayName = 'polinômio';
% 
ht1.set('HandleVisibility','off')
ht2.set('HandleVisibility','off')
legend('fatorado','fatorado','polinômio','polinômio');

grid on
grid minor
print('graficos\z_plane_zpk_tf','-dpng','-r700')


%% Polos e Zeros

% Projeto do Butterworth
figure16 = figure;
[hz_b, hp_b, ht_b] = zplane(z_b,p_b);
hold on
set(findobj(hz_b, 'Type', 'line'), 'Color', 'r');
set(findobj(hp_b, 'Type', 'line'), 'Color', 'r');
set(findobj(ht_b, 'Type', 'line'), 'Color', 'k');
set(findobj(ht_b, 'Type', 'line'), 'LineWidth', 1.5);
legend('zeros','polos','|z|=1');

xlim([0.85 1.0])
ylim([0.21 0.33])

grid on
grid minor
print('graficos\zp_b','-dpng','-r700')

% Plot de curvas de magnitude e fase
fvt_b = fvtool(sos_b,'Analysis','freq');
fvt_b.Fs = Fs;
legend(fvt_b,'Butterworth','Butterworth');
xlim([1.5 2.5]);
ylim([-400 50]);
print('graficos\mag_pha_b','-dpng','-r700');

% Projeto do Chebyshev I  
figure17 = figure;
[hz_c1, hp_c1, ht_c1] = zplane(z_c1,p_c1);
hold on
set(findobj(hz_c1, 'Type', 'line'), 'Color', 'r');
set(findobj(hp_c1, 'Type', 'line'), 'Color', 'r');
set(findobj(ht_c1, 'Type', 'line'), 'Color', 'k');
set(findobj(ht_c1, 'Type', 'line'), 'LineWidth', 1.5);
legend('zeros','polos','|z|=1');

xlim([0.85 1.0])
ylim([0.21 0.33])

grid on
grid minor
print('graficos\zp_c1','-dpng','-r700')

% Plot de curvas de magnitude e fase
fvt_c1 = fvtool(sos_c1,'Analysis','freq');
fvt_c1.Fs = Fs;
legend(fvt_c1,'Chebyshev I','Chebyshev I')
pause(2)
xlim([1.5 2.5])
ylim([-400 50])
print('graficos\mag_pha_c1','-dpng','-r700')

% Projeto do Chebyshev II
figure18 = figure;
[hz_c2, hp_c2, ht_c2] = zplane(z_c2,p_c2);
hold on
set(findobj(hz_c2, 'Type', 'line'), 'Color', 'r');
set(findobj(hp_c2, 'Type', 'line'), 'Color', 'r');
set(findobj(ht_c2, 'Type', 'line'), 'Color', 'k');
set(findobj(ht_c2, 'Type', 'line'), 'LineWidth', 1.5);
legend('zeros','polos','|z|=1');

xlim([0.85 1.0])
ylim([0.21 0.33])

grid on
grid minor
print('graficos\zp_c2','-dpng','-r700')

% Plot de curvas de magnitude e fase
fvt_c2 = fvtool(sos_c2,'Analysis','freq');
fvt_c2.Fs = Fs;
legend(fvt_c2,'Chebyshev II','Chebyshev II')
pause(2)
xlim([1.5 2.5])
ylim([-400 50])
print('graficos\mag_pha_c2','-dpng','-r700')

% Projeto do Elíptico
figure19 = figure;
[hz_e, hp_e, ht_e] = zplane(z_e,p_e);
hold on
set(findobj(hz_e, 'Type', 'line'), 'Color', 'r');
set(findobj(hp_e, 'Type', 'line'), 'Color', 'r');
set(findobj(ht_e, 'Type', 'line'), 'Color', 'k');
set(findobj(ht_e, 'Type', 'line'), 'LineWidth', 1.5);
legend('zeros','polos','|z|=1');

xlim([0.85 1.0])
ylim([0.21 0.33])

grid on
grid minor
print('graficos\zp_e','-dpng','-r700')

% Plot de curvas de magnitude e fase
fvt_e = fvtool(sos_e,'Analysis','freq');
fvt_e.Fs = Fs;
legend(fvt_e,'Elíptico','Elíptico')
pause(2)
xlim([1.5 2.5])
ylim([-400 50])
print('graficos\mag_pha_e','-dpng','-r700')

%% Filtro com prolblema de ordem

figure20 = figure;
[hz1, hp1, ht1] = zplane(Z_b,P_b);
hold on
set(findobj(hz1, 'Type', 'line'), 'Color', 'r');
set(findobj(hp1, 'Type', 'line'), 'Color', 'r');

[hz2, hp2, ht2] = zplane(B_b,A_b);
set(findobj(hz2, 'Type', 'line'), 'Color', 'k');
set(findobj(hp2, 'Type', 'line'), 'Color', 'k');

xlim([-5000 5500])
ylim([9000 17000])
% 
% hz1.DisplayName = 'fatorado';
% hz2.DisplayName = 'polinômio';
% hp1.DisplayName = 'fatorado';
% hp2.DisplayName = 'polinômio';
% 
ht1.set('HandleVisibility','off')
ht2.set('HandleVisibility','off')
legend('fatorado','fatorado','polinômio','polinômio');

grid on
grid minor
print('graficos\z_plane_zpk_tf','-dpng','-r700')








