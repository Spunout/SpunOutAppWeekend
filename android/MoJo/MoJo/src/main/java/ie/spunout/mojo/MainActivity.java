package ie.spunout.mojo;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.graphics.PorterDuff;
import android.provider.ContactsContract;
import android.support.v4.app.FragmentActivity;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentPagerAdapter;
import android.support.v4.app.FragmentStatePagerAdapter;
import android.support.v4.view.ViewPager;
import android.support.v7.app.ActionBarActivity;
import android.support.v7.app.ActionBar;
import android.support.v4.app.Fragment;
import android.widget.AdapterView;
import android.widget.BaseAdapter;
import android.widget.GridView;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import android.os.Build;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;
import android.util.Log;
import com.parse.ParseException;
import com.parse.Parse;
import com.parse.ParseAnalytics;
import com.parse.ParseObject;


public class MainActivity extends FragmentActivity {
    DemoCollectionPagerAdapter mDemoCollectionPagerAdapter;
    ViewPager mViewPager;
    public DatabaseHandler dh;
    private static final String TAG = "Miyo";   //log tag


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        //create new database handler
        dh = new DatabaseHandler(this);
        checkIfFirstOpen();

        mDemoCollectionPagerAdapter = new DemoCollectionPagerAdapter(getSupportFragmentManager());
        mViewPager = (ViewPager) findViewById(R.id.pager);
        mViewPager.setAdapter(mDemoCollectionPagerAdapter);

        //load the first fragment (initial)
        mViewPager.setCurrentItem(0);

    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.main, menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        // Handle action bar item clicks here. The action bar will
        // automatically handle clicks on the Home/Up button, so long
        // as you specify a parent activity in AndroidManifest.xml.
        int id = item.getItemId();
        switch(id) {
            case R.id.instructions_item:
                openInstructions();
                break;
        }
        return super.onOptionsItemSelected(item);
    }

    // Since this is an object collection, use a FragmentStatePagerAdapter,
    // and NOT a FragmentPagerAdapter.
    public class DemoCollectionPagerAdapter extends FragmentPagerAdapter {
        public DemoCollectionPagerAdapter(FragmentManager fm) {
            super(fm);
        }

        @Override
        public Fragment getItem(int i) {
            //TODO: add in the other fragments
            Fragment fragment;

            switch (i){
                case 0:
                    fragment = new Initial();
                    break;
                case 1:
                    fragment = new Graph();
                    break;
                default:
                    fragment = new Badges();
            }

            return fragment;
        }

        @Override
        public int getCount() {
            return 3;
        }

        @Override
        public CharSequence getPageTitle(int position) {
            //TODO: add in the other fragments
            String title;

            switch (position){
                case 0:
                    title = "Log Activities";
                    break;
                case 1:
                    title = "See your Progress";
                    break;
                default:
                    title = "Badge Gallery";
            }

            return title;
        }
    }

    /**
     * Checks to see if this is the first time the user has opened the app
     * and if so sets up some variables in local storage
     */
    private void checkIfFirstOpen(){
        //load the preferences file
        SharedPreferences prefs = this.getPreferences(MODE_PRIVATE);
        //check if the app has been loaded previously
        Boolean check = prefs.getBoolean("first_time", true);

        if(check){
            //this is the first time
            Log.i(TAG, "Using the app for the first time");
            //record that it has been loaded so that this will pass next time
            SharedPreferences.Editor editor = prefs.edit();
            editor.putBoolean("first_time", false);

            //store the initial score
            editor.putInt("current_points", 150);

            //set the initial level to zero
            editor.putInt("current_level", 1);

            //set all the badge levels to 0
            editor.putInt("badge_eat", 0);
            editor.putInt("badge_sleep", 0);
            editor.putInt("badge_exercise", 0);
            editor.putInt("badge_learn", 0);
            editor.putInt("badge_talk", 0);
            editor.putInt("badge_make", 0);
            editor.putInt("badge_play", 0);
            editor.putInt("badge_connect", 0);

            //commit these changes to memory
            editor.commit();
        }else{
            Log.i(TAG, "returning to the app");
            //check for new badges
            //check for level up
            //decrement points depending on how long they have been away for
        }
    }

    public void openInstructions(){
        FragmentManager fm = getSupportFragmentManager();
        Instructions instructionsDialog = new Instructions();
        instructionsDialog.show(fm, "Sample");
    }

}
