function [ gravity, THvar, varInc ] = getGravity( history, acc, gravity, THvar, varInc )
%GETGRAVITY ÖØÁ¦¼ì²â
originTHvar = 1.0;
hardThreshold = 1.5;
inc = 0.3;
mAcc = mean(acc);
v = norm(var(acc));
if norm(mAcc - gravity) > 4
    THvar = originTHvar;
end
if v < hardThreshold
    if v < THvar
        gravity = mAcc;
        THvar = (v + THvar) / 2;
        varInc = THvar * inc;
    else
        THvar = varInc + THvar;
    end
else
    gravity = mean(history);
end
end