package ie.spunout.mojo;

import android.animation.ValueAnimator;
import android.support.v4.app.Fragment;
import android.content.Context;
import android.content.SharedPreferences;
import android.content.res.Resources;
import android.graphics.Point;
import android.graphics.drawable.Drawable;
import android.graphics.drawable.ShapeDrawable;
import android.graphics.drawable.shapes.ArcShape;
import android.os.Bundle;
import android.util.Log;
import android.view.Display;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.SeekBar;
import android.widget.TextView;

//TODO: fix this so that we don't have to have min api lvl 19

import java.util.Calendar;
import java.util.Date;
import java.util.Scanner;

//TODO: the "EAT WELL" button icon is lighter than the other button icons
public class Score extends Fragment {
    private View view;                          //the view activity
    private SeekBar sbar;                       //the seekbar in the view
    private int score;                          //The users current score
    private TextView scoreNumber;               //the score in the middle of the circle
    private TextView prompt;                    //the text shown on screen to prompt the user
    private ImageView meterForeground;          //the circle filling the score indicator
    private ImageView meterBackground;
    private Miyo miyo;                          //keeps track of the selected activities
    private DatabaseHandler dh;                 //used to interact with the database
    private int lastSet;                        //keeps track of the last action recorded for the slider
    private int[] pointValues = {7,7,5,5,5,5,5,5};
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
        view = inflater.inflate(R.layout.fragment_score, container, false);
        scoreNumber = (TextView) view.findViewById(R.id.score_number);
        prompt = (TextView) view.findViewById(R.id.prompt);

        drawIcons();
        setupOnClicks();
        setupScore();
        setupMeter();
        drawCircle();
        loadActivities();
        loadTimesLogged();
        setupSeekbar();

