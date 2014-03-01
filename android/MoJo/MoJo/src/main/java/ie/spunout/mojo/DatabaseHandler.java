package ie.spunout.mojo;

import android.content.ContentValues;
import android.content.Context;
import android.content.SharedPreferences;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;
import android.util.Log;

import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;

public class DatabaseHandler extends SQLiteOpenHelper {
    private static final String TAG = "Miyo";   //log tag

    // All Static variables
    // Database Version
    private static final int DATABASE_VERSION = 1;

    // Database Name
    private static final String DATABASE_NAME = "MiyoDatabase";

    // Miyo table name
    private static final String TABLE_MIYO = "miyo";

    // Miyo Table Column names
    private static final String KEY_MOOD             = "mood";
    private static final String KEY_EAT              = "eat";
    private static final String KEY_SLEEP            = "sleep";
    private static final String KEY_LEARN            = "learn";
    private static final String KEY_PLAY             = "play";
    private static final String KEY_EXERCISE         = "exercise";
    private static final String KEY_MAKE             = "make";
    private static final String KEY_CONNECT          = "connect";
    private static final String KEY_TALK             = "talk";
    private static final String KEY_TIMESTAMP        = "timestamp";
    private static final String KEY_LIFE_TIME_POINTS = "life_time_points";

    public DatabaseHandler(Context context) {
        super(context, DATABASE_NAME, null, DATABASE_VERSION);
    }

    // Creating Tables
    @Override
    public void onCreate(SQLiteDatabase db) {
        Log.i(TAG, "creating the table");
        String CREATE_MIYO_TABLE = "CREATE TABLE " + TABLE_MIYO + "("
                + KEY_TIMESTAMP + " INTEGER PRIMARY KEY,"
                + KEY_MOOD + " REAL,"+ KEY_EAT + " INTEGER,"
                + KEY_SLEEP + " INTEGER," + KEY_LEARN + " INTEGER,"
                + KEY_PLAY + " INTEGER," + KEY_EXERCISE + " INTEGER,"
                + KEY_MAKE + " INTEGER," + KEY_CONNECT + " INTEGER,"
                + KEY_TALK + " INTEGER," + KEY_LIFE_TIME_POINTS + " INTEGER" + ")";
        db.execSQL(CREATE_MIYO_TABLE);

        addFirstMiyo(db);
    }

    // Upgrading database
    @Override
    public void onUpgrade(SQLiteDatabase db, int oldVersion, int newVersion) {
        // Drop older table if existed
        db.execSQL("DROP TABLE IF EXISTS " + TABLE_MIYO);
    }

    // Adding new activity record
    public void addMiyo(Miyo miyo) {
        SQLiteDatabase dbw = this.getWritableDatabase();
        SQLiteDatabase dbr = this.getReadableDatabase();

        ContentValues values = new ContentValues();
        values.put(KEY_TIMESTAMP, miyo.getTimestamp());
        values.put(KEY_MOOD, miyo.getMood());
        values.put(KEY_EAT, miyo.getEat());
        values.put(KEY_SLEEP, miyo.getSleep());
        values.put(KEY_LEARN, miyo.getLearn());
        values.put(KEY_PLAY, miyo.getPlay());
        values.put(KEY_EXERCISE, miyo.getExercise());
        values.put(KEY_MAKE, miyo.getMake());
        values.put(KEY_CONNECT, miyo.getConnect());
        values.put(KEY_TALK, miyo.getTalk());
        calculateLTP(miyo);
        values.put(KEY_LIFE_TIME_POINTS, miyo.getLifeTimePoints());

        // Inserting Row
        Long today = getTodayEntryOrZero();
        if ( today > 0){
           // deleteMiyo(today);
        }
        dbw.insert(TABLE_MIYO, null, values);
    }

    // Adding new activity record
    public void addFirstMiyo(SQLiteDatabase db) {
        Miyo miyo = new Miyo();

        Log.i(TAG,"adding the first item to the table");

        ContentValues values = new ContentValues();
        values.put(KEY_TIMESTAMP, miyo.getTimestamp());
        values.put(KEY_MOOD, miyo.getMood());
        values.put(KEY_EAT, miyo.getEat());
        values.put(KEY_SLEEP, miyo.getSleep());
        values.put(KEY_LEARN, miyo.getLearn());
        values.put(KEY_PLAY, miyo.getPlay());
        values.put(KEY_EXERCISE, miyo.getExercise());
        values.put(KEY_MAKE, miyo.getMake());
        values.put(KEY_CONNECT, miyo.getConnect());
        values.put(KEY_TALK, miyo.getTalk());
        values.put(KEY_LIFE_TIME_POINTS, 0);

        db.insert(TABLE_MIYO, null, values);
    }

    // get Miyo instance
    public Miyo getMiyo(long timestamp) {
        SQLiteDatabase db = this.getReadableDatabase();

        Cursor cursor = db.query(TABLE_MIYO, new String[] { KEY_TIMESTAMP, KEY_MOOD,
                KEY_EAT, KEY_SLEEP, KEY_LEARN, KEY_PLAY, KEY_EXERCISE, KEY_MAKE, KEY_CONNECT, KEY_TALK, KEY_LIFE_TIME_POINTS}, KEY_TIMESTAMP + "=?",
                new String[] { String.valueOf(timestamp) }, null, null, null, null);
        if (cursor != null)
            cursor.moveToFirst();

        Miyo miyo = new Miyo(Integer.parseInt(cursor.getString(1)), Integer.parseInt(cursor.getString(2)), Integer.parseInt(cursor.getString(3)), Integer.parseInt(cursor.getString(4)),
                                              Integer.parseInt(cursor.getString(5)), Integer.parseInt(cursor.getString(6)), Integer.parseInt(cursor.getString(7)),
                                              Integer.parseInt(cursor.getString(8)),Integer.parseInt(cursor.getString(9)), Integer.parseInt(cursor.getString(10)));
        // return miyo
        return miyo;
    }

