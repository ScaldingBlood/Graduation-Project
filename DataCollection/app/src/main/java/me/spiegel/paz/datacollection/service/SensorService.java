package me.spiegel.paz.datacollection.service;

import android.content.Context;
import android.hardware.Sensor;
import android.hardware.SensorEvent;
import android.hardware.SensorEventListener;
import android.hardware.SensorManager;

import me.spiegel.paz.datacollection.model.DataNode;

/**
 * Created by paz on 17-2-21.
 */
public class SensorService {
    public static final String SENSOR_DATA = "me.spiegel.paz.datacollection.service.SensorService";

    private SensorManager sm;
    private Sensor acclerateSensor;
    private Sensor gyromotionSensor;
    private Sensor magnetometerSensor;
    private float[] acc;
    private float[] gyr;
    private float[] mag;

    private SensorEventListener accListener = new SensorEventListener() {
        @Override
        public void onSensorChanged(SensorEvent event) {
            acc = event.values;
        }

        @Override
        public void onAccuracyChanged(Sensor sensor, int accuracy) {}
    };
    private SensorEventListener gyrListener = new SensorEventListener() {
        @Override
        public void onSensorChanged(SensorEvent event) {
            gyr = event.values;
        }

        @Override
        public void onAccuracyChanged(Sensor sensor, int accuracy) {}
    };
    private SensorEventListener magListener = new SensorEventListener() {
        @Override
        public void onSensorChanged(SensorEvent event) {
            mag = event.values;
        }

        @Override
        public void onAccuracyChanged(Sensor sensor, int accuracy) {}
    };

    public void register(Context context) {
        sm = (SensorManager)context.getSystemService(Context.SENSOR_SERVICE);
        acclerateSensor = sm.getDefaultSensor(Sensor.TYPE_ACCELEROMETER);
        gyromotionSensor = sm.getDefaultSensor(Sensor.TYPE_GYROSCOPE);
        magnetometerSensor = sm.getDefaultSensor(Sensor.TYPE_MAGNETIC_FIELD);
        sm.registerListener(accListener, acclerateSensor, SensorManager.SENSOR_DELAY_FASTEST);
        sm.registerListener(gyrListener, gyromotionSensor, SensorManager.SENSOR_DELAY_FASTEST);
        sm.registerListener(magListener, magnetometerSensor, SensorManager.SENSOR_DELAY_FASTEST);

    }

    public void unregister() {
        sm.unregisterListener(accListener);
        sm.unregisterListener(gyrListener);
        sm.unregisterListener(magListener);
    }

    public DataNode collect() {
        if(acc == null || gyr == null || mag == null)
            return null;
        return new DataNode(acc[0], acc[1], acc[2],
                gyr[0], gyr[1], gyr[2],
                mag[0], mag[1], mag[2]);
    }
}
