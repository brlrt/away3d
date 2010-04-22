﻿package away3d.events{   import away3d.animators.*;        import flash.events.Event;        /**    * Passed as a parameter when an animator event occurs    */    public class AnimatorEvent extends Event    {    	/**    	 * Defines the value of the type property of a start event object.    	 */    	public static const START:String = "start";    	    	/**    	 * Defines the value of the type property of a stop event object.    	 */    	public static const STOP:String = "stop";    	    	/**    	 * Defines the value of the type property of a cycle event object.    	 */    	public static const CYCLE:String = "cycle";    	    	/**    	 * Defines the value of the type property of a enterKeyFrame event object.    	 */    	public static const ENTER_KEY_FRAME:String = "enterKeyFrame";    	    	/**    	 * Defines the value of the type property of a sequenceUpdate event object.    	 */    	public static const SEQUENCE_UPDATE:String = "sequenceUpdate";    	    	/**    	 * Defines the value of the type property of a sequenceDone event object.    	 */    	public static const SEQUENCE_DONE:String = "sequenceDone";    	    	/**    	 * A reference to the animation object that is relevant to the event.    	 */        public var animator:Animator;				/**		 * Creates a new <code>AnimationEvent</code> object.		 * 		 * @param	type		The type of the event. Possible values are: <code>AnimationEvent.CYCLE</code>, <code>AnimationEvent.SEQUENCE_UPDATE</code> and <code>AnimationEvent.SEQUENCE_DONE</code>.		 * @param	animation	A reference to the animation object that is relevant to the event.		 */        public function AnimatorEvent(type:String, animator:Animator)        {            super(type);            this.animator = animator;        }				/**		 * Creates a copy of the AnimationEvent object and sets the value of each property to match that of the original.		 */        public override function clone():Event        {            return new AnimatorEvent(type, animator);        }    }}