/**
 * Created by Joseph Labrecque on 12/10/2014.
 */
package edu.du.captions.events {
import flash.events.Event;

public class CaptionParseEvent extends Event {
    public static const PARSED:String = "onParsed";
    public static const ERROR:String = "onError";
    public function CaptionParseEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false) {
        super(type, bubbles, cancelable);
    }
}
}
