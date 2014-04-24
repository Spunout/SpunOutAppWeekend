package ie.spunout.mojo;

import android.content.Context;
import android.content.SharedPreferences;
import android.graphics.Color;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
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
    private boolean[] choices = {false,false,false,false,false,false};
    private View[] buttons = new View[6];
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
        setActivityButtonOnClicks();
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
        l.setColor(getResources().getColor(R.color.spunoutGreen));

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
        Button b = (Button) view.findViewById(R.id.button_all_time);
        b.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {

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