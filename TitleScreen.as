/**
* ...
* @author Jeff Fulton
* @version 0.1
*/

package  {
	import flash.display.MovieClip;
	import flash.text.*; 
	import flash.display.Bitmap;
	import flash.display.Shape;
	import flash.geom.*;
	import flash.display.BitmapData;
	import flash.events.*;
	import flash.display.Stage;
	import GameLoop;


	public class TitleScreen extends MovieClip {
		private var titleScreen:titleScreen_mc;
		private var tlPressSpace:TextField;
		private var gameLoop:GameLoop;
		public static const STATE_DISPLAY:int=0;
		public static const STATE_ATTRACT:int=1;

		public function TitleScreen(gameLoopval:GameLoop) {
			gameLoop=gameLoopval;
			titleScreen=new titleScreen_mc();
			titleScreen.x=40;
			titleScreen.y=40;
			addChild(titleScreen);
		}
		
		public function addListeners():void {
			gameLoop.stage.addEventListener(KeyboardEvent.KEY_DOWN,keyDownListener,false,0,true);
		}
		
		public function removeListeners():void {
			gameLoop.stage.removeEventListener(KeyboardEvent.KEY_DOWN,keyDownListener);
		}

		function playFromStart():void {
			titleScreen.gotoAndPlay(1);
		}
		
		

		function keyDownListener(e:KeyboardEvent):void {
			
			trace("e.keyCode=" + e.keyCode);
			
			if (e.keyCode==32 || e.keyCode==13){ 
				trace("title screen keyboard listener");
				gameLoop.titleScreenFinshed();
				removeListeners();
			}
			
			if (e.keyCode==77) {
				trace("M pressed");
				gameLoop.dispatchSoundMuteEvent();
			}
		}
		
		
		
		
		
		
	
	
	
	} // end class

} // end package