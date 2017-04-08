function [] = analyze( )
%ANALYZE 获取两个步伐之间的序列并进行比较
path = 'E:\TurnData\';
files = dir(path);
for f = 3 : length(files)
data = importdata([path, files(f).name]);
fprintf('%s \n', files(f).name);
flag = 0; count1 = 0; count2 = 0; lowX = 0; lowY = 0; lowZ = 0;
tmp = []; %画检测到一步的图
accs = [];

last1 = 0;
last2 = 0;
last3 = 0;
    
fea1 = [];
fea2 = [];
    
res1 = [];
res2 = [];
for i = 300 : length(data) - 200
    [res, flag, count1, count2, lowX, lowY, lowZ] = stepDetect(data(i, 2:4), flag, count1, count2, lowX, lowY, lowZ);
    accs = [accs, norm(data(i, 2:4)) - 9.8];
    if res == 1 && (isempty(tmp) || i - tmp(length(tmp)) > 20)
%         fprintf('%.2f  ', i / 100);
        tmp = [tmp, i];

        if last1 ~= 0 && last2 ~= 0 && last3 ~= 0
            fea1 = data(last3:last2 -1, :);
            fea2 = data(last1:i -1, :);
            acc1 = [];
            acc2 = [];
            gyr1 = [];
            gyr2 = [];
            for j = 1 : length(fea1)
                acc1 = [acc1, norm(fea1(j, 2:4))];
                gyr1 = [gyr1, norm(fea1(j, 5:7))];
            end 
            for j = 1 : length(fea2)
                acc2 = [acc2, norm(fea2(j, 2:4))];
                gyr2 = [gyr2, norm(fea2(j, 5:7))];
            end
            fprintf('%d,%d %d,%d\n', length(acc1), length(acc2), length(gyr1), length(gyr2));
            len = min(length(acc1), length(acc2));
            c1 = corrcoef(acc1(1:len), acc2(1:len));
            c2 = corrcoef(gyr1(1:len), gyr2(1:len));
            res1 = [res1, c1(1,2)];
            res2 = [res2, c2(1,2)];
        end
        last3 = last2;
        last2 = last1;
        last1 = i;
    end
end


% plot(3 : 0.01 : length(data)/100 - 2, accs./15, '.-');
% hold on;
% plot(tmp./100, zeros(length(tmp)), '*');
% hold off;
% plot(tmp(4: length(tmp))./100, res1);
plot(res1);
hold on;
% plot(tmp(4: length(tmp)), res2);
plot(res2);
hold off;

end
end

