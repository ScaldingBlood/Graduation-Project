function [ res, flag, count1, count2, lowX, lowY, lowZ ] = stepDetect( frame, flag, count1, count2, lowX, lowY, lowZ )
%STEPDETECT 计步器
%  通过线性加速度为0的情况判断
FILTERING_VALAUE = 0.84;

x = frame(1);
y = frame(2);
z = frame(3);
lowX = lowX * FILTERING_VALAUE + x * (1 - FILTERING_VALAUE);
lowY = lowY * FILTERING_VALAUE + y * (1 - FILTERING_VALAUE);
lowZ = lowZ * FILTERING_VALAUE + z * (1 - FILTERING_VALAUE);
acc = norm([lowX, lowY, lowZ]);
accLine = acc - 9.8;
res = 0;
if accLine > 6 || accLine < -5
    flag = 0;
    return;
end
if flag == 0
    count2 = 0;
    if accLine >= 0.5
        flag = 1;
    end
elseif flag == 1
    count1 = 0;
    if accLine < 0.5
        flag = 4;
    elseif accLine >= 0.9
        flag = 2;
    end
elseif flag == 4
    if count2 >= 10
        flag = 0;
    elseif accLine >= 0.5
        flag = 1;
    else
        count2 = count2 + 1;
    end
elseif flag == 2
    count1 = count1 + 1;
    if count1 > 100
        flag = 0;
    elseif accLine >= 0.9
        flag = 2;
    elseif accLine < -0.5
        flag = 3;
    end
elseif flag == 3
    flag = 6;
elseif flag == 6
    res = 1;
    flag = 0;
end
end

