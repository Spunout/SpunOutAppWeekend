package ie.spunout.miyo.Fragments;

import android.content.Context;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ProgressBar;
import android.widget.TextView;

import ie.spunout.miyo.graph.Line;
import ie.spunout.miyo.graph.LineGraph;
import ie.spunout.miyo.graph.LinePoint;
import ie.spunout.miyo.DataPoint;
import ie.spunout.miyo.DatabaseHandler;
import ie.spunout.miyo.R;

/**
 * Created by jameswalsh on 16/02/2014.
 */
public class Graph extends Fragment{
    private View view;
    private boolean[] choices = {false,false,false,false,false,false};
    private String[] activity_labels = {"eat", "sleep", "exercise", "learn", "play", "connect"};
    private View[] buttons = new View[6];
    private int currentlySelected = 0;
    DatabaseHandler dh;
    private int[] current_timescale = {7,0};
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
        setActivityButtonOnClicks();
        setGraphButtonOnClicks();
        setupProgressBar();
        return view;
    }

    /**
     * This method draws the graph for any of the activities
     * @param activity      the activity which the data should be for
     */
    private void drawGraph(String activity){
        int [] points = getGraphData(activity);
        int max = 7;

        Line l = new Line();
        for (int i = 0; i < points.length; i++){
            //Log.i(TAG,"adding point to graph "+points[i]);
            LinePoint p = new LinePoint(i, points[i]);
            l.addPoint(p);
            if (points[i] >= max) max = points[i];
        }
        //l.addPoint(new LinePoint(0,0));
        //l.addPoint(new LinePoint(7,7));
        l.setColor(getResources().getColor(R.color.spunoutGreen));

        LineGraph li = (LineGraph) view.findViewById(R.id.graph);
        li.removeAllLines();
        li.addLine(l);
        li.setRangeX(0, points.length);
        li.setRangeY(0, max);
        li.setLineToFill(0);
    }

    /**
     * this will get the data for the graph for each activity
     * @param activity      this is the label of the activity
     *                      the data should be for
     *
     * @return an array containing the data points for the graph
     */
    private int[] getGraphData(String activity){
        //week 0 is the most recent week
        int[] points;
        //this is the accumulative difference in values over the weeks
        int diff = 0;
        int value;

        DataPoint[] data = dh.getNumberOf(activity, current_timescale[0], current_timescale[1]);
        points = new int[data.length];
        for (int i = 0; i < data.length; i++){
            points[i] = data[i].getValue();
        }
        /*for(int i = 1; i <= points.length; i++){
            //calculate the number of times done that week

            points[i-1] = value - diff;
            //Log.i(TAG, activity+" for week "+i+" is "+(value-diff));
            diff = value;
        }*/

        return points;
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

    private void setupButtons(){
        //load all the button views
        buttons[0] = view.findViewById(R.id.eat_button);
        buttons[1] = view.findViewById(R.id.sleep_button);
        buttons[2] = view.findViewById(R.id.move_button);
        buttons[3] = view.findViewById(R.id.learn_button);
        buttons[4] = view.findViewById(R.id.play_button);
        buttons[5] = view.findViewById(R.id.connect_button);
    }

    /**
     * Add on click methods for all of the activity buttons
     */
    private void setActivityButtonOnClicks(){
        View v;
        int normal = R.drawable.menu_item_normal;
        int[] viewArray = {
                R.id.eat_button, R.id.sleep_button,
                R.id.move_button, R.id.learn_button,
                R.id.play_button, R.id.connect_button};
        int[] bgArray= {
                R.drawable.eat_highlighted, R.drawable.sleep_highlighted,
                R.drawable.move_highlighted, R.drawable.learn_highlighted,
                R.drawable.play_highlighted, R.drawable.connect_highlighted};
        String[] labelArray = {
                "eat", "sleep", "exercise",
                "learn", "play", "connect"};

        for(int i = 0; i < 6; i++){
            v = view.findViewById(viewArray[i]);
            v.setOnClickListener(new GraphButtonOnClick(bgArray[i], normal, i, labelArray[i]));
        }
    }

    /**
     * Set the onclick listeners for the graph time range selection buttons
     */
    private void setGraphButtonOnClicks(){

        view.findViewById(R.id.button_all_time).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                current_timescale = new int[] {100,0};
                drawGraph(activity_labels[currentlySelected]);
            }
        });
        view.findViewById(R.id.button_this_month).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                current_timescale = new int[] {30,0};
                drawGraph(activity_labels[currentlySelected]);
            }
        });
        view.findViewById(R.id.button_last_week).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                current_timescale = new int[] {14,7};
                drawGraph(activity_labels[currentlySelected]);
            }
        });
        view.findViewById(R.id.button_this_week).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                current_timescale = new int[] {7,0};
                drawGraph(activity_labels[currentlySelected]);
            }
        });
    }

    private class GraphButtonOnClick implements View.OnClickListener{
        int bgId;
        int activityId;
        int normalBgId;
        String activityLabel;

        public GraphButtonOnClick(int bgId, int normalBgId, int activityId, String activityLabel){
            this.bgId = bgId;
            this.normalBgId = normalBgId;
            this.activityId = activityId;
            this.activityLabel = activityLabel;
        }

        @Override
        public void onClick(View v){
            if(!choices[activityId]){
                buttons[currentlySelected].setBackground(getResources().getDrawable(normalBgId));
                v.setBackground(getResources().getDrawable(bgId));
                choices[currentlySelected] = false;
                currentlySelected = activityId;
                choices[activityId] = true;
                drawGraph(activityLabel);
            }
        }
    }
}