package me.spiegel.paz.turndetect;

import java.util.List;

/**
 * Created by paz on 17-3-30.
 */
public class Gravity {
    private static final double hardThreshold = 1.5;
    private static final double subNorm = 4;
    private static final double originThreshold = 1.0;
    private static final double inc = 0.3;
    private static double THvar;
    private static double varIncrease;

    public static void init() {
        THvar = originThreshold;
        varIncrease = 0.1;
    }

    public static SensorDataNode getGravity(List<SensorDataNode> acc, List<SensorDataNode> history, SensorDataNode last) {
        double var = getVar(acc);
        SensorDataNode mean = getMean(acc);
        SensorDataNode tmp =  new SensorDataNode(mean);
        tmp.sub(last);
        SensorDataNode res;
        if(tmp.module() >= subNorm)
            THvar = originThreshold;
        if(var < hardThreshold) {
            if(var < THvar) {
                res = mean;
                THvar = (THvar + var) /2;
                varIncrease = THvar * inc;
            } else {
                res = last;
                THvar += varIncrease;
            }
        } else {
            res = getMean(history);
        }
        return res;
    }

    public static double getVar(List<SensorDataNode> al) {
        SensorDataNode m = getMean(al);
        float x, y, z;
        x = y = z = 0;
        for(SensorDataNode t : al) {
            x += (t.getX() - m.getX()) * (t.getX() - m.getX());
            y += (t.getY() - m.getY()) * (t.getY() - m.getY());
            z += (t.getZ() - m.getZ()) * (t.getZ() - m.getZ());
        }
        int s = al.size() - 1;
        x /= s; y /= s; z /= s;
        return Math.sqrt(x * x + y * y + z * z);
    }

    public static SensorDataNode getMean(List<SensorDataNode> list) {
        float sumx = 0;
        float sumy = 0;
        float sumz = 0;
        for(SensorDataNode tmp : list) {
            sumx += tmp.getX();
            sumy += tmp.getY();
            sumz += tmp.getZ();
        }
        return new SensorDataNode(new float[]{sumx / DataProcess.frameLen, sumy / DataProcess.frameLen, sumz / DataProcess.frameLen});
    }
}