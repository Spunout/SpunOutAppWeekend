package ie.spunout.miyo.Dialogs;

import android.app.Dialog;
import android.os.Bundle;
import android.support.v4.app.DialogFragment;
import android.support.v4.app.FragmentManager;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.NumberPicker;
import android.widget.TextView;

import ie.spunout.miyo.R;


/**
 * Created by jameswalsh on 27/02/2014.
 */
public class LowUse extends DialogFragment {
    View v;

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        v = inflater.inflate(R.layout.dialog_low_use, container);
        Bundle b = getArguments();

        String[] links = getResources().getStringArray(R.array.spunout_links);
        TextView text = (TextView) v.findViewById(R.id.low_use_link);
        text.setText(links[b.getInt("action")]);

        getDialog().setTitle("Need Some Help?");

        return v;
    }
}
