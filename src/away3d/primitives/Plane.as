﻿package away3d.primitives
{
    import away3d.core.*;
    import away3d.core.base.*;
    import away3d.core.math.*;
    import away3d.core.stats.*;
    import away3d.core.utils.*;
    import away3d.materials.*;
    
    /** Plane */ 
    public class Plane extends Mesh
    {
        public function Plane(init:Object = null)
        {
            super(init);

            var width:Number = ini.getNumber("width", 0, {min:0});
            var height:Number = ini.getNumber("height", 0, {min:0});
            var segments:int = ini.getInt("segments", 1, {min:1});
            var segmentsW:int = ini.getInt("segmentsW", segments, {min:1});
            var segmentsH:int = ini.getInt("segmentsH", segments, {min:1});
            var yUp:Boolean = ini.getBoolean("yUp", true);

            if (width*height == 0)
            {
                if (material is IUVMaterial)
                {
                    var uvm:IUVMaterial = material as IUVMaterial;
                    if (width == 0)
                        width = uvm.width;
                    if (height == 0)
                        height = uvm.height;
                }
                else
                {
                    width = 100;
                    height = 100;
                }
            }
            buildPlane(width, height, segmentsW, segmentsH, yUp);
        }
    
        private var grid:Array;
		
        private function buildPlane(width:Number, height:Number, segmentsW:int, segmentsH:int, yUp:Boolean):void
        {
            var i:int;
            var j:int;

            grid = new Array(segmentsW+1);
            for (i = 0; i <= segmentsW; i++)
            {
                grid[i] = new Array(segmentsH+1);
                for (j = 0; j <= segmentsH; j++) {
                	if (yUp)
                    	grid[i][j] = new Vertex((i / segmentsW - 0.5) * width, 0, (j / segmentsH - 0.5) * height);
                    else
                    	grid[i][j] = new Vertex((i / segmentsW - 0.5) * width, (j / segmentsH - 0.5) * height, 0);
                }
            }

            for (i = 0; i < segmentsW; i++)
                for (j = 0; j < segmentsH; j++)
                {
                    var a:Vertex = grid[i  ][j  ]; 
                    var b:Vertex = grid[i+1][j  ];
                    var c:Vertex = grid[i  ][j+1]; 
                    var d:Vertex = grid[i+1][j+1];

                    var uva:UV = new UV(i     / segmentsW, j     / segmentsH);
                    var uvb:UV = new UV((i+1) / segmentsW, j     / segmentsH);
                    var uvc:UV = new UV(i     / segmentsW, (j+1) / segmentsH);
                    var uvd:UV = new UV((i+1) / segmentsW, (j+1) / segmentsH);

                    addFace(new Face(a, b, c, null, uva, uvb, uvc));
                    addFace(new Face(d, c, b, null, uvd, uvc, uvb));
                }
				
			type = "Plane";
        	url = "primitive";
        }

        public function vertex(i:int, j:int):Vertex
        {
            return grid[i][j];
        }

    }
}
