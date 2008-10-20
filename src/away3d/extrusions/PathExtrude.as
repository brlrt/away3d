﻿package away3d.extrusions{		import away3d.core.math.Number3D;	import away3d.core.base.*;	import away3d.arcane;	import away3d.materials.*;	import away3d.core.utils.Init;	import away3d.core.math.Matrix3D;	import away3d.animators.data.Path;	import away3d.animators.utils.PathUtils;	import away3d.animators.data.CurveSegment; 	use namespace arcane;		public class PathExtrude extends Mesh	{		private var varr:Array;		private var xAxis:Number3D = new Number3D();    	private var yAxis:Number3D = new Number3D();    	private var zAxis:Number3D = new Number3D();		private var _worldAxis:Number3D = new Number3D(0,1,0);		private var _transform:Matrix3D = new Matrix3D();				private var _path:Path;		private var _points:Array;		private var _scales:Array;		private var _rotations:Array;		private var _subdivision:int = 2;		private var _scaling:Number =  1;		private var _coverall:Boolean = true;		private var _recenter:Boolean = false;		private var _flip:Boolean = false;		private var _closepath:Boolean = false;		private var _aligntopath:Boolean = true;		private var _smoothscale:Boolean = true;		 		        private function orientateAt(target:Number3D, position:Number3D):void        {            zAxis.sub(target, position);            zAxis.normalize();                if (zAxis.modulo > 0.1)            {                xAxis.cross(zAxis, _worldAxis);                xAxis.normalize();                    yAxis.cross(zAxis, xAxis);                yAxis.normalize();                    _transform.sxx = xAxis.x;                _transform.syx = xAxis.y;                _transform.szx = xAxis.z;                    _transform.sxy = -yAxis.x;                _transform.syy = -yAxis.y;                _transform.szy = -yAxis.z;                    _transform.sxz = zAxis.x;                _transform.syz = zAxis.y;                _transform.szz = zAxis.z;				            }        }				private function generate(points:Array, coverall:Boolean = false, closepath:Boolean = false, flip:Boolean = false):void		{				var uvlength:int = points.length-1;			for(var i:int = 0;i< points.length-1;++i){				varr = new Array();				extrudePoints( points[i], points[i+1], 1, coverall, (1/uvlength)*i, uvlength, flip);			}		}				private function extrudePoints(points1:Array, points2:Array, subdivision:int, coverall:Boolean, vscale:Number, indexv:int, flip:Boolean):void		{						var i:int;			var j:int;			var stepx:Number;			var stepy:Number;			var stepz:Number;						var uva:UV;			var uvb:UV;			var uvc:UV;			var uvd:UV;						var va:Vertex;			var vb:Vertex;			var vc:Vertex;			var vd:Vertex;						var u1:Number;			var u2:Number;			var index:int = 0;			var bu:Number = 0;			var bincu = 1/(points1.length-1);			var v1:Number = 0;			var v2:Number = 0;			 			for( i = 0; i < points1.length; ++i){				stepx = (points2[i].x - points1[i].x) / subdivision;				stepy = (points2[i].y - points1[i].y) / subdivision;				stepz = (points2[i].z - points1[i].z)  / subdivision;								for( j = 0; j < subdivision+1; ++j){					varr.push( new Vertex( points1[i].x+(stepx*j) , points1[i].y+(stepy*j), points1[i].z+(stepz*j)) );				}			}						for( i = 0; i < points1.length-1; ++i){								u1 = bu;				bu += bincu;				u2 = bu;								for( j = 0; j < subdivision; ++j){										v1 = (coverall)? vscale+((j/subdivision)/indexv) :  j/subdivision;					v2 = (coverall)? vscale+(( (j+1)/subdivision)/indexv) :  (j+1)/subdivision;										uva = new UV( u1 , v1);					uvb = new UV( u1 , v2 );					uvc = new UV( u2 , v2 );					uvd = new UV( u2 , v1 );											va = varr[index+j];					vb = varr[(index+j) + 1];					vc = varr[((index+j) + (subdivision + 2))];					vd = varr[((index+j) + (subdivision + 1))];					 					if(flip){												addFace(new Face(vb,va,vc, null, uvb, uva, uvc ));						addFace(new Face(vc,va,vd, null, uvc, uva, uvd));					}else{												addFace(new Face(va,vb,vc, null, uva, uvb, uvc ));						addFace(new Face(va,vc,vd, null, uva, uvc, uvd));					}				}								index += subdivision +1;			}					}				/**		 * Creates a new <PathExtrude>PathExtrude</code>		 * 		 * @param	 	path			A Path object. The _path definition.		 * @param	 	points		An array containing a series of Number3D's. Defines the profile to extrude on the _path definition.		 * @param 	scales		[optional]	An array containing a series of Number3D [Number3D(1,1,1)]. Defines the scale per segment. Init object smoothscale true smooth the scale across the segments, set to false the scale is applied equally to the whole segment, default is true.		  * @param 	rotations	[optional]	An array containing a series of Number3D [Number3D(0,0,0)]. Defines the rotation per segment. Default is null. Note that last value entered is reused for the next segment.		 * @param 	init			[optional]	An initialisation object for specifying default instance properties.		 * 		 */		 		function PathExtrude(path:Path=null, points:Array=null, scales:Array=null, rotations:Array=null, init:Object = null)		{				_path = path;				_points = points;				_scales = scales;				_rotations = rotations;								init = Init.parse(init);				super(init);					_subdivision = init.getInt("subdivision", 2, {min:2});				_scaling = init.getNumber("scaling", 1);				_coverall = init.getBoolean("coverall", true);				_recenter = init.getBoolean("recenter", false);				_flip = init.getBoolean("flip", false);				_closepath = init.getBoolean("closepath", false);				_aligntopath = init.getBoolean("aligntopath", true);				_smoothscale = init.getBoolean("smoothscale", true);								if(_path != null && _points!= null) build();		}				public function build():void		{			if(_path.length != 0 && _points.length >=2){								_worldAxis = _path.worldAxis;				if(_closepath){										var ref:CurveSegment = _path.array[_path.array.length-1];					var vc:Number3D = new Number3D(  (_path.array[0].vc.x+ref.vc.x)*.5,  (_path.array[0].vc.y+ref.vc.y)*.5, (_path.array[0].vc.z+ref.vc.z)*.5   );					_path.add( new CurveSegment( _path.array[0].v1, vc, _path.array[0].v0 )   );					if(_path.smoothed){												var tpv1:Number3D = new Number3D((_path.array[0].v0.x+_path.array[_path.length-1].v0.x)*.5, (_path.array[0].v0.y+_path.array[_path.length-1].v0.y)*.5, (_path.array[0].v0.z+_path.array[_path.length-1].v0.z)*.5);						var tpv2:Number3D = new Number3D((_path.array[0].v0.x+_path.array[0].v1.x)*.5, (_path.array[0].v0.y+_path.array[0].v1.y)*.5, (_path.array[0].v0.z+_path.array[0].v1.z)*.5);												_path.array[_path.length-1].vc.x = tpv1.x;						_path.array[_path.length-1].vc.y = tpv1.y;						_path.array[_path.length-1].vc.z = tpv1.z;												_path.array[_path.length-1].v1.x = (_path.array[0].v0.x+_path.array[0].v1.x)*.5;						_path.array[_path.length-1].v1.y = (_path.array[0].v0.y+_path.array[0].v1.y)*.5;						_path.array[_path.length-1].v1.z = (_path.array[0].v0.z+_path.array[0].v1.z)*.5;												_path.array[0].v0.x = _path.array[_path.length-1].vc.x;						_path.array[0].v0.y = _path.array[_path.length-1].vc.y;						_path.array[0].v0.z = _path.array[_path.length-1].vc.z;												_path.array[0].vc.x = tpv2.x;						_path.array[0].vc.y = tpv2.y;						_path.array[0].vc.z = tpv2.z;												tpv1 = null;						tpv2 = null;											} 					 				}								var aSegPoints:Array = PathUtils.getPointsOnCurve(_path, _subdivision);				var aPointlist:Array = [];				var aSegresult:Array = [];				var atmp:Array;				var tmppt:Number3D = new Number3D(0,0,0);				 				var i:int;				var j:int;				var k:int;								var nextpt:Number3D;				var lastscale:Number3D = new Number3D(1, 1, 1);				var rescale:Boolean = (_scales != null);				var rotate:Boolean = (_rotations != null);								if(rotate && _rotations.length > 0){					var lastrotate:Number3D = _rotations[0] ;					var nextrotate:Number3D;					var aRotates:Array = [];					var tweenrot:Number3D;				}				 				if(_smoothscale && rescale){					var nextscale:Number3D = new Number3D(1, 1, 1);					var aScales:Array = [];				}				 				for (i = 0; i <aSegPoints.length; ++i) {										if(rotate &&  i <aSegPoints.length){						lastrotate = (_rotations[i] == null) ? lastrotate : _rotations[i];						nextrotate = (_rotations[i+1] == null) ? lastrotate : _rotations[i+1];												aRotates = PathUtils.step( lastrotate, nextrotate,  _subdivision);					}										if(rescale)						lastscale = (_scales[i] == null) ? lastscale : _scales[i];											if(_smoothscale && rescale &&  i <aSegPoints.length){						nextscale = (_scales[i+1] == null) ? lastscale : _scales[i+1];						aScales = aScales.concat(PathUtils.step( lastscale, nextscale, _subdivision));					}										for(j = 0; j<aSegPoints[i].length;++j){						atmp = [];						atmp = atmp.concat(_points);						aPointlist = [];												if(rotate)							tweenrot = aRotates[j];						if(_aligntopath) {							_transform = new Matrix3D();							if(i == aSegPoints.length -1 && j==aSegPoints[i].length-1){																if(_closepath){									nextpt = aSegPoints[0][0];									orientateAt(nextpt, aSegPoints[i][j]);								} else{									nextpt = aSegPoints[i][j-1];									orientateAt(aSegPoints[i][j], nextpt);								}															} else {								nextpt = (j<aSegPoints[i].length-1)? aSegPoints[i][j+1]:  aSegPoints[i+1][0];								orientateAt(nextpt, aSegPoints[i][j]);							}						}												for (k = 0; k <atmp.length; ++k) {														if(_aligntopath) {								tmppt = new Number3D();								tmppt.x = atmp[k].x * _transform.sxx + atmp[k].y * _transform.sxy + atmp[k].z * _transform.sxz + _transform.tx;								tmppt.y = atmp[k].x * _transform.syx + atmp[k].y * _transform.syy + atmp[k].z * _transform.syz + _transform.ty;								tmppt.z = atmp[k].x * _transform.szx + atmp[k].y * _transform.szy + atmp[k].z * _transform.szz + _transform.tz;																if(rotate)									tmppt = PathUtils.rotatePoint(tmppt, tweenrot);															tmppt.x +=  aSegPoints[i][j].x;								tmppt.y +=  aSegPoints[i][j].y;								tmppt.z +=  aSegPoints[i][j].z;															} else {																tmppt = new Number3D(atmp[k].x+aSegPoints[i][j].x, atmp[k].y+aSegPoints[i][j].y, atmp[k].z+aSegPoints[i][j].z);							}														aPointlist.push(tmppt );														if(rescale && !_smoothscale){									tmppt.x *= lastscale.x;									tmppt.y *= lastscale.y;									tmppt.z *= lastscale.z;							}													}												if (_scaling != 1) {								for (k = 0; k < aPointlist.length; ++k) {									aPointlist[k].x *= _scaling;									aPointlist[k].y *= _scaling;									aPointlist[k].z *= _scaling;								}						}												aSegresult.push(aPointlist);					}									}				 				if(rescale && _smoothscale){					 					for (i = 0; i < aScales.length; ++i) {										 for (j = 0;j < aSegresult[i].length; ++j) {							aSegresult[i][j].x *= aScales[i].x;							aSegresult[i][j].y *= aScales[i].y;							aSegresult[i][j].z *= aScales[i].z;						 }					}										aScales = null;				}								if(rotate)					aRotates = null;								generate(aSegresult, _coverall, _closepath, _flip);								aSegPoints = null;				varr = null;								if(_recenter) {					applyPosition( (this.minX+this.maxX)*.5,  (this.minY+this.maxY)*.5, (this.minZ+this.maxZ)*.5);				} else {					x =  _path.array[0].v1.x;					y =  _path.array[0].v1.y;					z =  _path.array[0].v1.z;				}				 				type = "PathExtrude";				url = "Extrude";						} else {				trace("PathExtrude error: at least 2 Number3D are required in points. Path definition requires at least 1 object with 3 parameters: {v0:Number3D, va:Number3D ,v1:Number3D}, all properties being Number3D.");			} 		}		 		/**    	 * Defines the resolution beetween each CurveSegments. Default 2, minimum 2.    	 */ 		public function set subdivision(val:int):void		{			_subdivision = (val<2)? 2 :val;		}		public function get subdivision():int		{			return _subdivision;		}		/**    	 * Defines the scaling of the final generated mesh. Not being considered while building the mesh. Default 1.    	 */		public function set scaling(val:Number):void		{			_scaling = val;		}		public function get scaling():Number		{			return _scaling;		}		/**    	 * Defines if the texture should cover entire mesh or per segments. Default true.    	 */		public function set coverall(b:Boolean):void		{			_coverall = b;		}		/**    	 * Defines if the final mesh should have its pivot reset to its center after generation. Default false.    	 */		public function set recenter(b:Boolean):void		{			_recenter = b;		}		public function get recenter():Boolean		{			return _recenter;		}		/**    	 * Defines if the generated faces should be inversed. Default false.    	 */		public function set flip(b:Boolean):void		{			_flip = b;		}		public function get flip():Boolean		{			return _flip;		}		/**    	 * Defines if the last segment should join the first one and close the loop. Default false.    	 */		public function set closepath(b:Boolean):void		{			_closepath = b;		}		public function get closepath():Boolean		{			return _closepath;		}		/**    	 * Defines if the profile point array should be orientated on path or not. Default true. Note that Path object worldaxis property might need to be changed. default = 0,1,0.    	 */		public function set aligntopath(b:Boolean):void		{			_aligntopath = b;		}		public function get aligntopath():Boolean		{			return _aligntopath;		}		/**    	 * Defines if a scale array of number3d is passed if the scaling should be affecting the whole segment or spreaded from previous curvesegmentscale to the next curvesegmentscale. Default true.    	 */		public function set smoothscale(b:Boolean):void		{			_smoothscale = b;		}		public function get smoothscale():Boolean		{			return _smoothscale;		}		 /**    	 * Sets and defines the Path object. See animators.data package. Required.    	 */ 		 public function set path(p:Path):void    	{    		_path = p;    	}		 public function get path():Path    	{    		return _path;    	}		 		/**    	 * Sets and defines the Array of Number3D's (the profile information to be projected according to the Path object). Required.    	 */		 public function set points(aR:Array):void    	{    		_points = aR;    	}		 public function get points():Array    	{    		return _points;    	}		 		/**    	 * Sets and defines the optional Array of Number3D's. A series of scales to be set on each CurveSegments    	 */		 		 public function set scales(aR:Array):void    	{    		_scales = aR;    	}		 public function get scales():Array    	{    		return _scales;    	}				/**    	 * Sets and defines the optional Array of Number3D's. A series of rotations to be set on each CurveSegments    	 */		 		 public function set rotations(aR:Array):void    	{    		_rotations = aR;    	}		 public function get rotations():Array    	{    		return _rotations;    	}		 	}}