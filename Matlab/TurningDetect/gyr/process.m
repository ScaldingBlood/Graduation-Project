function [ sum ] = process( vectors, name )
%PROCESS vectors 一个文件的数据
smallWindowSize = 50;
% mediumWindowSize = 60;
largeWindowSize = 300;
intervalSize = 30;
smallWindow = [];
% mediumWindow = [];
largeWindow = [];
flagA = -10;
% flagB = -10;

stopA = 0;
countA = 0;
% stopB = 0;
% countB = 0;
stopC = 0;
countC = 0;
sum = 0;

angs = [];
angm = [];
angl = [];
for i = 1 : size(vectors, 1)
    if i < smallWindowSize
        smallWindow = [smallWindow; vectors(i,:)];
    else
        smallWindow = [smallWindow; vectors(i,:)];
        [res, ang] = judge(smallWindow);
        angs = [angs, ang / pi * 180];
        if stopA == 1 && res ==0
            countA = countA + 1;
            if countA == intervalSize 
                countA = 0;
                stopA  = 0;
            end
        end
        if res == 1 
            countA = 0;
            if stopA == 0 && stopC == 0
%                 && stopB == 0 
                fprintf('%.1f  small\n', 0.1 * i + 5);
                sum = sum + 1;
                flagA = i;
                stopA = 1;
            else
                flagA = flagA + 1;
            end
        end
        smallWindow = smallWindow(2:smallWindowSize, :);
    end
    
%     if i < mediumWindowSize
%         mediumWindow = [mediumWindow; vectors(i,:)];
%     else
%         mediumWindow = [mediumWindow; vectors(i,:)];
%         [res, ang2] = judge(mediumWindow);
%         angm = [angm, ang2/ pi * 180];
%         if res == 0 && stopB == 1
%             countB = countB + 1;
%             if countB == intervalSize 
%                 countB = 0;
%                 stopB  = 0;
%             end
%         end
%         if res == 1
%             countB = 0;
%             if stopB == 0 && stopC == 0
%                 if flagA < i - mediumWindowSize 
%                     fprintf('%.1f  medium\n', 0.1 * i + 5);
%                     sum = sum + 1;
%                     flagB = i;
%                     stopB = 1;
%                 end
%             else
%                 flagB = flagB +1;
%             end
%         end
%         mediumWindow = mediumWindow(2:mediumWindowSize, :);
%     end
    
    if i < largeWindowSize
        largeWindow = [largeWindow; vectors(i,:)];
    else
        largeWindow = [largeWindow; vectors(i,:)];
        [res, ang3] = judge(largeWindow);
        angl = [angl, ang3 / pi * 180];
        if res == 0 && stopC == 1
            countC = countC + 1;
            if countC == intervalSize 
                countC = 0;
                stopC  = 0;
            end
        end
        if res == 1
            countC = 0;
            if stopC == 0
                if flagA < i - largeWindowSize 
%                     && flagB < i - largeWindowSize
                    fprintf('%.1f  large\n', 0.1 * i + 5);
                    sum = sum + 1;
                    stopC = 1;
                end
            end
        end
        largeWindow = largeWindow(2:largeWindowSize, :);
    end
end
x = 10: 0.1 :size(vectors, 1) /10 + 5;
% xm = 11: 0.1 : size(vectors, 1)/10 + 5;
xl = 35: 0.1 : size(vectors, 1)/10 + 5;

% angFFT = abs((fft(angs, 512)));
% leng = size(vectors, 1) - smallWindowSize +1;

% plot(1 : (leng), temp(1:length(temp)));
% for i = 50 : 512 - 50
%     angFFT(i) = 0;
% end
% angs2 = ifft(angFFT);


plot(x, angs, 'b', xl, angl, 'g');
hold on;
% plot(10:0.1:61.1, angs2, 'r');
title(name);
xlabel('t/s');
ylabel('deg');
ylim([0, 180]);
% hold on;
end