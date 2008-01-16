package away3d.core.draw
{
    import away3d.core.*;
    import away3d.core.material.*;
    import away3d.core.math.*;
    import away3d.core.mesh.*;
    import away3d.core.render.*;
    import away3d.core.scene.*;
    
    import flash.display.*;
    import flash.geom.Matrix;
    import flash.geom.Rectangle;
    
    /** Triangle drawing primitive */
    public class DrawTriangle extends DrawPrimitive
    {
        use namespace arcane;
        
        public var v0:ScreenVertex;
        public var v1:ScreenVertex;
        public var v2:ScreenVertex;
        public var uv0:UV;
        public var uv1:UV;
        public var uv2:UV;
        public var area:Number;

        public var face:Face;
        
        public var backface:Boolean = false;
        
        public var material:ITriangleMaterial;
        public var bitmapMaterial:BitmapData;
        public var bitmapPhong:BitmapData;
        public var bitmapNormal:BitmapData;
        
        public var bitmapReflection:BitmapData;
        public var bitmapDisplacementX:BitmapData;
        public var bitmapDisplacementY:BitmapData;
        
        public var bitmapRect:Rectangle;
        public var normalRect:Rectangle;
        
        public var invtexturemapping:Matrix;
        public var texturemapping:Matrix;
        
        public override function clear():void
        {
            v0 = null;
            v1 = null;
            v2 = null;
            uv0 = null;
            uv1 = null;
            uv2 = null;
            texturemapping = null;
        }
		
        public override function render():void
        {
            material.renderTriangle(this);
        }
        
        public override function shade():void
        {
            material.shadeTriangle(this);
        }

        public final function maxEdgeSqr():Number
        {
            return Math.max(Math.max(ScreenVertex.distanceSqr(v0, v1),
                                        ScreenVertex.distanceSqr(v1, v2)),
                                        ScreenVertex.distanceSqr(v2, v0));
        }

        public final function minEdgeSqr():Number
        {
            return Math.min(Math.min(ScreenVertex.distanceSqr(v0, v1),
                                        ScreenVertex.distanceSqr(v1, v2)),
                                        ScreenVertex.distanceSqr(v2, v0));
        }

        public final function maxDistortSqr(focus:Number):Number
        {
            return Math.max(Math.max(ScreenVertex.distortSqr(v0, v1, focus),
                                        ScreenVertex.distortSqr(v1, v2, focus)),
                                        ScreenVertex.distortSqr(v2, v0, focus));
        }

        public final function minDistortSqr(focus:Number):Number
        {
            return Math.min(Math.min(ScreenVertex.distortSqr(v0, v1, focus),
                                        ScreenVertex.distortSqr(v1, v2, focus)),
                                        ScreenVertex.distortSqr(v2, v0, focus));
        }
        
		internal var d01:Number;
        internal var d12:Number;
        internal var d20:Number;
        internal var dd01:Number;
        internal var dd12:Number;
        internal var dd20:Number;
                
        public final function acuteAngled():Boolean
        {
            d01 = ScreenVertex.distanceSqr(v0, v1);
            d12 = ScreenVertex.distanceSqr(v1, v2);
            d20 = ScreenVertex.distanceSqr(v2, v0);
            dd01 = d01 * d01;
            dd12 = d12 * d12;
            dd20 = d20 * d20;
            
            return (dd01 <= dd12 + dd20) && (dd12 <= dd20 + dd01) && (dd20 <= dd01 + dd12);
        }
        
        internal var materialWidth:Number;
        internal var materialHeight:Number;
        
        internal var n0:Number3D;
        internal var n1:Number3D;
        internal var n2:Number3D;
        
        internal var _u0:Number;
        internal var _u1:Number;
        internal var _u2:Number;
        internal var _v0:Number;
        internal var _v1:Number;
        internal var _v2:Number;
        
        internal var transformMaterial:IUVTransformMaterial;
        internal var t:Matrix;
        
        public final function transformUV(material:IUVMaterial):Matrix
        {
        	if (material is IUVTransformMaterial && (transformMaterial = (material as IUVTransformMaterial)).projectionVector) {
        		if (backface) {
		    		n0 = new Number3D(face.v0.x, face.v0.y, face.v0.z);
		    		n2 = new Number3D(face.v1.x, face.v1.y, face.v1.z);        			
		    		n1 = new Number3D(face.v2.x, face.v2.y, face.v2.z);
        		} else {
		    		n0 = new Number3D(face.v0.x, face.v0.y, face.v0.z);
		    		n1 = new Number3D(face.v1.x, face.v1.y, face.v1.z);
		    		n2 = new Number3D(face.v2.x, face.v2.y, face.v2.z);
        		}
        		_u0 = Number3D.dot(n0, transformMaterial.N);
	            _u1 = Number3D.dot(n1, transformMaterial.N);
	            _u2 = Number3D.dot(n2, transformMaterial.N);
	            _v0 = -Number3D.dot(n0, transformMaterial.M);
	            _v1 = -Number3D.dot(n1, transformMaterial.M);
	            _v2 = -Number3D.dot(n2, transformMaterial.M);
	            
        	} else {	
	            materialWidth = material.width,
	            materialHeight = material.height;
	            
	            if (uv0 == null)
	                return new Matrix();
	            if (uv1 == null)
	                return new Matrix();
	            if (uv2 == null)
	                return new Matrix();
	
	            _u0 = materialWidth * uv0._u,
	            _u1 = materialWidth * uv1._u,
	            _u2 = materialWidth * uv2._u,
	            _v0 = materialHeight * (1 - uv0._v),
	            _v1 = materialHeight * (1 - uv1._v),
	            _v2 = materialHeight * (1 - uv2._v);
        	}
      
            // Fix perpendicular projections
            if ((_u0 == _u1 && _v0 == _v1) || (_u0 == _u2 && _v0 == _v2))
            {
                _u0 -= (_u0 > 0.05) ? 0.05 : -0.05;
                _v0 -= (_v0 > 0.07) ? 0.07 : -0.07;
            }
    
            if (_u2 == _u1 && _v2 == _v1)
            {
                _u2 -= (_u2 > 0.05) ? 0.04 : -0.04;
                _v2 -= (_v2 > 0.06) ? 0.06 : -0.06;
            }
            
            if (material is IUVMaterialContainer)
            {
            	bitmapRect = new Rectangle(int(materialWidth*face.minU), int(materialHeight*(1 - face.maxV)), int(materialWidth*(face.maxU-face.minU)+2), int(materialHeight*(face.maxV-face.minV)+2));
            	return new Matrix(_u1 - _u0, _v1 - _v0, _u2 - _u0, _v2 - _v0, _u0 - bitmapRect.x, _v0 - bitmapRect.y);
            }
            
            t = new Matrix(_u1 - _u0, _v1 - _v0, _u2 - _u0, _v2 - _v0, _u0, _v0);
            t.invert();
            return t;
        }
        
        internal var focus:Number;
        
        internal var ax:Number;
        internal var ay:Number;
        internal var az:Number;
        internal var bx:Number;
        internal var by:Number;
        internal var bz:Number;
        internal var cx:Number;
        internal var cy:Number;
        internal var cz:Number;
        
        internal var azf:Number;
        internal var bzf:Number;
        internal var czf:Number;

        internal var faz:Number;
        internal var fbz:Number;
        internal var fcz:Number;

        internal var axf:Number;
        internal var bxf:Number;
        internal var cxf:Number;
        internal var ayf:Number;
        internal var byf:Number;
        internal var cyf:Number;

        internal var det:Number;
        internal var da:Number;
        internal var db:Number;
        internal var dc:Number;
                
        public override final function getZ(x:Number, y:Number):Number
        {
            if (projection == null)
                return screenZ;

            focus = projection.focus;

            ax = v0.x;
            ay = v0.y;
            az = v0.z;
            bx = v1.x;
            by = v1.y;
            bz = v1.z;
            cx = v2.x;
            cy = v2.y;
            cz = v2.z;

            if ((ax == x) && (ay == y))
                return az;

            if ((bx == x) && (by == y))
                return bz;

            if ((cx == x) && (cy == y))
                return cz;

            azf = az / focus;
            bzf = bz / focus;
            czf = cz / focus;

            faz = 1 + azf;
            fbz = 1 + bzf;
            fcz = 1 + czf;

            axf = ax*faz - x*azf;
            bxf = bx*fbz - x*bzf;
            cxf = cx*fcz - x*czf;
            ayf = ay*faz - y*azf;
            byf = by*fbz - y*bzf;
            cyf = cy*fcz - y*czf;

            det = axf*(byf - cyf) + bxf*(cyf - ayf) + cxf*(ayf - byf);
            da = x*(byf - cyf) + bxf*(cyf - y) + cxf*(y - byf);
            db = axf*(y - cyf) + x*(cyf - ayf) + cxf*(ayf - y);
            dc = axf*(byf - y) + bxf*(y - ayf) + x*(ayf - byf);

            return (da*az + db*bz + dc*cz) / det;
        }
		
		internal var au:Number;
        internal var av:Number;
        internal var bu:Number;
        internal var bv:Number;
        internal var cu:Number;
        internal var cv:Number;
        
        public function getUV(x:Number, y:Number):UV
        {
            if (uv0 == null)
                return null;

            if (uv1 == null)
                return null;

            if (uv2 == null)
                return null;

            au = uv0._u;
            av = uv0._v;
            bu = uv1._u;
            bv = uv1._v;
            cu = uv2._u;
            cv = uv2._v;

            focus = projection.focus;

            ax = v0.x;
            ay = v0.y;
            az = v0.z;
            bx = v1.x;
            by = v1.y;
            bz = v1.z;
            cx = v2.x;
            cy = v2.y;
            cz = v2.z;

            if ((ax == x) && (ay == y))
                return uv0;

            if ((bx == x) && (by == y))
                return uv1;

            if ((cx == x) && (cy == y))
                return uv2;

            azf = az / focus;
            bzf = bz / focus;
            czf = cz / focus;

            faz = 1 + azf;
            fbz = 1 + bzf;
            fcz = 1 + czf;
                                
            axf = ax*faz - x*azf;
            bxf = bx*fbz - x*bzf;
            cxf = cx*fcz - x*czf;
            ayf = ay*faz - y*azf;
            byf = by*fbz - y*bzf;
            cyf = cy*fcz - y*czf;

            det = axf*(byf - cyf) + bxf*(cyf - ayf) + cxf*(ayf - byf);
            da = x*(byf - cyf) + bxf*(cyf - y) + cxf*(y- byf);
            db = axf*(y - cyf) + x*(cyf - ayf) + cxf*(ayf - y);
            dc = axf*(byf - y) + bxf*(y - ayf) + x*(ayf - byf);

            return new UV((da*au + db*bu + dc*cu) / det, (da*av + db*bv + dc*cv) / det);
        }

        public function fivepointcut(v0:ScreenVertex, v01:ScreenVertex, v1:ScreenVertex, v12:ScreenVertex, v2:ScreenVertex, uv0:UV, uv01:UV, uv1:UV, uv12:UV, uv2:UV):Array
        {
            if (ScreenVertex.distanceSqr(v0, v12) < ScreenVertex.distanceSqr(v01, v2))
            {
                return [
                    create(material, projection,  v0, v01, v12,  uv0, uv01, uv12),
                    create(material, projection, v01,  v1, v12, uv01,  uv1, uv12),
                    create(material, projection,  v0, v12 , v2,  uv0, uv12, uv2)];
            }
            else
            {
                return [
                    create(material, projection,   v0, v01,  v2,  uv0, uv01, uv2),
                    create(material, projection,  v01,  v1, v12, uv01,  uv1, uv12),
                    create(material, projection,  v01, v12,  v2, uv01, uv12, uv2)];
            }
        }
        
        public final function bisect(focus:Number):Array
        {
            var d01:Number = ScreenVertex.distanceSqr(v0, v1),
                d12:Number = ScreenVertex.distanceSqr(v1, v2),
                d20:Number = ScreenVertex.distanceSqr(v2, v0);

            if ((d12 >= d01) && (d12 >= d20))
                return bisect12(focus);
            else
            if (d01 >= d20)
                return bisect01(focus);
            else
                return bisect20(focus);
        }

        public final function distortbisect(focus:Number):Array
        {
            var d01:Number = ScreenVertex.distortSqr(v0, v1, focus),
                d12:Number = ScreenVertex.distortSqr(v1, v2, focus),
                d20:Number = ScreenVertex.distortSqr(v2, v0, focus);

            if ((d12 >= d01) && (d12 >= d20))
                return bisect12(focus);
            else
            if (d01 >= d20)
                return bisect01(focus);
            else
                return bisect20(focus);
        }

        private final function bisect01(focus:Number):Array
        {
            var v01:ScreenVertex = ScreenVertex.median(v0, v1, focus),
                uv01:UV = UV.median(uv0, uv1);
            return [
                create(material, projection, v2, v0, v01, uv2, uv0, uv01),
                create(material, projection, v01, v1, v2, uv01, uv1, uv2) 
            ];
        }

        private final function bisect12(focus:Number):Array
        {
            var v12:ScreenVertex = ScreenVertex.median(v1, v2, focus),
                uv12:UV = UV.median(uv1, uv2);
            return [
                create(material, projection, v0, v1, v12, uv0, uv1, uv12),
                create(material, projection, v12, v2, v0, uv12, uv2, uv0) 
            ];
        }

        private final function bisect20(focus:Number):Array
        {
            var v20:ScreenVertex = ScreenVertex.median(v2, v0, focus),
                uv20:UV = UV.median(uv2, uv0);
            return [
                create(material, projection, v1, v2, v20, uv1, uv2, uv20),
                create(material, projection, v20, v0, v1, uv20, uv0, uv1) 
            ];                                                
        }
        
        internal var v01:ScreenVertex;
        internal var v12:ScreenVertex;
        internal var v20:ScreenVertex;
        internal var uv01:UV;
        internal var uv12:UV;
        internal var uv20:UV;
        
        public override final function quarter(focus:Number):Array
        {
            if (area < 20)
                return null;

            v01 = ScreenVertex.median(v0, v1, focus);
            v12 = ScreenVertex.median(v1, v2, focus);
            v20 = ScreenVertex.median(v2, v0, focus);
            uv01 = UV.median(uv0, uv1);
            uv12 = UV.median(uv1, uv2);
            uv20 = UV.median(uv2, uv0);

            return [
                create(material, projection, v0, v01, v20, uv0, uv01, uv20),
                create(material, projection, v1, v12, v01, uv1, uv12, uv01),
                create(material, projection, v2, v20, v12, uv2, uv20, uv12),
                create(material, projection, v01, v12, v20, uv01, uv12, uv20)
            ];
        }

        public override final function contains(x:Number, y:Number):Boolean
        {   
            if (v0.x*(y - v1.y) + v1.x*(v0.y - y) + x*(v1.y - v0.y) < -0.001)
                return false;

            if (v0.x*(v2.y - y) + x*(v0.y - v2.y) + v2.x*(y - v0.y) < -0.001)
                return false;

            if (x*(v2.y - v1.y) + v1.x*(y - v2.y) + v2.x*(v1.y - y) < -0.001)
                return false;

            return true;
        }

        public final function distanceToCenter(x:Number, y:Number):Number
        {   
            var centerx:Number = (v0.x + v1.x + v2.x) / 3,
                centery:Number = (v0.y + v1.y + v2.y) / 3;

            return Math.sqrt((centerx-x)*(centerx-x) + (centery-y)*(centery-y));
        }

        public function calc():void
        {
        	if (v0.x > v1.x) {
                if (v0.x > v2.x) maxX = v0.x;
                else maxX = v2.x;
            } else {
                if (v1.x > v2.x) maxX = v1.x;
                else maxX = v2.x;
            }
            
            if (v0.x < v1.x) {
                if (v0.x < v2.x) minX = v0.x;
                else minX = v2.x;
            } else {
                if (v1.x < v2.x) minX = v1.x;
                else minX = v2.x;
            }
            
            if (v0.y > v1.y) {
                if (v0.y > v2.y) maxY = v0.y;
                else maxY = v2.y;
            } else {
                if (v1.y > v2.y) maxY = v1.y;
                else maxY = v2.y;
            }
            
            if (v0.y < v1.y) {
                if (v0.y < v2.y) minY = v0.y;
                else minY = v2.y;
            } else {
                if (v1.y < v2.y) minY = v1.y;
                else minY = v2.y;
            }
            
            if (v0.z > v1.z) {
                if (v0.z > v2.z) maxZ = v0.z;
                else maxZ = v2.z;
            } else {
                if (v1.z > v2.z) maxZ = v1.z;
                else maxZ = v2.z;
            }
            
            if (v0.z < v1.z) {
                if (v0.z < v2.z) minZ = v0.z;
                else minZ = v2.z;
            } else {
                if (v1.z < v2.z) minZ = v1.z;
                else minZ = v2.z;
            }
            
            screenZ = (v0.z + v1.z + v2.z) / 3;
            area = 0.5 * (v0.x*(v2.y - v1.y) + v1.x*(v0.y - v2.y) + v2.x*(v1.y - v0.y));
        }
        
        
        public override function toString():String
        {
            var color:String = "";
            if (material is WireColorMaterial)
            {
                switch ((material as WireColorMaterial).color)
                {
                    case 0x00FF00: color = "green"; break;
                    case 0xFFFF00: color = "yellow"; break;
                    case 0xFF0000: color = "red"; break;
                    case 0x0000FF: color = "blue"; break;
                }
            }
            return "T{"+color+int(area)+" screenZ = " + num(screenZ) + ", minZ = " + num(minZ) + ", maxZ = " + num(maxZ) + " }";
        }

        private static function num(n:Number):Number
        {
            return int(n*1000)/1000;
        }

    }
}
