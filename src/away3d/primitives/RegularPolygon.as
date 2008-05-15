﻿package away3d.primitives{    import away3d.containers.*;    import away3d.core.*;    import away3d.core.base.*;    import away3d.core.math.*;    import away3d.core.utils.*;    import away3d.materials.*;     public class RegularPolygon extends Mesh    {        public function RegularPolygon(init:Object = null)        {            super(init);            var radius:Number = ini.getNumber("radius", 10, {min:10});			var sides:int = ini.getInt("sides", 8, {min:3});			var subdivision:int = ini.getInt("subdivision", 1, {min:1}); 			var yUp:Boolean = ini.getBoolean("yUp", true); 			            buildRegularPolygon(radius, sides, subdivision, yUp);						type = "RegularPolygon";        	url = "primitive";        }            private function buildRegularPolygon(radius:Number, sides:int, subdivision:int, yUp:Boolean):void        {			var tmpPoints:Array = new Array();			var i:int = 0;			var j:int = 0;						var innerstep:Number = radius/subdivision;						var radstep:Number = 360/sides;			var ang:Number = 0;			var ang_inc:Number = radstep;						var uva:UV;			var uvb:UV;			var uvc:UV;			var uvd:UV;											var facea:Vertex;			var faceb:Vertex;			var facec:Vertex;			var faced:Vertex;						for (i; i <= subdivision; i++) {				tmpPoints.push(new Number3D(i*innerstep, 0, 0));			}						var base:Number3D = new Number3D(0,0,0);			var zerouv:UV = new UV(0.5, 0.5);			 			for (i = 0; i < sides; i++) {								for (j = 0; j <tmpPoints.length-1; j++) {											uva = new UV( (Math.cos(-ang_inc/180*Math.PI) / ((subdivision*2)/j) ) + .5, (Math.sin(ang_inc/180*Math.PI) / ((subdivision*2)/j)) +.5 );					uvb = new UV( (Math.cos(-ang/180*Math.PI) / ((subdivision*2)/(j+1)) ) + .5, (Math.sin(ang/180*Math.PI) / ((subdivision*2)/(j+1)) ) + .5   );					uvc = new UV( (Math.cos(-ang_inc/180*Math.PI) / ((subdivision*2)/(j+1)) ) + .5, (Math.sin(ang_inc/180*Math.PI) / ((subdivision*2)/(j+1))) + .5  );					uvd = new UV( (Math.cos(-ang/180*Math.PI) / ((subdivision*2)/j)) + .5, (Math.sin(ang/180*Math.PI) / ((subdivision*2)/j) ) +.5  );					if(j==0){						if (yUp) {							facea = new Vertex(base.x, base.y, base.z);							faceb = new Vertex(Math.cos(-ang/180*Math.PI) *  tmpPoints[1].x, base.y, Math.sin(ang/180*Math.PI) * tmpPoints[1].x);							facec = new Vertex(Math.cos(-ang_inc/180*Math.PI) *  tmpPoints[1].x, base.y, Math.sin(ang_inc/180*Math.PI) * tmpPoints[1].x);							} else {							facea = new Vertex(base.x, base.y, base.z);							faceb = new Vertex(Math.cos(-ang/180*Math.PI) *  tmpPoints[1].x, Math.sin(ang/180*Math.PI) * tmpPoints[1].x, base.z);							facec = new Vertex(Math.cos(-ang_inc/180*Math.PI) *  tmpPoints[1].x, Math.sin(ang_inc/180*Math.PI) * tmpPoints[1].x, base.z);							}									addFace( new Face(facea, faceb, facec, null, zerouv, uvb, uvc ) );											} else {						if (yUp) {							facea = new Vertex(Math.cos(-ang_inc/180*Math.PI) *  tmpPoints[j].x, base.y, Math.sin(ang_inc/180*Math.PI) * tmpPoints[j].x);							faceb = new Vertex(Math.cos(-ang_inc/180*Math.PI) *  tmpPoints[j+1].x, base.y, Math.sin(ang_inc/180*Math.PI) * tmpPoints[j+1].x);							facec = new Vertex(Math.cos(-ang/180*Math.PI) *  tmpPoints[j+1].x, base.y, Math.sin(ang/180*Math.PI) * tmpPoints[j+1].x);							faced = new Vertex(Math.cos(-ang/180*Math.PI) *  tmpPoints[j].x, base.y, Math.sin(ang/180*Math.PI) * tmpPoints[j].x);						} else {							facea = new Vertex(Math.cos(-ang_inc/180*Math.PI) *  tmpPoints[j].x, Math.sin(ang_inc/180*Math.PI) * tmpPoints[j].x, base.z);							faceb = new Vertex(Math.cos(-ang_inc/180*Math.PI) *  tmpPoints[j+1].x, Math.sin(ang_inc/180*Math.PI) * tmpPoints[j+1].x, base.z);							facec = new Vertex(Math.cos(-ang/180*Math.PI) *  tmpPoints[j+1].x, Math.sin(ang/180*Math.PI) * tmpPoints[j+1].x, base.z);							faced = new Vertex(Math.cos(-ang/180*Math.PI) *  tmpPoints[j].x, Math.sin(ang/180*Math.PI) * tmpPoints[j].x, base.z);						}						 						addFace( new Face(facec, faceb, facea, null, uvb, uvc, uva ) );						addFace( new Face(facec, facea, faced, null, uvb, uva, uvd ) );						 					}														}								ang += radstep;				ang_inc += radstep;							}				        }    }}