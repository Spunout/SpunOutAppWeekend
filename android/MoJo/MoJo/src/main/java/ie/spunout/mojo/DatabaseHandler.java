package ie.spunout.mojo;

import android.content.ContentValues;
import android.content.Context;
import android.content.SharedPreferences;
import android.database.Cursor;
import android.database.sqlite.SQLiteCursor;
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
    private static final String KEY_CONNECT          = "connect";
    private static final String KEY_TIMESTAMP        = "timestamp";
    private static final String KEY_LIFE_TIME_POINTS = "life_time_points";

    public DatabaseHandler(Context context) {
        super(context, DATABASE_NAME, null, DATABASE_VERSION);
    }

    // Creating Tables
    @Override
    public void onCreate(SQLiteDatabase db) {
        Log.i(TAG, "creating the table");

        //CREATE TABLE test (numbers INTEGER);
        String CREATE_MIYO_TABLE = "CREATE TABLE " + TABLE_MIYO + "("
                + KEY_TIMESTAMP + " INTEGER PRIMARY KEY,"
                + KEY_MOOD + " REAL,"+ KEY_EAT + " INTEGER,"
                + KEY_SLEEP + " INTEGER," + KEY_LEARN + " INTEGER,"
                + KEY_PLAY + " INTEGER," + KEY_EXERCISE + " INTEGER,"
                + KEY_CONNECT + " INTEGER," + KEY_LIFE_TIME_POINTS + " INTEGER" + ")";
        Log.i(TAG, CREATE_MIYO_TABLE);
        db.execSQL(CREATE_MIYO_TABLE);
    }

    // Upgrading database
    @Override
    public void onUpgrade(SQLiteDatabase db, int oldVersion, int newVersion) {
        // Drop older table if existed
        db.execSQL("DROP TABLE IF EXISTS " + TABLE_MIYO);
    }

    /**
     * Adds a new activity record to the database.
     * @param miyo
     */
    public void addMiyo(Miyo miyo) {
        SQLiteDatabase dbw = this.getWritableDatabase();

        Log.i(TAG, "Logging miyo instance to the database: "+miyo.toString());

        //set the timestamp for the entry
        miyo.setTimestamp();

        ContentValues values = new ContentValues();
        values.put(KEY_TIMESTAMP, miyo.getTimestamp());
        values.put(KEY_MOOD, miyo.getMood());
        values.put(KEY_EAT, miyo.getEat());
        values.put(KEY_SLEEP, miyo.getSleep());
        values.put(KEY_LEARN, miyo.getLearn());
        values.put(KEY_PLAY, miyo.getPlay());
        values.put(KEY_EXERCISE, miyo.getExercise());
        values.put(KEY_CONNECT, miyo.getConnect());
        calculateLTP(miyo);
        values.put(KEY_LIFE_TIME_POINTS, miyo.getLifeTimePoints());

        // Inserting Row
        Long today = getTodayEntryOrZero();
        if ( today > 0){
           deleteMiyo(today);
        }
        dbw.insert(TABLE_MIYO, null, values);
    }

    // Adding new activity record
    public void addFirstMiyo() {
        Miyo miyo = new Miyo();
        SQLiteDatabase dbw = this.getWritableDatabase();

        Log.i(TAG,"adding the first item to the table");

        ContentValues values = new ContentValues();
        values.put(KEY_TIMESTAMP, miyo.getTimestamp());
        values.put(KEY_MOOD, miyo.getMood());
        values.put(KEY_EAT, miyo.getEat());
        values.put(KEY_SLEEP, miyo.getSleep());
        values.put(KEY_LEARN, miyo.getLearn());
        values.put(KEY_PLAY, miyo.getPlay());
        values.put(KEY_EXERCISE, miyo.getExercise());
        values.put(KEY_CONNECT, miyo.getConnect());
        values.put(KEY_LIFE_TIME_POINTS, 0);

        dbw.insert(TABLE_MIYO, null, values);
    }

    // get Miyo instance
    public Miyo getMiyo(long timestamp) {
        SQLiteDatabase db = this.getReadableDatabase();

        String qry = "SELECT * FROM MIYO WHERE timestamp = ?";
        String[] args = {Long.valueOf(timestamp).toString()};
        Cursor cursor = db.rawQuery(qry, args);

        Miyo miyo;
        if (cursor != null){
            cursor.moveToFirst();

            miyo = new Miyo(
                Integer.parseInt(cursor.getString(1)), Integer.parseInt(cursor.getString(2)),
                Integer.parseInt(cursor.getString(3)), Integer.parseInt(cursor.getString(4)),
                Integer.parseInt(cursor.getString(5)), Integer.parseInt(cursor.getString(6)),
                Integer.parseInt(cursor.getString(7)), Integer.parseInt(cursor.getString(8))
            );
        }else{
            miyo = new Miyo();
        }
        cursor.close();
        return miyo;
    }

    // Deleting single record
    public void deleteMiyo(Long timestamp) {
        SQLiteDatabase db = this.getWritableDatabase();
        Log.i(TAG, "deleting an entry from the table");
        db.delete(TABLE_MIYO, KEY_TIMESTAMP + " = ?",
                new String[] { String.valueOf(timestamp) });
    }

    /**
     * Gets the number of actions between the specified days in the past e.g.
     * bigger=10, smaller=3 returns a datapoint for each day that an activity was logged
     * between three days ago and ten days ago.
     *
     * @param action - the action you're looking for (e.g. eat, sleep, dance, fight)
     * @param bigger - the farther back number of days to include in the range
     * @param smaller - the closer number of days to include in the range
     *
     * @return an array of data points, one for each day in which the activity was logged.
     */
    public DataPoint[] getNumberOf(String action, long bigger, long smaller){
        long millisperday = 86400000;                       //1000*60*60*24
        Calendar cal = new GregorianCalendar();
        DataPoint[] data = new DataPoint[(int)(bigger-smaller)];

        long currentTime = cal.getTimeInMillis();
        Log.i(TAG,"current time is "+currentTime);
        Long timeA = currentTime - (millisperday*bigger);
        Long timeB = currentTime - (millisperday*smaller);
        String rangeA = timeA.toString();
        String rangeB = timeB.toString();
        Log.i(TAG, "range is values greater than "+rangeA+" and less than "+rangeB);

        String[] args = {rangeA, rangeB};
        String qry = "SELECT * FROM "+TABLE_MIYO+" WHERE "+action.toLowerCase()+" > 0 AND "+KEY_TIMESTAMP+" >= ? AND "+KEY_TIMESTAMP+" <= ?";

        SQLiteDatabase db = this.getReadableDatabase();
        Cursor cursor = db.rawQuery(qry,args);

        Log.i(TAG,"number of items returned is "+cursor.getCount());
        long current_timestamp;
        int current_value;
        while(cursor.moveToNext()){
            current_timestamp = cursor.getLong(cursor.getColumnIndex(KEY_TIMESTAMP));
            current_value = cursor.getInt(cursor.getColumnIndex(action));
            //Log.i(TAG,"number of columns = "+cursor.getColumnCount());
            Log.i(TAG,"the value of the activity = "+cursor.getInt(cursor.getColumnIndex(action)));
            for(int i = 0; i < data.length; i++){
                long beginning_of_day = timeA + (millisperday * i);
                long end_of_day = timeB + (millisperday*(i+1));
                Log.i(TAG, "beginning of day is "+beginning_of_day);
                Log.i(TAG, "end of day is "+end_of_day);
                Log.i(TAG, "current timestamp is "+current_timestamp);
                if(current_timestamp >= beginning_of_day && current_timestamp <= end_of_day){
                    data[i] = new DataPoint(current_timestamp, current_value);
                    Log.i(TAG,"added "+current_value);
                }else{
                    //data[i] = new DataPoint(0,0);
                    //Log.i(TAG,"added 0");
                }
            }
        }
        for(int i = 0; i < data.length; i++){
            if(data[i] == null){
                data[i] = new DataPoint(0 ,0);
            }
        }
        cursor.close();
        //count = Integer.valueOf(strCount).intValue();
        return data;
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
        Log.i(TAG, zeroedDate.toString());

        Long ret = Long.valueOf(0);

        String[] args = {zeroedDate.toString()};

        SQLiteDatabase db = this.getReadableDatabase();
        Cursor cursor = db.rawQuery(
                "SELECT "+KEY_TIMESTAMP+" FROM "+TABLE_MIYO+" WHERE timestamp >= ?",
                args
        );
        Log.i(TAG, "number of items in cursor is "+cursor.getCount());
        if (cursor.getCount() != 0){
            cursor.moveToFirst();
            int index = cursor.getColumnIndex(KEY_TIMESTAMP);
            ret = cursor.getLong(index);
        }
        cursor.close();
        Log.i(TAG, "the timestamp of the item to be deleted is: "+ret.toString());
        return ret;
    }

    public long getRecentLTP(){
        return getRecentLTP(1);
    }

    /**
     * gets the lifetime points value for yesterday
     * @param offset
     * the number of days back to get values from
     * @return
     */
    public long getRecentLTP(int offset){
        String offset_s = Integer.toString(offset);
        SQLiteDatabase db = this.getReadableDatabase();
        String[] args = new String[0];
        //select life_time_points from miyo order by timestamp limit 2 offset 1
        String query = "SELECT "+KEY_LIFE_TIME_POINTS+" FROM "+TABLE_MIYO+" ORDER BY "+KEY_TIMESTAMP+" LIMIT 2 OFFSET "+offset_s+"";
        Cursor cursor = db.rawQuery(query, args);
        cursor.moveToFirst();

        if(cursor.getCount() == 0){
            return 0;
        }
        int value = Integer.parseInt(cursor.getString(0));
        cursor.close();

        return value;
    }

    public void calculateLTP(Miyo miyo){
        int ltp =  (int)getRecentLTP();//yesterday's score OR zero
        Log.i(TAG,"initial lifetime points = "+ltp);
        ltp += miyo.getEat();
        ltp += miyo.getSleep();
        ltp += miyo.getLearn();
        ltp += miyo.getPlay();
        ltp += miyo.getExercise();
        ltp += miyo.getConnect();
        miyo.setLifeTimePoints(ltp);
        Log.i(TAG,"final lifetime points = "+ltp);
    }

}
