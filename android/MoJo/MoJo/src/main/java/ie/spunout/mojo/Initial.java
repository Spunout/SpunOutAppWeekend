package ie.spunout.mojo;

import android.animation.ValueAnimator;
import android.app.Activity;
import android.app.ActionBar;
import android.app.Fragment;
import android.app.TaskStackBuilder;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.res.Resources;
import android.graphics.Color;
import android.graphics.Point;
import android.graphics.drawable.Drawable;
import android.graphics.drawable.ShapeDrawable;
import android.graphics.drawable.shapes.ArcShape;
import android.graphics.drawable.shapes.Shape;
import android.media.Image;
import android.os.Bundle;
import android.provider.Settings;
import android.support.v4.view.MotionEventCompat;
import android.support.v7.app.ActionBarActivity;
import android.util.JsonWriter;
import android.util.Log;
import android.util.SparseBooleanArray;
import android.view.Display;
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
import android.widget.TextView;
import android.widget.Toast;
import android.provider.Settings.Secure;

//TODO: fix this so that we don't have to have min api lvl 19
import org.json.*;

import com.parse.FunctionCallback;
import com.parse.Parse;
import com.parse.ParseCloud;
import com.parse.ParseException;
import com.parse.ParseObject;
import com.parse.ParseUser;
import com.parse.SignUpCallback;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Objects;
import java.util.Scanner;

public class Initial extends android.support.v4.app.Fragment {
    private View menu;                      //the object for the choice menu
    private View parent;                    //the parent activity
    private SeekBar sbar;                   //the seekbar in the view
    private int score;                      //The users current score
    private TextView scoreNumber;           //the score in the middle of the circle
    private ImageView meterForeground;      //the circle filling the score indicator
    private ImageView meterBackground;
    private boolean[] choices;              //keeps track of the users current choices in the menu
    private static final String TAG = "Miyo";//log tag

    @Override
    public void  onCreate(Bundle savedInstanceState)  {
        super.onCreate(savedInstanceState);

    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,Bundle savedInstanceState) {
        parent = inflater.inflate(R.layout.initial_layout, container, false);

        //get the parent activity
        //parent = getActivity();

        //hide the action bar
        //abar = getActionBar();
        //abar.hide();
        //abar.setDisplayHomeAsUpEnabled(true);

        //TODO: make sure all of these are in the right order

        //hide the overlay menu
        //menu = findViewById(R.id.hideable);
        //menu.setVisibility(View.INVISIBLE);

        //TODO the start point is 150

        //TODO make the size of the circle dynamic, check screen size and scale

        //generate the items for the menu list
        setupGrid();

        //set the size of the meter
        setupMeter();

        //get the score view items
        score = 100;
        scoreNumber.setText(String.valueOf(score));

        //setup the seekbar listener
        setupSeekbar();

        //setup the choices array from device memory
        setupChoices();

        //setup the score system for this use
        setupScore();

        return parent;
    }