    // Deleting single record
    public void deleteMiyo(Miyo miyo) {
        SQLiteDatabase db = this.getWritableDatabase();
        db.delete(TABLE_MIYO, KEY_TIMESTAMP + " = ?",
                new String[] { String.valueOf(miyo.getTimestamp()) });
        db.close();
    }

    /**
     * Gets the number of actions in the past days days.
     *
     * @param action - the action you're looking for (e.g. eat, sleep, dance, fight)
     * @param days - the number of days in the past you want to look at
     *
     * @return the number of times action has happened in the past days
     */
    public int getNumberOf(String action, int days){
        int millisperday = 86400000;//1000*60*60*24
        String strCount = "";
        int count = 0;
        Calendar cal = new GregorianCalendar();
        Long r = cal.getTimeInMillis()-(millisperday*days);
        String range = r.toString();

        String[] args = {action.toLowerCase(), range};

        SQLiteDatabase db = this.getWritableDatabase();
        Cursor cursor = db.rawQuery(
                "SELECT COUNT(*) FROM "+TABLE_MIYO+" WHERE ? = 1 AND "+KEY_TIMESTAMP+" <= ?",
                args
        );

        while( cursor.moveToFirst() ){
            strCount = cursor.getString(cursor.getColumnIndex("COUNT(*)"));
        }
        db.close();
        count = Integer.valueOf(strCount).intValue();
        return count;
    }

    public Long getTodayEntryOrZero(){
        Date date = new Date();                      // timestamp now
        Calendar cal = Calendar.getInstance();       // get calendar instance
        cal.setTime(date);                           // set cal to date
        cal.set(Calendar.HOUR_OF_DAY, 0);            // set hour to midnight
        cal.set(Calendar.MINUTE, 0);                 // set minute in hour
        cal.set(Calendar.SECOND, 0);                 // set second in minute
        cal.set(Calendar.MILLISECOND, 0);            // set millis in second
        Long zeroedDate = cal.getTimeInMillis();     // computes today floored

        Long ret = Long.valueOf(0);

        String[] args = {zeroedDate.toString()};

        SQLiteDatabase db = this.getWritableDatabase();
        Cursor cursor = db.rawQuery(
                "SELECT "+KEY_TIMESTAMP+" FROM "+TABLE_MIYO+" WHERE timestamp >= ?",
                args
        );
        cursor.moveToNext();
        if (cursor.getCount() != 0){
            cursor.moveToFirst();
            int index = cursor.getColumnIndex(KEY_TIMESTAMP);
            ret = cursor.getLong(index);
        }
        return ret;
    }

    public long getRecentLTP(){
        return getRecentLTP(1);
    }

    public long getRecentLTP(int offset)
    {
        String offset_s = Integer.toString(offset);
        SQLiteDatabase db = this.getReadableDatabase();
        String[] args = new String[0];
        //TODO: removed DESCENDING from the sql query as it isn't supported
        String query = "SELECT "+KEY_LIFE_TIME_POINTS+" FROM "+TABLE_MIYO+" ORDER BY "+KEY_TIMESTAMP+" LIMIT 2 OFFSET "+offset_s+"";
        Cursor cursor = db.rawQuery(
                query, args
        );
        cursor.moveToFirst();

        return Integer.parseInt(cursor.getString(0));
    }


/*    public badges(){
        checkBadge(KEY_EAT);
        checkBadge(KEY_SLEEP);
        checkBadge(KEY_LEARN);
        checkBadge(KEY_PLAY);
        checkBadge(KEY_EXERCISE);
        checkBadge(KEY_MAKE);
        checkBadge(KEY_CONNECT);
        checkBadge(KEY_TALK);
    }
*/
/*
    public checkBadge(String action)
    {
        //demo of how to get from local storage
        SharedPreferences sharedPref = getActivity().getPreferences(Context.MODE_PRIVATE);
        //getType should be the type of what you're getting back eg. getInt
        //the second parameter is the default value if none is found
        int currentlevel = sharedPref.getInt(action, 0);

        switch(currentlevel){
            case 2:
                if( getNumberOf( action, 21) > 18){
                    sharedPref.setInt(action, 3);
                } break;
            case 1:
                if( getNumberOf( action, 14) > 12){
                    sharedPref.setInt(action, 2);
                } break;
            case 0:
                if( getNumberOf( action, 7) > 6){
                    sharedPref.setInt(action, 1);
                } break;
        }
    }
*/

/*    public int checkLevel(int current_level)
    {
        long ltp = getRecentLTP(0); //get todays ltp value
        if(current_level != (levels.length-1)) //not at max level
        {
            while(ltp > levels[current_level+1]) //check next level's ltp points
            {
                current_level++;
            }
        }
        return current_level;
    }
*/

    public void calculateLTP(Miyo miyo)
    {
        int ltp =  (int)getRecentLTP();//yesterday's score OR zero
        ltp += (miyo.getEat()*7);
        ltp += (miyo.getSleep()*7);
        ltp += (miyo.getLearn()*5);
        ltp += (miyo.getPlay()*5);
        ltp += (miyo.getExercise()*6);
        ltp += (miyo.getMake()*6);
        ltp += (miyo.getConnect()*6);
        ltp += (miyo.getTalk()*6);
        miyo.setLifeTimePoints(ltp);
    }

}
