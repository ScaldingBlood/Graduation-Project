function [ bool, ang ] = judge( vectors )
%JUDGE vectors 一个窗口内的 vector[accX, accY, accZ, gyrX, gyrY, gyrZ, magX, magY, magZ]
%   此处显示详细说明
angTH = 2/5 * pi;
angGyr = 0;
angMag = 0;
angLast = pi + 1;
tmpA = [];
tmpM = [];
tmpG = [];
for i = 1 : size(vectors, 1)
    angGyr = angGyr + getGyrAngle(vectors(i, 2:7));
    tmpG = [tmpG, getGyrAngle(vectors(i, 2:7))];
    
%     tmp = getMagAngle([vectors(i, 2:4), vectors(i, 8:10)]);
%     if angLast == pi + 1
%         angLast = tmp;
%     end
%     
%     diff = tmp - angLast;
%     if diff > pi
%         diff = 2*pi - diff;
%     elseif diff < - pi
%         diff = -2*pi - diff;
%     end
%     angMag = angMag + diff;
% 
%     angLast = tmp;
%     tmpA = [tmpA, diff];
%     tmpM = [tmpM, angMag];
end

ang = abs(angGyr);
% ang = angMag;

if ang < angTH
    bool = 0;
else
    bool = 1;
end