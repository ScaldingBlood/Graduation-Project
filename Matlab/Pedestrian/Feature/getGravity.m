function [ gravity, THvar, varInc ] = getGravity( history, acc, gravity, THvar, varInc )
%GETGRAVITY �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
originVar = 1.0;
inc = 0.3;
v = norm(var(acc));
mAcc = mean(acc);
hardTH = 1.5;
if norm(mAcc - gravity) > 4
    THvar = originVar;
end
if( v < hardTH)
    if( v < THvar) 
        gravity = mAcc;
        THvar = (v + THvar) / 2;
        varInc = THvar * inc;
    else
        THvar = THvar + varInc;
    end
else
    gravity = mean(history);
end

end

