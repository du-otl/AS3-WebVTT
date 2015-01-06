/**
 * Created by Joseph Labrecque on 12/2/2014.
 */
package edu.du.captions.utils {
public class TimeFormatter {
    public function TimeFormatter() {}
    
    //converts raw seconds into a "00:00:00" string.
    public function seconds2HMS(raw_seconds:int):String {
        var hours:int = Math.floor(raw_seconds/3600);
        var minutes:int = Math.floor((raw_seconds-(hours*3600))/60);
        var seconds:int = Math.floor(raw_seconds%60);
        var hS:String;
        var mS:String;
        var sS:String;
        hS = ""+hours;
        if (minutes<10) {
            mS = "0"+minutes;
        } else {
            mS = ""+minutes;
        }
        if (seconds<10) {
            sS = "0"+seconds;
        } else {
            sS = ""+seconds;
        }
        var time_string:String = hS+":"+mS+":"+sS;
        if (time_string.length != 7){
            time_string = "00:00:00";
        }
        return time_string;
    }
    
    //converts a string formatted like "00:00:00" to raw seconds.
    public function text2Sec(t:String):Number {
        var time:String = t;
        var seconds:Number = 0;
        seconds += Number(time.substr(0,2))*3600;
        seconds += Number(time.substr(3,2))*60;
        seconds += Number(time.substr(6,2));
        seconds = Number(seconds + "." + time.substr(9,3));
        return seconds;
    }
}
}
