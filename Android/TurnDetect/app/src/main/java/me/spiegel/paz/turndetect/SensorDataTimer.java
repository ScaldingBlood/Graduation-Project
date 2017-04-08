package me.spiegel.paz.turndetect;

import android.content.Context;

import java.util.ArrayList;
import java.util.Timer;
import java.util.TimerTask;

/**
 * Created by paz on 17-3-30.
 */
public class SensorDataTimer {
    private Context context;
    private Timer timer;
    private ArrayList<SensorDataNode> accelerometerList;
    private ArrayList<SensorDataNode> gyroscopeList;
    final public static double sampleTime = 0.01;
    private SensorDataCallback dataCallback;
    public interface SensorDataCallback {
        void onAllSensorData(ArrayList<SensorDataNode> acc, ArrayList<SensorDataNode> gyr);
    }

    public SensorDataTimer(Context ctx, SensorDataCallback sensorDataCallback) {
        this.context = ctx;
        dataCallback = sensorDataCallback;
        accelerometerList = new ArrayList<>();
        gyroscopeList = new ArrayList<>();
    }

    public void start() {
        DataProvider.start(context);
        timer = new Timer();
        timer.schedule(new TimerTask() {
            float[] acc = new float[3];
            float[] gyr = new float[3];
            @Override
            public void run() {
                acc = DataProvider.getAccelerometerValues();
                gyr = DataProvider.getGyroscopeValues();
                if(acc[0] == 0 || acc[1] == 0 || acc[2] == 0) return;
                if(gyr[0] == 0 || gyr[1] == 0 || gyr[2] == 0) return;
                accelerometerList.add(new SensorDataNode(acc));
                gyroscopeList.add(new SensorDataNode(gyr));
                if(accelerometerList.size() >= 128 && gyroscopeList.size() >= 128) {
                    dataCallback.onAllSensorData(accelerometerList, gyroscopeList);
                    accelerometerList.clear();
                    gyroscopeList.clear();
                }
            }
        }, 0, (long)(1000 * sampleTime));
    }

    public void stop() {
        DataProvider.stop();
        timer.cancel();
    }
}
