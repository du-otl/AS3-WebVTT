AS3-WebVTT
==========

AS3-WebVTT is a set of ActionScript 3.0 utility classes which enable the parsing and sorting of standard WebVTT (.vtt) files for video captioning.

![alt tag](https://cloud.githubusercontent.com/assets/3355144/5382065/35b86b22-8064-11e4-8915-972f350b44d6.png)

Why write a WebVTT parser in AS3? Simple. A lot of video is still served with Flash Player or AIR – we certainly still use it extensively at the University of Denver. 

Recently, we’ve found the need to integrate captioning through a standard format across our video delivery tools. We settled on support for the WebVTT standard and now make our work available for everyone. Another example of web standards and Flash innovation working hand in hand!

So how is it used?
------------------

1. Download the code and include it in your project.
2. Import **edu.du.captions.utils.CaptionsHandler** – this is the only class you need to interact with from your application code.
3. Create a new instance of the **CaptionsHandler** class: **captionsHandler = new CaptionsHandler();**
4. You will need to stream a video, and create a text field for the captions to display in. This should be in your app already apart from the text object for captions support.
5. Invoke **captionsHandler.gatherCaptions(captionsPath);** passing in string representing a .vtt file location. It will then be loaded, read, and parsed.
6. Invoke **captionsHandler.renderCaptions(CurrentVideoTime, TextFieldForDisplay);** – passing in the current playback time of the video and the text field object whenever appropriate to render captions to the screen. You could use a Timer, for instance.

The video and text objects are completely under your control. Experiment with text positioning and format to get the desired results. You can see an example of all of this in the demo project.

If you do improve the classes – please contribute back to the project! Everything is pretty solid right now but there is always room for improvement. Some pieces of the WebVTT specification (such as alignment) are currently ignored by the parser.