        return view;
    }

    /**
     * Hide the seekbar
     */
    private void setupSeekbar(){
        sbar = (SeekBar) view.findViewById(R.id.slider);
        sbar.setVisibility(View.INVISIBLE);
        sbar.setMax(100);

        sbar.setOnSeekBarChangeListener(new SeekBar.OnSeekBarChangeListener() {
            @Override
            public void onProgressChanged(SeekBar seekBar, int progress, boolean fromUser) {

            }

            @Override
            public void onStartTrackingTouch(SeekBar seekBar) {

            }

            @Override
            public void onStopTrackingTouch(SeekBar seekBar) {
                //remove the points from the last log from the points circle
                updatePoints(-(miyo.getAny(lastSet)));
                //log a new miyo
                float current = (float) sbar.getProgress();
                float pointValue = (float) pointValues[lastSet];
                float oneHundred = 100;
                float value = current * pointValue / oneHundred;
                int result = (int) Math.round(value);

                miyo.setAny(lastSet, result);
                dh.addMiyo(miyo);
                updatePoints(result);
                incrementTimesLogged();
            }
        });
    }

    /**
     * Show the seekbar and change the prompt text.
     */
    private void updateScreen(){

    }

    /**
     * Add on click methods for all of the activity buttons
     */
    private void setupOnClicks(){
        //setup the eat button listener
        View eat = view.findViewById(R.id.eat_button);
        eat.setOnClickListener(new ActivityButtonOnClick(R.id.eat_img, 0, R.drawable.eat_g, R.drawable.eat_w, "eat"));

        //setup the sleep button listener
        View sleep = view.findViewById(R.id.sleep_button);
        sleep.setOnClickListener(new ActivityButtonOnClick(R.id.sleep_img, 1, R.drawable.sleep_g, R.drawable.sleep_w, "sleep"));

        //setup the exercise button listener
        View exercise = view.findViewById(R.id.exercise_button);
        exercise.setOnClickListener(new ActivityButtonOnClick(R.id.exercise_img, 2, R.drawable.exercise_g, R.drawable.exercise_w, "exercise"));

        //setup the learn button listener
        View learn = view.findViewById(R.id.learn_button);
        learn.setOnClickListener(new ActivityButtonOnClick(R.id.learn_img, 3, R.drawable.learn_g, R.drawable.learn_w, "learn"));


        //setup the talk button listener
        View talk = view.findViewById(R.id.talk_button);
        talk.setOnClickListener(new ActivityButtonOnClick(R.id.talk_img, 4, R.drawable.talk_g, R.drawable.talk_w, "talk"));


        //setup the make button listener
        View make = view.findViewById(R.id.make_button);
        make.setOnClickListener(new ActivityButtonOnClick(R.id.make_img, 5, R.drawable.make_g, R.drawable.make_w, "make"));


        //setup the play button listener
        View play = view.findViewById(R.id.play_button);
        play.setOnClickListener(new ActivityButtonOnClick(R.id.play_img, 6, R.drawable.play_g, R.drawable.play_w, "play"));


        //setup the connect button listener
        View connect = view.findViewById(R.id.connect_button);
        connect.setOnClickListener(new ActivityButtonOnClick(R.id.connect_img, 7, R.drawable.connect_g, R.drawable.connect_w, "connect"));
    }

    /**
     * Loads todays most recently logged record from the database and sets the
     * activity button icons appropriately, it won't set anything if there's
     * no entries for today.
     */
    private void loadActivities(){
        Long timestamp = dh.getTodayEntryOrZero();
        if(timestamp == 0){
            miyo = new Miyo();
        }else{
            miyo = dh.getMiyo(timestamp);
            Drawable newBackground = getResources().getDrawable(R.drawable.menu_item_highlighted);
            View v;
            ImageView image;

            //TODO: move these to the class level and use everywhere
            int[] vArray = {
                    R.id.eat_button, R.id.sleep_button,
                    R.id.exercise_button, R.id.learn_button,
                    R.id.talk_button, R.id.make_button,
                    R.id.play_button, R.id.connect_button};

            int[] iArray = {
                    R.id.eat_img, R.id.sleep_img,
                    R.id.exercise_img, R.id.learn_img,
                    R.id.talk_img, R.id.make_img,
                    R.id.play_img, R.id.connect_img};
            
            int[] wArray = {
                    R.drawable.eat_w, R.drawable.sleep_w,
                    R.drawable.exercise_w, R.drawable.learn_w,
                    R.drawable.talk_w, R.drawable.make_w,
                    R.drawable.play_w, R.drawable.connect_w};

            int[] gArray = {
                    R.drawable.eat_g, R.drawable.sleep_g,
                    R.drawable.exercise_g, R.drawable.learn_g,
                    R.drawable.talk_g, R.drawable.make_g,
                    R.drawable.play_g, R.drawable.connect_g};
            
            for(int i = 0; i < 8; i++){
                v = view.findViewById(vArray[i]);
                image = (ImageView) view.findViewById(iArray[i]);
                if(miyo.getAny(i) > 0){
                    v.setBackground(newBackground);
                    image.setImageDrawable(getResources().getDrawable(wArray[i]));
                }else{
                    image.setImageDrawable(getResources().getDrawable(gArray[i]));
                }
            }
        }
    }

    /**
     * Loads the number of times the user has logged activities today and
     * sets the times_logged text view to that value.
     */
    public void loadTimesLogged(){
        SharedPreferences prefs = getActivity().getPreferences(Context.MODE_PRIVATE);
        int timesLogged = prefs.getInt("times_logged", 0);

        TextView tv = (TextView) view.findViewById(R.id.times_logged);
        tv.setText(String.valueOf(timesLogged));
    }

    /**
     * Increments the count of records stored today and called loadTimesLogged to
     * update the displayed view.
     */
    public void incrementTimesLogged(){
        SharedPreferences prefs = getActivity().getPreferences(Context.MODE_PRIVATE);
        SharedPreferences.Editor editor = prefs.edit();

        int timesLogged = prefs.getInt("times_logged", 0);
        timesLogged++;
        editor.putInt("times_logged", timesLogged);
        editor.commit();
        loadTimesLogged();
    }

    /**
     * Draws the score circle proportionally for the screen using the min of either the
     * width or the height of the display
     */
    private void setupMeter(){
        meterForeground = (ImageView) view.findViewById(R.id.meterforeground);
        meterBackground = (ImageView) view.findViewById(R.id.meterbackground);


        Display display = getActivity().getWindowManager().getDefaultDisplay();
        Point size = new Point();
        display.getSize(size);
        int width = size.x;
        int height = size.y;
        int min = (width > height)? height: width;

        double outerSize = min * .65;
        double innerSize = min * .6;

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
    //laura's code
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

    /**
     * set the icons on the action buttons
     */
    public void drawIcons(){
        //
    }

    private class ActivityButtonOnClick implements View.OnClickListener{
        int imageId;
        int activityId;
        int gDrawable;
        int wDrawable;
        int pointsValue;
        String activityLabel;

        public ActivityButtonOnClick(int imageId, int activityId, int gDrawable, int wDrawable, String activityLabel){
            this.imageId = imageId;
            this.activityId = activityId;
            this.gDrawable = gDrawable;
            this.wDrawable = wDrawable;
            this.pointsValue = pointsValue;
            this.activityLabel = activityLabel;
        }

        @Override
        public void onClick(View v){
            ImageView image = (ImageView) v.findViewById(imageId);
            Drawable newBackground;
            Drawable newIcon;

            //check if the item has already been selected
            if(miyo.getAny(activityId) > 0){
                //if so, deselect it
                newBackground = getResources().getDrawable(R.drawable.menu_item_normal);
                newIcon = getResources().getDrawable(gDrawable);
                updatePoints(-(miyo.getAny(activityId)));
                miyo.setAny(activityId, 0);
                //log the change in the database
                dh.addMiyo(miyo);
                sbar.setVisibility(View.INVISIBLE);
                prompt.setText("What have you done today?");
            }else{
                //if not, select it
                sbar.setVisibility(View.VISIBLE);
                newBackground = getResources().getDrawable(R.drawable.menu_item_highlighted);
                newIcon = getResources().getDrawable(wDrawable);
                miyo.setAny(activityId, pointValues[activityId]);
                dh.addMiyo(miyo);
                updatePoints(pointValues[activityId]);
                incrementTimesLogged();
                prompt.setText("How well did you "+activityLabel+"?");
                lastSet = activityId;
            }
            v.setBackground(newBackground);
            image.setImageDrawable(newIcon);
        }
    }
}
