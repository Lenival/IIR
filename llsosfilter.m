function y = llsosfilter(sos,signal)
    [K,L] = size(sos);
    N = size(signal)
    % Necess�rio implementar condi��es iniciais na entrada
    wi = zeros(K,2);
    
    % Iterando sobre todo o sinal
    for n = 1:1:N
        % Iterando sobre as 6 colunas obrigat�rias da se��o
        for l = 1:1:6
           % Iterando sobra cada uma das se��es biquadr�ticas
           for k = 1:1:K

           end
        end
    end