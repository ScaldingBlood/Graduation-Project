% r = [-5.33,2.48,9.29,8.11,-10.48,-22.23,-11.44,8.14,19.05,0.69,-21.42,-21.06,10.78,16.74,6.15,-16.87,-33.06,-20.19,1.28,9.18,4.05,-12.05,-29.37,-23.32,-12.32,5.54,7.32,-1.98,-3.15,-15.01,-8.55,19.52,-6.28,-7.6,-18.00,7.07,21.19,24.74,21.11,1.64,-20.24,4.30,19.81,-2.60,29.06];
% r = [0.75,-3.78,3.09,-17.92,-17.53,-4.06,-7.28,-0.23,-6.97,-18.27,-12.14,-9.45,-8.03,-4.54,-6.78,-2.81,7.94,0.46,-8.09,-14.07,-4.61,-8.34,-8.78,-5.34,-24.32,-17.81,-1.75,-0.51,-10.06,0.31,-4.26,-17.49,-13.83,8.00,10.96,-4.92,-9.69,18.34,0.49,-7.33,-29.14,-9.3,-14.5,-29.72,-22.53,-20.85,4.33,-8.58,-6.38,5.40,-11.59,-7.67,0.48,-4.21,-0.90,0.34,11.64,-6.17,7.72,-12.74,-12.41,-6.35,-23.37,-16.65,-1.77,-5.77,-9.25,7.19,5.08,-12.84,-3.36,-2.13,-22.98,-23.30,-16.59,-16.33,-13.00,-2.75,-1.30,-12.14,-9.76,-8.43,-2.97,-14.17,0.78,9.9,-16.64,-10.73,-13.94,-19.88,-8.67,-15.94,-24.19,-12.88,-2.86,-8.89,-3,-3.89,-21.26,-19.11,-1.68,-1.54,0,-4.93,-14.94,-12.09,-6.97,-10.05,-15.81,-9.89,0.24,9.16,-9.05,-17.53];
% r = [-7.08,-19.42,-19.17,12.69,-0.55,-19.34,19.05,0.41,-22.14,10.47,-7.08,-20.13,9.28,-11.25,-26.57,4.65,-12.70,-18.77,7.33,-16.60,-20.53,15.75,7.44,9.77,17.25,1.19,-20.80,11.05,-3.37,5.13,-12.49,-22.47,-5.60,-22.15,-3.94,-9.74,8.65,-11.77,-6.62,7.16,-13.63,-10.92,13.42,-8.68,-1.70,0.97,-22.09,-16.98,-7.63];
data = importdata('E:\Code\TurningDetect\long');
r1 = [];
r2 = [];
for i = 1 : length(data)
    r1 = [r1, data(i, 1)];
    r2 = [r2, data(i, 2)];
end
avgVal = [sum(r1)/length(r1), sum(r2)/length(r2)];
maxVal = [max(max(r1), abs(min(r1))), max(max(r2), abs(min(r2)))];
tmp = 0;
tmp2 = 0;
for i = 1 : length(r1)
    if r1(i) > 20 || r1(i) < -20
        tmp = tmp + 1;
    end
    if r2(i) > 20 || r2(i) < -20
        tmp2 = tmp2 + 1;
    end
end
p = [1 - tmp / length(r1), 1 - tmp2 / length(r2)];
fprintf('%f %f %f\n%f %f %f\n',avgVal(1), maxVal(1), p(1), avgVal(2), maxVal(2), p(2));