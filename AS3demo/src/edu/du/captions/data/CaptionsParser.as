/**
 * Created by Joseph Labrecque on 12/9/2014.
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

    //do not mess with this directly - it is instantiated by CaptionsHandler
    public function CaptionsParser() {
        captionsLoader = new URLLoader();
        _captionsArray = new Array();
        rawArray = new Array();
    }

    //adds some listeners to the URLLoader and then loads the vtt file
    public function loadCaptions(f:String):void {
        captionsLoader = new URLLoader();
        _captionsArray = new Array();
        rawArray = new Array();
        
        captionsLoader.addEventListener(Event.COMPLETE, captionsLoaded);
        captionsLoader.addEventListener(IOErrorEvent.IO_ERROR, captionsError);
        captionsLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, captionsError);
        captionsLoader.load(new URLRequest(f));
    }

    //this is the core of the parser - it attempts to parse the loaded vtt file into cute little objects.
    private function parseCaptions(r:Array):void {
        var l:int = r.length;
        try {
            var chapterSignifier:String = "\r\n";
            if (rawArray[1].indexOf("\r\n") == -1) {
                chapterSignifier = "\n";
            }
            //here we are looking to see whether we need to strip out caption indexes.
            //we check the position at index 1 since index 0 is just "WEBVTT" - always skip that junk!
            var rawTestIndex:int = rawArray[1].indexOf(chapterSignifier);
            if(rawTestIndex == 1) {
                //okay... we have indexes. let's kill them all.
                try {
                    for (var j:int = 1; j < l; j++) {
                        rawTestIndex = rawArray[j].indexOf(chapterSignifier);
                        rawArray[j] = rawArray[j].substring(rawTestIndex + chapterSignifier.length);
                    }
                } catch (e:Error){
                    dispatchEvent(new CaptionParseEvent(CaptionParseEvent.ERROR, true));
                }
            }
            //now we are sure that the file is clean (no filthy indexes) and no errors yet.
            //so lets build neat little caption babies out of the base string data.
            for (var i:int = 1; i < l; i++) {
                var caption:Object = new Object();
                //we get the start and end times from the standard vtt time format of "00:00.000".
                var startTime:String = r[i].substr(0, 12);
                var stopTime:String = r[i].substr(17, 12);
                //here we identify the first line break - this is where the caption text lives.
                var textIndex:int = r[i].indexOf(chapterSignifier);
                var captionText:String = "";
                if (textIndex != -1){
                    captionText = r[i].substr(textIndex + chapterSignifier.length);
                }
                caption.startTime = startTime;
                caption.stopTime = stopTime;
                //replace the breaks with HTML junk for the TextField.
                caption.captionText = captionText.replace(chapterSignifier, "<br>");
                //add the baby to our array. this one is cooked.
                _captionsArray.push(caption);
            }
            captionsLoader.removeEventListener(IOErrorEvent.IO_ERROR, captionsError);
            captionsLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, captionsError);
            //let the application know that we have parsed the file just fine!
            dispatchEvent(new CaptionParseEvent(CaptionParseEvent.PARSED, true));
        } catch (e:Error){
            captionsLoader.removeEventListener(IOErrorEvent.IO_ERROR, captionsError);
            captionsLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, captionsError);
            //let the application know something truly horrifying has occurred...
            dispatchEvent(new CaptionParseEvent(CaptionParseEvent.ERROR, true));
        }
    }

    //captions loaded successfully - now this will all get parsed into little neat objects and placed in an array.
    public function captionsLoaded(e:Event):void {
        dispatchEvent(new CaptionLoadEvent(CaptionLoadEvent.LOADED, true));
        var captionSignifier:String = "\r\n\r\n";
        if (e.target.data.indexOf("\r\n\r\n") == -1) {
            captionSignifier = "\n\n";
        }
        rawArray = e.target.data.split(captionSignifier);
        parseCaptions(rawArray);
        //let the application know that we have loaded the file just fine!
        captionsLoader.removeEventListener(Event.COMPLETE, captionsLoaded);
    }

    //tsk tsk tsk... something is wrong... does the file even exist?
    private function captionsError(e:*):void {
        //let the application know something truly horrifying has occurred...
        dispatchEvent(new CaptionLoadEvent(CaptionLoadEvent.ERROR, true));
        captionsLoader.removeEventListener(IOErrorEvent.IO_ERROR, captionsError);
        captionsLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, captionsError);
        _captionsArray = new Array();
    }

    //CaptionsHandler grabs the captions through this.
    public function get captionsArray():Array {
        return _captionsArray;
    }

}
}
