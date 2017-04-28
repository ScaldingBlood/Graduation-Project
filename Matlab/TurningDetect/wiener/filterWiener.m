function [ output_args ] = filterWiener( input_args )
%FILTERWIENER 此处显示有关此函数的摘要
%   用于wiener消除角速度噪声
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
    beforeWiener = [];
    afterWiener = [];
    noise = [];
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
        if count < 16
            noise = [noise, ang];
        else
            beforeWiener = [beforeWiener, ang];
            frameAngBefore = [frameAngBefore, sum(ang)];
            tmp = [noise, ang];
            [angAfter, no] = WienerNoiseReduction(tmp', 100, 16 * 1.28);
            angAfter = angAfter';
            ang = angAfter(128 * 16 + 1 : 128*17);
            afterWiener = [afterWiener, ang];
            frameAngAfter = [frameAngAfter, sum(ang)];
        end
        count = count + 1;
    end
    figure(3);
    plot(beforeWiener);
    hold on;
    plot(afterWiener);
    hold off;
    
    temp1 = [];
    for k = 3 : length(frameAngBefore)
        temp1 = [temp1, frameAngBefore(k) + frameAngBefore(k -1) + frameAngBefore(k -2)];
    end
    temp2 = [];
    for k = 3 : length(frameAngAfter)
        temp2 = [temp2, frameAngAfter(k) + frameAngAfter(k -1) + frameAngAfter(k -2)];
    end
    
    figure(2);
    plot(temp1);
%     set(gca,'YTick',-200 : 20: 200);
    hold on;
    plot(temp2);
    hold off;
 end
end

