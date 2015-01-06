/**
 * Created by Joseph Labrecque on 12/1/2014.
 * release version 1.1.1
 * fixes for indexed captions
 * more robust comments ;)
 */
package edu.du.captions.utils {
import flash.text.TextField;
import edu.du.captions.data.CaptionsParser;

public class CaptionsHandler {
    public var captionsParser:CaptionsParser;
    private var timeFormatter:TimeFormatter;
    private var currentCaptionText:String;
    
    //instantiate this first and invoke everything through that.
    public function CaptionsHandler() {
        captionsParser = new CaptionsParser();
        timeFormatter = new TimeFormatter();
    }
    
    //pass in the URL to a .vtt file here - it'll employ the parser to load it up.
    public function gatherCaptions(s:String):void {
        var filePath:String = s;
        currentCaptionText = "";
        captionsParser.loadCaptions(filePath);
    }
    
    //this can bve invoked whenever appropriate - pass in a time in seconds and bind it to a TextField instance.
    public function renderCaptions(t:Number, d:TextField):void {
        var captions:Array = captionsParser.captionsArray;
        for (var i:int = 0; i < captions.length; i++) {
            //for each caption object, get start and end times
            var s:Number = timeFormatter.text2Sec(captions[i].startTime);
            var e:Number = timeFormatter.text2Sec(captions[i].stopTime);
            //if the current time is previous to this caption start time - we don't care.
            if (t < s) {
                break;
            } else {
                //does the current time fall between the caption object start and end time?
                if (t > s && t < e) {
                    //is it different from what is already displayed? great - print that stuff out.
                    if (captions[i].captionText != currentCaptionText) {
                        currentCaptionText = captions[i].captionText;
                        d.htmlText = currentCaptionText;
                        break;
                    }
                    //is the current time larger than the caption object end time? burn it all down.
                }else if(t > e){
                    currentCaptionText = "";
                    d.htmlText = currentCaptionText;
                }
            }
        }
    }

}
}
