package away3d.haxeutils;

import flash.display.Sprite;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.utils.Dictionary;
import flash.utils.getTimer;
import flash.display.DisplayObject;


class TimerUtils extends Sprite  {
	
	private var timeStart:Dictionary;
	private var timeEnd:Dictionary;
	private var nPasses:Dictionary;
	private var timerText:TextField;
	private static var instance:TimerUtils;
	

	public function new() {
		// autogenerated
		super();
		
		// Create a text field
		
		timerText = new TextField();
		timerText.autoSize = TextFieldAutoSize.LEFT;
		addChild(timerText);
		timerText.text = "";
		timeStart = new Dictionary();
		timeEnd = new Dictionary();
		nPasses = new Dictionary();
	}

	public static function getInstance():TimerUtils {
		
		if (instance == null) {
			instance = new TimerUtils();
		}
		return instance;
	}

	public function tickStart(id:String):Void {
		
		timeStart[cast id] = flash.Lib.getTimer();
	}

	public function tickEnd(id:String):Void {
		
		if (timeStart[cast id] != null) {
			var timePassed:Int = flash.Lib.getTimer() - timeStart[cast id];
			var cumulativeTime:Int = 0;
			var iter:Int = 0;
			if (timeEnd[cast id] != null) {
				cumulativeTime = timeEnd[cast id];
				iter = nPasses[cast id];
			}
			timeEnd[cast id] = timePassed + cumulativeTime;
			nPasses[cast id] = iter + 1;
		}
	}

	public function display():Void {
		
		var text:String = "";
		var key:String;
		var __keys:Iterator<Dynamic> = untyped (__keys__(timeEnd)).iterator();
		for (key in __keys) {
			text = text + key + " ----> " + timeEnd[cast key] + " / " + nPasses[cast key] + "\n";
			
		}

		timerText.text = text;
	}

}

