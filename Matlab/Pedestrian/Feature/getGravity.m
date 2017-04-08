function [ gravity, THvar, varInc ] = getGravity( history, acc, gravity, THvar, varInc )
%GETGRAVITY 此处显示有关此函数的摘要
%   此处显示详细说明
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

