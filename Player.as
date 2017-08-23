/**
* ...
* @author Jeff Fulton
* @version 0.1
*/

package  {
	
	import BasicGameSprite;
	import flash.display.MovieClip;
	import flash.events.*;
	import GamePlay;
	import flash.geom.*;
	import flash.display.BitmapData;
	import flash.filters.GlowFilter;
	import flash.geom.Matrix;
	
	
	public class Player extends BasicGameSprite {
		public var moveUp:Boolean=false;
		public var moveDown:Boolean=false;
		public var moveRight:Boolean=false;
		public var moveLeft:Boolean=false;
		public var moveDeath:Boolean=false;
		public var moveErase:Boolean=false;
		public var moveFadeOut:Boolean=false;
		public var moveStop:Boolean=false;
		public var moveTransport:Boolean=false;
		public var turning:Boolean=false;
		public var hitx:int;
		public var hity:int;
		public var hittilerow:int;
		public var hittilecol:int;
		public var mapRows:int;
		public var mapCols:int;
		public var frozen:Boolean=true; // player starts in frozen state
		public var newKeyPress:Boolean=false;
		public var newKeyValue:String;
		public var deathStarted:Boolean=false;
		public var deathComplete:Boolean=false;
		public var _rotation:Number=0;
		public var leveloutComplete:Boolean=false;
		public var leveloutStarted:Boolean=false;
		public var outCounter:int=0;
		public var playerStartRow:int;
		public var playerStartCol:int;
		public var aLastBitmapDataState:Array;
		public var currentFacing:String;
		public var animatingTurn:Boolean=false; // play turn animation, not current direction animation
		public var aAnimatingTurnBitmapData:Array;
		public var turnAminationIndex:int; // count frames in turn animation before swapping to normal animation
		
		public var blinkProtect:Boolean=false;
		public var blinkProtectCount:int=0;
		public var blinkProtectMaxFrames:int=3;
		public var protectblinkon:Boolean=false;
		//transports
		public var transportStarted:Boolean=false;
		public var nextTransportLocationX:int;
		public var nextTransportLocationY:int;
		public var transRowCtr:int=0;
		public var transCurrentLocBitmapData:BitmapData;
		public var transNextLocBitmapData:BitmapData;
		//events
		
		
		//powers
		public var invincible:Boolean=false;
		public var eatEnemy:Boolean;
		public var invFilterIndex:int=0;
		public var invFilterFrameDelay:int=3; 
		public var invFilterFrameCtr:int=0;
		public var invFilterArray:Array=[];
		//score
		public var score:int;

		//lives
		public var lives:int;
		
			
		//keys and doors
		public var keys:int=0;
		
		
		//bonus
		public var bonusTimeLimit:int;
		public var bonusXCount:int=0; //
		public var attackBonus:int=0;
		public var bonusX:int=0;
		
		//filters
		public var invFilter:Boolean=false;
		
		//transports
		public var transportedThisLevel:Boolean=false;
		
		
		public function Player(gp:GamePlay) {
			////trace ("new player");
			gamePlay=gp;
			
			gamePlay.addEventListener(GamePlay.RENDER, renderListener,false,0,true);
			gamePlay.addEventListener(GamePlay.UPDATE, updateListener,false,0,true);
			gamePlay.addEventListener(GamePlay.PLAYERSTART, playerStartListener,false,0,true);
			gamePlay.addEventListener(GamePlay.PLAYERDEATHSTARTED, playerdeathStartedListener,false,0,true);
			gamePlay.addEventListener(GamePlay.INVTIMERSTART,invtimerStartListener,false,0,true);
			gamePlay.addEventListener(GamePlay.TRANSPORTSTART,transportStartListener,false,0,true);
	
		}
		
		
		public function addScorePanelListeners():void {
			gamePlay.scorePanel.addEventListener(GamePlay.ACCTIMEREND, accTimerEndListener,false,0,true);
			gamePlay.scorePanel.addEventListener(GamePlay.INVTIMEREND,invtimerEndListener,false,0,true);
			gamePlay.scorePanel.addEventListener(GamePlay.INVTIMERABOUTTOEND, invTimerAboutToEndListener,false,0,true);
			gamePlay.scorePanel.addEventListener(GamePlay.POWERUPATTACKSTART, powerUpAttackStartListener,false,0,true);
		}
		
		public function dispose():void {
			gamePlay.removeEventListener(GamePlay.RENDER, renderListener);
			gamePlay.removeEventListener(GamePlay.UPDATE, updateListener);
			gamePlay.removeEventListener(GamePlay.PLAYERSTART, playerStartListener);
			gamePlay.removeEventListener(GamePlay.PLAYERDEATHSTARTED, playerdeathStartedListener);
			gamePlay.removeEventListener(GamePlay.INVTIMERSTART,invtimerStartListener);
			gamePlay.removeEventListener(GamePlay.TRANSPORTSTART,transportStartListener);
			gamePlay.scorePanel.removeEventListener(GamePlay.ACCTIMEREND, accTimerEndListener);
			gamePlay.scorePanel.removeEventListener(GamePlay.INVTIMEREND,invtimerEndListener);
			gamePlay.scorePanel.removeEventListener(GamePlay.INVTIMERABOUTTOEND, invTimerAboutToEndListener);
			bitmapStateObject=null;
			var ctr1:int;
			for (ctr1=0;ctr1<aSpriteBitmapData.length;ctr1++) {
				aSpriteBitmapData[ctr1]=null
			}
			aSpriteBitmapData=null;
		}
		
		
		public function transportStartListener(e:Event) {
			//trace("player transport start listener");
			transRowCtr=0;
			setBitmapState(GamePlay.MOVE_STATE_TRANSPORT, aSpriteBitmapData);
			resetMovement(GamePlay.MOVE_STATE_TRANSPORT);
			transCurrentLocBitmapData=aSpriteBitmapData[spriteBitmapDataIndex].clone();
			transNextLocBitmapData=new BitmapData(tileSize,tileSize,true,0x0000000);
			transportStarted=true;
			transportedThisLevel=true;
			//trace("end of player transport start listener");
			
		}
		
		private function invtimerStartListener(e:Event) {
			invFilter=true;
			blinkProtect=false;
			blinkProtectCount=0;
			protectblinkon=false;
			invFilterIndex=0;
			invFilterFrameCtr=0;
			
	
		}
		
		private function invTimerAboutToEndListener(e:Event) {
			blinkProtect=true;
			protectblinkon=true;
		}
		
		
		private function invtimerEndListener(e:Event) {
			//trace("**** players inv timer listener ****");
			invFilter=false;
		}
		
		private function renderListener (e:Event):void {
			render();
		}
		
		private function updateListener (e:Event):void {
			update();
		}
		
		private function powerUpAttackStartListener(e:Event) {
			accAdjust=1;
		}
		
		private function powerUpAttackEndListener(e:Event) {
			accAdjust=0;
		}
		
		private function accTimerEndListener(e:Event):void {
			//trace("player acc timer end listener");
			accAdjust=0;
		}
		
		
		private function playerStartListener(e:Event):void {
			initPosition((playerStartCol*tileSize),(playerStartRow*tileSize));
			rendervelocity=true;
			initMovement("right")
			deathStarted=false;
			blinkProtect=false;
			blinkProtectCount=0;
			protectblinkon=false;
			transportedThisLevel=false;
			accAdjust=0;
		}
		
		private function playerdeathStartedListener(e:Event):void {
			startDeath();
		}
		
		public function setNextTransportLocation(xval,yval){
			nextTransportLocationX=xval;
			nextTransportLocationY=yval;
		}
		
		
		public function setplayerStartRow(val:int):void {
			playerStartRow=val;
		}
			
		public function setplayerStartCol(val:int):void {
			playerStartCol=val;
		}
		
		public function incrementscore(val:int) {
			score+=val;
		}
		
		public function getscore():int {
			return score;
		}
		
		public function getlives():int {
			return lives;
		}
		
		public function resetLevelCounters():void {
			blinkProtectCount=0;
			protectblinkon=false;
			transportStarted=false;
			eatEnemy=false;
			invFilterIndex=0;
			blinkProtect=false;
			invincible=false;
			leveloutStarted=false;
			bonusTimeLimit=0;
			bonusXCount=0; //
			attackBonus=0;
			setbonusX(1);
			accAdjust=0;
			//createMoveStates();
		}
		
		public function incrementattackBonusCount(val:int):void {
			bonusXCount+=val;;
			////trace("bonusXCount=" + bonusXCount);
			if (bonusXCount >= gamePlay.getenemyToEatForBonusXPlus()) {
				setbonusX(bonusX+1);
				bonusXCount=0;
				dispatchEvent(new Event(GamePlay.INCREMENTBONUSX));
			}
		}
		
		function incrementAttackBonus(val:int):void {
			attackBonus+=val;
			
			////trace("attackBonus=" + attackBonus);
		}
		
		public function setbonusX(val:int):void {
			////trace("bonusX increase");
			bonusX=val;
			dispatchEvent(new Event(GamePlay.BONUSXUPDATE));
		}
		
		public function resetDeathCounters():void {
			blinkProtectCount=0;
			protectblinkon=false;
			transportStarted=false;
			eatEnemy=false;
			invFilterIndex=0;
			blinkProtect=false;
			invincible=false;
			bonusXCount=0; //
			setbonusX(1);
			transportedThisLevel=false;
			accAdjust=0;
			//createMoveStates();
		}
		
		public function initPosition(xval:Number,yval:Number){
			//trace("initx=" + xval);
			//trace("inity=" + yval);
			setx(xval);
			sety(yval);
			setnextx(x);
			setnexty(y);
			update();
		}
		
		public function initMovement(dir:String) {
			////trace("player init movement to: " + dir);
			//feed the bitmapdata stop state with some images - right is chosen
			aLastBitmapDataState=aSpriteBitmapData=getBitmapState(dir)
			resetMovement("stop");
			
		}
		
		public function incrementlives(val:int):void {
			lives+=val;
			gamePlay.scorePanel.updateLives(lives);
		}

		
		
		
		public function startLevelout():void {
			invFilter=false;
			
			outCounter=0;
			////trace("player.startLevelOut");
			leveloutStarted=true;
			////trace("1");
			leveloutComplete=false;
			////trace("2");
			//add the current bitmap state to the MOVE_STATE_ERASE array
			aSpriteBitmapData=getBitmapState(GamePlay.MOVE_STATE_LEVELOUT)
			setBitmapState(GamePlay.MOVE_STATE_FADEOUT, aSpriteBitmapData);
			////trace("3");
			resetMovement(GamePlay.MOVE_STATE_FADEOUT);
			////trace("player.endLevelOut");
			
		}
		
		
		
		public function startDeath():void {
			incrementlives(-1)
			gamePlay.scorePanel.updateLives(lives);
			_rotation=0;
			deathComplete=false;
			deathStarted=true;
			resetDeathCounters();
			
			//add the current bitmap state to the MOVE_STATE_ERASE array
			setBitmapState(GamePlay.MOVE_STATE_DEATH, aSpriteBitmapData);
			resetMovement(GamePlay.MOVE_STATE_DEATH);
		}
		
		
		
		public function playerDeathUpdate():void {
			////////trace("deathUpdate");
			var deathBitmapData:BitmapData=aSpriteBitmapData[spriteBitmapDataIndex];
	
			var scalefactor:Number = .95;
			_rotation+=8;
			////////trace("_rotation=" + _rotation);
			var angle_in_radians = Math.PI * 2 * (_rotation / 360);
			var rotationMatrix:Matrix = new Matrix();
			rotationMatrix.scale(scalefactor, scalefactor);
			rotationMatrix.translate(-tileSize*scalefactor/2,-tileSize*scalefactor/2);
			rotationMatrix.rotate(angle_in_radians);
			rotationMatrix.translate(tileSize*scalefactor/2,tileSize*scalefactor/2);
			var matrixImage:BitmapData = new BitmapData(tileSize, tileSize, true, 0x00000000);
			matrixImage.draw(deathBitmapData, rotationMatrix);
			aSpriteBitmapData[spriteBitmapDataIndex]=matrixImage;
			
			if (_rotation > 360) {
				if (transportedThisLevel) {
					createMoveStates();
				}
				deathComplete=true;
				resetMovement(GamePlay.MOVE_STATE_ERASE);
				
				////////trace("death complete!");
				//addRender_Update_listeners();
			}
			
		}
		
		public function playerLevelOutUpdate():void {
			////trace("player level out");
			if (outCounter<250) {
				var leveloutBitmapData:BitmapData=aSpriteBitmapData[spriteBitmapDataIndex].clone();
				var cTransform:ColorTransform = new ColorTransform();
				cTransform.alphaMultiplier = .995;
				var rect:Rectangle = new Rectangle(0, 0, tileSize, tileSize);
				leveloutBitmapData.colorTransform(rect, cTransform);
				aSpriteBitmapData[spriteBitmapDataIndex]=leveloutBitmapData;
				outCounter++;
				////trace("outCounter=" + outCounter++);
			}else{
				////trace("done with alpha");
				if (transportedThisLevel) {
					createMoveStates();
				}
				leveloutComplete=true;
				resetMovement(GamePlay.MOVE_STATE_ERASE);
			}
		}
		
		public function playerTransportUpdate():void {
			
			if (transRowCtr<32) {
				//trace("transRowCtr=" + transRowCtr);
				var newBitmapData:BitmapData=new BitmapData(tileSize,tileSize,true,0x0000000);
				var currentRec:Rectangle=new Rectangle(0,transRowCtr,tileSize,tileSize-transRowCtr);
				var currentPoint:Point=new Point(0,transRowCtr)
				newBitmapData.copyPixels(transCurrentLocBitmapData,currentRec,currentPoint);
				aSpriteBitmapData[spriteBitmapDataIndex]=newBitmapData;
				
				var nextRec:Rectangle=new Rectangle(0,0,tileSize,transRowCtr);
				var nextPoint:Point=new Point(0,0);
				transNextLocBitmapData.copyPixels(transCurrentLocBitmapData,nextRec,nextPoint);
				
				transRowCtr++;
				
			}else{
				//trace("transport complete");
				setnextx(nextTransportLocationX);
				setnexty(nextTransportLocationY);
				transportStarted=false;
				resetMovement(GamePlay.MOVE_STATE_STOP);
			}
		}
		
		
		
		public function createMoveStates() {
			var tempArray:Array=[];
			var rightTempArray:Array=[];
			var leftTempArray:Array=[];
			var upTempArray:Array=[];
			var downTempArray:Array=[];
			var eraseTempArray:Array=[];
			var deathTempArray:Array=[];
			var fadeoutTempArray:Array=[];
			var transportTempArray:Array=[];
			var uptoleftTempArray:Array=[];
			var uptorightTempArray:Array=[];
			var uptodownTempArray:Array=[];
			var downtoleftTempArray:Array=[];
			var downtorightTempArray:Array=[];
			var downtoupTempArray:Array=[];
			var lefttoupTempArray:Array=[];
			var lefttodownTempArray:Array=[];
			var lefttorightTempArray:Array=[];
			var righttoupTempArray:Array=[];
			var righttodownTempArray:Array=[];
			var righttoleftTempArray:Array=[];
			var leveloutTempArray:Array=[];
			
			
			var sourceX:int;
			var sourceY:int;
			var tileNum:int;
			var tilesPerRow:int=gamePlay.gettilesPerRow();
			var gameXML:XML=gamePlay.getgameXML();
			
			
			var eraseBitmapData:BitmapData=gamePlay.getaTilesheetData()[gamePlay.geterasertile()].aTileBitmapData[0];
			////////trace("gamePlay.geterasertile()=" + gamePlay.geterasertile());
			eraseTempArray.push(eraseBitmapData);
			addBitmapState(GamePlay.MOVE_STATE_ERASE,eraseTempArray);
				
			//for player death add a state with nothing in it that can be filled with the current bitmat data before death
			addBitmapState(GamePlay.MOVE_STATE_DEATH,deathTempArray);
			addBitmapState(GamePlay.MOVE_STATE_FADEOUT,fadeoutTempArray);
			addBitmapState(GamePlay.MOVE_STATE_TRANSPORT,transportTempArray);
			
						
			for each (var child:XML in gameXML.player.levelout) {
				tileNum=int(child);
				var leveloutBitmapData:BitmapData=gamePlay.getaTilesheetData()[tileNum].aTileBitmapData[0];
				leveloutTempArray.push(leveloutBitmapData);
			}
			addBitmapState(GamePlay.MOVE_STATE_LEVELOUT,leveloutTempArray);
			
			for each (child in gameXML.player.lefttile) {
				tileNum=int(child);
				var leftBitmapData:BitmapData=gamePlay.getaTilesheetData()[tileNum].aTileBitmapData[0];
				leftTempArray.push(leftBitmapData);
			}
			addBitmapState(GamePlay.MOVE_STATE_LEFT,leftTempArray);
			
			for each (child in gameXML.player.righttile) {
				tileNum=int(child);
				var rightBitmapData:BitmapData=gamePlay.getaTilesheetData()[tileNum].aTileBitmapData[0];
				rightTempArray.push(rightBitmapData);
			}
			addBitmapState(GamePlay.MOVE_STATE_RIGHT,rightTempArray);
			
			for each (child in gameXML.player.uptile) {
				tileNum=int(child);
				var upBitmapData:BitmapData=gamePlay.getaTilesheetData()[tileNum].aTileBitmapData[0];
				upTempArray.push(upBitmapData);
			}
			addBitmapState(GamePlay.MOVE_STATE_UP,upTempArray);
			
			for each (child in gameXML.player.downtile) {
				tileNum=int(child);
				var downBitmapData:BitmapData=gamePlay.getaTilesheetData()[tileNum].aTileBitmapData[0];
				downTempArray.push(downBitmapData);
			}
			addBitmapState(GamePlay.MOVE_STATE_DOWN,downTempArray);
			
			for each (child in gameXML.player.uptolefttile) {
				tileNum=int(child);
				var uptoleftBitmapData:BitmapData=gamePlay.getaTilesheetData()[tileNum].aTileBitmapData[0];
				uptoleftTempArray.push(uptoleftBitmapData);
			}
			addBitmapState(GamePlay.ANIMATE_UPTOLEFT,uptoleftTempArray);
			
			for each (child in gameXML.player.uptorighttile) {
				tileNum=int(child);
				var uptorightBitmapData:BitmapData=gamePlay.getaTilesheetData()[tileNum].aTileBitmapData[0];
				uptorightTempArray.push(uptorightBitmapData);
			}
			addBitmapState(GamePlay.ANIMATE_UPTORIGHT,uptorightTempArray);
			
			for each (child in gameXML.player.uptodowntile) {
				tileNum=int(child);
				var uptodownBitmapData:BitmapData=gamePlay.getaTilesheetData()[tileNum].aTileBitmapData[0];
				uptodownTempArray.push(uptodownBitmapData);
			}
			addBitmapState(GamePlay.ANIMATE_UPTODOWN,uptodownTempArray);
			
			for each (child in gameXML.player.downtolefttile) {
				tileNum=int(child);
				var downtoleftBitmapData:BitmapData=gamePlay.getaTilesheetData()[tileNum].aTileBitmapData[0];
				downtoleftTempArray.push(downtoleftBitmapData);
			}
			addBitmapState(GamePlay.ANIMATE_DOWNTOLEFT,downtoleftTempArray);
		
			for each (child in gameXML.player.downtorighttile) {
				tileNum=int(child);
				var downtorightBitmapData:BitmapData=gamePlay.getaTilesheetData()[tileNum].aTileBitmapData[0];
				downtorightTempArray.push(downtorightBitmapData);
			}
			addBitmapState(GamePlay.ANIMATE_DOWNTORIGHT,downtorightTempArray);
			
			for each (child in gameXML.player.downtouptile) {
				tileNum=int(child);
				var downtoupBitmapData:BitmapData=gamePlay.getaTilesheetData()[tileNum].aTileBitmapData[0];
				downtoupTempArray.push(downtoupBitmapData);
			}
			addBitmapState(GamePlay.ANIMATE_DOWNTOUP,downtoupTempArray);
		
			for each (child in gameXML.player.lefttouptile) {
				tileNum=int(child);
				var lefttoupBitmapData:BitmapData=gamePlay.getaTilesheetData()[tileNum].aTileBitmapData[0];
				lefttoupTempArray.push(lefttoupBitmapData);
			}
			addBitmapState(GamePlay.ANIMATE_LEFTTOUP,lefttoupTempArray);
			
			for each (child in gameXML.player.lefttodowntile) {
				tileNum=int(child);
				var lefttodownBitmapData:BitmapData=gamePlay.getaTilesheetData()[tileNum].aTileBitmapData[0];
				lefttodownTempArray.push(lefttodownBitmapData);
			}
			addBitmapState(GamePlay.ANIMATE_LEFTTODOWN,lefttodownTempArray);
			
			for each (child in gameXML.player.lefttorighttile) {
				tileNum=int(child);
				var lefttorightBitmapData:BitmapData=gamePlay.getaTilesheetData()[tileNum].aTileBitmapData[0];
				lefttorightTempArray.push(lefttorightBitmapData);
			}
			addBitmapState(GamePlay.ANIMATE_LEFTTORIGHT,lefttorightTempArray);
			
			for each (child in gameXML.player.righttouptile) {
				tileNum=int(child);
				var righttoupBitmapData:BitmapData=gamePlay.getaTilesheetData()[tileNum].aTileBitmapData[0];
				righttoupTempArray.push(righttoupBitmapData);
			}
			addBitmapState(GamePlay.ANIMATE_RIGHTTOUP,righttoupTempArray);
		
			for each (child in gameXML.player.righttodowntile) {
				tileNum=int(child);
				var righttodownBitmapData:BitmapData=gamePlay.getaTilesheetData()[tileNum].aTileBitmapData[0];
				righttodownTempArray.push(righttodownBitmapData);
			}
			addBitmapState(GamePlay.ANIMATE_RIGHTTODOWN,righttodownTempArray);
		
			for each (child in gameXML.player.righttolefttile) {
				tileNum=int(child);
				var righttoleftBitmapData:BitmapData=gamePlay.getaTilesheetData()[tileNum].aTileBitmapData[0];
				righttoleftTempArray.push(righttoleftBitmapData);
			}
			addBitmapState(GamePlay.ANIMATE_RIGHTTOLEFT,righttoleftTempArray);
			
			//the invinclible filter is not a state, it is used as a filter so it is a normal array, not part of the state array
			
			for each (child in gameXML.player.invfilter) {
			//	trace("XML invfilter counter");
				tileNum=int(child);
				var invFilterBitmapData:BitmapData=gamePlay.getaTilesheetData()[tileNum].aTileBitmapData[0];
				invFilterArray.push(invFilterBitmapData);
			}
			//trace("invFilterArray.length=" + invFilterArray.length);
			
		}
		
		public function detectKeyPress(keyCode:int) {
			//trace("new keypress=" + keyCode);
			newKeyPress=false;
			if (keyCode==38 && !moveUp) {
				newKeyPress=true;
				newKeyValue="up"
				//trace("new key detected up");
				
			}else if (keyCode==40 && !moveDown) {
				newKeyPress=true;
				newKeyValue="down"
				//trace("new key detected down");
				
			}else if (keyCode==37 && !moveLeft) {
				newKeyPress=true;
				newKeyValue="left"
				//trace("new key detected left");
				
				//player.scaleY=-1;
			}else if (keyCode==39 && !moveRight) {
				newKeyPress=true;
				newKeyValue="right"
				//trace("new key detected right");
			}
		}
		
		public function checkInput() {
			if (newKeyPress) {
				
				//trace("check input new keypress");
				var doMove:Boolean=false;
				var nextTileCol:Number;
				var nextTileRow:Number;
				var nextTile:Tile;
				var currentTileMiddleX:int=(tileCol*tileSize)+(.5*tileSize);
				var currentTileMiddleY:int=(tileRow*tileSize)+(.5*tileSize);
				
				
				switch (newKeyValue) {
				case GamePlay.MOVE_STATE_RIGHT:
					//trace("new key value right")
					nextTileCol=int(tileCol)+1;
					
					//*** for tunnels
					if (nextTileCol >mapCols-1) nextTileCol=0;//tunnel
					if (tileRow >mapRows-1) tileRow=0;
					//*** end for tunnels
					//////////trace("nextTileCol=" + nextTileCol);
					try{
						nextTile=gamePlay.getaTileMap()[tileRow][nextTileCol];
					}
					catch (error:Error){
						//////////trace("check input right error");
						//////////trace ("mapCols % nextTileCol=" + mapCols % nextTileCol);
						//////////trace("*** <Error> " + error.message);
						//////////trace("*** nextTileCol=" + nextTileCol);
						//////////trace("*** player.tilerow=" + player.tileRow);
					}
					////////////trace("nextTile=" + nextTile);
					if (nextTile.isWalkable) {
						
						if (moveLeft || moveStop) doMove=true;
						if ((moveUp && centernexty <= currentTileMiddleY+acceleration) || (moveDown && centernexty >= currentTileMiddleY-acceleration) ) {
							doMove=true;
						}
					}
					if (doMove) {
						//trace("doMove");
						resetMovement("right");
						turning=true;
					}
					break;
				case GamePlay.MOVE_STATE_LEFT:
					//trace("new key value left")
					nextTileCol=int(tileCol)-1;
					
					//*** for tunnels
					if (nextTileCol <0) nextTileCol=mapCols-1; //tunnel
					if (tileRow >mapRows-1) tileRow=0;
					//*** end for tunnels
					////////////trace("nextTileCol=" + nextTileCol);
					try{
						nextTile=gamePlay.getaTileMap()[tileRow][nextTileCol];
					}catch (error:Error){
						//////////trace("check input left error");
						//////////trace("*** <Error> " + error.message);
						//////////trace("*** nextTileCol=" + nextTileCol);
						//////////trace("*** player.tilerow=" + player.tileRow);
					}
					////////////trace("nextTile=" + nextTile);
					if (nextTile.isWalkable) {
						if (moveRight || moveStop) doMove=true;
						if ((moveUp && centernexty <= currentTileMiddleY+acceleration) || (moveDown && centernexty >= currentTileMiddleY-acceleration) ) {
							doMove=true;
						}
					}
					
											
					if (doMove) {
						//trace("doMove");
						resetMovement("left");
						turning=true;
					}
					break;
				case GamePlay.MOVE_STATE_UP:
					//trace("new key value up")
					nextTileRow=int(tileRow)-1; //tunnel
					//*** for tunnels
					if (nextTileRow <0) nextTileRow=mapRows-1;
					if (tileCol >mapCols-1) tileCol=0;
					//*** end for tunnels
					////////////trace("nextTileRow=" + nextTileRow);
					try{
						nextTile=gamePlay.getaTileMap()[nextTileRow][tileCol];
					}catch (error:Error){
						//////////trace("check input up error");
						//////////trace("*** <Error> " + error.message);
						//////////trace("*** player.tilecol=" + player.tileCol);
						//////////trace("*** nextTileRow=" + nextTileRow);
					}
					////////////trace("nextTile=" + nextTile);
					if (nextTile.isWalkable) {
						if (moveDown || moveStop) doMove=true;
						if ((moveRight && centernextx >= currentTileMiddleX-acceleration) || (moveLeft && centernextx <= currentTileMiddleX+acceleration)) {
							doMove=true;
						}
					}
					
					if (doMove) {
						//trace("doMove");
						resetMovement("up");
						turning=true;
						
					}
					break;
				case GamePlay.MOVE_STATE_DOWN:
					//trace("new key value down")
					nextTileRow=int(tileRow)+1;
					//*** for tunnels
					if (nextTileRow >mapRows-1) nextTileRow=0; //tunnel
					if (tileCol >mapCols-1) tileCol=0;
					 //*** end for tunnels
					////////////trace("nextTileRow=" + nextTileRow);
					try{
						nextTile=gamePlay.getaTileMap()[nextTileRow][tileCol];
					}catch (error:Error){
						//////////trace("check input down error");
						//////////trace("*** <Error> " + error.message);
						//////////trace("*** player.tilecol=" + player.tileCol);
						//////////trace("*** nextTileRow=" + nextTileRow);
					}
					////////////trace("nextTile=" + nextTile);
					if (nextTile.isWalkable) {
						if (moveUp || moveStop) doMove=true;
						if ((moveRight && centernextx >= currentTileMiddleX-acceleration) || (moveLeft && centernextx <= currentTileMiddleX+acceleration)) {
							doMove=true;
						}
					}
					if (doMove) {
						//trace("doMove");
						resetMovement("down");
						turning=true;
						
					}
					break;
				}
				
			}
			
		}
		
		
		
		function resetMovement(dir:String):void {
			
		//////////trace("turning");
			nextscalex=1;
			moveRight=false;
			moveLeft=false;
			moveUp=false;
			moveDown=false;
			moveDeath=false;
			moveErase=false;
			moveFadeOut=false;
			moveStop=false;
			moveTransport=false;
			
			//trace("changing player move state to: " + dir);
			switch (dir) {
				
				case "right":
					//trace("resetMovement right");
					animatingTurn=true;
					turnAminationIndex=0;
					if (currentFacing=="left") {
						aAnimatingTurnBitmapData=getBitmapState(GamePlay.ANIMATE_LEFTTORIGHT);
						
					}else if (currentFacing=="up") {
						aAnimatingTurnBitmapData=getBitmapState(GamePlay.ANIMATE_UPTORIGHT);
						
					}else if (currentFacing=="down") {
						aAnimatingTurnBitmapData=getBitmapState(GamePlay.ANIMATE_DOWNTORIGHT);
						
					}else{
						animatingTurn=false;
					}
					
					aSpriteBitmapData=getBitmapState(GamePlay.MOVE_STATE_RIGHT);
					aLastBitmapDataState=aSpriteBitmapData;
					moveRight=true;
					hitx=1;
					hity=0;
					dx=1;
					dy=0;
					currentFacing="right";
					spriteBitmapDataIndex=0;
					break;
				case "left":
					//trace("resetMovement left");
					animatingTurn=true;
					turnAminationIndex=0;
					if (currentFacing=="right") {
						aAnimatingTurnBitmapData=getBitmapState(GamePlay.ANIMATE_RIGHTTOLEFT);
						
					}else if (currentFacing=="up") {
						aAnimatingTurnBitmapData=getBitmapState(GamePlay.ANIMATE_UPTOLEFT);
						
					}else if (currentFacing=="down") {
						aAnimatingTurnBitmapData=getBitmapState(GamePlay.ANIMATE_DOWNTOLEFT);
						
					}else{
						animatingTurn=false;
					}
					
					aSpriteBitmapData=getBitmapState(GamePlay.MOVE_STATE_LEFT);
					aLastBitmapDataState=aSpriteBitmapData;
					moveLeft=true;
					hitx=-1;
					hity=0
					dx=-1;
					dy=0;
					currentFacing="left";
					spriteBitmapDataIndex=0;
					break;
				case "up":
					//trace("resetMovement up");
					animatingTurn=true;
					turnAminationIndex=0;
					if (currentFacing=="right") {
						aAnimatingTurnBitmapData=getBitmapState(GamePlay.ANIMATE_RIGHTTOUP);
						
					}else if (currentFacing=="left") {
						aAnimatingTurnBitmapData=getBitmapState(GamePlay.ANIMATE_LEFTTOUP);
						
					}else if (currentFacing=="down") {
						aAnimatingTurnBitmapData=getBitmapState(GamePlay.ANIMATE_DOWNTOUP);
						
					}else{
						animatingTurn=false;
					}
					
					aSpriteBitmapData=getBitmapState(GamePlay.MOVE_STATE_UP);
					aLastBitmapDataState=aSpriteBitmapData;
					moveUp=true;
					hitx=0;
					hity=-1;
					dx=0;
					dy=-1;
					currentFacing="up";
					spriteBitmapDataIndex=0;
					break;
				case "down":
					//trace("resetMovement down");
					animatingTurn=true;
					turnAminationIndex=0;
					if (currentFacing=="right") {
						aAnimatingTurnBitmapData=getBitmapState(GamePlay.ANIMATE_RIGHTTODOWN);
						
					}else if (currentFacing=="left") {
						aAnimatingTurnBitmapData=getBitmapState(GamePlay.ANIMATE_LEFTTODOWN);
						
					}else if (currentFacing=="up") {
						aAnimatingTurnBitmapData=getBitmapState(GamePlay.ANIMATE_UPTODOWN);
						
					}else{
						animatingTurn=false;
					}
					
					aSpriteBitmapData=getBitmapState(GamePlay.MOVE_STATE_DOWN);
					aLastBitmapDataState=aSpriteBitmapData;
					moveDown=true;
					hitx=0;
					hity=1;
					dx=0;
					dy=1;
					currentFacing="down";
					spriteBitmapDataIndex=0;
					break;
					
				case GamePlay.MOVE_STATE_DEATH:
					aSpriteBitmapData=getBitmapState(GamePlay.MOVE_STATE_DEATH);
					moveDeath=true;
					hitx=0;
					hity=0;
					dx=0;
					dy=0;
					spriteBitmapDataIndex=0;
					break;
				case GamePlay.MOVE_STATE_FADEOUT:
					aSpriteBitmapData=getBitmapState(GamePlay.MOVE_STATE_FADEOUT);
					moveFadeOut=true;
					hitx=0;
					hity=0;
					dx=0;
					dy=0;
					spriteBitmapDataIndex=0;
					break;
				case GamePlay.MOVE_STATE_TRANSPORT:
					aSpriteBitmapData=getBitmapState(GamePlay.MOVE_STATE_TRANSPORT);
					moveFadeOut=true;
					hitx=0;
					hity=0;
					dx=0;
					dy=0;
					spriteBitmapDataIndex=0;
					break;	
				case GamePlay.MOVE_STATE_ERASE:
					//////////trace("resetMovement stop");
					spriteBitmapDataIndex=0;
					aSpriteBitmapData=getBitmapState(GamePlay.MOVE_STATE_ERASE);
					//turning=true;
					moveErase=true;
					hitx=0;
					hity=0;
					dx=0;
					dy=0;
					spriteBitmapDataIndex=0;
					break;
				case GamePlay.MOVE_STATE_STOP:
					//trace("***** resetMovement stop *****");
					aSpriteBitmapData=aLastBitmapDataState;
					//turning=true;
					moveStop=true;
					hitx=0;
					hity=0;
					dx=0;
					dy=0;
					newKeyPress=false;
					spriteBitmapDataIndex=0;
					break;
			
			}
			
			
			//nextAnimation(); // need to jump to new animation state right away or delay will look strange on turn
		}
		
		
		override public function update() {
			//call super.update() if generic update is ok
			//trace("player accAdjust=" + accAdjust);
			
			if (animatingTurn) {
				aSpriteBitmapData=aAnimatingTurnBitmapData;
				turnAminationIndex++;
				if (turnAminationIndex == aAnimatingTurnBitmapData.length) {
					animatingTurn=false;
					turnAminationIndex=0;
					spriteBitmapDataIndex=0;
				}
				
			}else{
				if (!transportStarted && !moveStop) {
					aSpriteBitmapData=aLastBitmapDataState;
				}
			}
			
			
			if (rendervelocity) {
				
				if (moveUp) {
					if (turning) {
						//find center of tile x and put player there
						//centernextx=(tileCol * tileSize)+(tileSize*.5);
						setnextx(tileCol * tileSize);
						////////trace("player.nextx=" + player.nextx);
					}
					//setnexty(nexty+(acceleration+accAdjust+gamePlay.levelspeedadjust)*dy);
					setnexty(nexty+(acceleration+accAdjust)*dy);
				}else if (moveDown) {
					if (turning) {
						//find center of tile x and put player there
						//centernextx=(tileCol * tileSize)+(tileSize*.5);
						setnextx(tileCol * tileSize);
					}
					//setnexty(nexty+(acceleration+accAdjust+gamePlay.levelspeedadjust)*dy);
					setnexty(nexty+(acceleration+accAdjust)*dy);
				}else if (moveLeft) {
					if (turning) {
						//find center of tile x and put player there
						//centernexty=(tileRow * tileSize)+(tileSize*.5);
						setnexty(tileRow * tileSize);
					}
					//setnextx(nextx+(acceleration+accAdjust+gamePlay.levelspeedadjust)*dx);
					setnextx(nextx+(acceleration+accAdjust)*dx);
				}else if (moveRight) {
					if (turning) {
						//find center of tile x and put player there
						//centernexty=(tileRow * tileSize)+(tileSize*.5);
						setnexty(tileRow * tileSize);
					}
					//setnextx(nextx+(acceleration+accAdjust+gamePlay.levelspeedadjust)*dx);
					setnextx(nextx+(acceleration+accAdjust)*dx);
					////////trace("nextx=" + nextx);
				
				}
			
				//change location for tunnels
				if (nexty<(-.5*tileSize)) {
					////////trace ("up tunnel");
					setnexty(tileSize*mapRows);
				}else if (nexty> (tileSize*mapRows)){
					////////trace ("down tunnel");
					setnexty(-16);
				}else if (nextx > (tileSize*mapCols)){
					////////trace ("right tunnel");
					setnextx(-16);
				}else if (nextx < (-.5*tileSize)){
					////////trace ("left tunnel");
					setnextx(tileSize*mapCols);
				}
			
				
			}
			
			
			tileRow=int(centernexty / tileSize);
			tileCol=int(centernextx / tileSize);
			turning=false;
		}
	
		override public function render() {
			if (deathStarted) {
				playerDeathUpdate();
			}
			if (leveloutStarted) {
				playerLevelOutUpdate();
			}
			
			if (transportStarted) {
				playerTransportUpdate();
			}
			
				
		
			//trace("spriteBitmapDataIndex=" + spriteBitmapDataIndex);
			super.render();
			if (transportStarted) {
				gamePlay.getgameScreenBitmapData().copyPixels(transNextLocBitmapData,new Rectangle(0,0,tileSize,tileSize), new Point(nextTransportLocationX,nextTransportLocationY));
			}
			resetRenderBooleans();
			//gamePlay.lookAhead.x=centernextx;
			//gamePlay.lookAhead.y=centernexty;
			
			////////trace("x=" + x);
			////////trace("centerx=" + centerx);
			////////trace("player render end");
			if (invFilter) {
				//glowfilter=new GlowFilter(0x00FF00, .6,  4,  4,  2, 75, false, false);
				//renderGlowFilter=true;
				
				//trace("1 invFilter")
				if (blinkProtect) {
					blinkProtectCount++;
					if (blinkProtectCount > blinkProtectMaxFrames) {
						blinkProtectCount=0;
						if (protectblinkon) {
							protectblinkon=false;
						}else{
							protectblinkon=true
						
						}
					}
					
				}
				//trace("2 invFilter")
				if (!protectblinkon) {
					invFilterFrameCtr++
					if (invFilterFrameCtr >invFilterFrameDelay) {
						invFilterIndex++
						//trace("3 invFilter");
						if (invFilterIndex == invFilterArray.length) {
						//	trace("4 invFilter");
							invFilterIndex=0;
						}
					}
					//trace("invFilterArray.length=" + invFilterArray.length);
					//trace("invFilterIndex=" + invFilterIndex);
					gamePlay.getgameScreenBitmapData().copyPixels(invFilterArray[invFilterIndex],new Rectangle(0,0,tileSize,tileSize), new Point(x,y));
					
				}
				
			}	
		}
		
		override public function resetRenderBooleans() {
			//the basic game object resets all of these to false, but we need player velocity to not automatically reset.
			//rendervelocity=false;
			renderalpha=false;
			renderscalex=false;
			renderscaley=false;
			renderrotation=false;
			renderrotation=false;
			renderGlowFilter=false;
		}
	
	}
}
		