package me.spiegel.paz.datacollection.service;

import android.content.Context;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.util.Log;

import java.text.DecimalFormat;
import java.util.Timer;
import java.util.TimerTask;

import me.spiegel.paz.datacollection.model.DataNode;


/**
 * Created by paz on 17-2-21.
 */
public class DataProcessService {
    private SensorService sensorService;
    private PersistenceService persistenceService;

    private DecimalFormat df;
    private Timer timer;
    private TimerTask task;
    private int flag;//0 静止 1 行走 2 转弯 3 上楼 4 下楼

    public DataProcessService() {
        df = new DecimalFormat("#0.00");
        timer = new Timer();
        sensorService = new SensorService();
    }

    public void setFlag(int i) {
        flag = i;
    }

    public void processData(final Handler handler, Context context) {
        task = new TimerTask() {
            @Override
            public void run() {
                Message msg = new Message();
                Bundle bundle = process();
                if(bundle == null)
                    return;
                msg.setData(bundle);
                msg.what = 1;
                handler.sendMessage(msg);
            }
        };

        persistenceService = new PersistenceService(flag);
        sensorService.register(context);

        timer.schedule(task, 0, 10);
    }

    public void stopProcess() {
        task.cancel();
        sensorService.unregister();
        persistenceService.close();
    }

    private Bundle process() {
        Bundle bundle = new Bundle();
        DataNode data = sensorService.collect();
        if(data == null)
            return null;

        StringBuilder sb = new StringBuilder();
        sb.append(flag).append(" ")
                .append(data.getxAcc()).append(" ").append(data.getyAcc()).append(" ").append(data.getzAcc()).append(" ")
                .append(data.getxGyr()).append(" ").append(data.getyGyr()).append(" ").append(data.getzGyr()).append(" ")
                .append(data.getxMag()).append(" ").append(data.getyMag()).append(" ").append(data.getzMag()).append("\n");
        String stringInFile = sb.toString();
        Log.d("data process service", stringInFile);
        persistenceService.store(stringInFile);

        bundle.putString("acc", "Acc x:" + df.format(data.getxAcc()) + " y:" + df.format(data.getyAcc()) + " z:" + df.format(data.getzAcc()));
        bundle.putString("gyr", "Gyr x:" + df.format(data.getxGyr()) + " y:" + df.format(data.getyGyr()) + " z:" + df.format(data.getzGyr()));
        bundle.putString("mag", "Mag x:" + df.format(data.getxMag()) + " y:" + df.format(data.getyMag()) + " z:" + df.format(data.getzMag()));
        return bundle;
    }

}
