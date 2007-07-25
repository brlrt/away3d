package away3d.core.mesh
{
    import away3d.core.*;
    import away3d.core.material.*;
    import away3d.core.math.*;
    import away3d.core.mesh.*;
    import away3d.core.draw.*;
    import away3d.core.utils.*;
    
    import flash.geom.Matrix;
    import flash.events.Event;

    /** Mesh's triangle face */
    public class Face extends BaseMeshElement
    {
        use namespace arcane;

        public var extra:Object;

        arcane var _v0:Vertex;
        arcane var _v1:Vertex;
        arcane var _v2:Vertex;
        arcane var _uv0:UV;
        arcane var _uv1:UV;
        arcane var _uv2:UV;
        arcane var _material:ITriangleMaterial;
        arcane var _texturemapping:Matrix;
        private var _normal:Number3D;

        public override function get vertices():Array
        {
            return [_v0, _v1, _v2];
        }

        public function get v0():Vertex
        {
            return _v0;
        }

        public function set v0(value:Vertex):void
        {
            if (value == _v0)
                return;

            if (_v0 != null)
                if ((_v0 != _v1) && (_v0 != _v2))
                    _v0.removeOnChange(onVertexValueChange);

            _v0 = value;

            if (_v0 != null)
                if ((_v0 != _v1) && (_v0 != _v2))
                    _v0.addOnChange(onVertexValueChange);

            notifyVertexChange();
        }

        public function get v1():Vertex
        {
            return _v1;
        }

        public function set v1(value:Vertex):void
        {
            if (value == _v1)
                return;

            if (_v1 != null)
                if ((_v1 != _v0) && (_v1 != _v2))
                    _v1.removeOnChange(onVertexValueChange);

            _v1 = value;

            if (_v1 != null)
                if ((_v1 != _v0) && (_v1 != _v2))
                    _v1.addOnChange(onVertexValueChange);

            notifyVertexChange();
        }

        public function get v2():Vertex
        {
            return _v2;
        }

        public function set v2(value:Vertex):void
        {
            if (value == _v2)
                return;

            if (_v2 != null)
                if ((_v2 != _v1) && (_v2 != _v0))
                    _v2.removeOnChange(onVertexValueChange);

            _v2 = value;

            if (_v2 != null)
                if ((_v2 != _v1) && (_v2 != _v0))
                    _v2.addOnChange(onVertexValueChange);

            notifyVertexChange();
        }

        public function get material():ITriangleMaterial
        {
            return _material;
        }

        public function set material(value:ITriangleMaterial):void
        {
            if (value == _material)
                return;

            _material = value;

            _texturemapping = null;

            notifyMaterialChange();
        }

        public function get uv0():UV
        {
            _texturemapping = null;

            return _uv0;
        }

        public function set uv0(value:UV):void
        {
            if (value == _uv0)
                return;

            if (_uv0 != null)
                if ((_uv0 != _uv1) && (_uv0 != _uv2))
                    _uv0.removeOnChange(onUVChange);

            _uv0 = value;

            if (_uv0 != null)
                if ((_uv0 != _uv1) && (_uv0 != _uv2))
                    _uv0.addOnChange(onUVChange);

            _texturemapping = null;

            notifyMappingChange();
        }

        public function get uv1():UV
        {
            return _uv1;
        }

        public function set uv1(value:UV):void
        {
            if (value == _uv1)
                return;

            if (_uv1 != null)
                if ((_uv1 != _uv0) && (_uv1 != _uv2))
                    _uv1.removeOnChange(onUVChange);

            _uv1 = value;

            if (_uv1 != null)
                if ((_uv1 != _uv0) && (_uv1 != _uv2))
                    _uv1.addOnChange(onUVChange);

            _texturemapping = null;

            notifyMappingChange();
        }

        public function get uv2():UV
        {
            return _uv2;
        }

        public function set uv2(value:UV):void
        {
            if (value == _uv2)
                return;

            if (_uv2 != null)
                if ((_uv2 != _uv1) && (_uv2 != _uv0))
                    _uv2.removeOnChange(onUVChange);

            _uv2 = value;

            if (_uv2 != null)
                if ((_uv2 != _uv1) && (_uv2 != _uv0))
                    _uv2.addOnChange(onUVChange);

            _texturemapping = null;

            notifyMappingChange();
        }

        public function get area():Number
        {
            // not quick enough
            var a:Number = Number3D.distance(v0.position, v1.position);
            var b:Number = Number3D.distance(v1.position, v2.position);
            var c:Number = Number3D.distance(v2.position, v0.position);
            var s:Number = (a + b + c) / 2;
            return Math.sqrt(s*(s - a)*(s - b)*(s - c));
        }

        public function get normal():Number3D
        {
            if (_normal == null)
            {
                var d1x:Number = _v1.x - _v0.x;
                var d1y:Number = _v1.y - _v0.y;
                var d1z:Number = _v1.z - _v0.z;
            
                var d2x:Number = _v2.x - _v0.x;
                var d2y:Number = _v2.y - _v0.y;
                var d2z:Number = _v2.z - _v0.z;
            
                var pa:Number = d1y*d2z - d1z*d2y;
                var pb:Number = d1z*d2x - d1x*d2z;
                var pc:Number = d1x*d2y - d1y*d2x;

                var pdd:Number = Math.sqrt(pa*pa + pb*pb + pc*pc);

                _normal = new Number3D(pa / pdd, pb / pdd, pc / pdd);
            }
            return _normal;
        }

        public override function get radius2():Number
        {
            var rv0:Number = _v0._x*_v0._x + _v0._y*_v0._y + _v0._z*_v0._z;
            var rv1:Number = _v1._x*_v1._x + _v1._y*_v1._y + _v1._z*_v1._z;
            var rv2:Number = _v2._x*_v2._x + _v2._y*_v2._y + _v2._z*_v2._z;

            if (rv0 > rv1)
            {
                if (rv0 > rv2)
                    return rv0;
                else
                    return rv2;
            }
            else
            {
                if (rv1 > rv2)
                    return rv1;
                else        
                    return rv2;
            }
        }

        public override function get maxX():Number
        {
            if (_v0._x > _v1._x)
            {
                if (_v0._x > _v2._x)
                    return _v0._x;
                else
                    return _v2._x;
            }
            else
            {
                if (_v1._x > _v2._x)
                    return _v1._x;
                else
                    return _v2._x;
            }
        }
        
        public override function get minX():Number
        {
            if (_v0._x < _v1._x)
            {
                if (_v0._x < _v2._x)
                    return _v0._x;
                else
                    return _v2._x;
            }
            else
            {
                if (_v1._x < _v2._x)
                    return _v1._x;
                else
                    return _v2._x;
            }
        }
        
        public override function get maxY():Number
        {
            if (_v0._y > _v1._y)
            {
                if (_v0._y > _v2._y)
                    return _v0._y;
                else
                    return _v2._y;
            }
            else
            {
                if (_v1._y > _v2._y)
                    return _v1._y;
                else
                    return _v2._y;
            }
        }
        
        public override function get minY():Number
        {
            if (_v0._y < _v1._y)
            {
                if (_v0._y < _v2._y)
                    return _v0._y;
                else
                    return _v2._y;
            }
            else
            {
                if (_v1._y < _v2._y)
                    return _v1._y;
                else
                    return _v2._y;
            }
        }
        
        public override function get maxZ():Number
        {
            if (_v0._z > _v1._z)
            {
                if (_v0._z > _v2._z)
                    return _v0._z;
                else
                    return _v2._z;
            }
            else
            {
                if (_v1._z > _v2._z)
                    return _v1._z;
                else
                    return _v2._z;
            }
        }
        
        public override function get minZ():Number
        {
            if (_v0._z < _v1._z)
            {
                if (_v0._z < _v2._z)
                    return _v0._z;
                else
                    return _v2._z;
            }
            else
            {
                if (_v1._z < _v2._z)
                    return _v1._z;
                else
                    return _v2._z;
            }
        }

        arcane function get mapping():Matrix
        {
            if (_texturemapping != null)
                return _texturemapping;

            if (_material == null)
                return null;

            if (!(_material is IUVMaterial))
                return null;

            var uvm:IUVMaterial = _material as IUVMaterial;
            var width:Number = uvm.width;
            var height:Number = uvm.height;

            if (uv0 == null)
            {
                _texturemapping = new Matrix();
                return _texturemapping;
            }
            if (uv1 == null)
            {
                _texturemapping = new Matrix();
                return _texturemapping;
            }
            if (uv2 == null)
            {
                _texturemapping = new Matrix();
                return _texturemapping;
            }

            var u0:Number = width * uv0._u;
            var u1:Number = width * uv1._u;
            var u2:Number = width * uv2._u;
            var v0:Number = height * (1 - uv0._v);
            var v1:Number = height * (1 - uv1._v);
            var v2:Number = height * (1 - uv2._v);
      
            // Fix perpendicular projections
            if ((u0 == u1 && v0 == v1) || (u0 == u2 && v0 == v2))
            {
                u0 -= (u0 > 0.05) ? 0.05 : -0.05;
                v0 -= (v0 > 0.07) ? 0.07 : -0.07;
            }
    
            if (u2 == u1 && v2 == v1)
            {
                u2 -= (u2 > 0.05) ? 0.04 : -0.04;
                v2 -= (v2 > 0.06) ? 0.06 : -0.06;
            }
  
            _texturemapping = new Matrix(u1 - u0, v1 - v0, u2 - u0, v2 - v0, u0, v0);
            _texturemapping.invert();
            return _texturemapping;
        }

        public function Face(v0:Vertex, v1:Vertex, v2:Vertex, material:ITriangleMaterial = null, uv0:UV = null, uv1:UV = null, uv2:UV = null)
        {
            this.v0 = v0;
            this.v1 = v1;
            this.v2 = v2;
            this.material = material;
            this.uv0 = uv0;
            this.uv1 = uv1;
            this.uv2 = uv2;
        }

        private function onVertexChange(event:Event):void
        {
            _normal = null;
            notifyVertexChange();
        }

        private function onVertexValueChange(event:Event):void
        {
            _normal = null;
            notifyVertexValueChange();
        }

        private function onUVChange(event:Event):void
        {
            _texturemapping = null;
            notifyMappingChange();
        }

        public function addOnMappingChange(listener:Function):void
        {
            addEventListener("mappingchanged", listener, false, 0, true);
        }
        public function removeOnMappingChange(listener:Function):void
        {
            removeEventListener("mappingchanged", listener, false);
        }
        private var mappingchanged:FaceEvent;
        protected function notifyMappingChange():void
        {
            if (!hasEventListener("mappingchanged"))
                return;

            if (mappingchanged == null)
                mappingchanged = new FaceEvent("mappingchanged", this);
                
            dispatchEvent(mappingchanged);
        }

        public function addOnMaterialChange(listener:Function):void
        {
            addEventListener("materialchanged", listener, false, 0, true);
        }
        public function removeOnMaterialChange(listener:Function):void
        {
            removeEventListener("materialchanged", listener, false);
        }
        private var materialchanged:FaceEvent;
        protected function notifyMaterialChange():void
        {
            if (!hasEventListener("materialchanged"))
                return;

            if (materialchanged == null)
                materialchanged = new FaceEvent("materialchanged", this);
                
            dispatchEvent(materialchanged);
        }

    }
}
