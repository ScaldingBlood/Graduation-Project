function [] = processFFT( vectors )
%PROCESSFFT 对三种数据做fft变换
%   采样频率100Hz 数据点数 128
fs = 100;
N = 128;
n = 0:N/2 -1;
t = n/fs;
f = n*fs / N;
for i = 1: size(vectors,1)
    frame = vectors(i, :);
    acc = frame{1};
    accV = frame{2};
    accH = frame{3};
    gyr = frame{4};
    gyrV = frame{5};
    gyrH = frame{6};
    magx = frame{7};
    magy = frame{8};
    magz = frame{9};
    accY = abs(fft(acc, N));
    gyrY = abs(fft(gyr, N));
    magxY = abs(fft(magx, N));
    magyY = abs(fft(magy, N));
    magzY = abs(fft(magz, N));
    accVY = abs(fft(accV, N));
    accHY = abs(fft(accH, N));
    gyrVY = abs(fft(gyrV, N));
    gyrHY = abs(fft(gyrH, N));

%     subplot(3, 3, 1);
%     plot((1: N/2), accY(1: N/2));
%     hold on;
%     title('acc');
% 
    subplot(2, 2, 1);
    plot((0: N/2 -1), accVY(1: N/2), '-*');
    hold on;
    title('accV');
    
    subplot(2, 2, 2);
    plot((0: N/2 -1), accHY(1: N/2), '-*');
    hold on;
    title('accH');
    
%     subplot(3, 3, 4);
%     plot((1: N/2), gyrY(1: N/2));
%     hold on;
%     title('gyr');
    
    subplot(2, 2, 3);
    plot((0: N/2 -1), gyrVY(1: N/2), '-*');
    hold on;
%     set(gca,'XTick',f);
    title('gyrV');
    
    subplot(2, 2, 4);
    plot((0: N/2 -1), gyrHY(1: N/2), '-*');
    hold on;
    title('gyrH');
%     
%     subplot(3, 3, 7);
%     plot((2: N/2), magxY(2: N/2));
%     hold on;
%     title('magX');
%     
%     subplot(3, 3, 8);
%     plot((2: N/2), magyY(2: N/2));
%     hold on;
%     title('magY');
%     
%     subplot(3, 3, 9);
%     plot((2: N/2), magzY(2: N/2));
%     hold on;
%     title('magZ');
end
hold off;
end