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
public class Instructions extends DialogFragment {
    View v;

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        v = inflater.inflate(R.layout.dialog_instructions, container);

        getDialog().setTitle("How to Play");

        return v;
    }
}
