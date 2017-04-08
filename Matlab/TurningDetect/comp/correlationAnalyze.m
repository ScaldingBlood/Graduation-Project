function [ ] = correlationAnalyze()
%CORRELATIONANALYZE 对比左右脚相关性

filePath = 'E:\TurnData\';
files = dir(filePath);

for i = 3 : length(files)
    fprintf('%s\n', files(i).name);
    data = importdata([filePath, files(i).name]);
    
    last1 = 0;
    last2 = 0;
    
    fea1 = [];
    fea2 = [];
    
    res1 = [];
    res2 = [];
    
    gyrs = [];
    accs = [norm(mean(data(1:10, 2:4))), norm(mean(data(11:20, 2:4)))];
    tmp = [];
    for j = 25 :10: size(data, 1) - 200
        acc = norm(mean(data(j -4:j +5, 2:4)));
        accs = [accs, acc];
        gyr = norm(mean(data(j -4:j +5, 5:7)));
        gyrs = [gyrs, gyr];
        
        tmp1 = accs(length(accs) -1);
        tmp2 = accs(length(accs) -2);
        if tmp1 > acc && tmp1 > tmp2 && tmp1 > 11 && j -last1 > 30
            fprintf('%d \n', j - 10);
            tmp = [tmp, j - 10];
            
            % 从第三个点开始计算
            if last1 ~= 0 && last2 ~= 0
                fea1 = data(last1 : j -11, 2:7);
                len = 50;
                
                % 求加速度、角速度模的序列
                fea1acc = [];
                fea2acc = [];
                fea1gyr = [];
                fea2gyr = [];
                lent = min(min(length(fea1), length(fea2)), len);
                for k = 1 : lent
                    fea2acc = [fea2acc, norm(fea2(k, 1:3))];
                    fea1acc = [fea1acc, norm(fea1(k, 1:3))];
                    fea2gyr = [fea2gyr, norm(fea2(k, 4:6))];
                    fea1gyr = [fea1gyr, norm(fea1(k, 4:6))];
                end
                
                % 相关性
                c1 = corrcoef(fea1acc, fea2acc);
                resacc = c1(1, 2);
                res1 = [res1, abs(resacc)];
                c2 = corrcoef(fea1gyr, fea2gyr);
                resgyr = c2(1, 2);
                res2 = [res2, abs(resgyr)];
                
            end
            if  last2 ~= 0
                fea2 = data(last2 : last1 -1, 2:7);
            end
            last2 = last1;
            last1 = j -10;
        end
    end
%     plot(gyrs);
    plot(5 :10: size(data, 1) - 200, accs, '.-');
    hold on;
    plot(tmp, ones(length(tmp)).*10, '*');
    hold off;
    plot(res1);
    plot(res2);
end
end

