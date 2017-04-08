package me.spiegel.paz.turndetect;

import android.app.ProgressDialog;
import android.os.Handler;
import android.os.Message;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.ListView;
import android.widget.SimpleAdapter;
import android.widget.TextView;

import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class MainActivity extends AppCompatActivity {
    private TurnJudger turnJudger;
    private Button startButton;
    private Button endButton;
    private TextView turnText;
    private ListView listView;
    private List<Double> angleList;
    private List<Double> largeList;
    private int turnCount;
    private SimpleAdapter adapter;
    private List<Map<String, Object>> list;
    private ProgressDialog dialog;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        angleList = new ArrayList<>();
        largeList = new ArrayList<>();
        turnCount = 0;
        turnJudger = new TurnJudger(this, featureReady);
        startButton = (Button)findViewById(R.id.start);
        endButton = (Button)findViewById(R.id.end);
        turnText = (TextView)findViewById(R.id.turn_text);
        listView = (ListView) findViewById(R.id.angle_list);
        list = new ArrayList<>();

        adapter = new SimpleAdapter(this, list, R.layout.list_item, new String[]{"seconds", "angle", "largeAngle"},
                new int[]{R.id.date_view, R.id.angle_view, R.id.large_angle_view});
        View headView = getLayoutInflater().inflate(R.layout.list_header, null, false);

        listView.addHeaderView(headView);
        listView.setAdapter(adapter);
        startButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                turnCount = 0;
                turnText.setText("0");
                list.clear();
                angleList.clear();
                largeList.clear();
                adapter.notifyDataSetChanged();
                turnJudger.start();
                endButton.setEnabled(true);
                startButton.setEnabled(false);
                showDialogLoading("估计重力中…", 5);


            }
        });
        endButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                turnJudger.end();
                startButton.setEnabled(true);
                endButton.setEnabled(false);
            }
        });
    }

    private void showDialogLoading(String title, final int max) {
        dialog = new ProgressDialog(this);
        dialog.setProgressStyle(ProgressDialog.STYLE_HORIZONTAL);
        dialog.setTitle(title);
        dialog.setCancelable(false);
        dialog.show();

        new Thread() {
            @Override
            public void run() {
                dialog.setMax(max);
                int i = 0;
                while(true) {
                    if(i > max)
                        break;
                    try {
                        Thread.sleep(1280);
                        dialog.incrementProgressBy(1);
                        i++;
                    } catch(InterruptedException e) {
                        e.printStackTrace();
                    }
                }
                i = 1;
                Message msg = new Message();
                msg.what = 3;
                handler.sendMessage(msg);
                dialog.setProgress(1);
                dialog.setMax(10);
                while(true) {
                    if(i > 10)
                        break;
                    try {
                        Thread.sleep(1280);
                        dialog.incrementProgressBy(1);
                        i++;
                    } catch(InterruptedException e) {
                        e.printStackTrace();
                    }
                }
                dialog.dismiss();
            }
        }.start();
    }

    private Handler handler = new Handler() {
        public void handleMessage(android.os.Message msg) {
            if(msg.what == 1) {
                turnText.setText(String.valueOf(turnCount));
            } else if(msg.what == 2) {
                angleList.add(Double.valueOf((String)msg.obj));
                Map<String, Object> map = new HashMap<>();
                map.put("seconds", df.format((angleList.size()) * 1.28));
                map.put("angle", df.format(angleList.get(angleList.size() -1)));
                map.put("largeAngle", df.format(0));
                list.add(0, map);
                adapter.notifyDataSetChanged();
            } else if(msg.what == 3) {
                dialog.setTitle("请直行一段距离");
            } else if(msg.what == 4) {
                largeList.add(Double.valueOf((String)msg.obj));
                list.get(0).put("largeAngle", df.format(largeList.get(largeList.size() -1)));
                adapter.notifyDataSetChanged();
            }
            super.handleMessage(msg);
        }
    };

    private DecimalFormat df = new DecimalFormat("#0.00");
    private TurnJudger.FeatureReady featureReady = new TurnJudger.FeatureReady() {
        @Override
        public void angleCallback(double angle) {
            Message msg = new Message();
            msg.what = 2;
            msg.obj = df.format(angle);
            handler.sendMessage(msg);
        }

        @Override
        public void largeCallback(double angle) {
            Message msg = new Message();
            msg.what = 4;
            msg.obj = df.format(angle);
            handler.sendMessage(msg);
        }

        @Override
        public void turnCallback(int count) {
            Message msg = new Message();
            msg.what = 1;
            turnCount = count;
            handler.sendMessage(msg);
        }
    };
}
