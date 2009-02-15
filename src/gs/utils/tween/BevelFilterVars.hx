package gs.utils.tween;



class BevelFilterVars extends FilterVars  {
	public var distance(getDistance, setDistance) : Float;
	public var blurX(getBlurX, setBlurX) : Float;
	public var blurY(getBlurY, setBlurY) : Float;
	public var strength(getStrength, setStrength) : Float;
	public var angle(getAngle, setAngle) : Float;
	public var highlightAlpha(getHighlightAlpha, setHighlightAlpha) : Float;
	public var highlightColor(getHighlightColor, setHighlightColor) : Int;
	public var shadowAlpha(getShadowAlpha, setShadowAlpha) : Float;
	public var shadowColor(getShadowColor, setShadowColor) : Int;
	public var quality(getQuality, setQuality) : Int;
	
	private var _distance:Float;
	private var _blurX:Float;
	private var _blurY:Float;
	private var _strength:Float;
	private var _angle:Float;
	private var _highlightAlpha:Float;
	private var _highlightColor:Int;
	private var _shadowAlpha:Float;
	private var _shadowColor:Int;
	private var _quality:Int;
	

	public function new(?$distance:Float=4, ?$blurX:Float=4, ?$blurY:Float=4, ?$strength:Float=1, ?$angle:Float=45, ?$highlightAlpha:Float=1, ?$highlightColor:Int=0xFFFFFF, ?$shadowAlpha:Float=1, ?$shadowColor:Int=0x000000, ?$quality:Int=2, ?$remove:Bool=false, ?$index:Int=-1, ?$addFilter:Bool=false) {
		
		OPPOSITE_OR[X | X] = N;
		OPPOSITE_OR[XY | X] = Y;
		OPPOSITE_OR[XZ | X] = Z;
		OPPOSITE_OR[XYZ | X] = YZ;
		OPPOSITE_OR[Y | Y] = N;
		OPPOSITE_OR[XY | Y] = X;
		OPPOSITE_OR[XYZ | Y] = XZ;
		OPPOSITE_OR[YZ | Y] = Z;
		OPPOSITE_OR[Z | Z] = N;
		OPPOSITE_OR[XZ | Z] = X;
		OPPOSITE_OR[XYZ | Z] = XY;
		OPPOSITE_OR[YZ | Z] = Y;
		SCALINGS[1] = [1, 1, 1];
		SCALINGS[2] = [-1, 1, 1];
		SCALINGS[4] = [-1, 1, -1];
		SCALINGS[8] = [1, 1, -1];
		SCALINGS[16] = [1, -1, 1];
		SCALINGS[32] = [-1, -1, 1];
		SCALINGS[64] = [-1, -1, -1];
		SCALINGS[128] = [1, -1, -1];
		
		super($remove, $index, $addFilter);
		this.distance = $distance;
		this.blurX = $blurX;
		this.blurY = $blurY;
		this.strength = $strength;
		this.angle = $angle;
		this.highlightAlpha = $highlightAlpha;
		this.highlightColor = $highlightColor;
		this.shadowAlpha = $shadowAlpha;
		this.shadowColor = $shadowColor;
		this.quality = $quality;
	}

	//for parsing values that are passed in as generic Objects, like blurFilter:{blurX:5, blurY:3} (typically via the constructor)
	public static function createFromGeneric($vars:Dynamic):BevelFilterVars {
		
		if (Std.is($vars, BevelFilterVars)) {
			return cast($vars, BevelFilterVars);
		}
		return new BevelFilterVars();
	}

	//---- GETTERS / SETTERS --------------------------------------------------------------------------------------------
	public function setDistance($n:Float):Float {
		
		_distance = this.exposedVars.distance = $n;
		return $n;
	}

	public function getDistance():Float {
		
		return _distance;
	}

	public function setBlurX($n:Float):Float {
		
		_blurX = this.exposedVars.blurX = $n;
		return $n;
	}

	public function getBlurX():Float {
		
		return _blurX;
	}

	public function setBlurY($n:Float):Float {
		
		_blurY = this.exposedVars.blurY = $n;
		return $n;
	}

	public function getBlurY():Float {
		
		return _blurY;
	}

	public function setStrength($n:Float):Float {
		
		_strength = this.exposedVars.strength = $n;
		return $n;
	}

	public function getStrength():Float {
		
		return _strength;
	}

	public function setAngle($n:Float):Float {
		
		_angle = this.exposedVars.angle = $n;
		return $n;
	}

	public function getAngle():Float {
		
		return _angle;
	}

	public function setHighlightAlpha($n:Float):Float {
		
		_highlightAlpha = this.exposedVars.highlightAlpha = $n;
		return $n;
	}

	public function getHighlightAlpha():Float {
		
		return _highlightAlpha;
	}

	public function setHighlightColor($n:Int):Int {
		
		_highlightColor = this.exposedVars.highlightColor = $n;
		return $n;
	}

	public function getHighlightColor():Int {
		
		return _highlightColor;
	}

	public function setShadowAlpha($n:Float):Float {
		
		_shadowAlpha = this.exposedVars.shadowAlpha = $n;
		return $n;
	}

	public function getShadowAlpha():Float {
		
		return _shadowAlpha;
	}

	public function setShadowColor($n:Int):Int {
		
		_shadowColor = this.exposedVars.shadowColor = $n;
		return $n;
	}

	public function getShadowColor():Int {
		
		return _shadowColor;
	}

	public function setQuality($n:Int):Int {
		
		_quality = this.exposedVars.quality = $n;
		return $n;
	}

	public function getQuality():Int {
		
		return _quality;
	}

}

