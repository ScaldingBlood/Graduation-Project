package me.spiegel.paz.datacollection.model;

import java.io.Serializable;

/**
 * Created by paz on 17-2-21.
 */
public class DataNode implements Serializable {
    private float xAcc, yAcc, zAcc;
    private float xGyr, yGyr, zGyr;
    private float xMag, yMag, zMag;

    public DataNode() {
    }

    public DataNode(float xAcc, float yAcc, float zAcc, float xGyr, float yGyr, float zGyr, float xMag, float yMag, float zMag) {
        this.xAcc = xAcc;
        this.yAcc = yAcc;
        this.zAcc = zAcc;
        this.xGyr = xGyr;
        this.yGyr = yGyr;
        this.zGyr = zGyr;
        this.xMag = xMag;
        this.yMag = yMag;
        this.zMag = zMag;
    }

    public float getxAcc() {
        return xAcc;
    }

    public void setxAcc(float xAcc) {
        this.xAcc = xAcc;
    }

    public float getyAcc() {
        return yAcc;
    }

    public void setyAcc(float yAcc) {
        this.yAcc = yAcc;
    }

    public float getzAcc() {
        return zAcc;
    }

    public void setzAcc(float zAcc) {
        this.zAcc = zAcc;
    }

    public float getxGyr() {
        return xGyr;
    }

    public void setxGyr(float xGyr) {
        this.xGyr = xGyr;
    }

    public float getyGyr() {
        return yGyr;
    }

    public void setyGyr(float yGyr) {
        this.yGyr = yGyr;
    }

    public float getzGyr() {
        return zGyr;
    }

    public void setzGyr(float zGyr) {
        this.zGyr = zGyr;
    }

    public float getxMag() {
        return xMag;
    }

    public void setxMag(float xMag) {
        this.xMag = xMag;
    }

    public float getyMag() {
        return yMag;
    }

    public void setyMag(float yMag) {
        this.yMag = yMag;
    }

    public float getzMag() {
        return zMag;
    }

    public void setzMag(float zMag) {
        this.zMag = zMag;
    }

    public DataNode setAll(float xAcc, float yAcc, float zAcc, float xGyr, float yGyr, float zGyr, float xMag, float yMag, float zMag) {
        this.xAcc = xAcc;
        this.yAcc = yAcc;
        this.zAcc = zAcc;
        this.xGyr = xGyr;
        this.yGyr = yGyr;
        this.zGyr = zGyr;
        this.xMag = xMag;
        this.yMag = yMag;
        this.zMag = zMag;
        return this;
    }
}
