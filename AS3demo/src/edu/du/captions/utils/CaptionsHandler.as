/**
 * Created by joseph.labrecque on 12/1/2014.
 */
package edu.du.captions.utils {
import flash.events.EventDispatcher;
import flash.text.TextField;
import edu.du.captions.data.CaptionsParser;

public class CaptionsHandler extends EventDispatcher {
    private var timeFormatter:TimeFormatter;
    private var captionsParser:CaptionsParser;
    private var currentCaptionText:String;
    
    public function CaptionsHandler() {
        captionsParser = new CaptionsParser();
        timeFormatter = new TimeFormatter();
    }
    public function gatherCaptions(s:String):void {
        var filePath:String = s;
        captionsParser.loadCaptions(filePath);
    }
    public function renderCaptions(t:Number, d:TextField):void {
        var captions:Array = captionsParser.captionsArray;
        for (var i:int = 0; i < captions.length; i++) {
            var s:Number = timeFormatter.text2Sec(captions[i].startTime);
            var e:Number = timeFormatter.text2Sec(captions[i].stopTime);
            if (t < s) {
                break;
            } else {
                if (t > s && t < e) {
                    if (captions[i].captionText != currentCaptionText) {
                        currentCaptionText = captions[i].captionText;
                        d.htmlText = currentCaptionText;
                        break;
                    }
                }else if(t > e){
                    currentCaptionText = "";
                    d.htmlText = currentCaptionText;
                }
            }
        }
    }
}
}
