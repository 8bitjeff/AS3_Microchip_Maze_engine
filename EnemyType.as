/**
* ...
* @author Jeff Fulton
* @version 0.1
*/

package  {
	import flash.geom.*;
	import flash.display.BitmapData;
	
	public class EnemyType {
		//holds basic data for an dynamic enemy type
		//parameters such as speed, intellignece, hits needed to kill
		//holds the bitmap states
		public var speed:Number;
		public var intelligence:Number;
		public var bitmapStateObject:Object={};
		public var id:String;
		public var score:int;
		public var title:String; // used for levelinscreen
				
		
		public function EnemyType(idval:String, speedval:Number, intval:Number, scoreval:int) {
			id=idval;
			speed=speedval;
			intelligence=intval;
			score=scoreval;
			//trace("new enemy: speed=" + speed + " intelligence=" + intelligence);
		}
		
		function addBitmapState(statename:String,bitmapArray:Array) {
			bitmapStateObject[statename]=bitmapArray;
		}
		
		function getBitmapState(statename:String) {
			return bitmapStateObject[statename];
		}
		
		function dispose():void {
			 bitmapStateObject=null;
		}
		
	
	}
}
		