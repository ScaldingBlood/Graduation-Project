 filePath = 'E:\data\';
files = dir(filePath);
filesLen = length(files);
dataset = {[],[],[],[],[]};
d = {};
l = {};
for i = 3 : filesLen 
    fprintf('%s\n', files(i).name);
    dataTmp = importdata([filePath, files(i).name]);
    [data, label] = extractFeature(dataTmp);
    l{i -2} = label;
    d{i -2} = data;
end

for i = 1 : length(d)
    dataset = prePorcess(d{i}, l{i},dataset);
end

% displayFeature(dataset);

[u, c] = calExpAndCov(dataset);
for i = 1 : length(d)
% for i = 5 : 5
    data = d{i};
    label = l{i};
    res = getResult(data, label, u, c);
    fprintf('file %s ,success rate: %f %%\n ', files(i +2).name, res * 100);
end


