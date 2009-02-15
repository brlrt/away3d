package away3d.core.project;

import flash.events.EventDispatcher;
import away3d.sprites.Sprite2D;
import away3d.containers.View3D;
import flash.utils.Dictionary;
import away3d.core.draw.DrawScaledBitmap;
import away3d.core.utils.DrawPrimitiveStore;
import away3d.core.draw.IPrimitiveConsumer;
import away3d.core.draw.ScreenVertex;
import away3d.core.base.Object3D;
import away3d.core.draw.IPrimitiveProvider;
import flash.display.Sprite;
import away3d.core.math.Matrix3D;


class SpriteProjector implements IPrimitiveProvider {
	public var view(getView, setView) : View3D;
	
	private var _view:View3D;
	private var _vertexDictionary:Dictionary;
	private var _drawPrimitiveStore:DrawPrimitiveStore;
	private var _sprite:Sprite2D;
	private var _screenVertex:ScreenVertex;
	private var _drawScaledBitmap:DrawScaledBitmap;
	

	public function getView():View3D {
		
		return _view;
	}

	public function setView(val:View3D):View3D {
		
		_view = val;
		_drawPrimitiveStore = view.drawPrimitiveStore;
		return val;
	}

	public function primitives(source:Object3D, viewTransform:Matrix3D, consumer:IPrimitiveConsumer):Void {
		
		_vertexDictionary = _drawPrimitiveStore.createVertexDictionary(source);
		_sprite = cast(source, Sprite2D);
		_screenVertex = _view.camera.lens.project(viewTransform, _sprite.center);
		if (!_screenVertex.visible) {
			return;
		}
		_screenVertex.z += _sprite.deltaZ;
		consumer.primitive(_drawPrimitiveStore.createDrawScaledBitmap(source, _screenVertex, _sprite.smooth, _sprite.bitmap, _sprite.scaling * _view.camera.zoom / (1 + _screenVertex.z / _view.camera.focus), _sprite.rotation));
	}

	// autogenerated
	public function new () {
		
	}

	

}

