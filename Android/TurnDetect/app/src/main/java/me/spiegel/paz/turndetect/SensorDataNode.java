package me.spiegel.paz.turndetect;

/**
 * Created by paz on 17-3-30.
 */
public class SensorDataNode {
    private double x, y, z;

    public SensorDataNode() {}
    public SensorDataNode(float[] f) {
        x = f[0];
        y = f[1];
        z = f[2];
    }
    public SensorDataNode(SensorDataNode node) {
        x = node.x;
        y = node.y;
        z = node.z;
    }

    public double module() {
        return Math.sqrt(x * x + y * y + z * z);
    }

    public void sub(SensorDataNode tmp) {
        x -= tmp.getX();
        y -= tmp.getY();
        z -= tmp.getZ();
    }

    public double getX() {
        return x;
    }

    public double getY() {
        return y;
    }

    public double getZ() {
        return z;
    }
}
