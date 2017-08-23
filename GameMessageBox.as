/**
* ...
* @author Default
* @version 0.1
*/

package {

	import flash.events.*;
	import GamePlay;
	import flash.filters.GlowFilter;
	import flash.geom.*;
	import flash.text.TextField;
	import flash.text.TextFormat;

	public class GameMessageBox {
		private var lifeSpan:int=60;
		private var lifeCount:int=0;
		private var gamePlay:GamePlay;
		private var glowfilter=new GlowFilter();
		private var glowFilterrect:Rectangle;
		private var format:TextFormat=new TextFormat();
	
		
		
		public function GameMessageBox(gp:GamePlay){
			gamePlay=gp;
			gamePlay.addEventListener(GamePlay.UPDATE, updateListener,false,0,true);
			gamePlay.scorePanel.addEventListener(GamePlay.POWERUPATTACKSTART, powerUpAttackStartListener,false,0,true);
			gamePlay.scorePanel.addEventListener(GamePlay.POWERUPATTACKEND, powerUpAttackEndListener,false,0,true);
			gamePlay.addEventListener(GamePlay.PLAYERSTART, playerStartListener,false,0,true);
			gamePlay.addEventListener(GamePlay.PLAYERDEATHCOMPLETE,playerDeathCompleteListener,false,0,true);
			gamePlay.addEventListener(GamePlay.PLAYERDIE,playerDieListener,false,0,true);
			gamePlay.addEventListener(GamePlay.PLAYEROUTSTARTED,playerOutStartedListener,false,0,true);
			gamePlay.addEventListener(GamePlay.ACCTIMERSTART, accTimerStartListener,false,0,true);
			gamePlay.scorePanel.addEventListener(GamePlay.ACCTIMERABOUTTOEND, accTimerToEndListener,false,0,true);
			gamePlay.scorePanel.addEventListener(GamePlay.POWERUPATTACKABOUTOEND, powerUpAttackAboutToEndListener,false,0,true);
			gamePlay.addEventListener(GamePlay.INVTIMERSTART, invTimerStartListener,false,0,true);
			gamePlay.scorePanel.addEventListener(GamePlay.INVTIMERABOUTTOEND, invTimerAboutToEndListener,false,0,true);
			gamePlay.addEventListener(GamePlay.TRANSPORTSTART, transportStartListener,false,0,true);
			gamePlay.addEventListener(GamePlay.KEYEATEN, keyEatenListener,false,0,true);
			gamePlay.scorePanel.addEventListener(GamePlay.ACCTIMEREND, accTimerEndListener,false,0,true);
			gamePlay.scorePanel.addEventListener(GamePlay.INVTIMEREND, invTimerEndListener,false,0,true);
			gamePlay.addEventListener(GamePlay.POWERUPKILLALL, powerUpKillAllListener,false,0,true);
			gamePlay.player.addEventListener(GamePlay.INCREMENTBONUSX, bonusXUpdateListener,false,0,true);
			
			
			
			gamePlay.gameLoop.background_mc.messageBox_txt.autoSize="center";
			//glowfilter=new GlowFilter(0xffffff, 1,  3,  3,  2, 2, false, false);
			//gamePlay.gameLoop.background_mc.messageBox_txt.filters= [glowfilter];
			format.letterSpacing=4;
			
			
			
		}
	
		private function bonusXUpdateListener(e:Event) {
			changetext(0x009900, "Bonus Multiplier Increase!");
		}
		
		
		private function powerUpAttackStartListener(e:Event) :void {
			changetext(0x009900, "Attack Enemy Started!");
			gamePlay.createInPlayMessage(85, 200,"messageBox", "ATTACK!");
		}
		
		private function powerUpAttackEndListener(e:Event) :void {
			changetext(0xee0000, "Attack Enemy Ended!");
		}
		
		private function accTimerEndListener(e:Event) :void {
			changetext(0xee0000, "Freeze Ended!");
		}
		
		private function invTimerEndListener(e:Event) :void {
			changetext(0xee0000, "Protect Ended!");
		}
		
		
		private function playerStartListener(e:Event) {
			changetext(0x009900, "GO!");
		}
		
		private function playerDeathCompleteListener(e:Event):void {
			clearMessage();
			lifeCount=0;
		}
		
		private function playerDieListener(e:Event):void {
			changetext(0xee0000, "Ouch!");
		}
		
		private function playerOutStartedListener(e:Event):void {
			changetext(0x009900, "Level Complete!");
		}
		
		private function accTimerStartListener(e:Event):void {
			changetext(0x00ee00, "Power Up Freeze!");
		}
		
		private function accTimerToEndListener(e:Event):void {
			changetext(0x0000ee, "Freeze about to end!");
		}
		
		private function powerUpAttackAboutToEndListener(e:Event):void {
			changetext(0x0000ee, "Attack about to end!");
		}
		
		private function invTimerStartListener(e:Event):void {
			changetext(0x009900, "Power Up Protect!");
		}
		
		private function invTimerAboutToEndListener(e:Event):void {
			changetext(0x0000ee, "Protect about to end!");
		}
		
		private function keyEatenListener(e:Event):void {
			changetext(0x009900, "Doors Open!");
		}
		
		private function transportStartListener(e:Event):void {
			changetext(0x009900, "Transport!");
		}
		
		private function powerUpKillAllListener(e:Event):void {
			changetext(0x009900, "Got em all!");
		}
		
		
		private function changetext(colorval:Number, textval:String): void {
			format.color=colorval;
			gamePlay.gameLoop.background_mc.messageBox_txt.text=textval;
			gamePlay.gameLoop.background_mc.messageBox_txt.setTextFormat(format);
			lifeCount=0;
		}
		
		
		private function updateListener(e:Event):void {
			update();
		}
		
		public function clearMessage():void {
			//trace("clearing message");
			gamePlay.gameLoop.background_mc.messageBox_txt.text="";
		}
		
		
		public function update() {
			
			
			
			lifeCount++;
			//trace("message life count=" + lifeCount);
			if (lifeCount > lifeSpan) {
				clearMessage();
				lifeCount=0;
			}
			
		}
	}
	
}