package away3d.core.stats;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.BlendMode;
import flash.display.Sprite;
import flash.events.Event;
import flash.geom.Rectangle;
import flash.system.System;
import flash.utils.Dictionary;
import flash.utils.getTimer;
import flash.display.Stage;
import flash.display.DisplayObject;
import flash.text.TextField;
import flash.display.Shape;
import flash.display.Graphics;


/**
 * 
 * Task monitor
 * 
 * @source http://code.google.com/p/mrdoob/wiki/stats
 * @author katopz@sleepydesign.com
 * 
 */
class Tasks extends Sprite  {
	
	public static var desc:String = "";
	private var tasks:Dictionary;
	private var times:Dictionary;
	private var fs:Float;
	private var fps:Float;
	private var timer:Float;
	private var ms:Float;
	private var msPrev:Float;
	private var mem:Float;
	private var _width:Float;
	private var _height:Float;
	private var graphBitmap:Bitmap;
	private var graphBitmapData:BitmapData;
	public var isDirty:Bool;
	public static var instance:Tasks;
	

	public static function getInstance():Tasks {
		
		if (instance == null) {
			instance = new Tasks();
		}
		return cast(instance, Tasks);
	}

	public function new() {
		// autogenerated
		super();
		this.fs = 0;
		this.fps = 0;
		this.timer = 0;
		this.ms = 0;
		this.msPrev = 0;
		this.mem = 0;
		this._width = 0;
		this._height = 20;
		this.isDirty = false;
		
		
		tasks = new Dictionary();
		times = new Dictionary();
		graphBitmap = new Bitmap();
		addChild(graphBitmap);
		blendMode = BlendMode.MULTIPLY;
		var logo:Logo = new Logo();
		logo.x = 1;
		logo.y = 1;
		addChild(logo);
		// default task
		addTask("$Away3D", "000000", width, 1, "<b>Away3D </b>" + Stats.VERSION + "." + Stats.REVISION + " | " + desc + " | ");
		addTask("FPS", "CC0000", _width, 1, "", 80);
		addTask("MS", "00CC00", _width, 1, "", 60);
		addTask("MEM", "0000CC", _width, 1, "", 90);
		// graph
		graphBitmapData = graphBitmap.bitmapData = new BitmapData();
		addEventListener(Event.ENTER_FRAME, update, false, 0, true);
		draw();
	}

	public static function init(container:Sprite, ?desc:String=""):Tasks {
		
		if (container == null) {
			return null;
		}
		Tasks.desc = desc;
		var tasks:Tasks = getInstance();
		container.addChild(tasks);
		return tasks;
	}

	public function addTask(id:String, ?rgb:String="", ?x:Float=-1, ?y:Float=1, ?text:String="", ?span:Float=-1):StaticTextField {
		
		x = (x > 0) ? x : _width;
		rgb = (rgb != "") ? rgb : "DDDDDD";
		text = (text != "") ? text : "<FONT COLOR='#" + rgb + "'><b>" + id + ":</b></FONT>";
		var _text:StaticTextField = new StaticTextField();
		_text.x = x;
		_text.y = y;
		span = (span > 0) ? span : _text.width + 20;
		_width += span;
		addChild(_text);
		tasks[cast id] = _text;
		_text.defaultText = text;
		draw();
		return _text;
	}

	public static function begin(id:String):Void {
		//mark
		
		getInstance().times[id] = flash.Lib.getTimer();
	}

	public static function end(id:String, ?rgb:String="DDDDDD"):Void {
		//current
		
		var _time:Float = flash.Lib.getTimer();
		//old
		var tasks:Tasks = getInstance();
		var time:Float = Reflect.field(tasks.times, id);
		var task:StaticTextField = Reflect.field(tasks.tasks, id);
		//init
		if (task == null) {
			task = tasks.addTask(id, rgb);
		}
		if (time == 0) {
			time = _time;
		}
		//diff
		if (tasks.isDirty) {
			tasks.graphBitmapData.setPixel(0, tasks.graphBitmapData.height - ((_time - time) * .5 << 0), ("0x" + rgb));
		}
		task.htmlText = task.defaultText + (_time - time);
	}

	private function draw():Void {
		// Graph
		
		graphBitmap.x = Math.max(_width, (flash.Lib.current.stage != null) ? flash.Lib.current.stage.stageWidth - graphBitmap.width : 0);
		// Background
		graphics.clear();
		graphics.beginFill(0x999999);
		if ((flash.Lib.current.stage != null)) {
			graphics.drawRect(0, 0, flash.Lib.current.stage.stageWidth, _height);
		} else {
			graphics.drawRect(0, 0, width, _height);
		}
		graphics.endFill();
	}

	private function update(event:Event):Void {
		
		if (flash.Lib.current.stage == null) {
			return;
		}
		timer = flash.Lib.getTimer();
		fs += 4;
		isDirty = (timer - 250 > msPrev);
		if (isDirty) {
			msPrev = timer;
			var fsGraph:Float = Math.min(_height, _height / flash.Lib.current.stage.frameRate * fs);
			fps = Math.min(flash.Lib.current.stage.frameRate, fs);
			mem = ((System.totalMemory / 1048576).toFixed(3));
			var memGraph:Float = Math.min(_height, Math.sqrt(Math.sqrt(mem * 5000))) - 2;
			graphBitmapData.scroll(1, 0);
			graphBitmapData.fillRect(new Rectangle(), 0x333333);
			//FPS
			graphBitmapData.setPixel(0, _height - fsGraph, 0xFF0000);
			//MS
			graphBitmapData.setPixel(0, _height - ((timer - ms) * .5 << 0), 0x00FF00);
			//MEM
			graphBitmapData.setPixel(0, Std.int(_height - memGraph), 0x0000FF);
			tasks[cast "FPS"].htmlText = tasks[cast "FPS"].defaultText + fps + "/" + flash.Lib.current.stage.frameRate;
			tasks[cast "MEM"].htmlText = tasks[cast "MEM"].defaultText + mem;
			fs = 0;
		}
		tasks[cast "MS"].htmlText = tasks[cast "MS"].defaultText + (timer - ms);
		ms = timer;
	}

}

