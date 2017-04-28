function [ output_args ] = getFrameDataIntime( input_args )
%GETFRAMEDATAINTIME 此处显示有关此函数的摘要
%   此处显示详细说明
%GETFRAMEDATA  
%   用于FFT消除角速度噪声
filePath = 'E:\TurnData\';
files = dir(filePath);
filesLen = length(files);
frameLen = 128;
smallWindowLen = 3;
for i = 3 : filesLen
    fprintf('%s: \n', files(i).name);
    data = importdata([filePath, files(i).name]);
    
    THvar = 1.0;
    varInc = 0.1;
    gravity = mean(data(1:500, 2:4));
    sumAng = [];
    sumAngFFT = [];
    count = 0;
    frame = [];
    frameAngAfter = [];
    frameAngBefore = [];
    smallWindow = [];
    beforeFFT = [];
    afterFFT = [];
    pos = 0;
    neg = 0;
    posOrNeg = 0;
    for j = 501 : frameLen : size(data, 1) -frameLen
        history = data(j - 500 : j - 1, :);
        now = data(j : j + frameLen -1, :);
        tmp = data(j - frameLen : j + frameLen -1, :);
        [gravity, THvar, varInc] = getGravity(history(: , 2:4), tmp(:, 2:4), gravity, THvar, varInc);
        gravity(1:3);
        ang = [];
        gyr = now(:, 5:7);
        for k = 1 : frameLen
            ang = [ang, (gravity(1)*gyr(k, 1) + gravity(2)*gyr(k, 2) + gravity(3)*gyr(k, 3)) / norm(gravity) * 0.01 * 180 / pi];
        end
        
        frame = [frame, ang];
        if count < 8
            count = count + 1;
            if ang < 0
                neg = neg +1;
            else
                pos = pos +1;
            end
            if pos < neg
                posOrNeg = 1;
            end
        else
            len = length(frame);
            frameAngBefore = [frameAngBefore, sum(frame(len - frameLen +1: len))];
            beforeFFT = [beforeFFT, frame(len - frameLen +1: len)];
            complex = fft(frame);
%             figure(1);
%             plot(abs(complex));
%             hold on;
            for k = floor(5 * len/1000) : len/2
                complex(k) = 0;
                complex(len - k) = 0;
            end
            plot(abs(complex));
            tmp = real(ifft(complex));
%             z = zeros(1, len);
%             z(1, len - frameLen +1: len) = ones(1, frameLen);
%             z = z * 0.05;
%             tmp = tmp + z;
            frameAngAfter = [frameAngAfter, sum(tmp(len - frameLen +1: len))];
            afterFFT = [afterFFT, tmp(len - frameLen +1: len)];
           
%             frame = frame(frameLen+1:8*frameLen);
%             count = 7;
            count = count + 1;
        end
    end
    figure(3);
    plot(beforeFFT);
    hold on;
    plot(afterFFT);
    hold off;
    
    temp1 = [];
    for k = 3 : length(frameAngBefore)
        temp1 = [temp1, frameAngBefore(k) + frameAngBefore(k -1) + frameAngBefore(k -2)];
    end
    temp2 = [];
    for k = 3 : length(frameAngAfter)
%         if posOrNeg == 0
%             temp2 = [temp2, frameAngAfter(k) + frameAngAfter(k -1) + frameAngAfter(k -2) + 5];
%         else
%             temp2 = [temp2, frameAngAfter(k) + frameAngAfter(k -1) + frameAngAfter(k -2) - 5];
%         end
        temp2 = [temp2, frameAngAfter(k) + frameAngAfter(k -1) + frameAngAfter(k -2)];
    end
    
    figure(2);
    plot(temp1);
    set(gca,'YTick',-200 : 20: 200);
    hold on;
    plot(temp2);
    hold off;
 end
end