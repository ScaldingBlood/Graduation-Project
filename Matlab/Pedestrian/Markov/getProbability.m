function [ probability ] = getProbability( u, c, feature)
%   u 均值向量 c 协方差矩阵

probability = [];
sum = 0;
res = [];
for i = 1 : 5
    tmpu = u{i};
    tmpc = c{i};
    
    res(i) = 1 / (2 * pi) ^ 6 / sqrt(norm(c{i})) * exp(-0.5 * ((feature - u{i}) * pinv(c{i}) * (feature - u{i})'));
    sum = sum + res(i);
end
for i = 1 : 5
    if res(i) == 0
        probability(i) = 0.01;
    else
        probability(i) = res(i) / sum;
    end
end
end

