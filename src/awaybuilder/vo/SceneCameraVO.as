package awaybuilder.vo
{	import away3d.containers.ObjectContainer3D;	
	import away3d.cameras.Camera3D;
	
	
	
	/**	 * @author andreasengstrom	 */	public class SceneCameraVO
	{		public var id : String = "" ;
		public var name : String = "" ;
		public var camera : Camera3D ;
		public var values : SceneObjectVO ;
		public var extras : Array ;
		public var transitionTime : Number = 2 ;
		public var transitionType : String = "easeInOutCubic" ;
		public var parentSection : SceneSectionVO ;
		public var positionContainer : ObjectContainer3D ;
		
		
		
		public function SceneCameraVO ( )
		{
			this.camera = new Camera3D ( ) ;
			this.extras = new Array ( ) ;
		}
	}}