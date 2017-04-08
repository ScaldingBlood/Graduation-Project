package me.spiegel.paz.turndetect;

import android.content.Context;
import android.hardware.Sensor;
import android.hardware.SensorEvent;
import android.hardware.SensorEventListener;
import android.hardware.SensorManager;

/**
 * Created by paz on 17-3-30.
 */
public class DataProvider {
    private static Context context;
    private static SensorManager sensorManager;
    private static Sensor accelerometer;
    private static Sensor gyroscope;
    private static float[] accelerometerValues = new float[3];
    private static float[] gyroscopeValues = new float[3];

    public static void start(Context context) {
        DataProvider.context = context;
        sensorManager = (SensorManager)context.getSystemService(Context.SENSOR_SERVICE);
        accelerometer = sensorManager.getDefaultSensor(Sensor.TYPE_ACCELEROMETER);
        gyroscope =sensorManager.getDefaultSensor(Sensor.TYPE_GYROSCOPE);
        init();
    }

    private static void init() {
        sensorManager.registerListener(accelerometerListener, accelerometer, SensorManager.SENSOR_DELAY_FASTEST);
        sensorManager.registerListener(gyroscopeListener, gyroscope, SensorManager.SENSOR_DELAY_FASTEST);
    }

    public static void stop() {
        sensorManager.unregisterListener(accelerometerListener);
        sensorManager.unregisterListener(gyroscopeListener);
    }

    public static float[] getAccelerometerValues() {
        return accelerometerValues;
    }

    public static float[] getGyroscopeValues() {
        return gyroscopeValues;
    }

    private final static SensorEventListener accelerometerListener = new SensorEventListener() {
        @Override
        public void onSensorChanged(SensorEvent event) {
            accelerometerValues = event.values;
        }

        @Override
        public void onAccuracyChanged(Sensor sensor, int accuracy) {}
    };

    private final static SensorEventListener gyroscopeListener = new SensorEventListener() {
        @Override
        public void onSensorChanged(SensorEvent event) {
            gyroscopeValues = event.values;
        }

        @Override
        public void onAccuracyChanged(Sensor sensor, int accuracy) {}
    };
}
