function [ vector, label ] = extractFeature( sensorData )
%EXTRACTFEATURE �������� 
% 1. ���Լ��ٶ����� 
% 2. ���Լ��ٶȷ���
% 3. ��ֱ������ٶ�����
% 4. ��ֱ������ٶȷ���
% 5. ˮƽ������ٶ�����
% 6. ˮƽ������ٶȷ���
% 7. �Ƕ�
% 8. ��Ƶ��1
% 9. ��Ƶ��1��FFT���
% 10. ��Ƶ��2
% 11. ��Ƶ��2��Ӧ�����
% 12. ����

label = [];
vector = [];
windowSize = 32;
gravity = mean(sensorData(1 : windowSize*5, 1 : 3));   
tttmp = norm(gravity);
THvar = 1.0;
varInc = 0.1;

for j = windowSize * 5 + 1 : windowSize : size(sensorData, 1) - windowSize 
    frame = sensorData(j-windowSize : j + windowSize -1, :);
    label1 = frame(1, 1);
    continueFlag = 0;
    for i = 2 : size(frame,1)
        if label1 ~= frame(i, 1)
            continueFlag = 1;
            break;
        end
    end 
    if continueFlag == 1
        continue;
    end
    
	[gravity, THvar, varInc]  = getGravity(sensorData(j-windowSize*5 : j, 2 : 4 ), frame(:,2 : 4), gravity, THvar, varInc);
    
    accLine = [];
    for i = 1 : size(frame, 1)
        accLine = [accLine; frame(i,2:4) - gravity];  
    end
    meanAccLine = norm(mean(accLine));
    varAccLine = norm(var(accLine));
    
    accLineV = [];
    accLineH = [];
    for i = 1 : size(frame, 1)
        accLineV = [accLineV; dot(accLine(i, :),  gravity) / dot(gravity, gravity) .*gravity];
        accLineH = [accLineH; gravity - accLineV(i, :)];
    end
    meanAccLineV = norm(mean(accLineV));
    varAccLineV = norm(var(accLineV));
    
    meanAccLineH = norm(mean(accLineH));
    varAccLineH = norm(var(accLineH));
    
    gyr = frame(:,5:7);
    gyrNorm = [];
    for i = 1 : size(gyr, 1)
        gyrNorm = [gyrNorm, norm(gyr(i, :))];
    end
    angle = sum(gyrNorm) * 0.32;
    
%     processFFT( [sum(accLine.^2, 2).^(0.5), sum(accLineV.^2, 2).^(0.5), sum(accLineH.^2, 2).^(0.5), sum(gyr.^2, 2).^(0.5)] );

    dataFFT = abs(fft(sum(accLine.^2, 2).^(0.5)));
    freq1 = 2;
    freq2 = 3;
    peak1 = dataFFT(2);
    peak2 = dataFFT(3);
    energy = peak1^2 + peak2^2;
    if(peak1 < peak2)
        tmp = peak2;
        peak2 = peak1;
        peak1 = tmp;
        freq1 = 3;
        freq2 = 2;
    end
    for i = 4 : 32
        energy = energy + dataFFT(i) ^2;
        if dataFFT(i) > peak1
            peak2 = peak1;
            freq2 = freq1;
            peak1 = dataFFT(i);
            freq1 = i;
        elseif dataFFT(i) > peak2
            freq2 = i;
            peak2 = dataFFT(i);
        end
     end
    vector = [vector; [meanAccLine, varAccLine, meanAccLineV, varAccLineV, meanAccLineH, varAccLineH, angle, freq1, peak1, freq2, peak2, energy]];
    label = [label, label1];
end
end

