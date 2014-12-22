/**
 * Created by joseph.labrecque on 12/9/2014.
 */
package edu.du.captions.data {
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.IOErrorEvent;
import flash.events.SecurityErrorEvent;
import flash.net.URLLoader;
import flash.net.URLRequest;
import edu.du.captions.events.CaptionLoadEvent;
import edu.du.captions.events.CaptionParseEvent;

public class CaptionsParser extends EventDispatcher {
    private var rawArray:Array;
    private var captionsLoader:URLLoader;
    private var _captionsArray:Array;

    public function CaptionsParser() {
        captionsLoader = new URLLoader();
        _captionsArray = new Array();
        rawArray = new Array();
    }
    public function loadCaptions(f:String):void {
        captionsLoader.addEventListener(Event.COMPLETE, captionsLoaded);
        captionsLoader.addEventListener(IOErrorEvent.IO_ERROR, captionsError);
        captionsLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, captionsError);
        captionsLoader.load(new URLRequest(f));
    }
    private function parseCaptions(r:Array):void {
        var l:int = r.length;
        try {
            var rawTestIndex:int = rawArray[1].indexOf("\r\n");
            if(rawTestIndex == 1) {
                try {
                    for (var j:int = 1; j < l; j++) {
                        rawTestIndex = rawArray[j].indexOf("\r\n");
                        rawArray[j] = rawArray[j].substring(rawTestIndex + 2);
                    }
                } catch (e:Error){
                    dispatchEvent(new CaptionParseEvent(CaptionParseEvent.ERROR, true));
                }
            }
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
            captionsLoader.removeEventListener(IOErrorEvent.IO_ERROR, captionsError);
            captionsLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, captionsError);
            dispatchEvent(new CaptionParseEvent(CaptionParseEvent.PARSED, true));
        } catch (e:Error){
            captionsLoader.removeEventListener(IOErrorEvent.IO_ERROR, captionsError);
            captionsLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, captionsError);
            dispatchEvent(new CaptionParseEvent(CaptionParseEvent.ERROR, true));
        }
    }
    public function captionsLoaded(e:Event):void {
        dispatchEvent(new CaptionLoadEvent(CaptionLoadEvent.LOADED, true));
        rawArray = e.target.data.split("\r\n\r\n");
        parseCaptions(rawArray);
        captionsLoader.removeEventListener(Event.COMPLETE, captionsLoaded);
    }
    private function captionsError(e:*):void {
        captionsLoader.removeEventListener(IOErrorEvent.IO_ERROR, captionsError);
        captionsLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, captionsError);
        _captionsArray = new Array();
        dispatchEvent(new CaptionLoadEvent(CaptionLoadEvent.ERROR, true));
    }
    public function get captionsArray():Array {
        return _captionsArray;
    }
}
}
