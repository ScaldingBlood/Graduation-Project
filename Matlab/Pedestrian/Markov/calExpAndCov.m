function [ u, c ] = calExpAndCov( dataset )
%CALEXPANDCOV �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��

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

