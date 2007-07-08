﻿package nl.projects{	import flash.display.*;	import flash.events.*;	import flash.text.*;	import flash.utils.*;	import flash.ui.Keyboard;	import flash.geom.*;	import away3d.loaders.*;	import away3d.cameras.*;	import away3d.objects.*;	import away3d.core.*;	import away3d.core.material.*;	import away3d.core.proto.*;	import away3d.core.render.*;	import away3d.loaders.Obj;	//	import nl.fabrice.widgets.Slider;	import flash.text.TextFormat;	import nl.fabrice.bitmapdata.BMDScrollerRegister;		import away3d.core.material.fx.*;	public class BumpInterface extends Sprite	{		public var scene:Scene3D;		public var objmodel;		public var objmodel2;		public var objmodel3;		public var destbm:Bitmap;		public var destBMD:BitmapData;		protected var view:View3D;		protected var camera:HoverCamera3D;		//perftest		private var fpslabel:TextField;		private var cpulabel:TextField;		private var lastrender:int = 0;		//light		private var light:AmbientLight;		//sliders		private var mySliderR:Slider;		private var mySliderG:Slider;		private var mySliderB:Slider;		//private var mySliderY:Slider;		public var lightmodel;		//		private var zeroPoint:Point;				public var texture:BitmapData;		public var bumpsource:BitmapData;		public var sourcetexture:BitmapData;		public var lightMap:BitmapData;		public var lightMap2:BitmapData;		private var bump:Bump;		//		public function BumpInterface()		{			//this.goFullScreen();			this.initSWFEnvironement();			fpslabel = new TextField();			 			this.prepareWorld();			this.preparePerfFields();			//this.addSliders(); 		}		private function preparePerfFields():void		{			//fpslabel = new TextField();			fpslabel.x = 10;			fpslabel.y = 10;			fpslabel.defaultTextFormat = new TextFormat("Verdana", 10, 0x000000);			fpslabel.text = "";			fpslabel.background = true;			fpslabel.height = 15;			fpslabel.width = 200;			fpslabel.backgroundColor = 0xFF9900;			 			this.addChild(fpslabel);		}		private function goFullScreen():void		{			//stage["fullScreenSourceRect"] = new Rectangle(0, 0, Stage.width, Stage.height);			stage.displayState = "fullScreen";		}		private function initSWFEnvironement():void		{			stage.align = StageAlign.TOP_LEFT;			stage.scaleMode = StageScaleMode.NO_SCALE;			stage.showDefaultContextMenu = false;			stage.stageFocusRect = false;		}		private function generateFromLib(source_ID:String):BitmapData		{			var classRef:Class = getDefinitionByName(source_ID) as Class;			var mySprite:Sprite = new classRef();			var temp_bmd:BitmapData = new BitmapData(mySprite.width, mySprite.height, true, 0x00FFFFFF);			temp_bmd.draw(mySprite, null, null, null, temp_bmd.rect, true);			return temp_bmd;		}		private function prepareWorld():void		{			this.lightMap = this.generateFromLib("stonelight");			this.lightMap2 = this.lightMap.clone();						this.texture = this.generateFromLib("stonecolor");//fur,lightMap			this.sourcetexture = this.texture.clone();			this.bumpsource = this.generateFromLib("stonebump");			this.destbm = new Bitmap();			this.destBMD = new BitmapData(stage.stageWidth , stage.stageHeight, false, 0xFFFFFF);			this.destbm.bitmapData = this.destBMD;			this.addChild(this.destbm);			this.scene = new Scene3D();			//XXXXXXXXXXXXXXXXX			//Away new FX's			//XXXXXXXXXXXXXXXXX			this.bump = new Bump(this.bumpsource, this.lightMap);			BMDScrollerRegister.getInstance().setDestBMD(this.lightMap);			BMDScrollerRegister.getInstance().addScroll("lightmap", this.lightMap.width, this.lightMap.height, this.lightMap2, 0, 0, false);									//XXXXXXXXXXXXXXXXX			//new bmd materials			//XXXXXXXXXXXXXXXXX			//var mat:IMaterial = new PointBitmapMaterial(this.destBMD, 0x0099FF, {offsetX:stage.stageWidth / 2,  offsetY:stage.stageHeight / 2, pointsize:8, light:"flat"});			//var mat:IMaterial = new FillBitmapMaterial(this.destBMD, 0x880099FF, {offsetX:stage.stageWidth / 2,  offsetY:stage.stageHeight / 2, linecolor:0x886633CC , light:"flat"});			//var mat:IMaterial = new WireframeBitmapMaterial(this.destBMD, 0xFFccFFcc, {offsetX:stage.stageWidth / 2, offsetY:stage.stageHeight / 2, light:"flat"});//flat,smooth			//var mat:IMaterial = new TraceBitmapMaterial(texture, this.destBMD, {offsetX:stage.stageWidth / 2, offsetY:stage.stageHeight / 2, light:"flat"},[bump]);//flat,smooth			var mat:IMaterial = new BitmapMaterial(texture, {light:"flat", smooth:true}, [bump]);			//			//XXXXXXXXXXXXXXXXX			//Away materials			//XXXXXXXXXXXXXXXXX						//var mat:IMaterial = new WireframeMaterial(0xFF0000);			this.objmodel = Obj.parse("OBJs/colibri.obj", mat , {}, 1.3 ); 			//this.objmodel = new Sphere(mat, {radius:400, segmentsW:6, segmentsH:6});			//this.objmodel = new Plane(mat, {width:800,height:800, segmentsW:4, segmentsH:4});			//this.objmodel = Ase.parse("ASEs/seaturtle.ase",mat,{},4);			this.objmodel.x = 0;			this.scene.addChild(this.objmodel);/*			//var testbmp = new Bump(texture, this.lightMap);			//var mat2:IMaterial = new BitmapMaterial(texture, {light:"flat"},[testbmp]);			//this.objmodel2 = new Sphere(mat2, {radius:400, segmentsW:8, segmentsH:8});			this.objmodel2 = new Sphere(mat, {radius:300, segmentsW:8, segmentsH:8});			this.objmodel2.y = 120;			this.scene.addChild(this.objmodel2); 			var mat3:IMaterial = new BitmapMaterial(this.generateFromLib("stonecolor"),  {light:"fla1t"});			this.objmodel3 = new Sphere(mat3, {radius:300, segmentsW:6, segmentsH:6});			this.objmodel3.x = -700;			//this.scene.addChild(this.objmodel3);			//var mat:IMaterial = new WireframeBitmapMaterial(this.destBMD, 0xFFff88cc, stage.stageWidth / 2, stage.stageHeight / 2);			//mat = new PointBitmapMaterial(this.destBMD, 0xFFFFFFFF, stage.stageWidth / 2, stage.stageHeight / 2, 1);			// var objmodel2 = new Plane(mat, {height:250, width:300, segmentsW:4, segmentsH:4});			// objmodel2.x = 450;			// this.scene.addChild(objmodel2);						 var mat = new PointBitmapMaterial(this.destBMD, 0xFFFFFFFF, stage.stageWidth / 2, stage.stageHeight / 2, 1);			 var objmodel3 = new Sphere(mat, {radius:250, segmentsW:10, segmentsH:10});			 objmodel3.x = -350			 this.scene.addChild(objmodel3);			 */			//FF9900			this.light = new AmbientLight(0xFFFFFF, 600, 200, 300, 60, 0.2);			var matL:IMaterial = new PointBitmapMaterial(this.destBMD, 0xFFFF00cc, {offsetX:stage.stageWidth / 2,  offsetY:stage.stageHeight / 2, pointsize:8, light:"flat"});			this.lightmodel = new Sphere(matL, {radius:10, segmentsW:2, segmentsH:2});			//this.objmodel = Ase.parse("ASEs/seaturtle.ase",mat,{},4);			this.lightmodel.x = 300;			this.lightmodel.y = 300;			this.lightmodel.z = 300;			//this.scene.addChild(this.lightmodel);			this.camera = new HoverCamera3D(null, {zoom:3, focus:200, distance:800});			this.camera.tiltangle = 10;			this.camera.targettiltangle = 40;			this.camera.panangle = 0;			this.camera.targetpanangle = 120;			this.camera.mintiltangle = -10;			this.camera.lookAt(objmodel);			this.view = new View3D(this.scene, this.camera, Renderer.BASIC);			this.view.x = stage.stageWidth / 2;			this.view.y = stage.stageHeight / 2;			this.view.camera = camera;			this.addChild(this.view);			stage.addEventListener(Event.ENTER_FRAME, this.refreshScreen);			stage.addEventListener(Event.RESIZE, this.onResize);		}		private function refreshScreen(event:Event):void		{						//uncomment for bitmapdata only traces			//this.destBMD.fillRect(this.destBMD.rect, 0x000000);			//						var offsetx:Number = 2;			var offsety:Number = 2;			if (this.view.mouseX > 0) {				this.camera.targetpanangle -= 2;				offsetx = -2;			}			if (this.view.mouseX < 0) {				this.camera.targetpanangle += 2;				offsetx = 2;			}			if (this.view.mouseY > 0) {				this.camera.targettiltangle -= 2;				offsety = -2;			}			if (this.view.mouseY < 0) {				this.camera.targettiltangle += 2;				offsety = 2;			}			// this.objmodel.rotationY +=5;			// this.objmodel.rotationX +=5;			//this.objmodel2.rotationY +=5;			//this.objmodel2.rotationX +=5;			//this.objmodel3.rotationY +=5;			//this.objmodel3.rotationX +=5;			this.camera.hover();			this.view.render();			this.updateFPS();			 			BMDScrollerRegister.getInstance().update("lightmap", offsetx, offsety, 0, 0 );			//stage.removeEventListener(Event.ENTER_FRAME, this.refreshScreen);		}		private function updateFPS():void		{			var now:int = getTimer();			var performance:int = now - lastrender;			lastrender = now;			if (performance < 1000) {				fpslabel.text = "" + int(1000 / (performance+0.001)) + " fps " + performance + " ms";				fpslabel.width = 4 * performance;			}		}		private function onResize(event:Event):void		{			//this.destBMD = new BitmapData(stage.stageWidth ,stage.stageHeight , false, 0x00);			//this.destbm.bitmapData = this.destBMD;			this.view.x = stage.stageWidth / 2;			this.view.y = stage.stageHeight / 2;		}		//XXXXXXXXXXXXXXXXXXXX  sliders  XXXXXXXXXXXXXXXXXXXXXX		private function addSliders():void		{			trace("add sliders");			var tf = new TextFormat();			tf.size = 10;			tf.align = "left";			tf.font = "Verdana";			tf.color = 0xFFFFFF;			 			this.mySliderR = new Slider();			this.mySliderR.start(this, 10, 40, 255, 254, 127, -127, 2 ,"Red", tf);			this.mySliderR.addEventListener("SCROLL",onScrollR);			//color sliders			this.mySliderG = new Slider();			this.mySliderG.start(this, 10, 90, 255, 2, 1, -1, 1,"Green", tf);			this.mySliderG.addEventListener("SCROLL", onScrollG);			this.mySliderB = new Slider();			this.mySliderB.start(this, 10, 130, 255, 2, 1, 0, 2,"Blue", tf);			this.mySliderB.addEventListener("SCROLL", onScrollB);			//this.mySliderY = new Slider();			//this.mySliderY.start(this, 10, 170, 255, 2, 1, 0, 2,"Y", tf);			//this.mySliderY.addEventListener("SCROLL", onScrollB); 			//refresh			// this.light.color = this.composeColor();		}				//light positions		private function onScrollX(e:Event):void		{			this.lightmodel.x = e.target.value ;			this.light.x = e.target.value;		}		private function onScrollY(e:Event):void		{			this.lightmodel.y = e.target.value ;			this.light.y = e.target.value;		}		private function onScrollZ(e:Event):void		{			this.lightmodel.z = e.target.value ;			this.light.z = e.target.value;		}		//		private function onScrollR(e:Event):void		{			 this.light.color = this.composeColor();		}		private function onScrollG(e:Event):void		{			 this.light.color = this.composeColor();		}		private function onScrollB(e:Event):void		{			 this.light.color = this.composeColor();		}		private function composeColor():Number		{			var r:Number = this.mySliderR.value;			var g:Number = this.mySliderG.value;			var b:Number = this.mySliderB.value;			return r << 16 | g << 8 | b;		}		private function onScrollBias(e:Event):void		{			//this.light.brightness = e.target.value;	//this.CF = null;	//			this.CF.bias = e.target.value;		}		private function onScrollDivisor(e:Event):void		{			//this.light.ambient = e.target.value;			//this.CF.divisor = e.target.value;		}	}}