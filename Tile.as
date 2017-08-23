/**
* ...
* @author Jeff Fulton
* @version 0.1
*/

package  {
	
	import BasicGameTile;
	import flash.display.MovieClip;
	import flash.geom.*;
	import flash.display.BitmapData;
	import flash.events.*;
	import GamePlay;
	
	public class Tile extends BasicGameTile {
		
		var gamePlay:GamePlay;
		var destX;int;
		var destY:int;
	
		
		public function Tile(id:int,gp:GamePlay) {
			//trace ("tile");
			tileSheetID=id;
			gamePlay=gp;
			
		}
		
		public function addRenderListener() {
			//gamePlay.addEventListener(GamePlay.RENDER, renderListener,false,0,true);
		}
		
		public function setkeyEatenListener() {
			//turn on manually is d=1 (door=1)
			trace("key eaten listener");
			gamePlay.addEventListener(GamePlay.KEYEATEN, keyEatenListener,false,0,true);
		}
		
		private function renderListener (e:Event):void {
			render();
		}
		
		private function keyEatenListener(e:Event):void {
			//this is a door, so now 
			animate=true;
		}
		
		override public function render() {
			//trace("tile render");
			if (animate) {
				animationFrameCount++; 
				if (animationFrameCount > animationFrameDelay) {
					tileBitmapDataIndex++;
					if (tileBitmapDataIndex == aTileBitmapData.length) {
						if (isDoor) {
							animate=false;
							isWalkable=true;
							tileBitmapDataIndex--;
						}else{
							tileBitmapDataIndex=0;
						}
					}
					animationFrameCount=0;
					//gamePlay.getgameScreenBitmapData().copyPixels(aTileBitmapData[tileBitmapDataIndex],new Rectangle(0,0,tileSize,tileSize), new Point(destX,destX));
										
				} //if frame count
			} //if animate
		
		}
		
	}
}
		