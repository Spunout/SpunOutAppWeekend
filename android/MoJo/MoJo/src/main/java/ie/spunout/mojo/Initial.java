package ie.spunout.mojo;

import android.app.Activity;
import android.app.ActionBar;
import android.app.Fragment;
import android.app.TaskStackBuilder;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.res.Resources;
import android.graphics.Color;
import android.graphics.drawable.Drawable;
import android.graphics.drawable.ShapeDrawable;
import android.graphics.drawable.shapes.ArcShape;
import android.graphics.drawable.shapes.Shape;
import android.media.Image;
import android.os.Bundle;
import android.support.v4.view.MotionEventCompat;
import android.support.v7.app.ActionBarActivity;
import android.util.Log;
import android.view.GestureDetector;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuItem;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup;
import android.os.Build;
import android.view.Window;
import android.widget.AdapterView;
import android.widget.BaseAdapter;
import android.widget.GridView;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.SeekBar;
import android.widget.SimpleAdapter;
import android.widget.Toast;

import com.parse.Parse;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;

public class Initial extends Activity {
    private View menu;
    private ActionBar abar;
    private SeekBar sbar;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        //hide the action bar
        abar = getActionBar();
        abar.hide();
        //abar.setDisplayHomeAsUpEnabled(true);

        super.onCreate(savedInstanceState);
        setContentView(R.layout.initial_layout);

        //hide the overlay menu
        menu = findViewById(R.id.hideable);
        menu.setVisibility(View.INVISIBLE);

        //TODO make the size of the circle dynamic, check screen size and scale

        /*
        GridView gridview = (GridView) findViewById(R.id.moodpage);
        gridview.setAdapter(new ImageAdapter(this));

        gridview.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            public void onItemClick(AdapterView<?> parent, View v, int position, long id) {
                //TODO make this add an element to the parse object
                Toast.makeText(Initial.this, "" + position, Toast.LENGTH_SHORT).show();
            }
        });
        */

        // labels for the buttons
        String[] labels=new String[]{
            "EAT WELL",
            "SLEEP WELL",
            "EXERCISE",
            "LEARN",
            "TALK",
            "MAKE",
            "PLAY",
            "CONNECT"
        };

        // references to our images
        Integer[] mThumbIds = {
            R.drawable.eat, R.drawable.sleep,
            R.drawable.talk, R.drawable.exercise,
            R.drawable.creative, R.drawable.learn,
            R.drawable.play, R.drawable.relationship,
        };

        //set up the gridlayout
        List<HashMap<String, String>> listinfo = new ArrayList<HashMap<String, String>>();
        listinfo.clear();
        for(int i=0;i<labels.length;i++){
            HashMap<String, String> hm = new HashMap<String, String>();
            hm.put("name",labels[i]);
            hm.put("image", Integer.toString(mThumbIds[i]));
            listinfo.add(hm);
        }

        // Keys used in Hashmap
        String[] from = { "image","name" };
        int[] to = { R.id.img,R.id.txt };
        SimpleAdapter adapter = new SimpleAdapter(getBaseContext(), listinfo,R.layout.activity_items, from, to);
        GridView moodgrid = (GridView) findViewById(R.id.moodpage);
        moodgrid.setAdapter(adapter);

        //set the parse api key
        Parse.initialize(this, "2MS1N1zfmK380WV1zOYR1jhJWAj5BEz6uuZsAbIW", "Ke6SEnngzAwKRSWoPumG22ojb7UOjLl312uwOAp8");

        //set the seek bar listener
        SeekBar.OnSeekBarChangeListener seeklistener = new SeekBar.OnSeekBarChangeListener() {
            @Override
            public void onProgressChanged(SeekBar seekBar, int progress, boolean fromUser) {
                openPullUp();
            }

            @Override
            public void onStartTrackingTouch(SeekBar seekBar) {

            }

            @Override
            public void onStopTrackingTouch(SeekBar seekBar) {

            }
        };

        double score = 70;

        setPoints(score);

        // set up for the local storage
        SharedPreferences sharedPref = this.getPreferences(Context.MODE_PRIVATE);
        SharedPreferences.Editor editor = sharedPref.edit();
        editor.putBoolean("my_first_time", true);
        editor.commit();


        if (sharedPref.getBoolean("my_first_time", true)) {
            //the app is being launched for first time, do something
            Log.v("Comments", "First time");

            editor.putInt("Score", 150);
            editor.commit();

            Date today = new Date(System.currentTimeMillis());
            Calendar now = DateToCalendar(today);
            now.add(Calendar.DAY_OF_YEAR, -8);

            editor.putLong("LastOpen", now.getTimeInMillis());
            editor.commit();


            Date d = new Date(sharedPref.getLong("LastOpen", 0));


            // record the fact that the app has been started at least once
            editor.putBoolean("my_first_time", false);
            editor.commit();
        }

        if (firstOpenOfTheDay()) {

            if (firstOpenOfTheWeek()) {
                editor.putFloat("Score", 150);
                editor.commit();
            } else {
                unOpenedPenalty();
                Toast toast = new Toast(this);
            }
        } else {
            //Nothing Happening here
            //Hide Buttons for now
        }

        editor.putLong("LastOpen", System.currentTimeMillis());
        editor.commit();

        boolean[] act = new boolean[8];
        act[3] = true;
        act[7] = true;

