package ie.spunout.mojo;

import android.animation.ValueAnimator;
import android.provider.ContactsContract;
import android.support.v4.app.Fragment;
import android.content.Context;
import android.content.SharedPreferences;
import android.content.res.Resources;
import android.graphics.Color;
import android.graphics.Point;
import android.graphics.drawable.Drawable;
import android.graphics.drawable.ShapeDrawable;
import android.graphics.drawable.shapes.ArcShape;
import android.os.Bundle;
import android.support.v4.widget.DrawerLayout;
import android.util.Log;
import android.view.Display;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.SeekBar;
import android.widget.TextView;
import android.widget.Toast;

//TODO: fix this so that we don't have to have min api lvl 19

import java.util.Calendar;
import java.util.Date;
import java.util.Scanner;

public class Initial extends Fragment {
    private View view;                          //the view activity
    private SeekBar sbar;                       //the seekbar in the view
    private int score;                          //The users current score
    private TextView scoreNumber;               //the score in the middle of the circle
    private ImageView meterForeground;          //the circle filling the score indicator
    private ImageView meterBackground;
    private Miyo miyo;                          //keeps track of the selected activities
    private DatabaseHandler dh;                 //used to interact with the database
    private static final String TAG = "Miyo";   //log tag

    @Override
    public void onCreate(Bundle savedInstanceState)  {
        super.onCreate(savedInstanceState);

        //setup a Miyo object to keep track of the activities
        miyo = new Miyo();

        //setup the database handler
        dh = new DatabaseHandler(getActivity());
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,Bundle savedInstanceState) {
        view = inflater.inflate(R.layout.fragment_initial, container, false);
        scoreNumber = (TextView) view.findViewById(R.id.score_number);

        //TODO: make sure all of these are in the right order

        //TODO the start point is 150

        //TODO make the size of the circle dynamic, check screen size and scale

        //attach onclick methods to the activity buttons
        setupOnClicks();

        //setup the score
        setupScore();

        //set the size of the meter
        setupMeter();
        drawCircle();

        //load miyo
        loadMiyo();

        return view;
    }

