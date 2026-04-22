
% Parametrar
fs = 500;
T = 10;
N = fs * T;
dt = 1/fs;
df = fs/N; % frequency resolution

%index och tid vektorer
n = 0:N-1;
t = n * dt;

% signaler
A = 1.0; 
B = 0.8;
fh = 1.2; % ger hjärtslag på 72 BPM
fi = 50; %från sjukhuset

% vågorna
hjarta = A * sin(2*pi*fh*t);
brus = 0.2 * randn(1,N); % elektroniskt fuzz
storning = B * sin(2*pi*fi*t);

ekgsignal = hjarta + brus + storning;

% FFT
X = fft(ekgsignal);

amp = 2*abs(X)/N;
amp(1) = abs(X(1)) / N; % DC för just index 1 ska ej dubbleras
f = n * df;

%leta hjärtats peak
[~, idx] = max(amp(6:31));
idx_hjarta = idx + 5;
hjarta_freq = (idx_hjarta - 1) * df;

% leta ströningspeak
[~, idx1] = max(amp(401:601));
idx1_storning = idx1 + 400;
storning_freq = (idx1_storning - 1) * df;
BPM = hjarta_freq * 60;

% filtrering
X_filtrerad = X;
X_filtrerad(491:511) = 0; % tar bort störningen
X_filtrerad(4491:4511) = 0; % ta bort spegling

% invers
filtrerad = real(ifft(X_filtrerad));

fprintf('Hjärtfrekvens: %.1f Hz\n', hjarta_freq);
fprintf('Störningsfrekvens: %.1f Hz\n', storning_freq);
fprintf('Slag per minut: %.1f BPM\n', BPM);
fprintf('Frekvens uppslösning: %.1f Hz\n', df);

figure(1)
subplot(3,1,1)
plot(t(1:500), hjarta(1:500));
title("Ren signal av hjärtat");
xlabel("Tid i s");
ylabel("Amplitud")

subplot(3,1,2)
plot(t(1:500), ekgsignal(1:500));
title("Sjukhusets EKG");
xlabel("Tid i s");
ylabel("Amplitud")

subplot(3,1,3)
plot(t(1:500), filtrerad(1:500));
title("Filtrerad signal")
xlabel("Tid i s");
ylabel("Amplitud");

figure(2)
plot(f(1:N/2+1), amp(1:N/2+1));
xlim([0 100])
title("Amplitud spektrumet")
xlabel("Frekvens i Hz")
ylabel("Amplitud")
hold on;        
plot(hjarta_freq, amp(idx_hjarta), "ro", "MarkerSize", 10);                                                          
plot(storning_freq, amp(idx1_storning), "ro", "MarkerSize", 10);

figure(3)
plot(t(1:500), ekgsignal(1:500));
hold on;
plot(t(1:500), filtrerad(1:500));
legend("EKG signal", "Filtrerad")
title("Jämförelse mellan den givna EKG signalen och den filtrerade signalen")
xlabel("Tid i s")
ylabel("Amplitud")

saveas(figure(1), fullfile('~/Desktop', 'figur1.png'));                                                              
saveas(figure(2), fullfile('~/Desktop', 'figur2.png'));                                                              
saveas(figure(3), fullfile('~/Desktop', 'figur3.png'));      
