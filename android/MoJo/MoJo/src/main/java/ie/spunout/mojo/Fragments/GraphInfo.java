package ie.spunout.mojo.Fragments;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import ie.spunout.mojo.R;

/**
 * Created by James on 28/04/14.
 */
public class GraphInfo extends Fragment{

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.fragment_info_graph, container, false);

        return view;
    }
}
