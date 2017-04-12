function [ ] = processByFeature( )
%PROCESSBYFEATURE 根据特征来判断是否拐弯

filePath = 'E:\TurnData\';
files = dir(filePath);
frameLen = 128;
halfFrameLen = 64;
smallWindowLen = 5; % 5 * 0.64 = 3.2s
intervalLen = 4; % 4 * 0.64 = 2.56a
angTH = 75;

for i = 3 : length(files)
    fprintf('%s\n', files(i).name);
    data = importdata([filePath, files(i).name]);
    
    smallWindow = [];
    flag = 0;
    count = 0;
    flag2 = 0;
    count2 = 0;
    
    THvar = 1.0;
    varInc = 0.3;
    gravity = mean(data(1:500, 2:4));
    angles = [];
    tmp = [];
    for j = 501 : halfFrameLen : size(data, 1) - halfFrameLen
        frame = data(j-halfFrameLen : j + halfFrameLen -1, :);
        [gravity, THvar, varInc] = getGravity(data(j-500:j-1, 2:4), frame(:, 2:4), gravity, THvar, varInc);
        gyr = frame(:, 5:7);
        gyrV = [];
        for k = 1 : frameLen
            gyrV(k) = gyr(k, :) * gravity'/ norm(gravity);
        end
        
        ang = sum(gyrV(64:length(gyrV)) * 0.01);
        smallWindow = [smallWindow, ang];
        if length(smallWindow) >= smallWindowLen
            sumAng = abs(sum(smallWindow)) / pi * 180;
            angles = [angles, sumAng];
            if sumAng > angTH && flag == 0
                fprintf('small: %.2f\n', j/100);
                flag = 1;
                count = 0;
            elseif sumAng < angTH && flag == 1
                count = count + 1;
                if count == intervalLen
                    flag = 0;
                    count = 0;
                end
            end
            smallWindow = smallWindow(2:smallWindowLen);
        end
        
        feature = fft(gyrV, frameLen);
        tmp = [tmp, feature(1)];
        if abs(feature(1)) >= 65 && flag2 == 0
            fprintf('%.2f feature\n', j/100);
            flag2 = 1;
            count2 = 0;
        elseif abs(feature(1)) < 65 && flag2 == 1
            count2 = count2 + 1;
            if count2 == intervalLen
                flag2 = 0;
                count2 = 0;
            end
        end
    end
%     plot(angles);
    plot(tmp);
    
end


end

