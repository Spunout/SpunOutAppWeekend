package ie.spunout.mojo;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.app.ListFragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.ListView;

/**
 * Created by jameswalsh on 16/02/2014.
 */
public class Badges extends ListFragment {
    @Override
    public void onCreate(Bundle savedInstanceState){
        super.onCreate(savedInstanceState);

        //fill the list
        String[] values = new String[]{"Food Nut", "Sleeper Star", "Athlete", "Wise One", "Chatterbox", "Producer", "Merry Maker", "Social Butterfly"};

        ArrayAdapter<String> adapter = new ArrayAdapter<String>(getActivity(), R.layout.badge_list_item, R.id.label, values);

        setListAdapter(adapter);

        checkBadges();
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,Bundle savedInstanceState){
        View view = inflater.inflate(R.layout.fragment_badges, container, false);

        return view;
    }

    private void checkBadges(){
        //
    }
}
