package awaybuilder.parsers{	import awaybuilder.abstracts.AbstractParser;	import awaybuilder.interfaces.IValueObject;	import awaybuilder.utils.ConvertCoordinates;	import awaybuilder.vo.DynamicAttributeVO;	import awaybuilder.vo.SceneCameraVO;	import awaybuilder.vo.SceneGeometryVO;	import awaybuilder.vo.SceneObjectVO;	import awaybuilder.vo.SceneSectionVO;		import flash.events.Event;				public class Cinema4DParser extends AbstractParser	{		protected static const V6_BASEDOCUMENT : String = "v6_basedocument" ;		protected static const V6_ROOT_OBJECT : String = "v6_root_object" ;		protected static const V6_ROOTLIST2D : String = "v6_rootlist2d" ;		protected static const OBJ_PLUGINOBJECT : String = "obj_pluginobject" ;		protected static const V6_BASELIST2D : String = "v6_baselist2d" ;		protected static const STRING : String = "string" ;		protected static const V6_BASEOBJECT : String = "v6_baseobject" ;		protected static const CONTAINER : String = "container" ;		protected static const CONTAINER_VALUES : uint = 0 ;		protected static const CONTAINER_KEYS : uint = 1 ;		protected static const DATA : String = "data" ;		protected static const VECTOR_POSITION : uint = 0 ;		protected static const VECTOR_SCALE : uint = 1 ;		protected static const VECTOR_ROTATION : uint = 2 ;		protected static const GROUP_CAMERAS : String = "cameras" ;		protected static const GROUP_GEOMETRY : String = "geometry" ;		protected static const GROUP_SECTIONS : String = "sections" ;		protected static const PREFIX_CAMERA : String = "camera" ;		protected static const PREFIX_GEOMETRY : String = "geometry" ;		protected static const PREFIX_MATERIAL : String = "material" ;				protected var mainSections : Array = [ ] ;		protected var allSections : Array = [ ] ;		protected var allCameras : Array = [ ] ;		protected var allGeometry : Array = [ ] ;								public function Cinema4DParser ( )		{			super ( ) ;		}								////////////////////////////////////////////////////////////////////////////////		//		// Public Methods		//		////////////////////////////////////////////////////////////////////////////////								override public function parse ( data : * ) : void		{			var xml : XML = new XML ( data ) ;						this.extractMainSections ( xml ) ;			this._sections = this.mainSections ;			this.dispatchEvent ( new Event( Event.COMPLETE ) ) ;		}								////////////////////////////////////////////////////////////////////////////////		//		// Protected Methods		//		////////////////////////////////////////////////////////////////////////////////								protected function extractMainSections ( xml : XML ) : void		{			var list : XMLList = xml[ V6_BASEDOCUMENT ][ V6_ROOT_OBJECT ][ V6_ROOTLIST2D ][ OBJ_PLUGINOBJECT ] ;						for each ( var node : XML in list )			{				var name : String = node[ V6_BASELIST2D ][ STRING ].@v ;				var children : XMLList = node[ V6_ROOTLIST2D ][ OBJ_PLUGINOBJECT ] ;				var vo : SceneSectionVO = new SceneSectionVO ( ) ;								vo.id = name ;				vo.name = name ;				vo.values = this.extractPivot ( node[ V6_BASEOBJECT ].children ( ) ) ;				this.extractGroups ( vo , children ) ;				this.mainSections.push ( vo ) ;				this.sections.push ( vo ) ;			}		}								protected function extractSections ( list : XMLList ) : Array		{			var sections : Array = [ ] ;						for each ( var node : XML in list )			{				var name : String = node[ V6_BASELIST2D ][ STRING ].@v ;				var children : XMLList = node[ V6_ROOTLIST2D ][ OBJ_PLUGINOBJECT ] ;				var vo : SceneSectionVO = new SceneSectionVO ( ) ;								vo.id = name ;				vo.name = name ;				vo.values = this.extractPivot ( node[ V6_BASEOBJECT ].children ( ) ) ;				this.extractGroups ( vo , children ) ;				sections.push ( vo ) ;				this.allSections.push ( vo ) ;			}						return sections ;		}								protected function extractPivot ( list : XMLList ) : SceneObjectVO		{			var positions : Array = this.extractValues ( VECTOR_POSITION , list[ VECTOR_POSITION ] ) ;			var scales : Array = this.extractValues ( VECTOR_SCALE , list[ VECTOR_SCALE ] ) ;			var rotations : Array = this.extractValues ( VECTOR_ROTATION , list[ VECTOR_ROTATION ] ) ;			var pivot : SceneObjectVO = new SceneObjectVO ( ) ;						this.applyPosition ( pivot , positions ) ;			this.applyRotation ( pivot , rotations ) ;			this.applyScale ( pivot , scales ) ;			return pivot ;		}								protected function extractGroups ( section : SceneSectionVO , list : XMLList ) : void		{			for each ( var node : XML in list )			{				var name : String = node[ V6_BASELIST2D ][ STRING ].@v ;				var children : XMLList = node[ V6_ROOTLIST2D ].children ( ) ;								switch ( name )				{					case GROUP_CAMERAS :					{						section.cameras = this.extractCameras ( children ) ;						break ;					}					case GROUP_GEOMETRY :					{						section.geometry = this.extractGeometry ( children ) ;						break ;					}					case GROUP_SECTIONS :					{						section.sections = this.extractSections ( children ) ;						break ;					}				}			}		}								protected function extractCameras ( list : XMLList ) : Array		{			var objects : Array = [ ] ;						for each ( var node : XML in list )			{				var name : String = node[ V6_BASELIST2D ][ STRING ].@v ;				var vo : SceneCameraVO = new SceneCameraVO ( ) ;				var containers : XMLList = node[ V6_BASELIST2D ][ CONTAINER ] ;								vo.id = name ;				vo.name = name ;				vo.values = this.extractPivot ( node[ V6_BASEOBJECT ].children ( ) ) ;				if ( containers.length ( ) > 1 ) this.extractAttributes ( vo , containers ) ;				objects.push ( vo ) ;				this.allCameras.push ( vo ) ;			}						return objects ;		}								protected function extractGeometry ( list : XMLList ) : Array		{			var objects : Array = [ ] ;						for each ( var node : XML in list )			{				var name : String = node[ V6_BASELIST2D ][ STRING ].@v ;				var vo : SceneGeometryVO = new SceneGeometryVO ( ) ;				var containers : XMLList = node[ V6_BASELIST2D ][ CONTAINER ] ;								vo.id = name ;				vo.name = name ;				vo.values = this.extractPivot ( node[ V6_BASEOBJECT ].children ( ) ) ;				if ( containers.length ( ) > 1 ) this.extractAttributes ( vo , containers ) ;				objects.push ( vo ) ;				this.allGeometry.push( vo ) ;			}						return objects ;		}								protected function extractAttributes ( vo : IValueObject , containers : XMLList ) : void		{						var values : Array = [ ] ;			var keys : Array = [ ] ;						for each ( var valueData : XML in containers[ CONTAINER_VALUES ][ DATA ][ CONTAINER ][ DATA ].children ( ) )			{				values.push ( valueData.@v ) ;			}						for each ( var keyContainer : XML in containers[ CONTAINER_KEYS ][ DATA ].children ( ) )			{				for each ( var keyData : XML in keyContainer.children ( ) )				{					if ( keyData.childIndex ( ) == 0 )					{						keys.push ( keyData.children ( ).@v ) ;						break ;					}				}			}						for ( var i : uint ; i < keys.length ; i ++ )			{				var attribute : DynamicAttributeVO = new DynamicAttributeVO ( ) ;				var name : String = keys[ i ] ;				var pair : Array = name.split ( "_" ) ;				var prefix : String = pair[ 0 ] ;				var key : String = pair[ 1 ] ;								attribute.key = key ;				attribute.value = values[ i ] ;								switch ( prefix )				{					case PREFIX_CAMERA :					{						( vo as SceneCameraVO ).extras.push ( attribute ) ;						break ;					}					case PREFIX_GEOMETRY :					{						( vo as SceneGeometryVO ).geometryExtras.push ( attribute ) ;						break ;					}					case PREFIX_MATERIAL :					{						( vo as SceneGeometryVO ).materialExtras.push ( attribute ) ;						break ;					}				}			}		}								protected function extractValues ( type : uint , xml : XML ) : Array		{			var x : Number = Number ( xml.@x ) ;			var y : Number = Number ( xml.@y ) ;			var z : Number = Number ( xml.@z ) ;			var values : Array ;						switch ( type )			{				case VECTOR_ROTATION :				{					var radX : Number = ConvertCoordinates.radToDeg ( x ) ;					var radY : Number = ConvertCoordinates.radToDeg ( y ) ;					var radZ : Number = ConvertCoordinates.radToDeg ( z ) ;										values = [ radY , radX , radZ ] ;					break ;				}				default :				{					values = [ x , y , z ] ;					break ;				}			}						return values ;		}								protected function applyPosition ( target : SceneObjectVO , values : Array ) : void		{			target.x = values[ 0 ] ;			target.y = values[ 1 ] ;			target.z = values[ 2 ] ;		}								protected function applyScale ( target : SceneObjectVO , values : Array ) : void		{			target.scaleX = values[ 0 ] ;			target.scaleY = values[ 1 ] ;			target.scaleZ = values[ 2 ] ;		}								protected function applyRotation ( target : SceneObjectVO , values : Array ) : void		{			target.rotationX = values[ 0 ] ;			target.rotationY = values[ 1 ] ;			target.rotationZ = values[ 2 ] ;		}	}}