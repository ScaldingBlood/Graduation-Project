function displayFeature( dataset )
%DISPLAYFEATURE �˴���ʾ�йش˺�����ժҪ
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
        for i = 1 : length(dataset)
            fprintf('%d\n', i);
            data = dataset{i};
            vars = [];
            means = [];
            for j = 1 : size(data, 2)
                fprintf('%d ', j);
                x =data(:, j);
                m = mean(x);
                s = std(x);
                
                
                % չʾ���þ�ֵ�ͷ����Ӧ����̬�ֲ�
                tmpx = m - 3*s: 0.01: m + 3*s;
                fx = normpdf(tmpx, m , s);
                plot(tmpx, fx);
                
                % ���ݵ�Ƶ��ͼ
                [n, xout] = hist(data(:, j), 200); 
                n = n / sum(n);
                bar(xout, n); box off
                xlim([m-3*s, m+3*s]);
                
                % չʾ���ݺ���̬�ֲ���������
                normplot(x);
            end
            fprintf('\n');
        end
end