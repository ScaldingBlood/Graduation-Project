function [ vectors ] = getData(  )
%GETDATA 从文件取数据
filePath = 'E:\TurnData\';
files = dir(filePath);
filesLen = length(files);

for i = 3 : filesLen
    fprintf('%s: \n', files(i).name);
    data = importdata([filePath, files(i).name]);
    
    THvar = 1.0;
    varInc = 0.1;
    gravity = mean(data(1:500, 2:4)) - 10;
    vectors = [];
    for j = 511 : 10 : size(data, 1) -10
        history = data(j - 500 : j, :);
        now = data(j-9 : j+10, :);
        [gravity, THvar, varInc] = getGravity(history(: , 2:4), now(:, 2:4), gravity, THvar, varInc);
        vector = mean(now);
        vector(2:4) = gravity(1:3);
        vectors = [vectors; vector];
    end
%     res = process(vectors, files(i).name);
    res2 = calMagAng(vectors);
%     fprintf('sum = %d \n', res);
    fprintf('sum2 = %d \n', res2);
end


end

