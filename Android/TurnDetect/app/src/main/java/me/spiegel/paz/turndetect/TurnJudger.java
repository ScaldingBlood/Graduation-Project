package me.spiegel.paz.turndetect;

import android.content.Context;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by paz on 17-3-30.
 */
public class TurnJudger {
    private static final int smallWindowSize = 4;
    private static final int largeWindowSize = 20;
    private ArrayList<Double> smallWindow;
    private ArrayList<Double> largeWindow;
    private Context context;
    private SensorDataTimer sensorDataTimer;
    private FeatureReady featureReady;
    private DataProcess dataProcess;
    private int turnCount;
    private boolean stopS;
    private boolean stopL;
    private int stopCountS;
    private int stopCountL;
    private int lastFlag;

    public interface FeatureReady {
        void angleCallback(double angle);
        void largeCallback(double angle);
        void turnCallback(int count);
    }

    private SensorDataTimer.SensorDataCallback sensorDataCallback = new SensorDataTimer.SensorDataCallback() {
        @Override
        public void onAllSensorData(ArrayList<SensorDataNode> acc, ArrayList<SensorDataNode> gyr) {
            double ang = dataProcess.process(acc, gyr);
            if(ang == 0)
                return;
            smallWindow.add(ang);
            largeWindow.add(ang);
            if(smallWindow.size() == smallWindowSize) {
                double res = getSum(smallWindow);
                smallWindow.remove(0);

                featureReady.angleCallback(res);
                if(Math.abs(res) > 65) {
                    lastFlag = 0;
                    stopCountS = 0;
                    if(!stopS) {
                        featureReady.turnCallback(++turnCount);
                        stopS = true;
                    }
                } else {
                    lastFlag++;
                    stopCountS++;
                    if(stopCountS == 3) {
                        stopS = false;
                        stopCountS = 0;
                    }
                }
            }
            if(largeWindow.size() == largeWindowSize) {
                double res = getSum(largeWindow);
                featureReady.largeCallback(res);
                largeWindow.remove(0);
                if(Math.abs(res) > 70) {
                    stopCountL = 0;

                    if(!stopL && lastFlag >= largeWindowSize) {
                        featureReady.turnCallback(++turnCount);
                        stopL = true;
                    }
                } else {
                    stopCountL++;
                    if(stopCountL == 3) {
                        stopL = false;
                        stopCountL = 0;
                    }
                }

            }

        }
    };

    public TurnJudger(Context ctx, FeatureReady featureReady) {
        context = ctx;
        this.featureReady = featureReady;
        dataProcess = new DataProcess(callback);
        smallWindow = new ArrayList<>();
        largeWindow = new ArrayList<>();
        sensorDataTimer = new SensorDataTimer(context, sensorDataCallback);
    }

    public void start() {
        stopS = false;
        stopL = false;
        stopCountS = 0;
        stopCountL = 0;
        turnCount = 0;
        lastFlag = 0;
        smallWindow.clear();
        largeWindow.clear();
        dataProcess.init();
        sensorDataTimer.start();
    }

    public void end() {
        sensorDataTimer.stop();
    }

    private double getSum(List<Double> list) {
        double sum = 0;
        for(double d : list) {
            sum += d;
        }
        return sum;
    }

    private DataProcess.DetectWalkCallback callback = new DataProcess.DetectWalkCallback() {
        @Override
        public void detectedWalk() {
            largeWindow.clear();
            stopL = false;
            stopCountL = 0;
            lastFlag = 0;
        }
    };
}
