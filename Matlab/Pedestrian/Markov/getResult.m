function [ final ] = getResult( feature, label, u, c)
%GETRESULT �ж���ȷ��

sum = 0;
% ��ʼ��������
result = [0.2, 0.2, 0.2, 0.2, 0.2];
for i =1 : size(feature, 1)
% %     
%     fprintf('label: %d ', label(i) + 1);
    
    probability = getProbability(u, c, feature(i, :));
    [true, result] = judge(feature(i, :), result, label(i), probability);
    if true == 1
        sum = sum + 1;
    end
end
final = sum / size(feature, 1);

end

