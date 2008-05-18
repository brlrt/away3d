package away3d.lights
{
    import away3d.core.base.*;
    import away3d.core.draw.*;
    import away3d.core.light.*;
    import away3d.core.render.*;
    import away3d.core.utils.*;
	
    /**
    * Lightsource that colors all shaded materials proportional to the dot product of the offset vector with the normal vector.
    * The scalar value of distance does not affect the resulting light intensity, it is calulated as if the
    * source is an infinite distance away with an infinite brightness.
    */
    public class DirectionalLight3D extends Object3D implements ILightProvider, IPrimitiveProvider, IClonable
    {
        private var _color:int;
        private var _red:int;
        private var _green:int;
        private var _blue:int;
        private var _ambient:Number;
        private var _diffuse:Number;
        private var _specular:Number;
        private var _brightness:Number;
    	
    	private var _colorDirty:Boolean;
    	private var _ambientDirty:Boolean;
    	private var _diffuseDirty:Boolean;
    	private var _specularDirty:Boolean;
    	private var _brightnessDirty:Boolean;
		private var _ls:DirectionalLight = new DirectionalLight();
		
        //TODO: add debug graphics for directional light
        /**
        * Toggles debug mode: light source is visualised in the scene.
        */
        public var debug:Boolean;
		
		/**
		 * Defines the color of the lightsource.
		 */
		public function get color():int
		{
			return _color;
		}
		
		public function set color(val:int):void
		{
			_color = val;
			_red = (_color & 0xFF0000) >> 16;
            _green = (_color & 0xFF00) >> 8;
            _blue  = (_color & 0xFF);
            _colorDirty = true;
            _ambientDirty = true;
            _diffuseDirty = true;
            _specularDirty = true;
		}
		
		/**
		 * Defines a coefficient for the ambient light intensity.
		 */
		public function get ambient():Number
		{
			return _ambient;
		}
		public function set ambient(val:Number):void
		{
			if (val < 0)
				val  = 0;
			_ambient = val;
            _ambientDirty = true;
		}
		
		/**
		 * Defines a coefficient for the diffuse light intensity.
		 */
		public function get diffuse():Number
		{
			return _diffuse;
		}
		
		public function set diffuse(val:Number):void
		{
			if (val < 0)
				val  = 0;
			_diffuse = val;
            _diffuseDirty = true;
		}
		
		/**
		 * Defines a coefficient for the specular light intensity.
		 */
		public function get specular():Number
		{
			return _specular;
		}
		
		public function set specular(val:Number):void
		{
			if (val < 0)
				val  = 0;
			_specular = val;
            _specularDirty = true;
		}
		
		//TODO: brightness on directional light needs implementing
		/**
		 * Defines a coefficient for the overall light intensity.
		 */
		public function get brightness():Number
		{
			return _brightness;
		}
		
		public function set brightness(val:Number):void
		{
			_brightness = val;
            _brightnessDirty = true;
		}
		
		/**
		 * Creates a new <code>DirectionalLight3D</code> object.
		 * 
		 * @param	init	[optional]	An initialisation object for specifying default instance properties.
		 */
        public function DirectionalLight3D(init:Object = null)
        {
            super(init);
            
            color = ini.getColor("color", 0xFFFFFF);
            ambient = ini.getNumber("ambient", 0.5, {min:0, max:1});
            diffuse = ini.getNumber("diffuse", 0.5, {min:0, max:10});
            specular = ini.getNumber("specular", 1, {min:0, max:1});
            brightness = ini.getNumber("brightness", 1);
            debug = ini.getBoolean("debug", false);
            _ls.light = this;
            addOnTransformChange(_ls.updateDirection);
        }
        
		/**
		 * @inheritDoc
		 */
        public function light(consumer:ILightConsumer):void
        {
            //update color
			if (_colorDirty) {
				_ls.red = _red;
				_ls.green = _green;
				_ls.blue = _blue;
			}
        	
        	//update ambient diffuse
            if (_ambientDirty || _diffuseDirty || _brightnessDirty)
	        	_ls.updateAmbientDiffuseBitmap(ambient, diffuse);
        	
        	//update ambient
            if (_ambientDirty || _brightnessDirty) {
        		_ambientDirty = false;
	        	_ls.updateAmbientBitmap(ambient);
        	}
            
        	//update diffuse
        	if (_diffuseDirty || _brightnessDirty) {
        		_diffuseDirty = false;
	        	_ls.updateDiffuseBitmap(diffuse);
        	}
        	
        	//update specular
        	if (_specularDirty || _brightnessDirty) {
        		_specularDirty = false;
        		_ls.updateSpecularBitmap(specular);
        	}
        	
            consumer.directionalLight(_ls);
            
            _colorDirty = false;
            _brightnessDirty = false;
        }
        
		/**
		 * @inheritDoc
		 */
        override public function primitives(consumer:IPrimitiveConsumer, session:AbstractRenderSession):void
        {
        	super.primitives(consumer, session);

        }
		
		/**
		 * Duplicates the light object's properties to another <code>DirectionalLight3D</code> object
		 * 
		 * @param	object	[optional]	The new object instance into which all properties are copied
		 * @return						The new object instance with duplicated properties applied
		 */
        public override function clone(object:* = null):*
        {
            var light:DirectionalLight3D = object || new DirectionalLight3D();
            super.clone(light);
            light.color = color;
            light.brightness = brightness;
            light.ambient = ambient;
            light.diffuse = diffuse;
            light.specular = specular;
            light.debug = debug;
            return light;
        }

    }
}
