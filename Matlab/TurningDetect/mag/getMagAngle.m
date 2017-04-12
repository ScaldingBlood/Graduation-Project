function [ ang ] = getMagAngle( vector )
%   算法来自Android源码
%   获取与地磁北极之间的夹角
%   每次传入一个[accX, accY, accZ, gyrX, gyrY, gyrZ]
A = [vector(1), vector(2), vector(3)];
E = [vector(4), vector(5), vector(6)];
H = [E(2) * A(3) - E(3) * A(2), E(3) * A(1) - E(1) * A(3), E(1) * A(2) - E(2) * A(1)];

A = A./norm(A);
H = H./norm(H);
M = [A(2) * H(3) - A(3) * H(2), A(3) * H(1) - A(1) * H(3), A(1) * H(2) - A(2) * H(1)];

ang = atan2(H(2), M(2));
end

