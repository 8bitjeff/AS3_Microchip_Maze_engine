/**
* ...
* @author Jeff Fulton
* @version 0.1
*/

package  {
	import flash.events.*;
	import flash.media.Video;
	import GamePlay;


	public class LevelOutScreen extends EventDispatcher{
		
		private var gamePlay:GamePlay;
		public var levelOutScreen:levelOutScreen_mc;
		public var framesBeforeFade:int=60;
		public var framesToFade:int=30;
		public var frameCount:int=0;
		public var fadeCount:int=0;
		public var fadeStarted:Boolean=false;
		public var started:Boolean=false;
		private var fadeAmountPerFrame:Number;
		private var currentState:int;
		private var bonusTime:int;
		private var bonusTimeScore:int=0;
		private var attackBonusScore:int=0;
		private var attackBonusCounter:int=0;
		private var attackBonusRemainder:int=0;
		private var attackBonusDivisor:int=0;
		private var attackBonusCountVal:int=0;
		private var bonusX:int;
		private var bonusXCounter:int=0;
		private var startWait:int;
		private var endWait:int;
		private var startWaitCount:int;
		private var endWaitCount:int;
		private var totalBonus:int=0;
		
		//states
		public static const STATE_TIME_BONUS=1;
		public static const STATE_ATTACK_BONUS=2;
		public static const STATE_BONUS_MULTIPLIER=3;
		public static const STATE_BONUS_TOTAL =4;
		public static const STATE_EARN_EXTRA =5;
		public static const STATE_WAIT_FOR_SPACEBAR = 6;
		
		//time bonus
		private var timeBonusStarted:Boolean=false;
		private var timeBonusCountComplete:Boolean=false;
		
		//attach bonus
		private var attackBonusStarted:Boolean=false;
		private var attackBonusCountComplete:Boolean=false;
		
		//bonus multiplier
		private var bonusMultiplierStarted:Boolean=false;
		
		//bonus total
		private var bonusTotalStarted:Boolean=false;
		
		//earn extra man
		private var earnExtraStarted:Boolean=false;
		
		//events
		public static const COMPLETE:String = "complete";
		
		//*** optimization vars
		var seconds:int;
		var minutes:int;
		var timeString:String;
		var num1:String;
		var colon:String;
		var num2:String;
		var num3:String;
		
		public function LevelOutScreen(gp:GamePlay) {
			gamePlay=gp;
			levelOutScreen=new levelOutScreen_mc();
			levelOutScreen.x=50;
			levelOutScreen.y=50;
			fadeAmountPerFrame=1/framesToFade;
			//gamePlay.addEventListener(GamePlay.LEVELOUTUPDATE, updateListener,false,0,true);
		}
		
		public function start():void {
			
			trace("level out  started");
			gamePlay.addEventListener(GamePlay.LEVELOUTUPDATE, updateListener,false,0,true);
			gamePlay.gameLoop.stage.addEventListener(KeyboardEvent.KEY_DOWN,keyDownListener,false,0,true);
			
			trace("1");
			setBonusTimeScore("000000");
			setAttackBonusScore("000000");
			setTotalBonusCount("00000000");
			setBonusX("00");
			levelOutScreen.timeBonus_mc.visible=false;
			levelOutScreen.bonusTimeCtr_mc.visible=false;
			levelOutScreen.bonusTimeScoreCounter_mc.visible=false;
			levelOutScreen.attackBonus_mc.visible=false;
			levelOutScreen.attackBonusCounter_mc.visible=false;
			levelOutScreen.bonusMultiplier_mc.visible=false;
			levelOutScreen.bonusX_mc.visible=false;
			levelOutScreen.totalBonus_mc.visible=false;
			levelOutScreen.totalBonusCount_mc.visible=false;
			levelOutScreen.extra_mc.visible=false;
			levelOutScreen.pumpkin_mc.visible=false;
			levelOutScreen.amountneeded_mc.visible=false;
			trace("2");
			gamePlay.gameLoop.addChild(levelOutScreen);
			fadeStarted=false;
			frameCount=0;
			fadeCount=0;
			started=true;
			trace("3");
			
			timeBonusStarted=false;
			attackBonusStarted=false;
			bonusMultiplierStarted=false;
			bonusTotalStarted=false;
			earnExtraStarted=false;
			trace("4");
			bonusTimeScore=0;
			bonusTime=0;
			attackBonusStarted=false;
			attackBonusScore=0;
			attackBonusCounter=0;
			attackBonusRemainder=0;
			attackBonusDivisor=0;
			attackBonusCountVal=0;
			bonusMultiplierStarted=false;
			bonusX=0;
			bonusXCounter=0;
			totalBonus=0;
			trace("5");
			
			currentState=STATE_TIME_BONUS;
			}
		
		public function getstarted():Boolean {
			return started;
		}
		
		private function updateListener (e:Event):void {
			switch (currentState) {
				
				case STATE_TIME_BONUS:
					timeBonus()
					break;
				case STATE_ATTACK_BONUS:
					
					attackBonus();
					break;
				case STATE_BONUS_MULTIPLIER:
					
					bonusMultiplier();
					break;
				case STATE_BONUS_TOTAL:
					bonusTotal();
					break;
				case STATE_EARN_EXTRA:
					earnExtra();
					break;
				}
		}
	
		public function completed() {
			////trace("completed");
			removeFromScreen();
			dispatchEvent(new Event(COMPLETE));	
		}
		
		private function timeBonus():void {
			//trace("6");
			if (!timeBonusStarted) {
				bonusTime=gamePlay.scorePanel.bonusTime;
				trace("bonusTime=" + bonusTime);
				levelOutScreen.bonusTimeScoreCounter_mc.visible=true;
				levelOutScreen.timeBonus_mc.visible=true;
				levelOutScreen.bonusTimeCtr_mc.visible=true;
				setTimeMCs(convertMillisecondsToTimeString(bonusTime));
				dispatchEvent(new Event(GamePlay.LEVELOUTCOUNTTIMEBONUS));
				//gamePlay.gameLoop.soundManager.playPop1();
				timeBonusStarted=true;
				startWaitCount=0;
				endWaitCount=0;
				startWait=30;
				endWait=45;
				timeBonusCountComplete=false;
			}else{
				startWaitCount++;
				if (startWaitCount > startWait && !timeBonusCountComplete) {
					//trace("bonusTime=" + bonusTime);
					if (bonusTime >0) {
						bonusTime-=1000;
						setTimeMCs(convertMillisecondsToTimeString(bonusTime));
						bonusTimeScore+=gamePlay.gettimeBonus();
						trace("bonusTimeScore=" + bonusTimeScore);
						setBonusTimeScore(String(bonusTimeScore));
						//levelOutScreen.bonusTimeScoreCounter_txt.text=bonusTimeScore.toString();
						gamePlay.gameLoop.soundManager.playBonusCount();
					}else{
						//levelOutScreen.bonusTimeScoreCounter_txt.text="0";
					}
						
					if (bonusTime <= 0) {
						timeBonusCountComplete=true;
					}
				}else if (timeBonusCountComplete) {
					
					endWaitCount++
					if (endWaitCount > endWait) {
						totalBonus+=bonusTimeScore;
						currentState=STATE_ATTACK_BONUS;
					} // end if (endWaitCount > endWait) {
				} // end (timeBonusCountComplete)
			} // end if (!timeBonusStarted) {
		} // end function
		
		private function attackBonus():void {
			if (!attackBonusStarted) {
				levelOutScreen.attackBonus_mc.visible=true;
				levelOutScreen.attackBonusCounter_mc.visible=true;
				trace("starting attack bonus");
				attackBonusScore=gamePlay.getPlayerattackBonus();
				trace("attackBonusScore=" + attackBonusScore);
				attackBonusCountVal=attackBonusScore / 100;
				trace("attackBonusCountVal=" + attackBonusCountVal);
				attackBonusStarted=true;
				attackBonusRemainder=attackBonusScore % attackBonusCountVal;
				attackBonusDivisor=attackBonusScore / attackBonusCountVal;
				setAttackBonusScore(String(attackBonusCounter));
				//levelOutScreen.attackBonusCounter_txt.text=String(attackBonusCounter);
				gamePlay.gameLoop.soundManager.playPop1();
				startWaitCount=0;
				endWaitCount=0;
				startWait=30;
				endWait=45;
				attackBonusCountComplete=false;
			}else{
				startWaitCount++;
				if (startWaitCount > startWait && !attackBonusCountComplete) {
					attackBonusCounter+=attackBonusCountVal;
					//levelOutScreen.attackBonusCounter_txt.text=String(attackBonusCounter);
					setAttackBonusScore(String(attackBonusCounter));
					gamePlay.gameLoop.soundManager.playBonusCount();
					if (attackBonusCounter == attackBonusCountVal * attackBonusDivisor) {
						attackBonusCountComplete=true;
						trace("attackBonusCountComplete=true");
						if (attackBonusRemainder > 0) {
							attackBonusCounter += attackBonusRemainder;
							//levelOutScreen.attackBonusCounter_txt.text=String(attackBonusCounter);
							setAttackBonusScore(String(attackBonusCounter));
							gamePlay.gameLoop.soundManager.playBonusCount();
						}
					
					}
				}else if (attackBonusCountComplete) {
					
					endWaitCount++
					if (endWaitCount > endWait) {
						totalBonus+=attackBonusCounter;
						currentState=STATE_BONUS_MULTIPLIER;
					}
				}
			}
		}
		
		private function bonusMultiplier():void {
			if (!bonusMultiplierStarted) {
				bonusX=gamePlay.getPlayerbonusX()
				trace("bounsX=" + bonusX);
				levelOutScreen.bonusMultiplier_mc.visible=true;
				levelOutScreen.bonusX_mc.visible=true;
				//levelOutScreen.bonusX_txt.text="X" + String(bonusX);
				setBonusX(String(bonusX));
				bonusMultiplierStarted=true;
				gamePlay.gameLoop.soundManager.playPop1();
				
				endWaitCount=0;
				endWait=45;
				
			}else{
				endWaitCount++
				if (endWaitCount > endWait) {
					currentState=STATE_BONUS_TOTAL;
				}
			}
		}
		
		private function bonusTotal():void {
			if (!bonusTotalStarted) {
				totalBonus*=bonusX;
				levelOutScreen.totalBonus_mc.visible=true;
				levelOutScreen.totalBonusCount_mc.visible=true;
				levelOutScreen.amountneeded_mc.visible=true;
				levelOutScreen.amountneeded_mc.amount_txt.text=String(gamePlay.getextraManAmount());
				//levelOutScreen.totalBonusCounter_txt.text= String(totalBonus);
				setTotalBonusCount(String(totalBonus));
				bonusTotalStarted=true;
				gamePlay.gameLoop.soundManager.playPop1();
				
				endWaitCount=0;
				endWait=30;
				gamePlay.player.incrementscore(totalBonus);
				gamePlay.scorePanel.updateScore(gamePlay.player.score);
			}else{
				endWaitCount++
				if (endWaitCount > endWait) {
					currentState=STATE_EARN_EXTRA;
				}
			}
		}
			
		private function earnExtra():void {
			if (!earnExtraStarted) {
				earnExtraStarted=true;
				if (totalBonus >=gamePlay.getextraManAmount()) {
				levelOutScreen.pumpkin_mc.visible=true;
				levelOutScreen.extra_mc.visible=true;
				gamePlay.gameLoop.soundManager.playPlayerStart();
				gamePlay.player.incrementlives(1);
				
				endWaitCount=0;
				endWait=60;
			}
			}else{
				endWaitCount++
				if (endWaitCount > endWait) {
					trace("still running");
					started=false;
					//dispatchEvent(new Event(COMPLETE));	
					completed();
				}
			}
		}
		
		
		function convertMillisecondsToTimeString(timeval:int):String {
			////trace("converttime in: " + timeval);
			seconds=Math.floor(timeval/1000);
			////trace("step 1 seconds =" + seconds);
			minutes=Math.floor(seconds/60);
			////trace("step minutes=" + minutes);
			seconds-=minutes*60;
			////trace("step 3 seconds - monutes=" + seconds);
			timeString=minutes+":"+String(seconds+100).substr(1,2);
			////trace("step 4 timeString=" + timeString);
			return(timeString);
			////trace("converttime out: " + timeString);
		}
		
		function removeFromScreen(){
			gamePlay.gameLoop.stage.removeEventListener(KeyboardEvent.KEY_DOWN,keyDownListener);
			gamePlay.removeEventListener(GamePlay.LEVELOUTUPDATE, updateListener);
			gamePlay.gameLoop.removeChild(levelOutScreen);
			started=false;
			levelOutScreen.alpha=1;
			
		}
		
		function keyDownListener(e:KeyboardEvent):void {
			
			trace("e.keyCode=" + e.keyCode);
			
			if (e.keyCode==77) {
				trace("M pressed in level out");
				gamePlay.gameLoop.dispatchSoundMuteEvent();
			}
		}
		
		
		function setTimeMCs(timeString:String):void {
			
			//trace("setLevelNumMcs");
			num1=timeString.substr(0,1);
			colon=timeString.substr(1,1);
			num2=timeString.substr(2,1);
			num3=timeString.substr(3,1);
			//trace("timeString=" + timeString);
			//trace("num1=" + num1);
			//trace("colon=" + colon);
			//trace("num3=" + num2);
			//trace("num4=" + num3);
			
			if (num1 != null) {
				levelOutScreen.bonusTimeCtr_mc.number1.gotoAndStop("num" + num1);
			}
			if (num2 != null) {
				levelOutScreen.bonusTimeCtr_mc.number2.gotoAndStop("num" + num2);
			}
			if (num3 != null) {
				levelOutScreen.bonusTimeCtr_mc.number3.gotoAndStop("num" + num3);
			}
		}
		
		function setBonusTimeScore(bonusString:String):void {
	
			if (bonusString.length >0) 	levelOutScreen.bonusTimeScoreCounter_mc.number1.gotoAndStop("num" + bonusString.substr(bonusString.length-1,1));
			if (bonusString.length >1) 	levelOutScreen.bonusTimeScoreCounter_mc.number2.gotoAndStop("num" + bonusString.substr(bonusString.length-2,1));
			if (bonusString.length >2) 	levelOutScreen.bonusTimeScoreCounter_mc.number3.gotoAndStop("num" + bonusString.substr(bonusString.length-3,1));
			if (bonusString.length >3) 	levelOutScreen.bonusTimeScoreCounter_mc.number4.gotoAndStop("num" + bonusString.substr(bonusString.length-4,1));
			if (bonusString.length >4) 	levelOutScreen.bonusTimeScoreCounter_mc.number5.gotoAndStop("num" + bonusString.substr(bonusString.length-5,1));
			if (bonusString.length >5) 	levelOutScreen.bonusTimeScoreCounter_mc.number6.gotoAndStop("num" + bonusString.substr(bonusString.length-6,1));
		}
		
		function setAttackBonusScore(bonusString:String):void {
			
			if (bonusString.length >0) 	levelOutScreen.attackBonusCounter_mc.number1.gotoAndStop("num" + bonusString.substr(bonusString.length-1,1));
			if (bonusString.length >1) 	levelOutScreen.attackBonusCounter_mc.number2.gotoAndStop("num" + bonusString.substr(bonusString.length-2,1));
			if (bonusString.length >2) 	levelOutScreen.attackBonusCounter_mc.number3.gotoAndStop("num" + bonusString.substr(bonusString.length-3,1));
			if (bonusString.length >3) 	levelOutScreen.attackBonusCounter_mc.number4.gotoAndStop("num" + bonusString.substr(bonusString.length-4,1));
			if (bonusString.length >4) 	levelOutScreen.attackBonusCounter_mc.number5.gotoAndStop("num" + bonusString.substr(bonusString.length-5,1));
			if (bonusString.length >5) 	levelOutScreen.attackBonusCounter_mc.number6.gotoAndStop("num" + bonusString.substr(bonusString.length-6,1));
			if (bonusString.length >5) 	levelOutScreen.attackBonusCounter_mc.number6.gotoAndStop("num" + bonusString.substr(bonusString.length-6,1));
		}
		
		function setBonusX(bonusString:String):void {
			if (bonusString.length >0) 	{
				levelOutScreen.bonusX_mc.number1.gotoAndStop("num" + bonusString.substr(bonusString.length-1,1));
				
				
			}
			if (bonusString.length >1) 	{
				levelOutScreen.bonusX_mc.number2.gotoAndStop("num" + bonusString.substr(bonusString.length-2,1));
				
			}
			
		}
		
		function setTotalBonusCount(bonusString:String):void {
			
			if (bonusString.length >0) 	levelOutScreen.totalBonusCount_mc.number1.gotoAndStop("num" + bonusString.substr(bonusString.length-1,1));
			if (bonusString.length >1) 	levelOutScreen.totalBonusCount_mc.number2.gotoAndStop("num" + bonusString.substr(bonusString.length-2,1));
			if (bonusString.length >2) 	levelOutScreen.totalBonusCount_mc.number3.gotoAndStop("num" + bonusString.substr(bonusString.length-3,1));
			if (bonusString.length >3) 	levelOutScreen.totalBonusCount_mc.number4.gotoAndStop("num" + bonusString.substr(bonusString.length-4,1));
			if (bonusString.length >4) 	levelOutScreen.totalBonusCount_mc.number5.gotoAndStop("num" + bonusString.substr(bonusString.length-5,1));
			if (bonusString.length >5) 	levelOutScreen.totalBonusCount_mc.number6.gotoAndStop("num" + bonusString.substr(bonusString.length-6,1));
			if (bonusString.length >6) 	levelOutScreen.totalBonusCount_mc.number7.gotoAndStop("num" + bonusString.substr(bonusString.length-7,1));
			if (bonusString.length >7) 	levelOutScreen.totalBonusCount_mc.number8.gotoAndStop("num" + bonusString.substr(bonusString.length-8,1));
		}
		
		
	} // end class

} // end package