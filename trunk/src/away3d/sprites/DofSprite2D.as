package away3d.sprites
{
    import away3d.core.*;
    import away3d.core.base.*;
    import away3d.core.draw.*;
    import away3d.core.render.*;
    import away3d.core.utils.*;
    
    import flash.display.BitmapData;
	
	/**
	 * Spherical billboard (always facing the camera) sprite object that uses a cached array of bitmapData objects as it's texture.
	 * A depth of field blur image over a number of different perspecives is drawn and cached for later retrieval and display.
	 */
	public class DofSprite2D extends Object3D implements IPrimitiveProvider
    {
        private var _center:Vertex = new Vertex();
		private var _sc:ScreenVertex;
		private var _persp:Number;
        private var _primitive:DrawScaledBitmap = new DrawScaledBitmap();
        private var _dofcache:DofCache;
		
		/**
		 * Defines the bitmapData object to use for the sprite texture.
		 */
        public var bitmap:BitmapData;
        
        /**
        * Defines the overall scaling of the sprite object
        */
        public var scaling:Number;
        
        /**
        * Defines the overall 2d rotation of the sprite object
        */
        public var rotation:Number;
		
    	/**
    	 * Defines whether the texture bitmap is smoothed (bilinearly filtered) when drawn to screen
    	 */
        public var smooth:Boolean;
        
        /**
        * An optional offset value added to the z depth used to sort the sprite
        */
        public var deltaZ:Number;
    	
		/**
		 * Creates a new <code>DofSprite2D</code> object.
		 * 
		 * @param	bitmap				The bitmapData object to be used as the sprite's texture.
		 * @param	init	[optional]	An initialisation object for specifying default instance properties.
		 */
        public function DofSprite2D(bitmap:BitmapData, init:Object = null)
        {
        	this.bitmap = bitmap;
        	
            super(init);
    
            scaling = ini.getNumber("scaling", 1, {min:0});
			rotation = ini.getNumber("rotation", 0);
            smooth = ini.getBoolean("smooth", false);
            deltaZ = ini.getNumber("deltaZ", 0);
            
            _dofcache = DofCache.getDofCache(bitmap);
            
            _primitive.source = this;
        }
        
		/**
		 * @inheritDoc
    	 * 
    	 * @see	away3d.core.traverse.PrimitiveTraverser
    	 * @see	away3d.core.draw.DrawScaledBitmap
		 */
        override public function primitives(consumer:IPrimitiveConsumer, session:AbstractRenderSession):void
        {
        	super.primitives(consumer, session);

            _sc = _center.project(projection);
            if (!_sc.visible)
                return;
                
            _persp = projection.zoom / (1 + _sc.z / projection.focus);          
            _sc.z += deltaZ;
            
            _primitive.screenvertex = _sc;
            _primitive.smooth = smooth;
            _primitive.bitmap = _dofcache.getBitmap(_sc.z);
            _primitive.scale = _persp*scaling;
            _primitive.rotation = rotation;
            _primitive.calc();
            
            consumer.primitive(_primitive);
        }
    }
}