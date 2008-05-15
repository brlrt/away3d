package away3d.containers
{
    import away3d.core.base.*;
    import away3d.core.math.*;
    import away3d.core.utils.*;

    /**
    * 3d object container that is drawn only if its scaling to perspective falls within a given range.
    */ 
    public class LODObject extends ObjectContainer3D implements ILODObject
    {
    	/**
    	 * The maximum perspective value from which the 3d object can be viewed.
    	 */
        public var maxp:Number;
        
    	/**
    	 * The minimum perspective value from which the 3d object can be viewed.
    	 */
        public var minp:Number;
    	
	    /**
	    * Creates a new <code>LODObject</code> object.
	    * 
	    * @param	init			[optional]	An initialisation object for specifying default instance properties.
	    * @param	...childarray				An array of children to be added on instatiation.
	    */
        public function LODObject(init:Object = null, ...childarray)
        {
            super(init);
			
            maxp = ini.getNumber("maxp", Infinity);
            minp = ini.getNumber("minp", 0);

            for each (var child:Object3D in childarray)
                addChild(child);
        }
        
		/**
		 * @inheritDoc
		 */
        public function matchLOD(view:View3D):Boolean
        {
            var z:Number = viewTransform.tz;
            var persp:Number = view.camera.zoom / (1 + z / view.camera.focus);

            if (persp < minp)
                return false;
            if (persp >= maxp)
                return false;

            return true;
        }
    }
}
