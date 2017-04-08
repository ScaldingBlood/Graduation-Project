package me.spiegel.paz.datacollection.service;

import android.os.Environment;
import android.util.Log;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;


/**
 * Created by paz on 17-2-22.
 */
public class PersistenceService {
    private FileOutputStream fout;


    public PersistenceService(int flag) {
        createFile(getName(flag));
    }

    public void store(String content) {
        if(fout == null) {
            return;
        }
        try {
            fout.write(content.getBytes());
        } catch(IOException exp) {
            exp.printStackTrace();
        }
    }

    private void createFile(String name) {
//        Log.d("wtf", Environment.getExternalStorageState());
        if(!Environment.getExternalStorageState().equals(Environment.MEDIA_MOUNTED))
            return;
        File appRootDir = Environment.getExternalStoragePublicDirectory("DataCollection");
        if(!appRootDir.exists())
            appRootDir.mkdir();

        try {
            File dataFile = new File(appRootDir, name);
            Log.d("path", dataFile.getAbsolutePath());
            Log.d("is", String.valueOf(dataFile.exists()));
            if(!dataFile.exists())
                dataFile.createNewFile();
            fout = new FileOutputStream(dataFile);
        } catch(IOException exp) {
            exp.printStackTrace();
        }
    }

    public void close() {
        try {
            if(fout != null) {
                fout.flush();
                fout.close();
            }
        } catch(IOException exp) {
            exp.printStackTrace();
        }
    }

    private String getName(int flag) {
        StringBuilder sb = new StringBuilder();
        String tag;
        switch(flag) {
            case 0:tag = "hand";break;
            case 1:tag = "coat";break;
            case 2:tag = "trousers";break;
            case 3:tag = "upstairs";break;
            case 4:tag = "downstairs";break;
            default:tag = "error";
        }
        DateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        sb.append(tag);
        sb.append(df.format(new Date()));
        return sb.toString();
    }
}
