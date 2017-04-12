function [ vectors ] = processData( data )
%PROCESSDATA ����ԭʼ���ݣ���װ��128������Ϊһ֡��1.28�� ��50%���ص�����
%   ����3�����Լ��ٶȡ�3����ٶȡ�3��ش�
frameLen = 128;
gravity = mean(data( 1: frameLen * 5, 2 : 4));
THvar = 1.0;
varInc = 0.3;
vectors = [];
for i = 5 * frameLen +1: frameLen : size(data, 1) - frameLen
    acc = data(i:i + frameLen -1, 2:4);
    gyr = data(i:i + frameLen -1, 5:7);
    mag = data(i:i + frameLen -1, 8:10);
    accN = [];
    gyrN = [];
    magX = [];
    magY = [];
    magZ = [];
    accV = [];
    accH = [];
    gyrV = [];
    gyrH = [];
    [gravity, THvar, varInc] = getGravity(data(i- 5*frameLen:i-1, 2:4), acc, gravity, THvar, varInc);
    for j = 1 : size(acc, 1)
        acc(j, :) = acc(j, :) - gravity;
        tmpN = norm(acc(j,:));
        tmpV = acc(j,:) * gravity' / norm(gravity);
        tmpH = sqrt(tmpN^2 - tmpV^2);
        tmpgN = norm(gyr(j, :));
        tmpgV = gyr(j,:) * gravity'/ norm(gravity);
        tmpgH = sqrt(tmpgN^2 - tmpgV^2);
        accN = [accN; tmpN];
        accV = [accV; tmpV];
        accH = [accH; tmpH];
        gyrN = [gyrN; tmpgN];
        gyrH = [gyrH; tmpgH];
        gyrV = [gyrV; tmpgV];
        magX = [magX; mag(j, 1)];
        magY = [magY; mag(j, 2)];
        magZ = [magZ; mag(j, 3)];
    end
    
    frame = {accN, accV, accH, gyrN, gyrV, gyrH, magX, magY, magZ};
    vectors = [vectors; frame];
end

end

