package ie.spunout.mojo;

import java.util.Date;
import java.util.Calendar;
import java.util.GregorianCalendar;

/**
 * Used to keep track of the users inputs into the activity tracker
 */
public class Miyo {

    //private variables
    private int mood;
    private int eat;
    private int sleep;
    private int learn;
    private int play;
    private int exercise;
    private int make;
    private int connect;
    private int talk;
    private long timestamp;
    private int life_time_points;


    // Empty constructor
    public Miyo(){

    }

    // constructor
    public Miyo(int mood, int eat, int sleep, int learn, int play, int exercise, int make, int connect, int talk, int life_time_points) {
        this.mood = mood;
        this.eat = eat;
        this.sleep = sleep;
        this.learn = learn;
        this.play = play;
        this.exercise = exercise;
        this.make = make;
        this.connect = connect;
        this.talk = talk;
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

    // getting make
    public int getMake(){
        return this.make;
    }

    // setting make
    public void setMake(int make){
        this.make = make;
    }

    // getting connect
    public int getConnect(){
        return this.connect;
    }

    // setting connect
    public void setConnect(int connect){
        this.connect = connect;
    }

    // getting talk
    public int getTalk(){
        return this.talk;
    }

    // setting talk
    public void setTalk(int talk){
        this.talk = talk;
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