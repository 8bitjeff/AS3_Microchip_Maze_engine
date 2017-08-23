/**
* ...
* @author Default
* @version 0.1
*/

package {

	import flash.events.*;
	import GamePlay;

	public class GameMessageManager {
	
		public var gamePlay:GamePlay;
		
		
		public function GameMessageManager(gp:GamePlay){
			gamePlay=gp;
			
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
			gamePlay.addEventListener(GamePlay.POWERUPPRINCESS, powerUpPrincessListener,false,0,true);
			
		}
	
		private function bonusXUpdateListener(e:Event) {
			gamePlay.createInPlayMessage(40, 50,"BigBonusX", "");
		}
		
		
		private function powerUpAttackStartListener(e:Event) :void {
			//changetext(0x009900, "Attack Enemy Started!");
			gamePlay.createInPlayMessage(40, 200,"BigAttack", "");
		}
		
		private function powerUpAttackEndListener(e:Event) :void {
			//changetext(0xee0000, "Attack Enemy Ended!");
		}
		
		private function accTimerEndListener(e:Event) :void {
			//changetext(0xee0000, "Freeze Ended!");
		}
		
		private function invTimerEndListener(e:Event) :void {
			//changetext(0xee0000, "Protect Ended!");
		}
		
		
		private function playerStartListener(e:Event) {
			//changetext(0x009900, "GO!");
			gamePlay.createInPlayMessage(160, 200,"BigGO", "");
		}
	
		private function playerDieListener(e:Event):void {
			//changetext(0xee0000, "Ouch!");
			//gamePlay.createInPlayMessage(85, 200,"BigMessage1", "ouch!");
		}
		
		private function playerOutStartedListener(e:Event):void {
			//changetext(0x009900, "Level Complete!");
			//gamePlay.createInPlayMessage(85, 200,"BigMessage1", "complete");
		}
		
		private function accTimerStartListener(e:Event):void {
			//changetext(0x00ee00, "Power Up Freeze!");
			gamePlay.createInPlayMessage(40, 100,"BigFreeze", "");
		}
		
		private function accTimerToEndListener(e:Event):void {
			//changetext(0x0000ee, "Freeze about to end!");
		}
		
		private function powerUpAttackAboutToEndListener(e:Event):void {
			//changetext(0x0000ee, "Attack about to end!");
		}
		
		private function invTimerStartListener(e:Event):void {
			gamePlay.createInPlayMessage(40, 150,"BigProtect", "");
		}
		
		private function invTimerAboutToEndListener(e:Event):void {
			//changetext(0x0000ee, "Protect about to end!");
		}
		
		private function keyEatenListener(e:Event):void {
			gamePlay.createInPlayMessage(40, 250,"BigKey", "");
		}
		
		private function transportStartListener(e:Event):void {
			gamePlay.createInPlayMessage(85, 300,"BigTransport", "");
		}
		
		private function powerUpKillAllListener(e:Event):void {
			gamePlay.createInPlayMessage(20, 250,"BigKill", "");
		}
		
		private function playerDeathCompleteListener(e:Event) :void {
			//death
		}
		
		private function powerUpPrincessListener(e:Event):void {
			gamePlay.createInPlayMessage(0, 300,"BigPrincess", "");
		}
		
		
		
		
		
	
		
		
		
	}
	
}