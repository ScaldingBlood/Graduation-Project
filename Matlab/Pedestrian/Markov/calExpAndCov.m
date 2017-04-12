function [ u, c ] = calExpAndCov( dataset )
%CALEXPANDCOV 此处显示有关此函数的摘要
%   此处显示详细说明

for i = 1 : length(dataset)
    data = dataset{i};
    covs = [];
    means = [];
    for j = 1 : size(data, 2)
        x =data(:, j);
        m = mean(x);
        
        means = [means, m];
        covs = [covs ,x];
    end
    u{i} = means;
    c{i} = cov(covs);
end

end

