package ie.spunout.mojo;

import android.app.Dialog;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.support.v4.app.DialogFragment;
import android.support.v4.app.FragmentManager;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.NumberPicker;
import android.widget.TextView;


/**
 * Created by jameswalsh on 27/02/2014.
 */
public class BadgeAwarded extends DialogFragment {
    View v;
    String action;
    int level;

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        v = inflater.inflate(R.layout.dialog_badge, container);
        action = getArguments().getString("action");
        level = getArguments().getInt("level");

        getDialog().setTitle("New Badge");

        setBadgeType();

        return v;
    }

    private void setBadgeType(){
        TextView view1 = (TextView)v.findViewById(R.id.text1);
        TextView view2 = (TextView)v.findViewById(R.id.text2);
        String text1 = view1.getText().toString();

        switch(level){
            case 1:
                text1.replace("*","Bronze");
                view1.setText(text1);

                view2.setText("Complete this activity 12 times in 2 weeks to achieve a Silver");
                break;
            case 2:
                text1.replace("*","Silver");
                view1.setText(text1);

                view2.setText("Complete this activity 18 times in 3 weeks to achieve a Gold");
                break;
            case 3:
                text1.replace("*","Gold");
                view1.setText(text1);

                view2.setText("");
                break;
        }
    }
}
