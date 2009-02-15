package away3d.events;

import flash.events.Event;
import away3d.materials.IMaterial;
import flash.events.EventDispatcher;
import away3d.containers.View3D;
import away3d.core.base.Object3D;
import flash.display.Sprite;
import away3d.materials.IUVMaterial;
import away3d.core.draw.DrawPrimitive;
import away3d.core.base.UV;


/**
 * Passed as a parameter when a 3d mouse event occurs
 */
class MouseEvent3D extends Event  {
	
	/**
	 * Defines the value of the type property of a mouseOver3d event object.
	 */
	public static inline var MOUSE_OVER:String = "mouseOver3d";
	/**
	 * Defines the value of the type property of a mouseOut3d event object.
	 */
	public static inline var MOUSE_OUT:String = "mouseOut3d";
	/**
	 * Defines the value of the type property of a mouseUp3d event object.
	 */
	public static inline var MOUSE_UP:String = "mouseUp3d";
	/**
	 * Defines the value of the type property of a mouseDown3d event object.
	 */
	public static inline var MOUSE_DOWN:String = "mouseDown3d";
	/**
	 * Defines the value of the type property of a mouseMove3d event object.
	 */
	public static inline var MOUSE_MOVE:String = "mouseMove3d";
	/**
	 * Defines the value of the type property of a rollOver3d event object.
	 */
	public static inline var ROLL_OVER:String = "rollOver3d";
	/**
	 * Defines the value of the type property of a rollOut3d event object.
	 */
	public static inline var ROLL_OUT:String = "rollOut3d";
	/**
	 * The horizontal coordinate at which the event occurred in view coordinates.
	 */
	public var screenX:Float;
	/**
	 * The vertical coordinate at which the event occurred in view coordinates.
	 */
	public var screenY:Float;
	/**
	 * The depth coordinate at which the event occurred in view coordinates.
	 */
	public var screenZ:Float;
	/**
	 * The x coordinate at which the event occurred in global scene coordinates.
	 */
	public var sceneX:Float;
	/**
	 * The y coordinate at which the event occurred in global scene coordinates.
	 */
	public var sceneY:Float;
	/**
	 * The z coordinate at which the event occurred in global scene coordinates.
	 */
	public var sceneZ:Float;
	/**
	 * The view object inside which the event took place.
	 */
	public var view:View3D;
	/**
	 * The 3d object inside which the event took place.
	 */
	public var object:Object3D;
	/**
	 * The 3d element inside which the event took place.
	 */
	public var element:Dynamic;
	/**
	 * The draw primitive inside which the event took place.
	 */
	public var drawpri:DrawPrimitive;
	/**
	 * The material of the 3d element inside which the event took place.
	 */
	public var material:IUVMaterial;
	/**
	 * The uv coordinate inside the draw primitive where the event took place.
	 */
	public var uv:UV;
	/**
	 * Indicates whether the Control key is active (true) or inactive (false).
	 */
	public var ctrlKey:Bool;
	/**
	 * Indicates whether the Shift key is active (true) or inactive (false).
	 */
	public var shiftKey:Bool;
	

	/**
	 * Creates a new <code>MouseEvent3D</code> object.
	 * 
	 * @param	type		The type of the event. Possible values are: <code>MouseEvent3D.MOUSE_OVER</code>, <code>MouseEvent3D.MOUSE_OUT</code>, <code>MouseEvent3D.MOUSE_UP</code>, <code>MouseEvent3D.MOUSE_DOWN</code> and <code>MouseEvent3D.MOUSE_MOVE</code>.
	 */
	public function new(type:String) {
		
		
		super(type);
	}

	/**
	 * Creates a copy of the MouseEvent3D object and sets the value of each property to match that of the original.
	 */
	public override function clone():Event {
		
		var result:MouseEvent3D = new MouseEvent3D();
		result.screenX = screenX;
		result.screenY = screenY;
		result.screenZ = screenZ;
		result.sceneX = sceneX;
		result.sceneY = sceneY;
		result.sceneZ = sceneZ;
		result.view = view;
		result.object = object;
		result.element = element;
		result.drawpri = drawpri;
		result.material = material;
		result.uv = uv;
		result.ctrlKey = ctrlKey;
		result.shiftKey = shiftKey;
		return result;
	}

}

