function [ sum ] = calMagAng( vectors )
%CALMAGANG 维护一个队列，队列中的元素为n秒的均值，然后用队头减队尾来计算变化角度值
%   队列长度为8秒
%   取2秒均值
%   传入的数据为0.1秒均值
ThAng = 2/5 * pi;
sum = 0;
flag = 0;
countFail = 0;
intervalSize = 30;
angs = [];
for i = 0 : 1 :  size(vectors, 1) -120
%     elements = [mean(vectors(i + 1 : i + 20, :)); mean(vectors(i + 21 : i + 40, :)); mean(vectors(i + 41 : i + 60, :)); mean(vectors(i + 61 :i + 80, :))];
%     bigQueue = [mean(vectors(i + 1 : i + 30, :)); mean(vectors(i + 271 : i + 300, :))];
    smallQueue = [mean(vectors(i + 1 : i + 30, :)); mean(vectors(i + 91 : i + 120, :))];

    ang = abs(getMagAngle([smallQueue(2, 2:4), smallQueue(2, (8:10))]) - getMagAngle([smallQueue(1, 2:4), smallQueue(1, (8:10))]));
    if ang > pi
        ang = 2*pi - ang;
    end
    angs = [angs, ang / pi * 180];
    if ang > ThAng 
        countFail = 0;
        if flag == 0
            flag = 1;
            fprintf('mag: %.1f\n', (i + 90)/10 + 5);
            sum = sum + 1;
        end
    elseif ang <= ThAng && flag == 1
        countFail = countFail +  1;
        if(countFail == intervalSize)
            flag = 0;
            countFail = 0;
        end
    end
%     elements = [elements(2:4, :); mean(vectors(i : i + 20, :))];
end
x = 14 : 0.1 : 5 + size(vectors, 1)/ 10 - 3;
% x = 0 : 5 : size(vectors, 1) - 120;
plot(x, angs, 'k');
hold off;
end