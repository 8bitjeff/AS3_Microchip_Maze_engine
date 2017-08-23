/**
* ...
* @author Jeff Fulton
* @version 0.1
*/

package  {
	
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.geom.*;
	import flash.display.BitmapData;
	import GamePlay;
	import flash.filters.GlowFilter;
	
	public class BasicGameSprite extends Sprite {
		var bitmapStateObject:Object={}; // holds arrays of bitmap data states
		var aSpriteBitmapData:Array=[]; // holds an array of bitmapData objects for animation
		var spriteBitmapDataIndex:int=0; // holds current index in aSpriteBitmapData for surface
		//var spriteBitmapData:BitmapData; // holds current bitmapData for this sprite
		var spriteBitmap:Bitmap; // holds the currrent bitmap data to display
		var animationFrameDelay:int=1; // number of frames to wait before moving to next sprite in aSpriteBitmapData
		var animationFrameCount:int=0; // current frame count to compare to  animationFrameDelay
		var animate:Boolean=false; // if true, then run through aSpriteBitmapData based on animationFrameDelay
		var dx:Number=0; // x direction coeficient (-1 to 1)
		var dy:Number=0; // y direction coeficient (-1 to 1)
		var nextx:Number=0;
		var nexty:Number=0;
		var nextrotation:Number=0;
		var nextscalex:Number=1;
		var nextscaley:Number=1;
		var nextalpha:Number=1;
		var acceleration:Number=1; // # of pixels to add for each movement
		var velocity:Number=0; //accounts for speed and direction dx or dy * acceleration
		var friction:Number=0; // subtract from velocity each frame.
		var gravity:Number=0; //ex 9.8 m/sec^2 for earth bound. gravityDirection would be 180 to pull down
		var gravityDirection:Number=0; // a number -180 to 180 for angle of gravity pull
		var rendervelocity:Boolean=false; // if true
		var renderalpha:Boolean=false;
		var renderrotation:Boolean=false;
		var renderscalex:Boolean=false;
		var renderscaley:Boolean=false;
		var renderGlowFilter:Boolean=false;
		var glowfilter:GlowFilter;
		var usegravity:Boolean=false;
		var usefriction:Boolean=false;
		var accAdjust:int=0; // how much to adjust the acceleration in special circumstances
		
		//since x and y are in upper left hand corner, these are needed to have origin in middle
		var centerx:int;
		var centery:int;
		var centernextx:int;
		var centernexty:int;
		
		public var tileRow:int;
		public var tileCol:int;
		public var tileSize:int;
		public var gamePlay:GamePlay;
		
		//*** optimization vars
		var blitRectangle:Rectangle;
		var blitPoint:Point=new Point;
		
				
		public function BasicGameSprite() {
			
		}
		
		public function setblitRectangle():void  {
			blitRectangle=new Rectangle(0,0,tileSize,tileSize);
		}
		
		public function setx(val:int) {
			x=val;
			centerx=x+.5*tileSize;
		}
		
		public function sety(val:int) {
			y=val;
			centery=y+.5*tileSize;
		}
		
		public function setnextx(val:int) {
			nextx=val;
			centernextx=nextx+.5*tileSize;
		}
		
		public function setnexty(val:int) {
			nexty=val;
			centernexty=nexty+.5*tileSize;
		}
		
		function addBitmapState(statename:String,bitmapArray:Array) {
			bitmapStateObject[statename]=bitmapArray;
		}
		
		function getBitmapState(statename:String):Array {
			return bitmapStateObject[statename];
		}
		
		function setBitmapState(statename:String, stateArray:Array) {
			//run loop for copy from one array to another
			for (var ctr=0;ctr < stateArray.length;ctr++) {
				bitmapStateObject[statename][ctr]=stateArray[ctr];
			}
		}
		
		public function getCurrentBitmapData():BitmapData {
			return aSpriteBitmapData[spriteBitmapDataIndex];
		}
		
		
		public function update() {
			//call super.update() if generic update is ok
			trace("acceleration+accAdjust=" + acceleration+accAdjust);
			if (rendervelocity) {
				setnextx(x+(dx*(acceleration+accAdjust)));
				setnexty(y+(dy*(acceleration+accAdjust)));
			}
		}
		
		public function resetRenderBooleans() {
			trace("reset booleans");
			rendervelocity=false;
			renderalpha=false;
			renderscalex=false;
			renderscaley=false;
			renderrotation=false;
			renderGlowFilter=false;
	
		}
		
		
		public function render() {
			if (rendervelocity) {
				setx(nextx);
				sety(nexty);
				
				
			}	
		
			
		
			if (animate) {
				nextAnimation();
			}else{
				blitPoint.x=x;
				blitPoint.y=y;
				gamePlay.getgameScreenBitmapData().copyPixels(aSpriteBitmapData[spriteBitmapDataIndex],blitRectangle, blitPoint)
			}
		}
			
		public function nextAnimation() {
		//trace("animating");
			//trace("animationFrameCount=" + animationFrameCount);
			//trace("spriteBitmapDataIndex=" + spriteBitmapDataIndex);
			//trace("1");
			var cTransform:ColorTransform = new ColorTransform();
			var cTransrect:Rectangle;
			var glowFilterrect:Rectangle;
			//trace("2");
			
			if (animationFrameCount > animationFrameDelay) {
				spriteBitmapDataIndex++;
				if (spriteBitmapDataIndex == aSpriteBitmapData.length) {
					spriteBitmapDataIndex=0;
				}
				animationFrameCount=0;
				//spriteBitmap.bitmapData=aSpriteBitmapData[spriteBitmapDataIndex];
				
			}
			animationFrameCount++; 
		//	trace("3");
			var displayBitmapData:BitmapData = aSpriteBitmapData[spriteBitmapDataIndex].clone();
			
			//trace("4");
			if (renderalpha) {
				alpha=nextalpha;
				cTransrect= new Rectangle(0, 0, tileSize, tileSize);
				cTransform.alphaMultiplier=alpha;
				displayBitmapData.colorTransform(cTransrect, cTransform);
			}
			//trace("5");
			if (renderscalex) {
				scaleX=nextscalex;
			}
			//trace("6");
			if (renderscaley) {
				scaleX=nextscaley;
			}
			//trace("7");
			if (renderrotation) {
				rotation=nextrotation;
			}
		//	trace("8");
			if (renderGlowFilter) {
			//	trace("rendering glow filter");
				glowFilterrect=new Rectangle(0, 0, tileSize, tileSize);
				displayBitmapData.applyFilter(displayBitmapData,glowFilterrect,new Point(0,0),glowfilter);
			}
		//	trace("9");
		blitPoint.x=x;
		blitPoint.y=y;
			gamePlay.getgameScreenBitmapData().copyPixels(displayBitmapData,blitRectangle, blitPoint);
		//	trace("10");
		}
	
	
	}
		
}