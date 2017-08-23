/**
* ...
* @author Jeff Fulton
* @version 0.1
*/

package  {
	
	import BasicGameSprite;
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.geom.*;
	import flash.display.BitmapData;
	import flash.filters.GlowFilter;
	import GamePlay;
	import Tile;
	
	public class Enemy extends BasicGameSprite {
		
		
		public var moveUp:Boolean=false;
		public var moveDown:Boolean=false;
		public var moveRight:Boolean=false;
		public var moveLeft:Boolean=false;
		public var moveStop:Boolean=false;
		public var moveErase:Boolean=false
		public var aiState:String;
		public var turning:Boolean=false;
		public var lastTile:int;
		public var hitx:int;
		public var hity:int;
		public var hittilerow:int;
		public var hittilecol:int;
		public var mapRows:int;
		public var mapCols:int;
		public var intelligence:int=0;
		public var score:int;
		public var started:Boolean=false;
		public var frameDelayBeforeStart:int=20;
		public var frameCountBeforeStart:int=0;
		public var restartX:int;
		public var restartY:int;
		public var stateBeforeFreeze:String;
		public var restartFrameDelay=100;
		public var blinkFlee:Boolean=false;
		public var blinkFleeCount:int=0;
		public var blinkFleeMaxFrames:int=3;
		public var fleeblinkon:Boolean=false;
		public var frozen:Boolean=false;
		public var blinkFreeze:Boolean=false;
		public var blinkFreezeCount:int=0;
		public var blinkFreezeMaxFrames:int=3;
		public var freezeblinkon:Boolean=false;
		public var title:String; // used for levelinscreen
		
		public var fleeFilterIndex:int=0;
		public var fleeFilterFrameDelay:int=7; 
		public var fleeFilterFrameCtr:int=0;
		public var fleeFilterArray:Array=[];
		
		//*** optimization vars
		var ctr1:int;
		var temphitx:Number;
		var temphity:Number;
		var nextHitTile:Tile;
		
		//*** fin new direction optimization vars
		var randState:int;
		var aState:Array;
		var newDirectionFound:Boolean;
		var nextTileCol:Number;
		var nextTileRow:Number;
		var nextTile:Tile;
		var currentTileMiddleX:int;
		var currentTileMiddleY:int;
		var newState:String;
		var aNewState:Array=[];
		var dHorizontal:int;
		var dVertical:int;
		var doChange:Boolean;
		var doMove:Boolean;
		
		//*** update function optimizations
		var currentTile:int;
		
		
		
		
		public function Enemy(xval:Number,yval:Number,gp:GamePlay) {
			////trace ("enemy");
			x=xval;
			y=yval;
			nextx=x;
			nexty=y;
			restartX=x;
			restartY=y;
			gamePlay=gp;
			
			gamePlay.addEventListener(GamePlay.UPDATE, updateListener,false,0,true);
			
			
		}
		
		public function setlastTile() {
			lastTile=tileRow * tileCol;
		}
		
		public function resetTileRow() {
			tileRow=int(y/tileSize);
		}
		
		public function resetTileCol() {
			tileCol=int(x/tileSize);
		}
		
		private function renderListener (e:Event):void {
			render();
		}
		
		private function updateListener (e:Event):void {
			if (started) {
				////trace("started");
				update();
			}else{
				////trace("!started");
				if (frameCountBeforeStart >= frameDelayBeforeStart) {
					startMe();
					//trace("starting enemy");
				}
				frameCountBeforeStart++;
				//trace("frameCountBeforeStart" + frameCountBeforeStart);
			}
			
			
		}
		
		private function powerUpAttackAboutToEndListener(e:Event):void  {
			blinkFlee=true;
			gamePlay.debugCtr=0;
		}
		
		private function accTimerStartListener(e:Event) :void {
			trace("enemy acctimer start");
			frozen=true;
			blinkFreeze=false;
			blinkFreezeCount=0;
			blinkFreezeMaxFrames=5;
			resetMovement(GamePlay.MOVE_STATE_STOP,false);
		}
		
		private function accTimerEndListener(e:Event) :void {
			resetMovement(stateBeforeFreeze,false);
			frozen=false;
			blinkFreeze=false
		}
		
		private function accTimerAboutToEndListener(e:Event) :void { 
			blinkFreeze=true;
		}
		
		
		private function powerUpAttackStartListener(e:Event) :void {
			////trace("starting to flee now!!");
			aiState=GamePlay.AI_STATE_FLEE;
			accAdjust=2;
			blinkFlee=false;
			blinkFleeCount=0;
			blinkFleeMaxFrames=3;
			fleeblinkon=false;
			fleeFilterIndex=0;
			fleeFilterFrameCtr=0;
			fleeFilterArray=getBitmapState(GamePlay.AI_FILTER_FLEE);
			
			//render();
		}
		
		private function powerUpAttackEndListener(e:Event) :void {
			
			blinkFlee=false;
			aiState=GamePlay.AI_STATE_CHASE;
			accAdjust=0;
			//render();
			gamePlay.debugCtr++;
			trace("gamePlay.debugCtr="+gamePlay.debugCtr);
			//resetRenderBooleans();
		}
		
		
		public function startMe() {
			accAdjust=0;
			started=true;
			animate=true;
			////trace("enemyStarted");
			gamePlay.addEventListener(GamePlay.CHECK_WALL_COLLISIONS, wallcollisionListener,false,0,true);
			gamePlay.addEventListener(GamePlay.RENDER, renderListener,false,0,true);
			gamePlay.scorePanel.addEventListener(GamePlay.POWERUPATTACKSTART, powerUpAttackStartListener,false,0,true);
			gamePlay.scorePanel.addEventListener(GamePlay.POWERUPATTACKEND, powerUpAttackEndListener,false,0,true);
			gamePlay.addEventListener(GamePlay.ACCTIMERSTART, accTimerStartListener,false,0,true);
			gamePlay.scorePanel.addEventListener(GamePlay.ACCTIMEREND, accTimerEndListener,false,0,true);
			gamePlay.scorePanel.addEventListener(GamePlay.POWERUPATTACKABOUTOEND, powerUpAttackAboutToEndListener,false,0,true);
			gamePlay.scorePanel.addEventListener(GamePlay.ACCTIMERABOUTTOEND, accTimerAboutToEndListener,false,0,true);
			aiState=GamePlay.AI_STATE_CHASE;
			frameCountBeforeStart=0;
			blinkFreeze=false;
			blinkFlee=false;
			resetMovement("right", false);
			
		}
		
		public function eatMe() {
			started=false;
			animate=false;
			frameDelayBeforeStart=restartFrameDelay;
			gamePlay.removeEventListener(GamePlay.CHECK_WALL_COLLISIONS, wallcollisionListener);
			gamePlay.removeEventListener(GamePlay.RENDER, renderListener);
			gamePlay.scorePanel.removeEventListener(GamePlay.POWERUPATTACKSTART, powerUpAttackStartListener);
			gamePlay.scorePanel.removeEventListener(GamePlay.POWERUPATTACKEND, powerUpAttackEndListener);
			gamePlay.scorePanel.removeEventListener(GamePlay.ACCTIMERSTART, accTimerStartListener);
			gamePlay.scorePanel.removeEventListener(GamePlay.ACCTIMEREND, accTimerEndListener);
			setx(restartX);
			sety(restartY);
			setnextx(x);
			setnexty(y);
			resetTileRow();
			resetTileCol();
			setlastTile();
			resetRenderBooleans();
			blinkFreeze=false;
			blinkFlee=false;
			frozen=false;
			
		}
		
		
		
		public function removeMe(){
			////trace("enemy removed");
			resetMovement(GamePlay.MOVE_STATE_ERASE,true);
			gamePlay.removeEventListener(GamePlay.RENDER, renderListener);
			gamePlay.removeEventListener(GamePlay.UPDATE, updateListener);
			gamePlay.removeEventListener(GamePlay.CHECK_WALL_COLLISIONS, wallcollisionListener);
			gamePlay.scorePanel.removeEventListener(GamePlay.POWERUPATTACKSTART, powerUpAttackStartListener);
			gamePlay.scorePanel.removeEventListener(GamePlay.POWERUPATTACKEND, powerUpAttackEndListener);
			

		}
		
		public function dispose(){
			////trace("enemy removed");
			resetMovement(GamePlay.MOVE_STATE_ERASE,true);
			gamePlay.removeEventListener(GamePlay.RENDER, renderListener);
			gamePlay.removeEventListener(GamePlay.UPDATE, updateListener);
			gamePlay.removeEventListener(GamePlay.CHECK_WALL_COLLISIONS, wallcollisionListener);
			gamePlay.scorePanel.removeEventListener(GamePlay.POWERUPATTACKSTART, powerUpAttackStartListener);
			gamePlay.scorePanel.removeEventListener(GamePlay.POWERUPATTACKEND, powerUpAttackEndListener);
			
			
			for (ctr1=0;ctr1<aSpriteBitmapData.length;ctr1++) {
				aSpriteBitmapData[ctr1]=null
			}
			aSpriteBitmapData=null;

		}
		
		
		
		
		
		
		private function wallcollisionListener (e:Event):void {
			//check next hit tile, if it is a wall, move in a new direction.
			temphitx=centernextx + (hitx*.5*tileSize);
			temphity=centernexty + (hity*.5*tileSize);
			
			
			hittilerow=int(temphity / tileSize);
			hittilecol=int(temphitx / tileSize);
			// if tunnel, check tile on other side, not the empty tile
			if (hittilerow > mapRows-1) hittilerow=0;
			if (hittilerow < 0) hittilerow=mapRows-1;
			if (hittilecol > mapCols-1) hittilecol=0;
			if (hittilecol < 0) hittilecol=mapCols-1;
		
			try{
				nextHitTile=gamePlay.getaTileMap()[hittilerow][hittilecol];
			}catch (error:Error){
				////trace("*** checkCollisions error ***");
				////trace("*** <Error> " + error.message);
				////trace("*** player.hittilecol=" + player.hittilecol);
				////trace("*** player.hittilerow=" + player.hittilerow);
				
			}
			if (!nextHitTile.isWalkable && !nextHitTile.isEnemyGenerator) {
				//////trace("hit wall");
				setnextx(x);
				setnexty(y);
				
				//for now, randomly pick a new direction when hit a wall
				//var aState:Array=gamePlay.getaMoveState();
				//var randState:int=int(Math.random()*aState.length);
				//resetMovement(aState[randState]);
				findNewDirection();
			}
			
																										 
			
			
		}
		
		
		
		
		function resetMovement(dir:String,animateNow:Boolean):void {
			
		//////trace("turning");
			nextscalex=1;
			moveRight=false;
			moveLeft=false;
			moveUp=false;
			moveDown=false;
			moveStop=false;
			moveErase=false;
			////trace ("resetMovement " + dir);
			
			switch (dir) {
				
				case GamePlay.MOVE_STATE_RIGHT:
					//////trace("resetMovement right");
					
					aSpriteBitmapData=getBitmapState(GamePlay.MOVE_STATE_RIGHT);
					
					spriteBitmapDataIndex=0;
					turning=true;
					moveRight=true;
					hitx=1;
					hity=0;
					dx=1;
					dy=0;
					stateBeforeFreeze=GamePlay.MOVE_STATE_RIGHT;
					break;
				case GamePlay.MOVE_STATE_LEFT:
					//////trace("resetMovement left");
					
					aSpriteBitmapData=getBitmapState(GamePlay.MOVE_STATE_LEFT);
					
					spriteBitmapDataIndex=0;
					turning=true;
					moveLeft=true;
					hitx=-1;
					hity=0
					dx=-1;
					dy=0;
					stateBeforeFreeze=GamePlay.MOVE_STATE_LEFT;
					break;
				case GamePlay.MOVE_STATE_UP:
					//////trace("resetMovement up");
					
					aSpriteBitmapData=getBitmapState(GamePlay.MOVE_STATE_UP);
					
					
					spriteBitmapDataIndex=0;
					turning=true;
					moveUp=true;
					hitx=0;
					hity=-1;
					dx=0;
					dy=-1;
					stateBeforeFreeze=GamePlay.MOVE_STATE_UP;
					break;
				case GamePlay.MOVE_STATE_DOWN:
					//////trace("resetMovement down");
					
					aSpriteBitmapData=getBitmapState(GamePlay.MOVE_STATE_DOWN);
						
				
					
					spriteBitmapDataIndex=0;
					turning=true;
					moveDown=true;
					hitx=0;
					hity=1;
					dx=0;
					dy=1;
					stateBeforeFreeze=GamePlay.MOVE_STATE_DOWN;
					break;
				case GamePlay.MOVE_STATE_STOP:
					//////trace("resetMovement stop");
					//aSpriteBitmapData=getBitmapState(GamePlay.MOVE_STATE_DOWN);
					//turning=true;
					moveStop=true;
					hitx=0;
					hity=0;
					dx=0;
					dy=0;
					break;
			case GamePlay.MOVE_STATE_ERASE:
					//////trace("resetMovement stop");
					aSpriteBitmapData=getBitmapState(GamePlay.MOVE_STATE_ERASE);
					spriteBitmapDataIndex=0;
					//turning=true;
					moveErase=true;
					hitx=0;
					hity=0;
					dx=0;
					dy=0;
					stateBeforeFreeze=GamePlay.MOVE_STATE_ERASE;
					break;
			
			}
			if (animateNow) {
				nextAnimation(); // need to jump to new animation state right away or delay will look strange on turn
			}
		}
		
		
		
		
		
		function findNewDirection():void {
			
			aState=gamePlay.getaMoveState();
			newDirectionFound=false;
			currentTileMiddleX=(tileCol*tileSize)+(.5*tileSize);
			currentTileMiddleY=(tileRow*tileSize)+(.5*tileSize);
			newState="";
			aNewState=[];
			doChange=true; // on false if in same square as player
			doMove=false;
			//choose based on current aiState - chase or flee.
			if (aiState==GamePlay.AI_STATE_CHASE) {
			
				
				
				//enemy intelligence is a range from 0-100;
				//0 = completely random
				//100 = always chase
				//90 is a good number for chase so it will still have some randomness
				//movement is restricted to vertical or horziontal
				//Horizontal = -1 if hero is to the left of enemy
				//Horizontal = 0 if hero is at the same column as enemy
				//Horizontal = 1 if hero is to the right of the enemy
				//Vertical = -1 if hero is above enemy
				//Vertical = 0 if hero is at the same row  as enemy
				//Vertical = 1 if hero is below the enemy
				//if horizontal and vertical = 0, no movement change, they are in the same tile
				//if horizontal or vertical = 0, then use the other one
				//if both are non-zero then randomly choose one
						
			
				if (int(Math.random()*100) > intelligence) {
					////trace("no chase, random");
					//choose random direction
					randState=int(Math.random()*aState.length);
					newState=aState[randState];
				}else{
					////trace("chase");
					
					if (tileCol > gamePlay.getPlayerCurrentCol()) {
						dHorizontal=-1;
					}else if (tileCol < gamePlay.getPlayerCurrentCol()){
						dHorizontal=1;
					}else{ // if the are equal 
						dHorizontal=0;
					}
					if (tileRow > gamePlay.getPlayerCurrentRow()) {
						dVertical=-1;
					}else if (tileRow < gamePlay.getPlayerCurrentRow()){
						dVertical=1;
					}else{ // if the are equal
						dVertical=0;
					}
					
					if (dHorizontal==0 && dVertical !=0) {
						if (dVertical == -1) {
							
							newState="up";
							////trace("player is up");
						}else{
							newState="down";
							////trace("player is down");
						}
					}else if (dVertical==0 && dHorizontal !=0) {
						if (dHorizontal ==-1) {
							newState="left";
							////trace("player is left");
						}else {
							newState="right";
							////trace("player is right");
						}
					}else if (dVertical==0 && dHorizontal==0) {
						doChange=false;
						////trace("in same square as player");
					}else{
						if (dVertical ==-1) aNewState.push("up");
						if (dVertical == 1) aNewState.push("down");
						if (dHorizontal ==-1) aNewState.push("left");
						if (dHorizontal ==1) aNewState.push("left");
						
						randState=int(Math.random()*aNewState.length);
						newState=aNewState[randState];
						////trace("player in two directions");
						////trace("randomly moving" + newState);
					}
					
					
				}
			}else{
				//aiState=flee
				//enemy intelligence is a range from 0-100;
				//0 = completely random
				//100 = always chase
				//90 is a good number for chase so it will still have some randomness
				//movement is restricted to vertical or horziontal
				//Horizontal = -1 if hero is to the left of enemy
				//Horizontal = 0 if hero is at the same column as enemy
				//Horizontal = 1 if hero is to the right of the enemy
				//Vertical = -1 if hero is above enemy
				//Vertical = 0 if hero is at the same row  as enemy
				//Vertical = 1 if hero is below the enemy
				//if horizontal and vertical = 0, no movement change, they are in the same tile
				//if horizontal or vertical = 0, then use the other one
				//if both are non-zero then randomly choose one
						
			
				if (int(Math.random()*100) > intelligence) {
					////trace("no chase, random");
					//choose random direction
					randState=int(Math.random()*aState.length);
					newState=aState[randState];
				}else{
					////trace("chase");
					
					if (tileCol > gamePlay.getPlayerCurrentCol()) {
						dHorizontal=-1;
					}else if (tileCol < gamePlay.getPlayerCurrentCol()){
						dHorizontal=1;
					}else{ // if the are equal 
						dHorizontal=0;
					}
					if (tileRow > gamePlay.getPlayerCurrentRow()) {
						dVertical=-1;
					}else if (tileRow < gamePlay.getPlayerCurrentRow()){
						dVertical=1;
					}else{ // if the are equal
						dVertical=0;
					}
					
					if (dHorizontal==0 && dVertical !=0) {
						if (dVertical == -1) {
							
							newState="down";
							////trace("player is up");
						}else{
							newState="up";
							////trace("player is down");
						}
					}else if (dVertical==0 && dHorizontal !=0) {
						if (dHorizontal ==-1) {
							newState="right";
							////trace("player is left");
						}else {
							newState="left";
							////trace("player is right");
						}
					}else if (dVertical==0 && dHorizontal==0) {
						doChange=false;
						////trace("in same square as player");
					}else{
						if (dVertical ==-1) aNewState.push("up");
						if (dVertical == 1) aNewState.push("down");
						if (dHorizontal ==-1) aNewState.push("left");
						if (dHorizontal ==1) aNewState.push("left");
						
						randState=int(Math.random()*aNewState.length);
						newState=aNewState[randState];
						////trace("player in two directions");
						////trace("randomly moving" + newState);
					}
					
					
				}
			}
				
			if (doChange) {
				switch (newState) {
					case GamePlay.MOVE_STATE_RIGHT:
						////trace("trying right");
						nextTileCol=int(tileCol)+1;
						
						//*** for tunnels
						if (nextTileCol >mapCols-1) nextTileCol=0;//tunnel
						if (tileRow >mapRows-1) tileRow=0;
						//*** end for tunnels
						//////trace("nextTileCol=" + nextTileCol);
						try{
							nextTile=gamePlay.getaTileMap()[tileRow][nextTileCol];
						}
						catch (error:Error){
							//////trace("check input right error");
							//////trace ("mapCols % nextTileCol=" + mapCols % nextTileCol);
							//////trace("*** <Error> " + error.message);
							//////trace("*** nextTileCol=" + nextTileCol);
							//////trace("*** player.tilerow=" + player.tileRow);
						}
						////////trace("nextTile=" + nextTile);
						if (nextTile.isWalkable) {
							if (moveLeft || moveRight) doMove=true;
							if ((moveUp && centernexty <= currentTileMiddleY+acceleration) || (moveDown && centernexty >= currentTileMiddleY-acceleration) ) {
								doMove=true;
							}
						}
						if (doMove) {
							aSpriteBitmapData=getBitmapState(GamePlay.MOVE_STATE_RIGHT);
							resetMovement("right",true);
							turning=true;
							newDirectionFound=true;
							
						}else{
							////trace("can't move right");
						}
						break;
					case GamePlay.MOVE_STATE_LEFT:
						////trace("trying left");
						nextTileCol=int(tileCol)-1;
						
						//*** for tunnels
						if (nextTileCol <0) nextTileCol=mapCols-1; //tunnel
						if (tileRow >mapRows-1) tileRow=0;
						//*** end for tunnels
						////////trace("nextTileCol=" + nextTileCol);
						try{
							nextTile=gamePlay.getaTileMap()[tileRow][nextTileCol];
						}catch (error:Error){
							//////trace("check input left error");
							//////trace("*** <Error> " + error.message);
							//////trace("*** nextTileCol=" + nextTileCol);
							//////trace("*** player.tilerow=" + player.tileRow);
						}
						////////trace("nextTile=" + nextTile);
						if (nextTile.isWalkable) {
							if (moveRight || moveLeft) doMove=true;
							if ((moveUp && centernexty <= currentTileMiddleY+acceleration) || (moveDown && centernexty >= currentTileMiddleY-acceleration) ) {
								doMove=true;
							}
						}
						
												
						if (doMove) {
							aSpriteBitmapData=getBitmapState(GamePlay.MOVE_STATE_LEFT);
							resetMovement("left",true);
							turning=true;
							newDirectionFound=true;
						}else{
							////trace("can't move left");
						}
						break;
					case GamePlay.MOVE_STATE_UP:
						////trace("trying up");
						nextTileRow=int(tileRow)-1; //tunnel
						//*** for tunnels
						if (nextTileRow <0) nextTileRow=mapRows-1;
						if (tileCol >mapCols-1) tileCol=0;
						//*** end for tunnels
						////////trace("nextTileRow=" + nextTileRow);
						try{
							nextTile=gamePlay.getaTileMap()[nextTileRow][tileCol];
						}catch (error:Error){
							//////trace("check input up error");
							//////trace("*** <Error> " + error.message);
							//////trace("*** player.tilecol=" + player.tileCol);
							//////trace("*** nextTileRow=" + nextTileRow);
						}
						////////trace("nextTile=" + nextTile);
						if (nextTile.isWalkable) {
							if (moveDown || moveUp) doMove=true;
							if ((moveRight && centernextx >= currentTileMiddleX-acceleration) || (moveLeft && centernextx <= currentTileMiddleX+acceleration)) {
							//if ((moveRight && nextx >= currentTileMiddleX) || (moveLeft && nextx <= currentTileMiddleX)) {
								doMove=true;
							}
						}
						
						if (doMove) {
							aSpriteBitmapData=getBitmapState(GamePlay.MOVE_STATE_UP);
							resetMovement("up",true);
							turning=true;
							newDirectionFound=true;
							
						}else{
							////trace("can't move up");
						}
						break;
					case GamePlay.MOVE_STATE_DOWN:
						////trace("trying down");
						nextTileRow=int(tileRow)+1;
						//*** for tunnels
						if (nextTileRow >mapRows-1) nextTileRow=0; //tunnel
						if (tileCol >mapCols-1) tileCol=0;
						 //*** end for tunnels
						////////trace("nextTileRow=" + nextTileRow);
						try{
							nextTile=gamePlay.getaTileMap()[nextTileRow][tileCol];
						}catch (error:Error){
							//////trace("check input down error");
							//////trace("*** <Error> " + error.message);
							//////trace("*** player.tilecol=" + player.tileCol);
							//////trace("*** nextTileRow=" + nextTileRow);
						}
						////////trace("nextTile=" + nextTile);
						if (nextTile.isWalkable) {
							if (moveUp || moveDown) doMove=true;
							if ((moveRight && centernextx >= currentTileMiddleX-acceleration) || (moveLeft && centernextx <= currentTileMiddleX+acceleration)) {
								doMove=true;
							}
						}
						if (doMove) {
							aSpriteBitmapData=getBitmapState(GamePlay.MOVE_STATE_DOWN);
							resetMovement("down",true);
							turning=true;
							newDirectionFound=true;
							
						}else{
							////trace("can't move down");
						}
						break;
					}
		
				}// end if doChange
		
			
		}
		
		
		
		override public function update() {
			//call super.update() if generic update is ok
			//for now, wait some frames and then look for a new direction
			currentTile=tileRow*tileCol;
			currentTileMiddleX=(tileCol*tileSize)+(.5*tileSize);
			currentTileMiddleY=(tileRow*tileSize)+(.5*tileSize);
			if ((currentTile != lastTile) && (centernextx >= currentTileMiddleX) && (centernexty >= currentTileMiddleY) && (!moveStop)) {
				findNewDirection();
				setlastTile();
			}
			
			
			if (rendervelocity) {
				
				if (moveUp) {
					if (turning) {
						//find center of tile x and put player there
						//centernextx=(tileCol * tileSize)+(tileSize*.5);
						setnextx(tileCol * tileSize);
						////trace("player.nextx=" + player.nextx);
					}
					if (!frozen) setnexty(nexty+(acceleration+accAdjust+gamePlay.levelspeedadjust)*dy);
					
				}else if (moveDown) {
					if (turning) {
						//find center of tile x and put player there
						//centernextx=(tileCol * tileSize)+(tileSize*.5);
						setnextx(tileCol * tileSize);
					}
					
					if (!frozen) setnexty(nexty+(acceleration+accAdjust+gamePlay.levelspeedadjust)*dy);
					
				}else if (moveLeft) {
					if (turning) {
						//find center of tile x and put player there
						//centernexty=(tileRow * tileSize)+(tileSize*.5);
						setnexty(tileRow * tileSize);
					}
					
					if (!frozen) setnextx(nextx+(acceleration+accAdjust+gamePlay.levelspeedadjust)*dx);
						
				
				}else if (moveRight) {
					if (turning) {
						//find center of tile x and put player there
						//centernexty=(tileRow * tileSize)+(tileSize*.5);
						setnexty(tileRow * tileSize);
					}
					
					if (!frozen) setnextx(nextx+(acceleration+accAdjust+gamePlay.levelspeedadjust)*dx);
					
					////trace("nextx=" + nextx);
				
				}
			
				//change location for tunnels
				if (nexty<(-.5*tileSize)) {
					////trace ("up tunnel");
					setnexty(tileSize*mapRows);
				}else if (nexty> (tileSize*mapRows)){
					////trace ("down tunnel");
					setnexty(0);
				}else if (nextx > (tileSize*mapCols)){
					////trace ("right tunnel");
					setnextx(0);
				}else if (nextx < (-.5*tileSize)){
					////trace ("left tunnel");
					setnextx(tileSize*mapCols);
				}
			
			}
			
			tileRow=int(centernexty / tileSize);
			tileCol=int(centernextx / tileSize);
			turning=false;
		}
	
		override public function render() {
			
			
			
			
			
			
			if (blinkFreeze) {
				blinkFreezeCount++;
				trace("blinkFreezeCount=" + blinkFreezeCount);
				if (blinkFreezeCount > blinkFreezeMaxFrames) {
					blinkFreezeCount=0;
					if (freezeblinkon) {
						freezeblinkon=false;
					}else{
						freezeblinkon=true
						
					}
				}
				if (freezeblinkon) {
					renderalpha=true;
					nextalpha=.1;
				}
					
			}
			
			
			
			////trace("enemy render start");
			super.render();
			resetRenderBooleans();
			////trace("enemy render end");
			
			if (aiState==GamePlay.AI_STATE_FLEE)  {
				//trace("acceleration=" + acceleration + " dx=" + dx + " dy=" + dy);
			
				if (blinkFlee) {
					blinkFleeCount++;
					//trace("blinkFleeCount=" + blinkFleeCount);
					if (blinkFleeCount > blinkFleeMaxFrames) {
						blinkFleeCount=0;
						if (fleeblinkon) {
							//trace("fleeblinkon = false");
							fleeblinkon=false;
						}else{
							fleeblinkon=true
							//trace("fleeblinkon = true");
						}
					}
					
				}
				
				if (!fleeblinkon) {
					fleeFilterFrameCtr++
					if (fleeFilterFrameCtr >fleeFilterFrameDelay) {
						fleeFilterIndex++
						fleeFilterFrameCtr=0;
						//trace("3 invFilter");
						if (fleeFilterIndex == fleeFilterArray.length) {
						//	trace("4 invFilter");
							fleeFilterIndex=0;
						}
					}
					//trace("invFilterArray.length=" + invFilterArray.length);
					//trace("invFilterIndex=" + invFilterIndex);
					gamePlay.getgameScreenBitmapData().copyPixels(fleeFilterArray[fleeFilterIndex],new Rectangle(0,0,tileSize,tileSize), new Point(x,y));
					
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
		