        int currscore = sharedPref.getInt("Score", 499);
        setPoints(currscore);
        updateActivities(act);
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {

        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.main, menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        // Handle action bar item clicks here. The action bar will
        // automatically handle clicks on the Home/Up button, so long
        // as you specify a parent activity in AndroidManifest.xml.
        int id = item.getItemId();
        if (id == R.id.action_settings) {
            return true;
        }
        return super.onOptionsItemSelected(item);
    }

    public void openPullUp(View view){
        menu.setVisibility(View.VISIBLE);
        //abar.show();
    }
/*
    @Override
    public Intent getSupportParentActivityIntent(){
        Intent i = new Intent(Initial.this, Initial.class);
        return i;
    }
*/


    @Override
    public boolean onTouchEvent(MotionEvent event){

        int action = MotionEventCompat.getActionMasked(event);

        switch(action) {
            case (MotionEvent.ACTION_DOWN) :
                if (menu.getVisibility() == View.VISIBLE){
                    menu.setVisibility(View.INVISIBLE);
                }
                return true;
            default :
                return super.onTouchEvent(event);
        }
    }

    public boolean firstOpenOfTheDay() {
        SharedPreferences sharedPref = this.getPreferences(Context.MODE_PRIVATE);
        Date today = new Date(System.currentTimeMillis());
        Date d = new Date(sharedPref.getLong("LastOpen", 0));

        Calendar cal = DateToCalendar(d);
        Calendar now = DateToCalendar(today);
        return !(now.DATE == cal.DATE);
    }

    public static Calendar DateToCalendar(Date date) {
        Calendar cal = Calendar.getInstance();
        cal.setTime(date);
        return cal;
    }

    public boolean firstOpenOfTheWeek() {
        SharedPreferences sharedPref = this.getPreferences(Context.MODE_PRIVATE);
        Date d = new Date(sharedPref.getLong("LastOpen", 0));
        Date today = new Date(System.currentTimeMillis());
        Calendar cal = DateToCalendar(d);
        Calendar now = DateToCalendar(today);
        return !(now.WEEK_OF_YEAR == cal.WEEK_OF_YEAR);
    }

    public int unOpenedPenalty() {
        SharedPreferences sharedPref = this.getPreferences(Context.MODE_PRIVATE);
        Date d = new Date(sharedPref.getLong("LastOpen", 0));
        Date today = new Date(System.currentTimeMillis());
        Calendar cal = DateToCalendar(d);
        Calendar now = DateToCalendar(today);
        int penalty= now.DAY_OF_WEEK-cal.DAY_OF_WEEK-1;
        return penalty*15;
    }

    /*public boolean setPoints(int score) {

        float fraction = score/500;
        double start;
        float end;
        start = -90;
        end = 360 * fraction;
        ShapeDrawable shape = new ShapeDrawable(new ArcShape((float) start, (float) end));
        shape.setIntrinsicHeight(350);
        shape.setIntrinsicWidth(350);
        shape.getPaint().setColor(Color.LTGRAY);

        ImageView foreground = new ImageView(this);
        Drawable mDrawable = shape;
        foreground = (ImageView) this.findViewById(R.id.meterforeground);
        foreground.setImageDrawable(mDrawable);

        return true;
    }
    */

    public boolean setPoints(double score){

        //TODO add real score
        score = .47;

        double start, end;
        start = -90;
        end = 360*score;
        ShapeDrawable shape = new ShapeDrawable(new ArcShape((float)start, (float)end));
        shape.setIntrinsicHeight(170);
        shape.setIntrinsicWidth(170);

        //set the color
        shape.getPaint().setColor(0xff01c390);

        ImageView foreground = new ImageView(this);
        Drawable mDrawable = shape;
        foreground = (ImageView)this.findViewById(R.id.meterforeground);
        foreground.setImageDrawable(mDrawable);

        return true;
    }

    public int updateActivities(boolean[] activities) {
        int score = 0;
        float scoreupdate = 0;
        Resources res = getResources();
        String[] types = res.getStringArray(R.array.button_labels);
        for (int i = 0; i < activities.length; i++) {
            if (activities[i]) {
                String name = "";
                SharedPreferences sharedPref = this.getPreferences(Context.MODE_PRIVATE);
                name = types[i];
                scoreupdate = sharedPref.getFloat(name, scoreupdate);
                SharedPreferences.Editor editor = sharedPref.edit();
                if (i < 2) {
                    editor.putFloat(name, scoreupdate + 5);
                    editor.commit();
                } else if (i < 6) {
                    editor.putFloat(name, scoreupdate + 7);
                    editor.commit();
                } else {
                    editor.putFloat(name, scoreupdate + 6);
                    editor.commit();
                }
            }
        }
        return score;
    }
}
/*
        mylist.setOnItemClickListener(new OnItemClickListener(){

            @Override
            public void onItemClick(AdapterView<?> arg0, View arg1, int arg2,
                                    long arg3) {
                Log.w("sdsd", "fdfdf");
                ListView lv = (ListView) arg0;
                TextView fishtextview=(TextView)arg0.getChildAt(arg2-lv.getFirstVisiblePosition()).findViewById(R.id.txt);
                String fieldname = fishtextview.getText().toString();
                Toast mtost=Toast.makeText(getApplicationContext(),fieldname, Toast.LENGTH_SHORT);
                mtost.show();
            }
        });
    }
*/