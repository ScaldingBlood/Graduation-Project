function [ ang ] = getGyrAngle( vector )
%GETGYRANGLE ��ȡ�Ƕ� ͨ�����ֽ��ٶ�
%  [accX, accY, accZ, gyrX, gyrY, gyrZ]
gyrH = [vector(1), vector(2), vector(3)] * [vector(4) , vector(5), vector(6)]'/ norm([vector(1), vector(2), vector(3)]);
ang = gyrH * 0.1;

end