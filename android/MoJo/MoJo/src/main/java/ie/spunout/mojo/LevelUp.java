package ie.spunout.mojo;

import android.app.Dialog;
import android.content.Context;
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
public class LevelUp extends DialogFragment {
    View v;

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        v = inflater.inflate(R.layout.dialog_level_up, container);

        getDialog().setTitle("Congratulations");

        setLeveLNo();

        return v;
    }

    /**
     * sets the level number in the text of the dialog
     */
    private void setLeveLNo(){
        SharedPreferences prefs = getActivity().getPreferences(Context.MODE_PRIVATE);
        Integer level = prefs.getInt("current_level", 0);
        TextView tv = (TextView) v.findViewById(R.id.level_sentence);
        String str = tv.getText().toString();
        str += " "+level;
        tv.setText(str);
    }
}
