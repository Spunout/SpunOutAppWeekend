package ie.spunout.miyo.Fragments;

import android.content.Context;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;

import ie.spunout.miyo.R;

/**
 * Created by jameswalsh on 16/02/2014.
 */
public class Badges extends Fragment {
    View view;

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,Bundle savedInstanceState){
        view = inflater.inflate(R.layout.fragment_badges, container, false);

        checkBadges();

        return view;
    }

    //TODO: abstract this to a for loop and arrays
    private void checkBadges(){
        SharedPreferences prefs = getActivity().getPreferences(Context.MODE_PRIVATE);
        int currentLevel;
        ImageView currentView;

        currentLevel = prefs.getInt("eat",0);
        switch (currentLevel){
            case 1:
                currentView = (ImageView) view.findViewById(R.id.eat_bronze);
                currentView.setImageDrawable(getResources().getDrawable(R.drawable.eat_bronze));
                break;
            case 2:
                currentView = (ImageView) view.findViewById(R.id.eat_silver);
                currentView.setImageDrawable(getResources().getDrawable(R.drawable.eat_silver));
                break;
            case 3:
                currentView = (ImageView) view.findViewById(R.id.eat_gold);
                currentView.setImageDrawable(getResources().getDrawable(R.drawable.eat_gold));
                break;
        }
        currentLevel = prefs.getInt("sleep",0);
        switch (currentLevel){
            case 1:
                currentView = (ImageView) view.findViewById(R.id.sleep_bronze);
                currentView.setImageDrawable(getResources().getDrawable(R.drawable.sleep_bronze));
                break;
            case 2:
                currentView = (ImageView) view.findViewById(R.id.sleep_silver);
                currentView.setImageDrawable(getResources().getDrawable(R.drawable.sleep_silver));
                break;
            case 3:
                currentView = (ImageView) view.findViewById(R.id.sleep_gold);
                currentView.setImageDrawable(getResources().getDrawable(R.drawable.sleep_gold));
                break;
        }
        currentLevel = prefs.getInt("exercise",0);
        switch (currentLevel){
            case 1:
                currentView = (ImageView) view.findViewById(R.id.move_bronze);
                currentView.setImageDrawable(getResources().getDrawable(R.drawable.exercise_bronze));
                break;
            case 2:
                currentView = (ImageView) view.findViewById(R.id.move_silver);
                currentView.setImageDrawable(getResources().getDrawable(R.drawable.exercise_silver));
                break;
            case 3:
                currentView = (ImageView) view.findViewById(R.id.move_gold);
                currentView.setImageDrawable(getResources().getDrawable(R.drawable.exercise_gold));
                break;
        }
        currentLevel = prefs.getInt("learn",0);
        switch (currentLevel){
            case 1:
                currentView = (ImageView) view.findViewById(R.id.learn_bronze);
                currentView.setImageDrawable(getResources().getDrawable(R.drawable.learn_bronze));
                break;
            case 2:
                currentView = (ImageView) view.findViewById(R.id.learn_silver);
                currentView.setImageDrawable(getResources().getDrawable(R.drawable.learn_silver));
                break;
            case 3:
                currentView = (ImageView) view.findViewById(R.id.learn_gold);
                currentView.setImageDrawable(getResources().getDrawable(R.drawable.learn_gold));
                break;
        }
        currentLevel = prefs.getInt("play",0);
        switch (currentLevel){
            case 1:
                currentView = (ImageView) view.findViewById(R.id.play_bronze);
                currentView.setImageDrawable(getResources().getDrawable(R.drawable.play_bronze));
                break;
            case 2:
                currentView = (ImageView) view.findViewById(R.id.play_silver);
                currentView.setImageDrawable(getResources().getDrawable(R.drawable.play_silver));
                break;
            case 3:
                currentView = (ImageView) view.findViewById(R.id.play_gold);
                currentView.setImageDrawable(getResources().getDrawable(R.drawable.play_gold));
                break;
        }
        currentLevel = prefs.getInt("connect",0);
        switch (currentLevel){
            case 1:
                currentView = (ImageView) view.findViewById(R.id.connect_bronze);
                currentView.setImageDrawable(getResources().getDrawable(R.drawable.connect_bronze));
                break;
            case 2:
                currentView = (ImageView) view.findViewById(R.id.connect_silver);
                currentView.setImageDrawable(getResources().getDrawable(R.drawable.connect_silver));
                break;
            case 3:
                currentView = (ImageView) view.findViewById(R.id.connect_gold);
                currentView.setImageDrawable(getResources().getDrawable(R.drawable.connect_gold));
                break;
        }
    }
}
