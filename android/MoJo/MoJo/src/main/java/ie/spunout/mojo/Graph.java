package ie.spunout.mojo;

import android.content.Context;
import android.content.SharedPreferences;
import android.graphics.Color;
import android.graphics.drawable.Drawable;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ProgressBar;
import android.widget.TextView;

import ie.spunout.mojo.graph.Line;
import ie.spunout.mojo.graph.LineGraph;
import ie.spunout.mojo.graph.LinePoint;

/**
 * Created by jameswalsh on 16/02/2014.
 */
public class Graph extends Fragment{
    private View view;
    private boolean[] choices = {false,false,false,false,false,false,false,false,};
    private View[] buttons = new View[8];
    private int currentlySelected = 0;
    DatabaseHandler dh;
    private static final String TAG = "Miyo";   //log tag

    @Override
    public void onCreate(Bundle savedInstanceState){
        super.onCreate(savedInstanceState);
        dh = new DatabaseHandler(getActivity());
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,Bundle savedInstanceState){
        view = inflater.inflate(R.layout.fragment_graphs, container, false);
        setupButtons();
        setupOnClicks();
        setupProgressBar();
        return view;
    }

    private void drawGraph(String activity){
        int [] weeks = getGraphData(activity);

        Line l = new Line();
        for (int i = 0; i < weeks.length; i++){
            LinePoint p = new LinePoint(i, weeks[3-i]);
            l.addPoint(p);
        }
        l.setColor(Color.parseColor("#FFBB33"));

        LineGraph li = (LineGraph) view.findViewById(R.id.graph);
        li.removeAllLines();
        li.addLine(l);
        li.setRangeY(0, 7);
        li.setLineToFill(0);
    }

    /**
     * this will get the data for the graph for each activity
     * @param activity      this is the label of the activity
     *                      the data should be for
     */
    private int[] getGraphData(String activity){
        //week 0 is the most recent week
        int[] weeks = new int[4];
        //this is the accumulative difference in values over the weeks
        int diff = 0;
        int value;

        for(int i = 1; i <= weeks.length; i++){
            //calculate the number of times done that week
            value = dh.getNumberOf(activity, (i*7));
            weeks[i-1] = value - diff;
            Log.i(TAG, activity+" for week "+i+" is "+(value-diff));
            diff = value;
        }

        return weeks;
    }

