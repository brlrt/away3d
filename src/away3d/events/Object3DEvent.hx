package away3d.events;

import flash.events.Event;
import flash.events.EventDispatcher;
import away3d.core.base.Object3D;


/**
 * Passed as a parameter when a 3d object event occurs
 */
class Object3DEvent extends Event  {
	
	/**
	 * Defines the value of the type property of a parentUpdated event object.
	 */
	public static inline var PARENT_UPDATED:String = "parentUpdated";
	/**
	 * Defines the value of the type property of a transformChanged event object.
	 */
	public static inline var TRANSFORM_CHANGED:String = "transformChanged";
	/**
	 * Defines the value of the type property of a scenetransformChanged event object.
	 */
	public static inline var SCENETRANSFORM_CHANGED:String = "scenetransformChanged";
	/**
	 * Defines the value of the type property of a sceneChanged event object.
	 */
	public static inline var SCENE_CHANGED:String = "sceneChanged";
	/**
	 * Defines the value of the type property of a sessionChanged event object.
	 */
	public static inline var SESSION_CHANGED:String = "sessionChanged";
	/**
	 * Defines the value of the type property of a sessionUpdated event object.
	 */
	public static inline var SESSION_UPDATED:String = "sessionUpdated";
	/**
	 * Defines the value of the type property of a dimensionsChanged event object.
	 */
	public static inline var DIMENSIONS_CHANGED:String = "dimensionsChanged";
	/**
	 * A reference to the 3d object that is relevant to the event.
	 */
	public var object:Object3D;
	

	/**
	 * Creates a new <code>MaterialEvent</code> object.
	 * 
	 * @param	type		The type of the event. Possible values are: <code>Object3DEvent.TRANSFORM_CHANGED</code>, <code>Object3DEvent.SCENETRANSFORM_CHANGED</code>, <code>Object3DEvent.SCENE_CHANGED</code>, <code>Object3DEvent.RADIUS_CHANGED</code> and <code>Object3DEvent.DIMENSIONS_CHANGED</code>.
	 * @param	object		A reference to the 3d object that is relevant to the event.
	 */
	public function new(type:String, object:Object3D) {
		
		
		super(type);
		this.object = object;
	}

	/**
	 * Creates a copy of the Object3DEvent object and sets the value of each property to match that of the original.
	 */
	public override function clone():Event {
		
		return new Object3DEvent();
	}

}