    private void setupGrid(){
        //TODO try and store this in the strings file
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
        SimpleAdapter adapter = new SimpleAdapter(getActivity().getBaseContext(), listinfo,R.layout.activity_items, from, to);
        GridView moodgrid = (GridView) parent.findViewById(R.id.moodpage);
        moodgrid.setAdapter(adapter);

        moodgrid.setItemChecked(3,true);

        //set what will happen when an item in the view is clicked
        moodgrid.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                Drawable newBackground;

                //check if the item has already been selected
                if(choices[position]){
                    //if so, deselect it
                    newBackground = getResources().getDrawable(R.drawable.menu_item_normal);
                    choices[position] = false;
                }else{
                    //if not, highlight it
                    newBackground = getResources().getDrawable(R.drawable.menu_item_highlighted);
                    choices[position] = true;
                }
                view.setBackground(newBackground);
            }
        });
    }

    private void setupSeekbar(){
        //create a seekbar listener that will open the menu when the seekbar is set
        SeekBar.OnSeekBarChangeListener seeklistener = new SeekBar.OnSeekBarChangeListener() {
            @Override
            public void onProgressChanged(SeekBar seekBar, int progress, boolean fromUser) {

            }

            @Override
            public void onStartTrackingTouch(SeekBar seekBar) {

            }

            @Override
            public void onStopTrackingTouch(SeekBar seekBar) {
                //when the user has chosen a value open the menu
                int value = seekBar.getProgress();
                //TODO make sure that this is the max score
                int diff = (score+value) < 500 ? value: value-((score+value)%500);
                for (int i = 0; i < diff; i++){
                    incrementScore();
                }
            }
        };

        //assign this listener to the seekbar
        sbar = (SeekBar) parent.findViewById(R.id.seekbar);
        sbar.setOnSeekBarChangeListener(seeklistener);
    }

    private void setupScore(){
        //TODO remove this and get the score from storage
        setPoints();

        // set up for the local storage
        SharedPreferences sharedPref = getActivity().getPreferences(Context.MODE_PRIVATE);
        SharedPreferences.Editor editor = sharedPref.edit();
        //editor.putBoolean("my_first_time", true);
        editor.commit();

        Log.i(TAG,Boolean.toString(sharedPref.getBoolean("my_first_time", true)));

        if (sharedPref.getBoolean("my_first_time", true)) {
            //the app is being launched for first time, do something
            Log.v("Comments", "First time");

            editor.putInt("Score", 150);
            editor.commit();

            //TODO: move this to outside of the if statement
            Date today = new Date(System.currentTimeMillis());
            Calendar now = DateToCalendar(today);
            now.add(Calendar.DAY_OF_YEAR, -8);

            editor.putLong("LastOpen", now.getTimeInMillis());
            editor.commit();

            Date d = new Date(sharedPref.getLong("LastOpen", 0));

            // record the fact that the app has been started at least once
            editor.putBoolean("my_first_time", false);
            editor.commit();
        }else{
            //this is not the first time the user has opened the app
            Log.i(TAG,"Logging in not for the first time");
        }

        if (firstOpenOfTheDay()) {
            Log.i(TAG,"First open of the day");
            if (firstOpenOfTheWeek()) {
                editor.putFloat("Score", 150);
                editor.commit();
            } else {
                unOpenedPenalty();
                Toast toast = new Toast(getActivity());
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
        setPoints();
        updateActivities(act);
    }

    private void setupMeter(){
        meterForeground = (ImageView) parent.findViewById(R.id.meterforeground);
        meterBackground = (ImageView) parent.findViewById(R.id.meterbackground);
        scoreNumber = (TextView) parent.findViewById(R.id.score_number);


        Display display = getActivity().getWindowManager().getDefaultDisplay();
        Point size = new Point();
        display.getSize(size);
        int width = size.x;
        int height = size.y;

        double outerSize = width * .7;
        double innerSize = width * .65;

        Log.i(TAG,"meter size = "+String.valueOf(outerSize)+","+String.valueOf(innerSize));

        meterBackground.getLayoutParams().height = (int)outerSize;
        meterBackground.getLayoutParams().width = (int)outerSize;
        meterForeground.getLayoutParams().height = (int)innerSize;
        meterForeground.getLayoutParams().width = (int)innerSize;
        scoreNumber.getLayoutParams().height = (int)outerSize;
        scoreNumber.getLayoutParams().width = (int)outerSize;
    }

    private void setupChoices(){
        //set all the choices to false initially
        //TODO: load these from the local storage
        choices = new boolean[] {false,false,false,false,false,false,false,false};
    }

    private void incrementScore(){
        score++;
        //update the score in the view
        scoreNumber.setText(String.valueOf(score));
        setPoints();
        /**
        try{
            wait(1000);
        }catch (Exception e){
            e.printStackTrace();
        }*/

    }

    public boolean firstOpenOfTheDay() {
        SharedPreferences sharedPref = getActivity().getPreferences(Context.MODE_PRIVATE);
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
        SharedPreferences sharedPref = getActivity().getPreferences(Context.MODE_PRIVATE);
        Date d = new Date(sharedPref.getLong("LastOpen", 0));
        Date today = new Date(System.currentTimeMillis());
        Calendar cal = DateToCalendar(d);
        Calendar now = DateToCalendar(today);
        return !(now.WEEK_OF_YEAR == cal.WEEK_OF_YEAR);
    }

    public int unOpenedPenalty() {
        SharedPreferences sharedPref = getActivity().getPreferences(Context.MODE_PRIVATE);
        Date d = new Date(sharedPref.getLong("LastOpen", 0));
        Date today = new Date(System.currentTimeMillis());
        Calendar cal = DateToCalendar(d);
        Calendar now = DateToCalendar(today);
        int penalty= now.DAY_OF_WEEK-cal.DAY_OF_WEEK-1;
        return penalty*15;
    }

    //TODO decide which of these is correct
    public boolean alternateSetPoints(int score) {

        float fraction = score/500;
        double start;
        float end;
        start = -90;
        end = 360 * fraction;
        ShapeDrawable shape = new ShapeDrawable(new ArcShape((float) start, (float) end));
        shape.setIntrinsicHeight(350);
        shape.setIntrinsicWidth(350);
        shape.getPaint().setColor(Color.LTGRAY);

        ImageView foreground = new ImageView(getActivity());
        Drawable mDrawable = shape;
        foreground = (ImageView) parent.findViewById(R.id.meterforeground);
        foreground.setImageDrawable(mDrawable);

        return true;
    }

    //draws the meter circle
    public boolean setPoints(){
        //calculate the score as a 0-1 double
        double scoreScale = (double) score/500;

        double start, end;
        start = -90;
        end = 360*scoreScale;
        ArcShape arc = new ArcShape((float)start, (float)end);
        ShapeDrawable shape = new ShapeDrawable(arc);
        shape.setIntrinsicHeight(170);
        shape.setIntrinsicWidth(170);

        //set the color
        shape.getPaint().setColor(0xff01c390);

        ValueAnimator anim = new ValueAnimator();
        anim.setTarget(arc);

        Drawable mDrawable = shape;
        ImageView foreground = (ImageView) parent.findViewById(R.id.meterforeground);
        foreground.setImageDrawable(mDrawable);

        foreground.getDrawable();

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
                SharedPreferences sharedPref = getActivity().getPreferences(Context.MODE_PRIVATE);
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

    public void recordChoices(View view){
        Log.i(TAG, "recording choices: "+choices);
    }

    //code to calculate whether they have achieved badges
    public class CalculateLevel {
        private final Integer[] levels = new Integer[29];
        private Scanner sc;

        public void main(String[]args){
            double multiplier = 1.55;
            levels[0] = 10;
            //initiate an array with the values that need to be passed to level up
            for(int i = 1; i <=28; i ++ ){
                levels[i] = (int) (levels[i-1]*multiplier);
                if(i==10){
                    multiplier = 1.1;
                }
            }
            //assign a value to lifepoints
            int lifePoints = 0;
            //pull value of lifepoints from db
            new CalculateLevel(levels, lifePoints);
        }

        //using the lifePoints calculate the level that the user is at.
        private CalculateLevel(Integer[] levels, int lifePoints){
            if(lifePoints > levels[27]){
                System.out.print("You are at level 28");
            }
            for(int i = 0; i<28; i++){
                if(lifePoints < 10){
                    System.out.print("You are at level 0");
                    break;
                }else if(lifePoints >= levels[i] && lifePoints <= levels[i+1]){
                    System.out.print("You are at level " + (i+1));
                    break;
                }
            }
        }
    }
}
