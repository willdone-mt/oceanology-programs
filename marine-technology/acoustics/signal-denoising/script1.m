clc;            % Membersihkan command window
clear all;      % Menghapus semua variabel dari workspace

% ========================================================================
% Membaca file audio .wav
% ========================================================================
[s, fs] = wavread('D:\Academics and Works\School\College\Semester 3\2. September\Akustik\Acara 3\Materi\whistle2.wav');   % s = sinyal asli, fs = sample rate
sig = s;                        % Menyimpan sinyal asli ke variabel 'sig'

% ========================================================================
% Parameter untuk denoising
% ========================================================================
denPAR = {[1 94 5.9; 94 1110 19.5; 1110 2000 4.5]}; % Parameter filter
wname = 'sym4';        % Nama wavelet yang digunakan ('sym4')
level = 5;             % Level dekomposisi wavelet
sorh = 's';            % Jenis thresholding ('s' = soft thresholding)
thr = 19.5;            % Nilai threshold global

% ========================================================================
% Proses denoising menggunakan wavelet
% ========================================================================
[sigden_2, cxd, lxd, perf0, perfl2] = wdencmp('gbl', sig, wname, level, thr, sorh, 1);
% wdencmp melakukan kompresi/denoising pada sinyal dengan parameter yang ditentukan

% ========================================================================
% Menghitung residual (selisih antara sinyal asli dan sinyal denoised)
% ========================================================================
res = sig - sigden_2;

% ========================================================================
% Plot sinyal asli
% ========================================================================
figure(1);
plot(sig, 'r');                 % Menampilkan sinyal asli dengan warna merah
axis tight;                     % Menyesuaikan sumbu plot agar rapat
grid on;                         % Menampilkan grid
xlabel('Frekuensi (Hz)');        % Label sumbu X
ylabel('Amplitude (kU)');        % Label sumbu Y
title('Original Signal');        % Judul grafik

% ========================================================================
% Plot sinyal setelah denoising
% ========================================================================
figure(2);
plot(sigden_2, 'b');             % Menampilkan sinyal denoised dengan warna biru
axis tight;                      
grid on;
xlabel('Time (ms)');             
ylabel('Amplitude (kU)');
title('Denoised Signal');

% ========================================================================
% Plot residual signal
% ========================================================================
figure(3);
plot(res, 'k');                  % Menampilkan sinyal residual dengan warna hitam
axis tight;
grid on;
xlabel('Frekuensi (Hz)');
ylabel('Amplitude (kU)');
title('Residual Signal');

% Menampilkan hasil kinerja denoising (nilai performa)
perf0, perfl2;

% ========================================================================
% Menyimpan hasil sinyal ke dalam file .wav (MATLAB 2013)
% ========================================================================
wavwrite(sigden_2, fs, 'D:\Academics and Works\School\College\Semester 3\2. September\Akustik\Acara 3\Processing\denoised_signal.wav');   % Simpan sinyal bersih
wavwrite(res, fs, 'D:\Academics and Works\School\College\Semester 3\2. September\Akustik\Acara 3\Processing\residual_signal.wav');        % Simpan noise yang dihapus