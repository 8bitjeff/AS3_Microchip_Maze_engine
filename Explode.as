/**
* ...
* @author Jeff Fulton
* @version 0.1
*/

package  {
	
	import GamePlay;
	import flash.display.Sprite;
	import flash.events.*;
	import flash.geom.*;
	import flash.display.BitmapData;
	import flash.filters.GlowFilter;
	
	public class Explode extends Sprite{
		
		public var aSpriteBitmapData:Array=[]; // holds an array of bitmapData objects for animation
		public var id:String; 
		public var spriteBitmapDataIndex:int=0; // holds current index in aSpriteBitmapData for surface
		public var animationFrameDelay:int=1; // number of frames to wait before moving to next sprite in aSpriteBitmapData
		public var animationFrameCount:int=0; // current frame count to compare to  animationFrameDelay
		public var started:Boolean=false;
		public var complete:Boolean=false;
		public var gamePlay:GamePlay;
	
		public function Explode(xval, yval,idval:String,delayval:int, gp:GamePlay) {
			gamePlay=gp;
			id=idval;
			aSpriteBitmapData = gamePlay.oExplodeType[id].aSpriteBitmapData;
			animationFrameDelay=delayval;
			x=xval;
			y=yval;
			
		}
	
		private function renderListener (e:Event):void {
			if (started) {
				render();
			}
		}
		
		public function startMe() {
			started=true;
			gamePlay.addEventListener(GamePlay.RENDER, renderListener,false,0,true);
		}
	
		public function removeMe(){
			//trace("explode removed");
			
			gamePlay.removeEventListener(GamePlay.RENDER, renderListener);
			complete=true; // gamePlay will run through the aExplode array any look for those marked as complete to splice
		
		}
		
		public function render() {
			animationFrameCount++; 
			if (animationFrameCount > animationFrameDelay) {
				spriteBitmapDataIndex++;
				if (spriteBitmapDataIndex == aSpriteBitmapData.length) {
					removeMe();
				}else{
					var tileSize=gamePlay.tileSize;
					var tempBitmapData:BitmapData;
					var gf:GlowFilter=new GlowFilter(0xFF0000, .6,  4,  4,  2, 75, true, false);
					tempBitmapData=aSpriteBitmapData[spriteBitmapDataIndex].clone();
					tempBitmapData.applyFilter(tempBitmapData,new Rectangle(0,0,tileSize,tileSize),new Point(0,0),gf);
					gamePlay.getgameScreenBitmapData().copyPixels(tempBitmapData,new Rectangle(0,0,tileSize,tileSize), new Point(x,y));
					
					//gamePlay.getgameScreenBitmapData().copyPixels(aSpriteBitmapData[spriteBitmapDataIndex],new Rectangle(0,0,gamePlay.tileSize,gamePlay.tileSize), new Point(x,y));
					animationFrameCount=0;
				}
				
			}
			
		}
		
		
		
	}
}
		