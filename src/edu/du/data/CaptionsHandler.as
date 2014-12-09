/**
 * Created by joseph.labrecque on 12/1/2014.
 */
package edu.du.data {
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.net.URLLoader;
import flash.net.URLRequest;
import flash.text.TextField;
import edu.du.utils.TimeFormatter;

public class CaptionsHandler {
    private var timeFormatter:TimeFormatter;
    private var captionsLoader:URLLoader;
    private var _captionsArray:Array;
    private var currentCaptionText:String;
    
    public function CaptionsHandler() {
        captionsLoader = new URLLoader();
        timeFormatter = new TimeFormatter();
        _captionsArray = new Array();
    }
    public function gatherCaptions(s:String):void {
        var filePath:String = s;
        captionsLoader.addEventListener(Event.COMPLETE, captionsLoaded);
        captionsLoader.addEventListener(IOErrorEvent.IO_ERROR, captionsError);
        captionsLoader.load(new URLRequest(filePath));
    }
    private function parseCaptions(r:Array):void {
        var l:int = r.length;
        for (var i:int = 1; i < l; i++) {
            var caption:Object = new Object();
            var startTime:String = r[i].substr(0, 12);
            var stopTime:String = r[i].substr(17, 12);
            var textIndex:int = r[i].indexOf("\r\n");
            var captionText:String = r[i].substr(textIndex + 2);
            caption.startTime = startTime;
            caption.stopTime = stopTime;
            caption.captionText = captionText.replace("\r\n", "<br>");
            _captionsArray.push(caption);
        }
        trace(_captionsArray.length + " captions loaded!");
    }
    public function renderCaptions(t:Number, d:TextField):void {
        for (var i:int = 0; i < captionsArray.length; i++) {
            var s:Number = timeFormatter.text2Sec(captionsArray[i].startTime);
            var e:Number = timeFormatter.text2Sec(captionsArray[i].stopTime);
            if (t < s) {
                break;
            } else {
                if (t > s && t < e) {
                    if (captionsArray[i].captionText != currentCaptionText) {
                        currentCaptionText = captionsArray[i].captionText;
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
    private function captionsError(e:IOErrorEvent):void {
        trace(e);
    }
    public function captionsLoaded(e:Event):void {
        _captionsArray = new Array();
        var rawArray:Array = new Array();
        rawArray = e.target.data.split("\r\n\r\n");
        parseCaptions(rawArray);
        captionsLoader.removeEventListener(Event.COMPLETE, captionsLoaded);
    }

    public function get captionsArray():Array {
        return _captionsArray;
    }
}
}
