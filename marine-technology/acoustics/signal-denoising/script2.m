% ========================================================================
% fftwav.m
% Program untuk memutar file audio, menampilkan spektrum waktu-frekuensi
% menggunakan spektrogram, dan melakukan analisis FFT (Fast Fourier Transform).
% ========================================================================

% ========================================================================
% Membaca file audio .wav
% ========================================================================
[y, fs, nbits] = wavread('D:\Academics and Works\School\College\Semester 3\2. September\Akustik\Acara 3\Materi\whistle2.wav'); 
% y      = data sinyal audio
% fs     = sample rate dari file audio
% nbits  = jumlah bit per sample

% ========================================================================
% Memutar audio pada sample rate asli
% ========================================================================
disp('Playing at the original sample rate.'); % Menampilkan teks ke Command Window
sound(y, fs);                                % Memutar audio dengan sample rate fs

% ========================================================================
% Menampilkan spektrum waktu-frekuensi (spectrogram)
% ========================================================================
specgram(y);               % Membuat spectrogram sinyal audio
c1 = colorbar;             % Menambahkan colorbar sebagai skala amplitudo
c1.title = '-dB';          % Memberikan judul pada colorbar sebagai skala desibel

% ========================================================================
% Menunggu interaksi pengguna sebelum melanjutkan
% ========================================================================
disp('Hit any key to continue ...'); % Instruksi untuk pengguna
pause                                 % Program berhenti sampai tombol ditekan

% ========================================================================
% Melakukan transformasi Fourier (FFT) pada sinyal audio
% ========================================================================
Y = fft(y);                 % Menghitung FFT untuk melihat domain frekuensi

% ========================================================================
% Menampilkan hasil FFT
% ========================================================================
plot(abs(Y));                % Menampilkan magnitude spektrum frekuensi
axis([0 length(Y)/2, 0 max(abs(Y))]); % Menyesuaikan sumbu X dan Y agar lebih jelas

% ========================================================================
% Memberikan label dan judul pada grafik
% ========================================================================
title('Waveform whistle sound of dolphin');  % Judul grafik
xlabel('Power (kU)');                         % Label sumbu X
ylabel('Amplitude (Ku)');                     % Label sumbu Y