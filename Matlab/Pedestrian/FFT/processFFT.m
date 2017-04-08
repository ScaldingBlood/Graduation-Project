function processFFT( data )
%PROCESSFFT 展示 线性加速度 垂直加速度 水平加速度 角速度 的FFT结果
%   data = [lineAcc, lineAccV, lineAccH，gyr]
x = 1: size(data, 1);

plot(x, abs(fft(data(:,1)))), title('Acc');
axis ([1,32,0,50]);

plot(x, abs(fft(data(:,2)))), title('AccV');
axis ([1,32,0,100]);

plot(x, abs(fft(data(:,3)))), title('AccH');
axis ([1,32,0,100]);

plot(x, abs(fft(data(:,4)))), title('Gyr');
axis ([1,32,0,100]);
end

