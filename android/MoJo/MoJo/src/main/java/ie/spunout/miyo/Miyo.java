package ie.spunout.miyo;

import java.util.Date;
import java.util.Calendar;
import java.util.GregorianCalendar;

/**
 * Used to keep track of the users inputs into the activity tracker
 */
public class Miyo {

    //private variables
    //these should be set to one to indicate true or zero for false
    private int mood;
    private int eat;
    private int sleep;
    private int learn;
    private int play;
    private int exercise;
    private int connect;
    private long timestamp;
    private int life_time_points;


    // Empty constructor
    public Miyo(){
        mood = 0;
        eat = 0;
        sleep = 0;
        learn = 0;
        play = 0;
        exercise = 0;
        connect = 0;
        life_time_points = 0;
        setTimestamp();
    }

    // constructor
    public Miyo(int mood, int eat, int sleep, int learn, int play, int exercise, int connect, int life_time_points) {
        this.mood = mood;
        this.eat = eat;
        this.sleep = sleep;
        this.learn = learn;
        this.play = play;
        this.exercise = exercise;
        this.connect = connect;
        this.timestamp = new Date().getTime();
        this.life_time_points = life_time_points;
    }

    // getting mood
    public int getMood(){
        return this.mood;
    }

    // setting mood
    public void setMood(int mood){
        this.mood = mood;
    }

    // getting eat
    public int getEat(){
        return this.eat;
    }

    // setting eat
    public void setEat(int eat){
        this.eat = eat;
    }

    // getting sleep
    public int getSleep(){
        return this.sleep;
    }

    // setting sleep
    public void setSleep(int sleep){
        this.sleep = sleep;
    }

    // getting learn
    public int getLearn(){
        return this.learn;
    }

    // setting learn
    public void setLearn(int learn){
        this.learn = learn;
    }

    // getting play
    public int getPlay(){
        return this.play;
    }

    // setting play
    public void setPlay(int play){
        this.play = play;
    }

    // getting exercise
    public int getExercise(){
        return this.exercise;
    }

    // setting exercise
    public void setExercise(int exercise){
        this.exercise = exercise;
    }

    // getting connect
    public int getConnect(){
        return this.connect;
    }

    // setting connect
    public void setConnect(int connect){
        this.connect = connect;
    }

    /**
     * sets any of the activities
     */
    public void setAny(int activity, int value){
        switch (activity){
            case 0:
                setEat(value);
                break;
            case 1:
                setSleep(value);
                break;
            case 2:
                setExercise(value);
                break;
            case 3:
                setLearn(value);
                break;
            case 4:
                setPlay(value);
                break;
            case 5:
                setConnect(value);
                break;
        }
    }
    
    /**
     * gets any of the activities
     */
    public int getAny(int activity){
        switch (activity){
            case 0:
                return getEat();
            case 1:
                return getSleep();
            case 2:
                return getExercise();
            case 3:
                return getLearn();
            case 4:
                return getPlay();
            case 5:
                return getConnect();
            default:
                return 0;
        }
    }

    // getting timestamp
    public long getTimestamp(){
        return this.timestamp;
    }

    // setting timestamp
    public void setTimestamp(){
        Calendar cal = new GregorianCalendar();
        long millis = cal.getTimeInMillis();
        this.timestamp = millis;
    }

    // getting life_time_points
    public int getLifeTimePoints(){
        return this.life_time_points;
    }

    // setting life_time_points
    public void setLifeTimePoints(int ltp){
        this.life_time_points = ltp;
    }

}