package ie.spunout.miyo.Activities;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentActivity;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentPagerAdapter;
import android.support.v4.view.ViewPager;

import ie.spunout.miyo.Fragments.BadgesInfo;
import ie.spunout.miyo.Fragments.GraphInfo;
import ie.spunout.miyo.Fragments.ScoreInfo;
import ie.spunout.miyo.R;

/**
 * Created by James on 28/04/14.
 * Activity class for the help pages fragments
 */
public class InfoPages extends FragmentActivity {
    SpunoutPagerAdapter mPagerAdapter;
    ViewPager mViewPager;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_info);

        mPagerAdapter = new SpunoutPagerAdapter(getSupportFragmentManager());
        mViewPager = (ViewPager) findViewById(R.id.info_pager);
        mViewPager.setAdapter(mPagerAdapter);

        mViewPager.setCurrentItem(0);
    }

    private class SpunoutPagerAdapter extends FragmentPagerAdapter {

        public SpunoutPagerAdapter(FragmentManager fm){
            super(fm);
        }

        @Override
        public Fragment getItem(int i) {
            Fragment f;

            switch (i){
                case 0:
                    f = new ScoreInfo();
                     break;
                case 1:
                    f = new GraphInfo();
                    break;
                case 2:
                    f = new BadgesInfo();
                    break;
                default:
                    f = new ScoreInfo();
            }

            return f;
        }

        @Override
        public int getCount() {
            return 3;
        }

        @Override
        public CharSequence getPageTitle(int position) {
            String title;

            switch (position){
                case 0:
                    title = "Score Info";
                    break;
                case 1:
                    title = "Graph Info";
                    break;
                default:
                    title = "Badges Info";
            }

            return title;
        }
    }
}
