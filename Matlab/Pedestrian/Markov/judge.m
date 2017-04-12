function [ true, result ] = judge( feature, last, label, probability)
%JUDGE 此处显示有关此函数的摘要
%   此处显示详细说明

A = [0.69, 0.2, 0.01, 0.05, 0.05; 
        0.1, 0.7, 0.1, 0.05, 0.05;
        0.01, 0.49, 0.3, 0.1, 0.1;
        0.01, 0.1, 0.1, 0.78, 0.01;
        0.01, 0.1, 0.1, 0.01, 0.78];
result = [];
sum = 0;
max = 0;
flag = 1;
for i = 1 :5
    result(i) = (last(1)*A(1, i) + last(2)*A(2, i) + last(3)*A(3, i) + last(4)*A(4, i) + last(5)*A(5, i)) * probability(i);
    if result(i) <= 0.01
        result(i) = 0.01;
    end;
% %
%     fprintf('%f ', result(i));
    sum = sum + result(i);
    if result(i) > max
        max = result(i);
        flag = i;
    end
end
for i = 1 : 5
    result(i) = result(i) / sum;
end
% % 
% fprintf('%d\n', flag);
if flag == label +1 
    true = 1;
else
    true = 0;
end
end

