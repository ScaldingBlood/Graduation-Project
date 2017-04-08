function [ output_args ] = getFrameData( )
%GETFRAMEDATA  
%   用于FFT消除角速度噪声
filePath = 'E:\TurnData\';
files = dir(filePath);
filesLen = length(files);

frameLen = 10;
for i = 3 : filesLen
    fprintf('%s: \n', files(i).name);
    data = importdata([filePath, files(i).name]);
    
    THvar = 1.0;
    varInc = 0.1;
    gravity = mean(data(1:500, 2:4));
    sumAng = [];
    sumAngFFT = [];
    for j = 501 : frameLen : size(data, 1) -frameLen
        history = data(j - 500 : j - 1, :);
        now = data(j : j + frameLen -1, :);
        tmp = data(j - frameLen : j + frameLen -1, :);
        [gravity, THvar, varInc] = getGravity(history(: , 2:4), tmp(:, 2:4), gravity, THvar, varInc);
        gravity(1:3);
        ang = [];
        for k = 1 : frameLen
            gyr = now(k, 5:7);
            ang = [ang, (gravity(1)*gyr(1) + gravity(2)*gyr(2) + gravity(3)*gyr(3)) / norm(gravity) * 0.1 * 180 / pi];
%             ang = (gravity(1)*gyr(1) + gravity(2)*gyr(2) + gravity(3)*gyr(3)) / norm(gravity) * 0.1 * 180 / pi;
        end
        sumAng = [sumAng, mean(ang)];

    end
    figure(1);
    plot(sumAng);
    hold on;

    len = length(sumAng);
    res = [];
    for k = 1 : 10: length(sumAng) -30
        res = [res, sum(sumAng(k:k+30))];
    end
    figure(3);
    plot(res);
    hold on;
    
    tmp = fft(sumAng);
    
    figure(2);
    plot(abs(tmp));
    axis([0 len/2 0 2000]);
    set(gca,'XTick',[0: 10: len/2], 'YTick',[0 : 100: 2000]);
    hold on;
    for k = round(len / 32) : round(len / 2)
        tmp(k) = 0;
        tmp(len - k) = 0;
    end
    
    figure(2);
    plot(abs(tmp));
    hold off;
    
    figure(1);
    sumAngTmp = real(ifft(tmp));
    plot(sumAngTmp);
    hold off;
    
    res = [];
    for k = 1 : 10: length(sumAngTmp) -30
        res = [res, sum(sumAngTmp(k:k+30))];
    end
    figure(3);
    plot(res);
    hold off;
end

end

