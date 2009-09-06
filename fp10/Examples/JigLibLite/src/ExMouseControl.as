package
{
	import away3dlite.core.geom.Plane3D;
	import away3dlite.lights.Light;
	import away3dlite.materials.WireframeMaterial;
	import away3dlite.materials.shaders.PhongColorMaterial;
	import away3dlite.templates.PhysicsTemplate;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Vector3D;
	
	import jiglib.math.*;
	import jiglib.physics.*;
	import jiglib.physics.constraint.*;
	import jiglib.plugin.away3dlite.Away3DLiteMesh;

	[SWF(backgroundColor="#666666",frameRate="30",quality="MEDIUM",width="800",height="600")]
	/**
	 * Example : Mouse Control
	 * 
 	 * @see http://away3d.googlecode.com/svn/trunk/fp10/Away3DLite/src
	 * @see http://away3d.googlecode.com/svn/branches/JigLibLite/src
	 * 
	 * @author katopz
	 */
	public class ExMouseControl extends PhysicsTemplate
	{
		private var boxBody:Array;

		private var onDraging:Boolean = false;

		private var currDragBody:RigidBody;
		private var dragConstraint:JConstraintWorldPoint;
		private var planeToDragOn:Plane3D;
		
		private var light:Light;

		override protected function build():void
		{
			title += " | Mouse Control | Use mouse to drag red ball | ";

			camera.y = 1000;
			
			light = new Light();
			light.setPosition(Math.random() - 0.5, Math.random() - 0.5, Math.random() - 0.5);
			
			init3D();
			
			stage.addEventListener(MouseEvent.MOUSE_UP, handleMouseRelease);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, handleMouseMove);
		}

		private function init3D():void
		{
			// Layer
			var layer:Sprite = new Sprite();
			view.addChild(layer);
			
			var color:uint;
			for (var i:int = 0; i < 3; i++)
			{
				color = (i == 0) ? 0xff8888 : 0xeeee00;

				var ball:RigidBody;
				if(i==2)
				{
					ball = physics.createSphere(new PhongColorMaterial(light, 0xFF0000), 25);
					
					// draggable
					currDragBody = ball;
					Away3DLiteMesh(ball.skin).mesh.layer = layer;
				}else{
					ball = physics.createSphere(new WireframeMaterial(), 25);
				}
				ball.mass = 5;
				ball.moveTo(new Vector3D(-100, 500 + (100 * i + 100), -100));
			}
			
			boxBody = [];
			for (i = 0; i < 3; i++)
			{
				boxBody[i] = physics.createCube(new WireframeMaterial(0xFFFFFF * Math.random()), 25, 25, 25);
				boxBody[i].moveTo(new Vector3D(500*Math.random()-500*Math.random(), 500+500*Math.random(), 500*Math.random()-500*Math.random()));
			}
			
			layer.addEventListener(MouseEvent.MOUSE_DOWN, handleMousePress);
		}

		private var startMousePos:Vector3D;
		
		private function handleMousePress(event:MouseEvent):void
		{
			onDraging = true;
			var layer:Sprite = event.target as Sprite;
			
			startMousePos = new Vector3D(currDragBody.x, currDragBody.y, currDragBody.z);

			planeToDragOn = new Plane3D();
			planeToDragOn.fromNormalAndPoint(new Vector3D(0, 1, 0), new Vector3D(0, 0, -startMousePos.z));

			var p:Vector3D = currDragBody.currentState.position;
			var bodyPoint:Vector3D = startMousePos.subtract(new Vector3D(p.x, p.y, p.z));

			var a:Vector3D = new Vector3D(bodyPoint.x, bodyPoint.y, bodyPoint.z);
			var b:Vector3D = new Vector3D(startMousePos.x, startMousePos.y, startMousePos.z);
			
			dragConstraint = new JConstraintWorldPoint(currDragBody, a, b);
			physics.engine.addConstraint(dragConstraint);
		}
		
		// TODO:clean up/by pass
		private function handleMouseMove(event:MouseEvent):void
		{
			if (onDraging)
			{
				var ray:Vector3D = view.camera.unproject(view.mouseX, -view.mouseY);
				ray.add(new Vector3D(view.camera.x, view.camera.y, view.camera.z));

				var cameraVector3D:Vector3D = new Vector3D(view.camera.x, view.camera.y, view.camera.z);
				var rayVector3D:Vector3D = new Vector3D(ray.x, ray.y, ray.z);
				var intersectPoint:Vector3D = planeToDragOn.getIntersectionLine(cameraVector3D, rayVector3D);

				dragConstraint.worldPosition = new Vector3D(intersectPoint.x, intersectPoint.y, intersectPoint.z);
			}
		}

		private function handleMouseRelease(event:MouseEvent):void
		{
			if (onDraging)
			{
				onDraging = false;
				physics.engine.removeConstraint(dragConstraint);
				currDragBody.setActive();
			}
		}

		override protected function onPreRender():void
		{
			physics.step();

			camera.lookAt(Away3DLiteMesh(currDragBody.skin).mesh.position, new Vector3D(0, 1, 0));
			//camera.lookAt(Away3DLiteMesh(ground.skin).mesh.transform.matrix3D.position);
		}
		
		override protected function onEnterFrame(event:Event):void
		{
			// BUG : avoid shader bug...
			try{
				super.onEnterFrame(event);
			}catch(e:*){}
		}
	}
}