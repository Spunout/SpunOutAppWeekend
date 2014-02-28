package ie.spunout.mojo;

import android.graphics.Color;
import android.graphics.drawable.Drawable;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.GridView;
import android.widget.SimpleAdapter;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import ie.spunout.mojo.graph.Line;
import ie.spunout.mojo.graph.LineGraph;
import ie.spunout.mojo.graph.LinePoint;

/**
 * Created by jameswalsh on 16/02/2014.
 */
public class Graph extends Fragment{
    private View parent;
    private boolean[] choices = {false,false,false,false,false,false,false,false,};

    @Override
    public void onCreate(Bundle savedInstanceState){
        super.onCreate(savedInstanceState);

    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,Bundle savedInstanceState){
        parent = inflater.inflate(R.layout.fragment_graphs, container, false);
        setupGrid();
        setupGraph();


        return parent;
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

        LineGraph li = (LineGraph) parent.findViewById(R.id.graph);
        li.addLine(l);
        li.setRangeY(0, 10);
        li.setLineToFill(0);
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
        GridView moodgrid = (GridView) parent.findViewById(R.id.graph_choice);
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
}