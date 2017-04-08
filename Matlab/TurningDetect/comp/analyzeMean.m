function [] = analyzeMean( )
%ANALYZE 获取两个步伐之间的序列并进行比较
path = 'E:\TurnData\';
files = dir(path);
for f = 3 : length(files)
data = importdata([path, files(f).name]);
fprintf('%s \n', files(f).name);
flag = 0; count1 = 0; count2 = 0; lowX = 0; lowY = 0; lowZ = 0; % 用于计步器
tmp = []; %画检测到一步的时间点的序列图
accs = []; %所有的加速度数据，用于计步器

last = 0; % 上次检测到步伐的时间
fea = []; % 当前检测到的序列
    
target = 0; % 希望下次出现的脚步 有1、2两个值，对应两种不用长度的序列
normalAcc1 = 0; % 长序列的加速度均值
normalAcc2 = 0; % 短序列的加速度均值
normalGyr1 = 0; % 长序列的角速度均值
normalGyr2 = 0; % 短序列的角速度均值
sum1 = 0; sum2 = 0;
reaAcc = []; % 加速度相关系数序列
resGyr = []; % 角速度相关系数序列
for i = 300 : length(data) - 200
    [res, flag, count1, count2, lowX, lowY, lowZ] = stepDetect(data(i, 2:4), flag, count1, count2, lowX, lowY, lowZ);
    accs = [accs, norm(data(i, 2:4)) - 9.8];
    if res == 1 && (isempty(tmp) || i - tmp(length(tmp)) > 20)
%         fprintf('%.2f  ', i / 100);
        tmp = [tmp, i];
%         isOneStep = 0; % 是否走了一步
        if last ~= 0
            %             fprintf('%d,%d %d,%d\n', length(acc1), length(acc2), length(gyr1), length(gyr2));
            fea = data(last:i -1, :); % 一步
            acc = []; % 一步的加速度序列
            gyr = []; % 一步的角速度序列
            
            len = length(fea);
            fprintf('%d %d\n ',len, i);
            for j = 1 : len
                acc = [acc, norm(fea(j, 2:4))];
                gyr = [gyr, norm(fea(j, 5:7))];
            end 
            if len > 55 && target < 2 && i < 800 %长序列
%                 isOneStep = 1;
                minLen = min(len, length(normalAcc1));
                normalAccTmp1 = (normalAcc1(1:minLen).*sum1 + acc(1:minLen))./(sum1 + 1);
                normalGyrTmp1 = (normalGyr1(1:minLen).*sum1 + gyr(1:minLen))./(sum1 + 1);
                if(minLen < length(normalAcc1))
                    normalAcc1 = [normalAccTmp1, normalAcc1(len +1:length(normalAcc1))];
                    normalGyr1 = [normalGyrTmp1, normalGyr1(len +1:length(normalGyr1))];
                else
                    normalAcc1 = [normalAccTmp1, acc(minLen +1:len)];
                    normalGyr1 = [normalGyrTmp1, gyr(minLen +1:len)];
                end
                sum1 = sum1 + 1;
                target = 2;
            elseif len <= 40 && (target == 0 || target == 2) && i < 800 % 短序列
%                 isOneStep = 1;
                minLen = min(len, length(normalAcc2));
                normalAccTmp2 = (normalAcc2(1:minLen).*sum2 + acc(1:minLen))./(sum2 + 1);
                normalGyrTmp2 = (normalGyr2(1:minLen).*sum2 + gyr(1:minLen))./(sum2 + 1);
                if(minLen == len)
                    normalAcc2 = [normalAccTmp2, normalAcc2(len +1:length(normalAcc2))];
                    normalGyr2 = [normalGyrTmp2, normalGyr2(len +1:length(normalGyr2))];
                else
                    normalAcc2 = [normalAccTmp2, acc(minLen +1:len)];
                    normalGyr2 = [normalGyrTmp2, gyr(minLen +1:len)];
                end
                sum2 = sum2 + 1;
                target = 1;
            end

            if i > 500 % 先采集5s数据
                len = min(len, length(normalAcc1));
                if(len > 55) % 认为长度大于55的为长序列
%                     fprintf('%d %d\n', len, length(normalAcc1));
                    len = min(len, length(normalAcc1));
                    c1 = corrcoef(acc(1:len), normalAcc1(1:len));
                    c2 = corrcoef(gyr(1:len), normalGyr1(1:len));
                    reaAcc = [reaAcc, c1(1,2)];
                    resGyr = [resGyr, c2(1,2)];
                elseif(len < 40)
                    len = min(len, length(normalAcc2));
                    c1 = corrcoef(acc(1:len), normalAcc2(1:len));
                    c2 = corrcoef(gyr(1:len), normalGyr2(1:len));
%                     reaAcc = [reaAcc, c1(1,2)];
%                     resGyr = [resGyr, c2(1,2)];
                end
                
            end
        end
        last = i;
    end
end


% plot(3 : 0.01 : length(data)/100 - 2, accs./15, '.-');
% hold on;
% plot(tmp./100, zeros(length(tmp)), '*');
% hold off;
% plot(tmp(4: length(tmp))./100, res1);
plot(reaAcc, '*-');
hold on;
% plot(tmp(4: length(tmp)), res2);
plot(resGyr, '*-');
hold off;

end
end