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
import android.text.LoginFilter;
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

        //check if the user has leveled up
        checkLevel();

        //check if any badges have been awarded
        allBadges();

        //check for any low usage
        allLowUse();

        checkIfStartOfWeek();
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

            //initialise the level and points to level 2
            editor.putInt("current_level", 1);
            editor.putInt("points_to_next_level", 30);

            //set all the badge levels to 0
            editor.putInt("eat", 0);
            editor.putInt("sleep", 0);
            editor.putInt("exercise", 0);
            editor.putInt("learn", 0);
            editor.putInt("talk", 0);
            editor.putInt("make", 0);
            editor.putInt("play", 0);
            editor.putInt("connect", 0);

            //insert the first week timer
            editor.putLong("week_timer", System.currentTimeMillis());

            //commit these changes to memory
            editor.commit();

            //create the database
            dh.addFirstMiyo();

            //open the instructions dialog
            openInstructions();
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

    public void checkLevel(){
        Log.i(TAG, "checking level");
        SharedPreferences prefs = this.getPreferences(MODE_PRIVATE);
        //get the current level
        Integer currentLevel = prefs.getInt("current_level", 0);
        Integer pointsToNext = prefs.getInt("points_to_next_level", 0);
        Long currentLTP = dh.getRecentLTP();
        Log.i(TAG, "current LTP is: "+currentLTP.toString());
        Log.i(TAG, "points required are: "+pointsToNext.toString());
        if(currentLTP > pointsToNext){
            Log.i(TAG, "levelling up");
            //advance to the next level
            SharedPreferences.Editor editor = prefs.edit();
            currentLevel++;
            editor.putInt("current_level", currentLevel);

            if(currentLevel <= 10){
                Log.i(TAG, "level less than ten");
                Double temp = 1.5 * pointsToNext.doubleValue();
                pointsToNext = temp.intValue();
            }else{
                Double temp = 1.1 * pointsToNext.doubleValue();
                pointsToNext = temp.intValue();
                Log.i(TAG, "level greater than ten");
            }
            editor.putInt("points_to_next_level", pointsToNext);
            editor.commit();
            //display the dialog
            openLevelUp();
        }
    }

    public void openLevelUp(){
        FragmentManager fm = getSupportFragmentManager();
        LevelUp levelDialog = new LevelUp();
        levelDialog.show(fm, "Sample");
    }

    public void allBadges(){
        Log.i(TAG, "checking for any new badges");
        checkBadge("eat");
        checkBadge("sleep");
        checkBadge("learn");
        checkBadge("play");
        checkBadge("exercise");
        checkBadge("make");
        checkBadge("connect");
        checkBadge("talk");
    }

    public void checkBadge(String action){
        SharedPreferences sharedPref = this.getPreferences(Context.MODE_PRIVATE);
        int currentBadge = sharedPref.getInt(action, 0);
        if(currentBadge == 3){
            Log.i(TAG, action+"no change");
            return;
        }

        //add one for easier manipulation
        currentBadge++;
        int timesDone = dh.getNumberOf(action, (currentBadge*7));
        Log.i(TAG, action+" was done "+timesDone+" times");
        if(timesDone > (currentBadge*6)){
            //the user has earned a new badge
            SharedPreferences.Editor edit = sharedPref.edit();
            //give them then new badge
            Log.i(TAG,"New Badge awarded");
            edit.putInt(action, currentBadge);
            edit.commit();
            //display the dialog to award them the badge
            openBadgeAward(action, currentBadge);
        }
    }

    private void openBadgeAward(String action, int level){
        Bundle b = new Bundle();
        b.putString("action", action);
        b.putInt("level", level);

        FragmentManager fm = getSupportFragmentManager();
        BadgeAwarded badgeDialog = new BadgeAwarded();
        badgeDialog.setArguments(b);
        badgeDialog.show(fm, "Sample");
    }

    public void allLowUse(){
        Log.i(TAG, "checking for any low usage");
        int check = -1;
        check = checkLowUse("connect")? 7:check;
        check = checkLowUse("exercise")? 6:check;
        check = checkLowUse("learn")? 5:check;
        check = checkLowUse("make")? 4:check;
        check = checkLowUse("play")? 3:check;
        check = checkLowUse("talk")? 2:check;
        check = checkLowUse("sleep")? 1:check;
        check = checkLowUse("eat")? 0:check;

        if (check > -1){
            openLowUse(check);
        }
    }

    /**
     * Checks if the user isn't doing any activity much
     * less than four times in a week is considered bad
     */
    public boolean checkLowUse(String action){
        int timesDone = dh.getNumberOf(action, 7);
        return (timesDone < 4);
    }

    public void openLowUse(int action){
        Bundle b = new Bundle();
        b.putInt("action",action);

        FragmentManager fm = getSupportFragmentManager();
        LowUse lowUseDialog = new LowUse();
        lowUseDialog.setArguments(b);
        lowUseDialog.show(fm, "Sample");
    }

    private void checkIfStartOfWeek(){
        SharedPreferences prefs = getPreferences(MODE_PRIVATE);
        Long currentTime = System.currentTimeMillis();
        Long aWeekAgo = currentTime-(604800000);
        if(prefs.getLong("week_timer", 0) < aWeekAgo){
            SharedPreferences.Editor edit = prefs.edit();
            edit.putLong("week_timer", System.currentTimeMillis());
            edit.putInt("current_score", 150);
            edit.commit();
            Log.i(TAG, "resetting the score as a week has passed");
        }
    }
}
