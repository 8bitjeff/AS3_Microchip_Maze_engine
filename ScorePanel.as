/**
* ...
* @author Jeff Fulton
* @version 0.1
*/

package  {
	import flash.display.Sprite;
	import flash.events.*;
	
	import GamePlay;
	import flash.utils.Timer;

	public class ScorePanel extends Sprite {
		
		private var gamePlay:GamePlay;
		public var frameTimer:Timer;
		public var framesCounted:int=0;
		public var scorePanel:scorePanel_mc;
		
		//bonus timer
		public var bonusTimerStarted:Boolean=false;
		public var bonusTime:int=0;
		
		//attacktimer
		public var attackTimerStarted:Boolean=false;
		public var attackTime:int;
		
		//accelerationtimer
		public var accTimerStarted:Boolean=false;
		public var accTime:int=0;
		
		//invincibletimer
		public var invTimerStarted:Boolean=false;
		public var invTime:int=0;
		
		var soundMute:Boolean=false;
		public var gameLoop:GameLoop;
		
		
		public function ScorePanel(gameLoopval:GameLoop) {
			gameLoop=gameLoopval;
			gameLoop.addEventListener(GameLoop.SOUNDMUTE, soundMuteListener,false,0,true);
			scorePanel=new scorePanel_mc();
			scorePanel.x=480;
			scorePanel.y=1;
			addChild(scorePanel);
			frameTimer= new Timer(1000,0);
			frameTimer.addEventListener(TimerEvent.TIMER,frameCounter,false,0,true);
			frameTimer.start();
		}
		
		public function setGamePlay(gp:GamePlay) {
			gamePlay=gp;
		}
		
		public function addGamePlayEventListeners():void {
			gamePlay.addEventListener(GamePlay.UPDATE, updateListener,false,0,true);
			gamePlay.player.addEventListener(GamePlay.BONUSXUPDATE, playerbonusupdateListener,false,0,true);
			gamePlay.addEventListener(GamePlay.PLAYERSTART, playerStartListener,false,0,true);
			gamePlay.addEventListener(GamePlay.PLAYERDEATHSTARTED, playerdeathStartedListener,false,0,true);
			gamePlay.addEventListener(GamePlay.PLAYEROUTSTARTED, playeroutStartedListener,false,0,true);
			gamePlay.addEventListener(GamePlay.ACCTIMERSTART, accTimerStartListener,false,0,true);
			gamePlay.addEventListener(GamePlay.INVTIMERSTART, invTimerStartListener,false,0,true);
			gamePlay.addEventListener(GamePlay.PAUSEDSTARTED, pauseStartedListener,false,0,true);
			gamePlay.pausedScreen.addEventListener(PausedScreen.COMPLETE, pauseEndedListener,false,0,true);
		}
		
		
		public function soundMuteListener(e:Event) {
			trace("score Panel got mute event");
			if (soundMute) {
				scorePanel.mute_mc.gotoAndStop("sound");
				soundMute=false;
			}else{
				scorePanel.mute_mc.gotoAndStop("mute");
				soundMute=true;
			}
		}
		
		
		private function accTimerStartListener(e:Event) {
			trace("score panel accTimerStartListener");
			accTimerStart();
			updateAccTimer();
		}
		
		
		
		
		private function invTimerStartListener(e:Event) {
			trace("score panel invTimerStartListener");
			invTimerStart();
			updateInvTimer();
		}
		
		private function pauseStartedListener(e:Event):void {
			frameTimer.stop();
		}
		
		private function pauseEndedListener(e:Event):void {
			frameTimer.start();
		}
		
		private function updateListener (e:Event):void {
			countFrames();
			
		}
		
		private function playeroutStartedListener(e:Event):void {
			bonusTimerStop();
			resetAttackTimer();
			resetAccTimer();
			resetInvTimer();
		}
		
		private function playerdeathStartedListener(e:Event):void {
			bonusTimerStop();
			//bonusTimerStarted=false;
			resetAttackTimer();
			resetInvTimer();
			resetAccTimer();
		}
		
		private function playerbonusupdateListener(e:Event):void {
			updateBonusX();
		}
		
		private function playerStartListener(e:Event):void {
				bonusTimerStart();
		}
		
		
		public function bonusTimerSet(timeVal:int):void {
			bonusTime=timeVal;
		
		}
		
	 	public function bonusTimerStart():void {
			bonusTimerStarted=true;
		}
		
		public function bonusTimerStop():void{
			bonusTimerStarted=false;
		}
		
		public function attackTimerStop():void{
			attackTimerStarted=false;
		}
		
		public function accTimerStart():void {
			accTimerStarted=true;
			
		}
		
		public function invTimeIncrement(val:int):void{
			invTime+=val;
		}
		
		public function accTimerStop():void{
			accTimerStarted=false;
			
		}
		
		public function invTimerStart():void {
			invTimerStarted=true;
			gamePlay.player.invincible=true;
		}
		
		public function invTimerStop():void{
			invTimerStarted=false;
			gamePlay.player.invincible=false;
		}
		
		public function accTimeIncrement(val:int):void{
			accTime+=val;
		}
		
		public function updateBonusTimer(){
			if (bonusTimerStarted) {
				bonusTime-=1000;
				if (bonusTime < 0) {
					bonusTime=0;
					bonusTimerStarted=false;
				}
				updateBonusTime();
			}
		}
	
		
		public function attackTimerStart(timeVal:int) {
			if (attackTimerStarted) {
				attackTime+=timeVal;
			}else{//pass in milliseconds
				attackTimerStarted=true;
				attackTime=timeVal;
					
			}
			dispatchEvent(new Event(GamePlay.POWERUPATTACKSTART));
		}
		
		public function updateAttackTimer(){
			if (attackTimerStarted) {
				attackTime-=1000;
				if (attackTime < 0) {
					attackTime=0;
					dispatchEvent(new Event(GamePlay.POWERUPATTACKEND));
					attackTimerStarted=false;
				}else if (attackTime == 2000) {
					dispatchEvent(new Event(GamePlay.POWERUPATTACKABOUTOEND));
				}
					
				updateAttackTime();
			}
		}
		
		public function updateAccTimer(){
			if (accTimerStarted) {
				accTime-=1000;
				if (accTime < 0) {
					accTime=0;
					dispatchEvent(new Event(GamePlay.ACCTIMEREND));
					trace("score panel dispatch accertime end event");
					accTimerStop();
				}else if (accTime == 2000) {
					dispatchEvent(new Event(GamePlay.ACCTIMERABOUTTOEND));
				}
				updateAccTime();
			}
		}
		
		
		public function updateInvTimer(){
			if (invTimerStarted) {
				invTime-=1000;
				if (invTime < 0) {
					invTime=0;
					dispatchEvent(new Event(GamePlay.INVTIMEREND));
					invTimerStop();
				}else if (invTime == 2000) {
					dispatchEvent(new Event(GamePlay.INVTIMERABOUTTOEND));
				}
				scorePanel.invtimer_txt.text=convertMillisecondsToTimeString(invTime);
			}
		}
	
		function frameCounter(e:TimerEvent) {
			//////////trace("timer event");
			////////trace("framesCounted=" + framesCounted.toString());
			scorePanel.frameCount_txt.text=framesCounted.toString();
			framesCounted=0;
			updateBonusTimer();
			updateAttackTimer();
			updateInvTimer();
			updateAccTimer();
		}
		
		function updateLevel(levelVal:int) {
			////////trace("score panel level=" + levelVal);
			scorePanel.level_txt.text = levelVal.toString();
		}
		
		function updateLives(livesVal:int) {
			////////trace("score panel level=" + livesVal);
			scorePanel.lives_txt.text = livesVal.toString();
		}
		
		function updateScore(scoreVal:int) {
			////trace("scorePanel.updateScore start");
			scorePanel.score_txt.text = scoreVal.toString();
			////trace("scorePanel.updateScore end");
		}
		
		function updateBonusTime():void {
			////////trace("bonusTime=" + bonusTime);
			scorePanel.bonustimer_txt.text=convertMillisecondsToTimeString(bonusTime);
		}
		
		function updateAttackTime():void {
			////////trace("bonusTime=" + bonusTime);
			scorePanel.attacktimer_txt.text=convertMillisecondsToTimeString(attackTime);
		}
		
		
		function updateAccTime():void {
			////trace("updateAccTime start");
			scorePanel.acctimer_txt.text=convertMillisecondsToTimeString(accTime);
			////trace("updateAccTime end");
		}
		
		function updateInvTime():void {
			////////trace("bonusTime=" + bonusTime);
			scorePanel.invtimer_txt.text=convertMillisecondsToTimeString(invTime);
		}
		
		function updateBonusX():void {
			scorePanel.bonusx_txt.text=String(gamePlay.getPlayerbonusX());
			
		}
		
		function convertMillisecondsToTimeString(timeval:int):String {
			////////trace("converttime in: " + timeval);
			var seconds:int=Math.floor(timeval/1000);
			////////trace("step 1 seconds =" + seconds);
			var minutes:int=Math.floor(seconds/60);
			////////trace("step minutes=" + minutes);
			seconds-=minutes*60;
			////////trace("step 3 seconds - monutes=" + seconds);
			var timeString:String=minutes+":"+String(seconds+100).substr(1,2);
			////////trace("step 4 timeString=" + timeString);
			return(timeString);
			////////trace("converttime out: " + timeString);
		}
		
		function resetBonusTimer():void {
			bonusTimerStarted=false;
			bonusTime=0;
			updateBonusTime();
			////trace("resetBonusTimer complete");
		}
		
		function resetAttackTimer():void {
			attackTimerStarted=false;
			attackTime=0;
			updateAttackTime();
			////trace("resetAttackTimer complete");
		}
		
		function resetAccTimer():void {
			accTimerStarted=false;
			accTime=0;
			updateAccTime();
			////trace("resetAccTimer complete");
		}
		
		function resetInvTimer():void {
			invTimerStarted=false;
			invTime=0;
			updateInvTime();
			trace("resetInvTimer complete");
		}
		
		function resetAllTimers():void {
			////trace("resetting all timers");
			resetBonusTimer();
			resetAttackTimer();
			resetInvTimer();
			resetAccTimer();
			
		}
		
		
		function countFrames() {
			
			framesCounted++;
			
		}
		
	} // end class

} // end package