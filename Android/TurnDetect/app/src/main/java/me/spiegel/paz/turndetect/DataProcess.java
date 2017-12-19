package me.spiegel.paz.turndetect;

import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;

import me.spiegel.paz.turndetect.feature.Complex;
import me.spiegel.paz.turndetect.feature.FFT;

/**
 * Created by paz on 17-3-30.
 */
public class DataProcess {
    private static final int startCounter = 4;
    public static final int halfFrameLen = 128;
    public static final int frameLen = 256;
    private List<SensorDataNode> allAccData;
    private List<SensorDataNode> allGyrData;
    private int start;
    private SensorDataNode gravity;
    private boolean flag;
    Logger logger = Logger.getLogger("DATAPROCESS");
    private List<Double> verticalGyrList;
    private DetectWalkCallback callback;
    private boolean posOrNeg = false;

    public DataProcess(DetectWalkCallback callback) {
        allAccData = new ArrayList<>();
        allGyrData = new ArrayList<>();
        verticalGyrList = new ArrayList<>();
        this.callback = callback;
    }

    public void init() {
        flag = true;
        gravity = null;
        allAccData.clear();
        allGyrData.clear();
        verticalGyrList.clear();
        start = 1;
        posOrNeg = false;
        Gravity.init();
    }

    public double[] process(ArrayList<SensorDataNode> acc, ArrayList<SensorDataNode> gyr) {
        if(allAccData == null) {
            allAccData = acc;
            allGyrData = gyr;
            return new double[]{0, 0};
        }
        allAccData.addAll(acc);
        allGyrData.addAll(gyr);
        if(start++ < startCounter) {
            return new double[]{0, 0};
        }
        int start = allAccData.size() - startCounter * halfFrameLen;
        List<SensorDataNode> history = allAccData.subList(start, allAccData.size());
        allAccData = history; //减小allAccData

        int frameStart = allAccData.size() - frameLen;
        List<SensorDataNode> frameAcc = allAccData.subList(frameStart, allAccData.size());
        List<SensorDataNode> frameGyr = allGyrData.subList(allGyrData.size() - halfFrameLen, allGyrData.size());
        allGyrData = frameGyr; //gyr数据只需保留一帧

        if(flag) {
            gravity = Gravity.getMean(history);
            flag = false;
        }

        gravity = Gravity.getGravity(frameAcc, history, gravity);


        double ang = 0;
        for(int i = 0; i < frameGyr.size(); i++) {
//            ang += (gravity.getX() * frameGyr.get(i).getX() + gravity.getY() * frameGyr.get(i).getY() + gravity.getZ() * frameGyr.get(i).getZ())
//                    / gravity.module() * SensorDataTimer.sampleTime * 180 / Math.PI;
            verticalGyrList.add((gravity.getX() * frameGyr.get(i).getX() + gravity.getY() * frameGyr.get(i).getY() + gravity.getZ() * frameGyr.get(i).getZ())
                    / gravity.module());
        }

        if(verticalGyrList.size() < 2 * halfFrameLen) { // 8*128=1024 2*128=256
            if(verticalGyrList.size() == 7 * halfFrameLen) { // judge left or right, in order to adjust the angle.
                int neg = 0;
                int pos = 0;
                for(int i = 0; i < 7 * halfFrameLen; i++) {
                    if(verticalGyrList.get(i) > 0)
                        pos++;
                    else
                        neg++;
                }
                if(pos > neg)
                    posOrNeg = true;
            }
            return new double[]{0, 0};
        }
        else {
//            double[] tmp = new double[verticalGyrList.size()/10];
//            double tmpSum = 0;
//            for(int i = 0, j = 0; i < verticalGyrList.size(); i++) {
//                tmpSum += verticalGyrList.get(i);
//                if((i + 1) % 10 == 0) {
//                    tmp[j++] = tmpSum / 10;
//                    tmpSum = 0;
//                }
//            }
            double[] tmp = new double[verticalGyrList.size()];
            for(int i = 0; i < verticalGyrList.size(); i++) {
                tmp[i] = verticalGyrList.get(i);
            }
            Complex[] res = FFT.FFTTransform(tmp);
            boolean affected = false;
            for(int i = (int)Math.floor(tmp.length/200); i <= tmp.length/2; i++) {
                if(res[i].re() > 18 && !affected) {
                    callback.detectedWalk();
                    affected = true;
                }
                res[i].setRe(0);
                res[i].setIm(0);
                res[tmp.length - i].setRe(0);
                res[tmp.length - i].setIm(0);
            }
            Complex[] after = FFT.ifft(res);
            for(int i = 0; i < 128; i++) {
                ang += (after[after.length -1 - i]).re();
            }
            ang *= 0.01 * 180 / Math.PI;
            double angOrigin = 0;
            for(int i = 0; i < 128; i++) {
                angOrigin += verticalGyrList.get(verticalGyrList.size() -1 - i);
            }
            angOrigin *= 0.01 * 180 / Math.PI;
//            logger.info(String.valueOf(ang) + "  " + String.valueOf(angOrigin));
            verticalGyrList = verticalGyrList.subList(halfFrameLen, verticalGyrList.size());
//            if(affected)
//                ang = ang + (posOrNeg ? -1 : 1);
            return new double[]{ang, angOrigin};
        }

    }

    public interface DetectWalkCallback {
        void detectedWalk();
    }
}
