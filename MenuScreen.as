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


	public class MenuScreen extends MovieClip {
		private var menuScreen:MenuScreen_mc=new MenuScreen_mc;
		private var gameLoop:GameLoop;
		private var currentIndex:int;
		private var aItem:Array=new Array("instructions_mc","credits_mc","enterpassword_mc","restart_mc","playgame_mc");
		private var ctr1:int;
		private var eSound:Event;
		
		public function MenuScreen(gameLoopval:GameLoop) {
			gameLoop=gameLoopval;
			menuScreen.x=40;
			menuScreen.y=40;
			addChild(menuScreen);
			
		}
		
		public function reset():void {
			currentIndex=4;
			refreshMenu();
			addListeners();
			menuScreen.lastlevel_txt.text=String(gameLoop.getlastLevel());
		}
		
		
		
		public function refreshMenu():void {
			trace("currentIndex=" + currentIndex);
			
			menuScreen.instructions_mc.gotoAndStop(1);
			menuScreen.credits_mc.gotoAndStop(1);
			menuScreen.enterpassword_mc.gotoAndStop(1);
			menuScreen.restart_mc.gotoAndStop(1);
			menuScreen.playgame_mc.gotoAndStop(1);
			
			switch (currentIndex) {
				
				case 0:
					menuScreen.instructions_mc.gotoAndStop("on");
					break;
				case 1:
					menuScreen.credits_mc.gotoAndStop("on");
					break;
				case 2: 
					menuScreen.enterpassword_mc.gotoAndStop("on");
					break;
				case 3:
					menuScreen.restart_mc.gotoAndStop("on");
					break;
				case 4:
					menuScreen.playgame_mc.gotoAndStop("on");
					break;
			}
			/*
			for (ctr1=0;ctr1<aItem.length;ctr1++) {
				
				if (ctr1==currentIndex) {
					trace("moving to: " + aItem[currentIndex]);
					menuScreen[aItem[currentIndex]].gotoAndStop(2);
				}else{
					menuScreen[aItem[currentIndex]].gotoAndStop(1);
				}
				
			}
			*/
		}
		
		public function addListeners():void {
			gameLoop.stage.addEventListener(KeyboardEvent.KEY_DOWN,keyDownListener,false,0,true);
		}
		
		public function removeListeners():void {
			gameLoop.stage.removeEventListener(KeyboardEvent.KEY_DOWN,keyDownListener);
		}
		
		function keyDownListener(e:KeyboardEvent):void {
			
			trace("e.keyCode=" + e.keyCode);
			
			if (e.keyCode==77) {
				trace("M pressed in menu screen");
				gameLoop.dispatchSoundMuteEvent();
			}
			
			if (e.keyCode==32 || e.keyCode==13){ 
				trace("space pressed");
				removeListeners();
				gameLoop.soundManager.menuMoveSelect();
				switch (currentIndex) {
				
				case 0:
					//instructions
					trace("instructions game chosen");
					
					gameLoop.menuScreenFinished(GameLoop.STATE_SYSTEM_INSTRUCTIONS);
					break;
				case 1:
					//credits
					trace("credits chosen");
					gameLoop.menuScreenFinished(GameLoop.STATE_SYSTEM_TITLE);
					break;
				case 2: 
					//code
					trace("code chosen");
					gameLoop.menuScreenFinished(GameLoop.STATE_SYSTEM_CODECREEN);
					break;
				case 3:
					//restart
					gameLoop.menuScreenFinished(GameLoop.STATE_SYSTEM_RESTART);
					break;
				case 4:
					//play
					trace("play game chosen");
					gameLoop.menuScreenFinished(GameLoop.STATE_SYSTEM_GAMEPLAY);
					break;
				}
				
			}else if (e.keyCode==38) {
				currentIndex--;
				if (currentIndex < 0) {
					currentIndex = aItem.length-1;	
					}
				refreshMenu();
				gameLoop.soundManager.menuMove();
			}else if (e.keyCode==40) {
				currentIndex++;
				if (currentIndex == aItem.length) {
					currentIndex = 0;
				}
				refreshMenu();
				gameLoop.soundManager.menuMove();
			}
		}
	
	} // end class

} // end package