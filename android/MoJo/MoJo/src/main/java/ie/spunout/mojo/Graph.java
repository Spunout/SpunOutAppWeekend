package ie.spunout.mojo;

import android.graphics.Color;
import android.graphics.drawable.Drawable;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import ie.spunout.mojo.graph.Line;
import ie.spunout.mojo.graph.LineGraph;
import ie.spunout.mojo.graph.LinePoint;

/**
 * Created by jameswalsh on 16/02/2014.
 */
public class Graph extends Fragment{
    private View view;
    private boolean[] choices = {false,false,false,false,false,false,false,false,};

    @Override
    public void onCreate(Bundle savedInstanceState){
        super.onCreate(savedInstanceState);

    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,Bundle savedInstanceState){
        view = inflater.inflate(R.layout.fragment_graphs, container, false);
        setupOnClicks();
        setupGraph();


        return view;
    }

    private void setupGraph(){
        Line l = new Line();
        LinePoint p = new LinePoint(0, 5);
        l.addPoint(p);
        p = new LinePoint(8, 8);
        l.addPoint(p);
        p = new LinePoint(10, 4);
        l.addPoint(p);
        p = new LinePoint(1, 0);
        l.addPoint(p);
        l.setColor(Color.parseColor("#FFBB33"));

        LineGraph li = (LineGraph) view.findViewById(R.id.graph);
        li.addLine(l);
        li.setRangeY(0, 10);
        li.setLineToFill(0);
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
                if(choices[0]){
                    //if so, deselect it
                    newBackground = getResources().getDrawable(R.drawable.menu_item_normal);
                    choices[0] = false;
                }else{
                    //if not, highlight it
                    newBackground = getResources().getDrawable(R.drawable.menu_item_highlighted);
                    choices[0] = true;
                }
                v.setBackground(newBackground);
            }
        });

        //setup the sleep button listener
        View sleep = view.findViewById(R.id.sleep_button);
        sleep.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Drawable newBackground;

                //check if the item has already been selected
                if(choices[1]){
                    //if so, deselect it
                    newBackground = getResources().getDrawable(R.drawable.menu_item_normal);
                    choices[1] = false;
                }else{
                    //if not, highlight it
                    newBackground = getResources().getDrawable(R.drawable.menu_item_highlighted);
                    choices[1] = true;
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
                if(choices[2]){
                    //if so, deselect it
                    newBackground = getResources().getDrawable(R.drawable.menu_item_normal);
                    choices[2] = false;
                }else{
                    //if not, highlight it
                    newBackground = getResources().getDrawable(R.drawable.menu_item_highlighted);
                    choices[2] = true;
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
                if(choices[3]){
                    //if so, deselect it
                    newBackground = getResources().getDrawable(R.drawable.menu_item_normal);
                    choices[3] = false;
                }else{
                    //if not, highlight it
                    newBackground = getResources().getDrawable(R.drawable.menu_item_highlighted);
                    choices[3] = true;
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
                if(choices[4]){
                    //if so, deselect it
                    newBackground = getResources().getDrawable(R.drawable.menu_item_normal);
                    choices[4] = false;
                }else{
                    //if not, highlight it
                    newBackground = getResources().getDrawable(R.drawable.menu_item_highlighted);
                    choices[4] = true;
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
                if(choices[5]){
                    //if so, deselect it
                    newBackground = getResources().getDrawable(R.drawable.menu_item_normal);
                    choices[5] = false;
                }else{
                    //if not, highlight it
                    newBackground = getResources().getDrawable(R.drawable.menu_item_highlighted);
                    choices[5] = true;
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
                if(choices[6]){
                    //if so, deselect it
                    newBackground = getResources().getDrawable(R.drawable.menu_item_normal);
                    choices[6] = false;
                }else{
                    //if not, highlight it
                    newBackground = getResources().getDrawable(R.drawable.menu_item_highlighted);
                    choices[6] = true;
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
                if(choices[7]){
                    //if so, deselect it
                    newBackground = getResources().getDrawable(R.drawable.menu_item_normal);
                    choices[7] = false;
                }else{
                    //if not, highlight it
                    newBackground = getResources().getDrawable(R.drawable.menu_item_highlighted);
                    choices[7] = true;
                }
                v.setBackground(newBackground);
            }
        });
    }
}