    /**
     * Add on click methods for all of the activity buttons
     */
    private void setupOnClicks(){
        //setup the eat button listener
        View eat = view.findViewById(R.id.eat_button);
        eat.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Drawable newBackground;

                //check if the item has already been selected
                if(miyo.getEat() == 1){
                    //if so, deselect it
                    newBackground = getResources().getDrawable(R.drawable.menu_item_normal);
                    miyo.setEat(0);
                    //log the change in the database
                    dh.addMiyo(miyo);
                    updatePoints(-7);
                }else{
                    //if not, highlight it
                    newBackground = getResources().getDrawable(R.drawable.menu_item_highlighted);
                    miyo.setEat(1);
                    dh.addMiyo(miyo);
                    updatePoints(7);
                }
                v.setBackground(newBackground);

                //store the new state of the activities

            }
        });

        //setup the sleep button listener
        View sleep = view.findViewById(R.id.sleep_button);
        sleep.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Drawable newBackground;

                //check if the item has already been selected
                if(miyo.getSleep() == 1){
                    //if so, deselect it
                    newBackground = getResources().getDrawable(R.drawable.menu_item_normal);
                    miyo.setSleep(0);
                    dh.addMiyo(miyo);
                    updatePoints(-7);
                }else{
                    //if not, highlight it
                    newBackground = getResources().getDrawable(R.drawable.menu_item_highlighted);
                    miyo.setSleep(1);
                    dh.addMiyo(miyo);
                    updatePoints(7);
                }
                v.setBackground(newBackground);
            }
        });

        //setup the exercise button listener
        View exercise = view.findViewById(R.id.exercise_button);
        exercise.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Drawable newBackground;

                //check if the item has already been selected
                if(miyo.getExercise() == 1){
                    //if so, deselect it
                    newBackground = getResources().getDrawable(R.drawable.menu_item_normal);
                    miyo.setExercise(0);
                    dh.addMiyo(miyo);
                    updatePoints(-5);
                }else{
                    //if not, highlight it
                    newBackground = getResources().getDrawable(R.drawable.menu_item_highlighted);
                    miyo.setExercise(1);
                    dh.addMiyo(miyo);
                    updatePoints(5);
                }
                v.setBackground(newBackground);
            }
        });

        //setup the learn button listener
        View learn = view.findViewById(R.id.learn_button);
        learn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Drawable newBackground;

                //check if the item has already been selected
                if(miyo.getLearn() == 1){
                    //if so, deselect it
                    newBackground = getResources().getDrawable(R.drawable.menu_item_normal);
                    miyo.setLearn(0);
                    dh.addMiyo(miyo);
                    updatePoints(-5);
                }else{
                    //if not, highlight it
                    newBackground = getResources().getDrawable(R.drawable.menu_item_highlighted);
                    miyo.setLearn(1);
                    dh.addMiyo(miyo);
                    updatePoints(5);
                }
                v.setBackground(newBackground);
            }
        });

        //setup the talk button listener
        View talk = view.findViewById(R.id.talk_button);
        talk.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Drawable newBackground;

                //check if the item has already been selected
                if(miyo.getTalk() == 1){
                    //if so, deselect it
                    newBackground = getResources().getDrawable(R.drawable.menu_item_normal);
                    miyo.setTalk(0);
                    dh.addMiyo(miyo);
                    updatePoints(-7);
                }else{
                    //if not, highlight it
                    newBackground = getResources().getDrawable(R.drawable.menu_item_highlighted);
                    miyo.setTalk(1);
                    dh.addMiyo(miyo);
                    updatePoints(7);
                }
                v.setBackground(newBackground);
            }
        });

        //setup the make button listener
        View make = view.findViewById(R.id.make_button);
        make.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Drawable newBackground;

                //check if the item has already been selected
                if(miyo.getMake() == 1){
                    //if so, deselect it
                    newBackground = getResources().getDrawable(R.drawable.menu_item_normal);
                    miyo.setMake(0);
                    dh.addMiyo(miyo);
                    updatePoints(-5);
                }else{
                    //if not, highlight it
                    newBackground = getResources().getDrawable(R.drawable.menu_item_highlighted);
                    miyo.setMake(1);
                    dh.addMiyo(miyo);
                    updatePoints(5);
                }
                v.setBackground(newBackground);
            }
        });

        //setup the play button listener
        View play = view.findViewById(R.id.play_button);
        play.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Drawable newBackground;

                //check if the item has already been selected
                if(miyo.getPlay() == 1){
                    //if so, deselect it
                    newBackground = getResources().getDrawable(R.drawable.menu_item_normal);
                    miyo.setPlay(0);
                    dh.addMiyo(miyo);
                    updatePoints(-5);
                }else{
                    //if not, highlight it
                    newBackground = getResources().getDrawable(R.drawable.menu_item_highlighted);
                    miyo.setPlay(1);
                    dh.addMiyo(miyo);
                    updatePoints(5);
                }
                v.setBackground(newBackground);
            }
        });

        //setup the connect button listener
        View connect = view.findViewById(R.id.connect_button);
        connect.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Drawable newBackground;

                //check if the item has already been selected
                if(miyo.getConnect() == 1){
                    //if so, deselect it
                    newBackground = getResources().getDrawable(R.drawable.menu_item_normal);
                    miyo.setConnect(0);
                    dh.addMiyo(miyo);
                    updatePoints(-7);
                }else{
                    //if not, highlight it
                    newBackground = getResources().getDrawable(R.drawable.menu_item_highlighted);
                    miyo.setConnect(1);
                    dh.addMiyo(miyo);
                    updatePoints(7);
                }
                v.setBackground(newBackground);
            }
        });
    }

    private void loadMiyo(){
        Long timestamp = dh.getTodayEntryOrZero();
        if(timestamp == 0){
            miyo = new Miyo();
        }else{
            miyo = dh.getMiyo(timestamp);
            Drawable newBackground = getResources().getDrawable(R.drawable.menu_item_highlighted);

            View eat = view.findViewById(R.id.eat_button);
            //set the buttons
            if(miyo.getEat() == 1){
                eat.setBackground(newBackground);
            }
            View sleep = view.findViewById(R.id.sleep_button);
            //set the buttons
            if(miyo.getSleep() == 1){
                sleep.setBackground(newBackground);
            }
            View move = view.findViewById(R.id.exercise_button);
            //set the buttons
            if(miyo.getExercise() == 1){
                move.setBackground(newBackground);
            }
            View learn = view.findViewById(R.id.learn_button);
            //set the buttons
            if(miyo.getLearn() == 1){
                learn.setBackground(newBackground);
            }
            View talk = view.findViewById(R.id.talk_button);
            //set the buttons
            if(miyo.getTalk() == 1){
                talk.setBackground(newBackground);
            }
            View make = view.findViewById(R.id.make_button);
            //set the buttons
            if(miyo.getMake() == 1){
                make.setBackground(newBackground);
            }
            View play = view.findViewById(R.id.play_button);
            //set the buttons
            if(miyo.getPlay() == 1){
                play.setBackground(newBackground);
            }
            View connect = view.findViewById(R.id.connect_button);
            //set the buttons
            if(miyo.getConnect() == 1){
                connect.setBackground(newBackground);
            }
        }
    }

    /**
     * Draws the score circle proportionally for the screen
     */
    private void setupMeter(){
        meterForeground = (ImageView) view.findViewById(R.id.meterforeground);
        meterBackground = (ImageView) view.findViewById(R.id.meterbackground);


        Display display = getActivity().getWindowManager().getDefaultDisplay();
        Point size = new Point();
        display.getSize(size);
        int width = size.x;
        int height = size.y;

        double outerSize = width * .65;
        double innerSize = width * .6;

        Log.i(TAG,"meter size = "+String.valueOf(outerSize)+","+String.valueOf(innerSize));

        meterBackground.getLayoutParams().height = (int)outerSize;
        meterBackground.getLayoutParams().width = (int)outerSize;
        meterForeground.getLayoutParams().height = (int)innerSize;
        meterForeground.getLayoutParams().width = (int)innerSize;
        scoreNumber.getLayoutParams().height = (int)outerSize;
        scoreNumber.getLayoutParams().width = (int)outerSize;
    }

    private void setupScore(){
        SharedPreferences prefs = getActivity().getPreferences(Context.MODE_PRIVATE);
        //get the score view items
        score = prefs.getInt("current_points", 150);
        scoreNumber.setText(String.valueOf(score));
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
        foreground = (ImageView) view.findViewById(R.id.meterforeground);
        foreground.setImageDrawable(mDrawable);

        return true;
    }

    /**
     * Stores the new value of points locally and in shared prefs
     * and redraws the circle with the new value
     * @param change    the amout to change points by
     */
    public void updatePoints(int change){
        SharedPreferences prefs = getActivity().getPreferences(Context.MODE_PRIVATE);
        SharedPreferences.Editor editor = prefs.edit();
        score += change;

        editor.putInt("current_points", score);
        editor.commit();
        drawCircle();
        scoreNumber.setText(String.valueOf(score));
    }

    //draws the meter circle
    public boolean drawCircle(){
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
        ImageView foreground = (ImageView) view.findViewById(R.id.meterforeground);
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
        Log.i(TAG, "recording choices: "+miyo.toString());
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
