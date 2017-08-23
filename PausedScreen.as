/**
* ...
* @author Jeff Fulton
* @version 0.1
*/

package  {

	import flash.events.*;
	import GamePlay;


	public class PausedScreen extends EventDispatcher {
		
		public var started:Boolean=false;
		private var gamePlay:GamePlay;
		public static const COMPLETE:String = "complete";
		public static const QUIT:String = "quit";
		public var pausedScreen:pausedScreen_mc;
		public function PausedScreen(gp:GamePlay) {
			gamePlay=gp;
			pausedScreen=new pausedScreen_mc();
			pausedScreen.x=90;
			pausedScreen.y=40;
		}
		
		public function start():void {
			gamePlay.gameLoop.addChild(pausedScreen);
		}
	
		function detectKeyPress(keyCode:int):void {
			
			trace(keyCode + " was pressed");
			
			if (keyCode==81) {
				gamePlay.gameLoop.removeChild(pausedScreen);
				dispatchEvent(new Event(QUIT));
			}
			
			if (keyCode==32) {
				gamePlay.gameLoop.removeChild(pausedScreen);
				dispatchEvent(new Event(COMPLETE));
			}
		}
		
		
		
		
		
		
	
	
	
	} // end class

} // end package