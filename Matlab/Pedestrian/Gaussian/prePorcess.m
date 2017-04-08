function [ dataset ] = prePorcess( data, label, dataset )
%PREPORCESS 此处显示有关此函数的摘要
%   此处显示详细说明
data1 = dataset{1};
data2 = dataset{2};
data3 = dataset{3};
data4 = dataset{4};
data5 = dataset{5};
for i = 1 : length(label)
    if label(i) == 0
        data1 = [data1; data(i, :)];
    elseif label(i) == 1
        data2 = [data2; data(i, :)];
    elseif label(i) == 2
        data3 = [data3; data(i, :)];
    elseif label(i) == 3
        data4 = [data4; data(i, :)];
    elseif label(i) == 4
        data5 = [data5; data(i, :)];
    end
end
dataset = {data1, data2, data3, data4, data5};
end

