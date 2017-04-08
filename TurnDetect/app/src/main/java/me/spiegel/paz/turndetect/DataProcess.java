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
        Gravity.init();
    }

    public double process(ArrayList<SensorDataNode> acc, ArrayList<SensorDataNode> gyr) {
        if(allAccData == null) {
            allAccData = acc;
            allGyrData = gyr;
            return 0;
        }
        allAccData.addAll(acc);
        allGyrData.addAll(gyr);
        if(start++ < startCounter) {
            return 0;
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
        if(verticalGyrList.size() < 10 * halfFrameLen)
            return ang;
        else {
            double[] tmp = new double[verticalGyrList.size()/10];
            double tmpSum = 0;
            for(int i = 0, j = 0; i < verticalGyrList.size(); i++) {
                tmpSum += verticalGyrList.get(i);
                if((i + 1) % 10 == 0) {
                    tmp[j++] = tmpSum / 10;
                    tmpSum = 0;
                }
            }
            Complex[] res = FFT.FFTTransform(tmp);
            for(int i = 9; i < 120; i++) {
                if(res[i].re() > 40) {
                    logger.info(i + " " + res[i].re() + "\n");
                    callback.detectedWalk();
                }
                res[i] = new Complex(0, 0);
            }
            Complex[] after = FFT.ifft(res);
            for(int i = 0; i < 12; i++) {
                ang += (after[after.length -1 - i]).re();
            }
            ang = ang * 0.1 * 180 / Math.PI;
            logger.info(String.valueOf(Math.abs(ang)));
            verticalGyrList = verticalGyrList.subList(halfFrameLen, verticalGyrList.size());
            return ang;
        }

    }

    public interface DetectWalkCallback {
        void detectedWalk();
    }
}
