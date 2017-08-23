/**
* ...
* @author Jeff Fulton
* @version 0.1
*/

package  {
	import flash.events.*;
	import GamePlay;
	import flash.filters.GlowFilter;
	import flash.geom.*;


	public class GetReadyScreen extends EventDispatcher{
		
		private var gamePlay:GamePlay;
		public var getReadyScreen:getReadyScreen_mc;
		public var framesBeforeFade:int=60;
		public var framesToFade:int=30;
		public var frameCount:int=0;
		public var fadeCount:int=0;
		public var fadeStarted:Boolean=false;
		public var started:Boolean=false;
		private var fadeAmountPerFrame:Number;
		private var glowfilter=new GlowFilter();
		
		
		//events
		public static const COMPLETE:String = "complete";
		
		public function GetReadyScreen(gp:GamePlay) {
			trace("get ready created");
			gamePlay=gp;
			getReadyScreen=new getReadyScreen_mc();
			getReadyScreen.x=80;
			getReadyScreen.y=150;
			//glowfilter=new GlowFilter(0x00ff00, .5,  4,  4,  2, 5, true, false);
			//getReadyScreen.filters=[glowfilter];
			fadeAmountPerFrame=1/framesToFade;
		}
		
		public function start() {
			trace ("get ready started");
			gamePlay.addEventListener(GamePlay.GETREADYUPDATE, updateListener,false,0,true);
			gamePlay.gameLoop.addChild(getReadyScreen);
			fadeStarted=false;
			frameCount=0;
			fadeCount=0;
			started=true;
			
			
		}
		
		public function getstarted():Boolean {
			return started;
		}
		
		private function updateListener (e:Event):void {
			fadeit();
			//completed();
		}
	
		private function fadeit(){
			////trace("get ready running");
			if (started) {
				frameCount++;
				////trace("get ready frameCount=" + frameCount);
				////trace("get ready fadeCount=" + fadeCount);
				if (frameCount >framesBeforeFade && !fadeStarted) {
					fadeStarted=true;
					////trace("fade started");
				}
				if (fadeCount > framesToFade) {
					////trace("fade ended");
					completed();
				}
				
				if (fadeStarted) {
					fadeCount++;
					getReadyScreen.alpha-=fadeAmountPerFrame;
					////trace(" getReadyScreen.alpha=" + getReadyScreen.alpha);
				}
				
			}
		}
	
		public function completed() {
			////trace("get ready completed");
			gamePlay.removeEventListener(GamePlay.GETREADYUPDATE, updateListener);
			gamePlay.gameLoop.removeChild(getReadyScreen);
			started=false;
			getReadyScreen.alpha = 1;
			dispatchEvent(new Event(COMPLETE));	
		}
		
	} // end class

} // end package