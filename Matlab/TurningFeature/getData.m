function [ vectors ] = getData( )
%GETDATA ���ļ���ȡ����
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

