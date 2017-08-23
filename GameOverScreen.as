/**
* ...
* @author Jeff Fulton
* @version 0.1
*/

package  {
	import flash.events.*;
	import GamePlay;


	public class GameOverScreen extends EventDispatcher{
		
		private var gamePlay:GamePlay;
		public var gameOverScreen:gameOverScreen_mc;
		public var framesBeforeFade:int=60;
		public var framesToFade:int=30;
		public var frameCount:int=0;
		public var fadeCount:int=0;
		public var fadeStarted:Boolean=false;
		public var started:Boolean=false;
		private var fadeAmountPerFrame:Number;
		
		//events
		public static const COMPLETE:String = "complete";
		
		public function GameOverScreen(gp:GamePlay) {
			gamePlay=gp;
			gameOverScreen=new gameOverScreen_mc();
			gameOverScreen.x=110;
			gameOverScreen.y=150;
			fadeAmountPerFrame=1/framesToFade;
			
			
			
			
		}
		
		public function start() {
			trace("gameover  started");
			gamePlay.addEventListener(GamePlay.GAMEOVERUPDATE, updateListener,false,0,true);
			gamePlay.gameLoop.addChild(gameOverScreen);
			fadeStarted=false;
			frameCount=0;
			fadeCount=0;
			started=true;
			
			
		}
		
		public function getstarted():Boolean {
			return started;
		}
		
		private function updateListener (e:Event):void {
			trace("game over update listener");
			if (started) {
				frameCount++;
				trace("gameOver frameCount=" + frameCount);
				trace("gameOver fadeCount=" + fadeCount);
				if (frameCount >framesBeforeFade && !fadeStarted) {
					fadeStarted=true;
					trace("fade started");
				}
				if (fadeCount > framesToFade) {
					trace("fade ended");
					completed();
				}
				
				if (fadeStarted) {
					fadeCount++;
					gameOverScreen.alpha-=fadeAmountPerFrame;
					trace("gameoverScreen.alpha=" + gameOverScreen.alpha);
				}
				
			}
		}
	
		public function completed() {
			trace("game over completed");
			gamePlay.removeEventListener(GamePlay.GAMEOVERUPDATE, updateListener);
			gamePlay.gameLoop.removeChild(gameOverScreen);
			started=false;
			gameOverScreen.alpha=1;
			dispatchEvent(new Event(COMPLETE));	
		}
		
	} // end class

} // end package