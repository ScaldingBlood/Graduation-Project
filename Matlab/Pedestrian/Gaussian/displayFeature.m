function displayFeature( dataset )
%DISPLAYFEATURE 此处显示有关此函数的摘要
% 1. 线性加速度期望 
% 2. 线性加速度方差
% 3. 垂直方向加速度期望
% 4. 垂直方向加速度方差
% 5. 水平方向加速度期望
% 6. 水平方向加速度方差
% 7. 角度
% 8. 主频率1
% 9. 主频率1的FFT振幅
% 10. 主频率2
% 11. 主频率2对应的振幅
% 12. 能量
        for i = 1 : length(dataset)
            fprintf('%d\n', i);
            data = dataset{i};
            vars = [];
            means = [];
            for j = 1 : size(data, 2)
                fprintf('%d ', j);
                x =data(:, j);
                m = mean(x);
                s = std(x);
                
                
                % 展示所得均值和方差对应的正态分布
                tmpx = m - 3*s: 0.01: m + 3*s;
                fx = normpdf(tmpx, m , s);
                plot(tmpx, fx);
                
                % 数据的频数图
                [n, xout] = hist(data(:, j), 200); 
                n = n / sum(n);
                bar(xout, n); box off
                xlim([m-3*s, m+3*s]);
                
                % 展示数据和正态分布的拟合情况
                normplot(x);
            end
            fprintf('\n');
        end
end