    private void setupButtons(){
        //load all the button views
        buttons[0] = view.findViewById(R.id.eat_button);
        buttons[1] = view.findViewById(R.id.sleep_button);
        buttons[2] = view.findViewById(R.id.exercise_button);
        buttons[3] = view.findViewById(R.id.learn_button);
        buttons[4] = view.findViewById(R.id.talk_button);
        buttons[5] = view.findViewById(R.id.make_button);
        buttons[6] = view.findViewById(R.id.play_button);
        buttons[7] = view.findViewById(R.id.connect_button);
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
                //check if the item has already been selected
                if(!choices[0]){
                    //if not deselect the previous button and highlight this one
                    buttons[currentlySelected].setBackground(getResources().getDrawable(R.drawable.menu_item_normal));
                    v.setBackground(getResources().getDrawable(R.drawable.eat_highlighted));
                    choices[currentlySelected] = false;
                    currentlySelected = 0;
                    choices[0] = true;
                    drawGraph("eat");
                }
            }
        });

        //setup the sleep button listener
        View sleep = view.findViewById(R.id.sleep_button);
        sleep.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                //check if the item has already been selected
                if(!choices[1]){
                    //if not deselect the previous button and highlight this one
                    buttons[currentlySelected].setBackground(getResources().getDrawable(R.drawable.menu_item_normal));
                    v.setBackground(getResources().getDrawable(R.drawable.sleep_highlighted));
                    choices[currentlySelected] = false;
                    currentlySelected = 1;
                    choices[1] = true;
                    drawGraph("sleep");
                }
            }
        });

        //setup the exercise button listener
        View exercise = view.findViewById(R.id.exercise_button);
        exercise.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                //check if the item has already been selected
                if(!choices[2]){
                    //if not deselect the previous button and highlight this one
                    buttons[currentlySelected].setBackground(getResources().getDrawable(R.drawable.menu_item_normal));
                    v.setBackground(getResources().getDrawable(R.drawable.move_highlighted));
                    choices[currentlySelected] = false;
                    currentlySelected = 2;
                    choices[2] = true;
                    drawGraph("exercise");
                }
            }
        });

        //setup the learn button listener
        View learn = view.findViewById(R.id.learn_button);
        learn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                //check if the item has already been selected
                if(!choices[3]){
                    //if not deselect the previous button and highlight this one
                    buttons[currentlySelected].setBackground(getResources().getDrawable(R.drawable.menu_item_normal));
                    v.setBackground(getResources().getDrawable(R.drawable.learn_highlight));
                    choices[currentlySelected] = false;
                    currentlySelected = 3;
                    choices[3] = true;
                    drawGraph("learn");
                }
            }
        });

        //setup the talk button listener
        View talk = view.findViewById(R.id.talk_button);
        talk.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if(!choices[4]){
                    //if not deselect the previous button and highlight this one
                    buttons[currentlySelected].setBackground(getResources().getDrawable(R.drawable.menu_item_normal));
                    v.setBackground(getResources().getDrawable(R.drawable.talk_highlighted));
                    choices[currentlySelected] = false;
                    currentlySelected = 4;
                    choices[4] = true;
                    drawGraph("talk");
                }
            }
        });

        //setup the make button listener
        View make = view.findViewById(R.id.make_button);
        make.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if(!choices[5]){
                    //if not deselect the previous button and highlight this one
                    buttons[currentlySelected].setBackground(getResources().getDrawable(R.drawable.menu_item_normal));
                    v.setBackground(getResources().getDrawable(R.drawable.make_highlighted));
                    choices[currentlySelected] = false;
                    currentlySelected = 5;
                    choices[5] = true;
                    drawGraph("make");
                }
            }
        });

        //setup the play button listener
        View play = view.findViewById(R.id.play_button);
        play.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if(!choices[6]){
                    //if not deselect the previous button and highlight this one
                    buttons[currentlySelected].setBackground(getResources().getDrawable(R.drawable.menu_item_normal));
                    v.setBackground(getResources().getDrawable(R.drawable.play_highlighted));
                    choices[currentlySelected] = false;
                    currentlySelected = 6;
                    choices[6] = true;
                    drawGraph("play");
                }
            }
        });

        //setup the connect button listener
        View connect = view.findViewById(R.id.connect_button);
        connect.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if(!choices[7]){
                    //if not deselect the previous button and highlight this one
                    buttons[currentlySelected].setBackground(getResources().getDrawable(R.drawable.menu_item_normal));
                    v.setBackground(getResources().getDrawable(R.drawable.connect_highlighted));
                    choices[currentlySelected] = false;
                    currentlySelected = 7;
                    choices[7] = true;
                    drawGraph("connect");
                }
            }
        });
    }

    /**
     * Sets the level number at the top of the page and
     * sets the value of the progress bar
     */
    private void setupProgressBar(){
        //set the level number
        SharedPreferences prefs = getActivity().getPreferences(Context.MODE_PRIVATE);
        Integer level = prefs.getInt("current_level", 0);
        TextView levelNumber = (TextView) view.findViewById(R.id.level_number);
        levelNumber.setText(level.toString());

        //set the value for the progress bar
        Integer max = prefs.getInt("points_to_next_level", 0);
        Long points = dh.getRecentLTP();
        ProgressBar bar = (ProgressBar) view.findViewById(R.id.progressBar);
        bar.setMax(max);
        bar.setProgress(points.intValue());
    }

}