package me.spiegel.paz.datacollection.view;

import android.Manifest;
import android.content.pm.PackageManager;
import android.os.Handler;
import android.os.Message;
import android.support.v4.app.ActivityCompat;
import android.support.v4.content.ContextCompat;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.RadioButton;
import android.widget.RadioGroup;
import android.widget.TextView;
import android.widget.Toast;


import me.spiegel.paz.datacollection.R;
import me.spiegel.paz.datacollection.service.DataProcessService;

public class MainActivity extends AppCompatActivity {

    private final static int WRITE_EXTERNAL_STORAGE_CODE = 0;
    private final static int MOUNT_UNMOUNT_FILESYSTEMS = 1;
    private Button startButton;
    private Button endButton;
    private TextView showView;
    private Handler dataHandler;
    private RadioGroup radioGroup;
    private DataProcessService dataProcessService;
    private boolean radioButtonChecked;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        startButton = (Button)findViewById(R.id.start_button);
        endButton = (Button)findViewById(R.id.end_button);
        showView = (TextView)findViewById(R.id.show_view);
        radioGroup = (RadioGroup)findViewById(R.id.radio_group);
        radioGroup.clearCheck();
    }

    @Override
    protected void onStart() {
        super.onStart();
    }

    @Override
    protected void onResume() {
        super.onResume();
        dataProcessService = new DataProcessService();
        startButton.setOnClickListener(new View.OnClickListener() {
            public void onClick(View view) {
                if(radioButtonChecked == false) {
                    Toast.makeText(MainActivity.this, "please choose mode first.", Toast.LENGTH_SHORT).show();
                    return;
                }
                requestPermissions();

                dataProcessService.processData(dataHandler, MainActivity.this);
//                radioGroup.setEnabled(false);
                endButton.setEnabled(true);
                view.setEnabled(false);
            }
        });

        endButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                radioGroup.clearCheck();
                radioButtonChecked = false;
                dataProcessService.stopProcess();
                startButton.setEnabled(true);
                v.setEnabled(false);
            }
        });

        radioGroup.setOnCheckedChangeListener(new RadioGroup.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(RadioGroup rg, int checkedId) {
                RadioButton button = (RadioButton)rg.findViewById(checkedId);
                if(button != null && checkedId != -1) {
                    radioButtonChecked = true;
                    int flag = -1;
                    switch(checkedId) {
                        case R.id.flag_stay:flag = 0;break;
                        case R.id.flag_walk:flag = 1;break;
                        case R.id.flag_turn:flag = 2;break;
//                        case R.id.flag_upstairs:flag = 3;break;
//                        case R.id.flag_downstairs:flag = 4;break;
                    }
                    dataProcessService.setFlag(flag);
                }
            }
        });

        dataHandler = new Handler() {
            Bundle bundle = new Bundle();
            @Override
            public void handleMessage(Message msg) {
                switch(msg.what) {
                    case 1:
                        bundle = msg.getData();
                        showView.setText(bundle.getString("acc") + "\n" + bundle.getString("gyr") + "\n" + bundle.getString("mag"));

                }
            }
        };

    }

    public void requestPermissions() {
        if(ContextCompat.checkSelfPermission(this, Manifest.permission.WRITE_EXTERNAL_STORAGE)
                != PackageManager.PERMISSION_GRANTED) {
            ActivityCompat.requestPermissions(this, new String[]{Manifest.permission.WRITE_EXTERNAL_STORAGE}, WRITE_EXTERNAL_STORAGE_CODE);
        }
    }

    @Override
    public void onRequestPermissionsResult(int requestCode, String[] permission, int[] grantResult) {
        super.onRequestPermissionsResult(requestCode, permission, grantResult);
        if(requestCode == WRITE_EXTERNAL_STORAGE_CODE) {
            if(grantResult[0] != PackageManager.PERMISSION_GRANTED)
                Toast.makeText(this, "will not create the file", Toast.LENGTH_SHORT).show();
        }
    }
}
