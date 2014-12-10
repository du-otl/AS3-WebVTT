package {
import flash.display.Sprite;
import flash.events.TimerEvent;
import flash.filters.BitmapFilterQuality;
import flash.filters.GlowFilter;
import flash.media.Video;
import flash.net.NetConnection;
import flash.net.NetStream;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.utils.Timer;
import edu.du.captions.utils.CaptionsHandler;
import edu.du.captions.events.CaptionLoadEvent;
import edu.du.captions.events.CaptionParseEvent;

[SWF(width="854", height="480", backgroundColor="#000000", frameRate="30")]

public class Main extends Sprite {
    private var videoHolder:Video;
    private var captionsHandler:CaptionsHandler;
    private var captionDisplay:TextField;
    private var captionFormat:TextFormat;
    private var captionsTimer:Timer;
    private var netConnection:NetConnection;
    private var netStream:NetStream;

    private const videoPath:String = "assets/video.mp4";
    private const captionsPath:String = "assets/captiosns.vtt";

    public function Main() {
        captionsTimer = new Timer(200);
        captionsTimer.addEventListener(TimerEvent.TIMER, checkCaptionTime);
        buildVideoDisplay();
        buildCaptionDisplay();
        captionsHandler = new CaptionsHandler();
        captionsHandler.addEventListener(CaptionLoadEvent.LOADED, onCaptionsLoaded);
        captionsHandler.addEventListener(CaptionLoadEvent.ERROR, onCaptionsError);
        captionsHandler.addEventListener(CaptionParseEvent.PARSED, onCaptionsParsed);
        captionsHandler.addEventListener(CaptionParseEvent.ERROR, onCaptionsError);
        captionsHandler.gatherCaptions(captionsPath);
    }

    private function buildVideoDisplay():void {
        videoHolder = new Video(854, 480);
        netConnection = new NetConnection();
        netConnection.connect(null);
        netStream = new NetStream(netConnection);
        var client:Object = new Object();
        client.onMetaData = function(o:Object):void {}
        netStream.client = client;
        videoHolder.attachNetStream(netStream);
        netStream.play(videoPath);
        addChild(videoHolder);
        captionsTimer.start();
    }

    private function buildCaptionDisplay():void {
        captionFormat = new TextFormat("Arial", 18, 0xFFFFE8, true, false, false, null, null, "center", null, null, null, 4);
        captionDisplay = new TextField();
        captionDisplay.defaultTextFormat = captionFormat;
        captionDisplay.multiline = true;
        captionDisplay.selectable = false;
        captionDisplay.wordWrap = true;
        captionDisplay.condenseWhite = true;
        captionDisplay.htmlText = "";
        captionDisplay.width = 854;
        captionDisplay.height = 80;
        captionDisplay.y = 400;
        captionDisplay.filters = [new GlowFilter(0x000000, 0.7, 28, 28, 8, BitmapFilterQuality.MEDIUM)];
        addChild(captionDisplay);
    }

    private function checkCaptionTime(timerEvent:TimerEvent):void {
        var t:Number = netStream.time;
        captionsHandler.renderCaptions(t, captionDisplay);
    }




    private function onCaptionsLoaded(e:CaptionLoadEvent):void {
        trace("loaded successfully");
    }

    private function onCaptionsParsed(e:CaptionParseEvent):void {
        trace("parsed successfully");
    }

    private function onCaptionsError(e:*):void {
        trace("bad news kids...");
    }

}
}
