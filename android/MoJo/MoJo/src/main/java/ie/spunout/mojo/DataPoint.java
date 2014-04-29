package ie.spunout.mojo;

/**
 * Created by James on 26/04/14.
 */
public class DataPoint {
    long timestamp;
    int value;

    public DataPoint(){

    }

    public DataPoint(long ts, int v){
        timestamp = ts;
        value = v;
    }

    public long getTimestamp() {
        return timestamp;
    }

    public void setTimestamp(long timestamp) {
        this.timestamp = timestamp;
    }

    public int getValue() {
        return value;
    }

    public void setValue(int value) {
        this.value = value;
    }
}
