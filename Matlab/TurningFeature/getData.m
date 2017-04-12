function [ vectors ] = getData( )
%GETDATA 从文件读取数据
    filePath = 'E:\TurnData\';
    files = dir(filePath);
    filesLen = length(files);
    data = [];
    for i = 3 : filesLen
        tmp = importdata([filePath, files(i).name]);
        data = [data; tmp];
    end
    vectors = processData(data);
end

