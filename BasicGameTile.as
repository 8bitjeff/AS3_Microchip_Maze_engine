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
	
	
	public class BasicGameTile extends Sprite {
		var tileSheetID:int; // the original id number from tile sheet
		var isWalkable:Boolean=false;
		var isCollectible:Boolean=false;
		var isPowerUp:Boolean=false;
		var animationFrameDelay:int=1; // number of frames to wait before moving to next sprite in aTileBitmapData
		var animationFrameCount:int=0; // current frame count to compare to  animationFrameDelay
		var animate:Boolean=false; // if true, then run through aTileBitmapData based on animationFrameDelay
		var aTileBitmapData:Array=[]; // holds an array of bitmapData objects for animation
		var tileBitmapDataIndex:int=0; // holds current index in aTileBitmapData for surface
		var tileBitmap:Bitmap // display object for this tile
		var mapRow:int=0; // holds location in the actual screen map
		var mapCol:int=0; // holds location in the actual screen map
		var powerUpType:int; // hold integer of power up type for GamePlay class to use
		var isEnemyGenerator:Boolean=false;
		var isKey:Boolean=false;
		var isDoor:Boolean=false;
		var tileSize:int;
		var isTransport:Boolean;
		var isReceiver:Boolean;
		var transportID:int; 
		var poweruptitle:String; //used for enemy and power ups in level in screen
		public function BasicGameTile() {
			
		}
		
		public function dispose():void {
			for each(var bd in aTileBitmapData) {
				//bd.dispose();
			}
			aTileBitmapData=null;
			
			
		}
		
		
		public function getCurrentBitmapData():BitmapData {
			return aTileBitmapData[tileBitmapDataIndex];
		}
		
		
		public function render() {
			
		}
			
	}
		
}