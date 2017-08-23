﻿/*** ...* @author Jeff Fulton* @version 0.1*/package  {		import flash.display.MovieClip;	import flash.text.*; 	import flash.display.Bitmap;	import flash.display.Shape;	import flash.geom.*;	import flash.display.BitmapData;	import flash.events.*;	import flash.display.Stage;	import GameLoop;		//states		dynamic public class HighscoreScreen extends MovieClip {		private var aChoice:Array=new Array("X","A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z","0","1","2","3","4","5","6","7","8","9","&","@","(",")","$","!",".","?");		private var currentInitial:Number;		private var aInitialIndex:Array=new Array(1,1,1);		public static const STATE_DISPLAY:int=0;		public static const STATE_ENTER:int=1;		public static const STATE_ATTRACT:int=2;		public static const STATE_CHECK:int=3;		public static const STATE_WORLDDISPLAY:int=4;		public var currentState:int;		//public var highscoreScreen:highscoreScreen_mc;		//public var highscoreEntryScreen:highscoreScreenEntry_mc;		public var highscoreCheckScreen:highscoreCheckScreen_mc;		//public var highscoreWorldDisplayScreen:highscoreWorldDisplayScreen_mc;		public var mochiHolder:MovieClip=new MovieClip;		public var mochiEnterHolder:MovieClip=new MovieClip;		private var tlPressSpace:TextField;		private var gameLoop:GameLoop;		private var boardID:String;		private var gameID:String;		private var enterStarted:Boolean=false;		private var checkStarted:Boolean=false;		private var worldDisplayStarted:Boolean=false;		private var yourscore:Number;		private var yourname:String;								public function HighscoreScreen(gameLoopval:GameLoop,boardval:String,gameval:String) {			gameLoop=gameLoopval;			boardID=boardval;			gameID=gameval;					//MochiServices.connect(gameID,this);			//highscoreScreen=new highscoreScreen_mc();			//highscoreEntryScreen=new highscoreScreenEntry_mc();			highscoreCheckScreen=new highscoreCheckScreen_mc();			//highscoreWorldDisplayScreen=new highscoreWorldDisplayScreen_mc();		}				public function addListeners():void {				gameLoop.stage.addEventListener(KeyboardEvent.KEY_DOWN,keyDownListener,false,0,true);		}				public function removeListeners():void {			gameLoop.stage.removeEventListener(KeyboardEvent.KEY_DOWN,keyDownListener);			worldDisplayStarted=false;			checkStarted=false;			enterStarted=false;					}						public function setState(stateval:int) {			currentState=stateval;			switch (currentState) {								case STATE_CHECK:					if (!checkStarted) {						checkStarted=true;						trace("check 1");						highscoreCheckScreen.x=40;						highscoreCheckScreen.y=40;						trace("inside check, yourname=" + yourname);																		yourscore=gameLoop.getlastScore();						highscoreCheckScreen.yourscore_txt.text=String(yourscore);						//**** mind jolt high score												trace("trying mind jolt")						//MindJoltAPI.service.submitScore(yourscore);						trace("end trying mind jolt")						//**** end people grade highscore																	addChild(highscoreCheckScreen);											}					break;																}		}												function keyDownListener(e:KeyboardEvent):void {						if (e.keyCode==77) {				trace("M pressed in high score screen");				gameLoop.dispatchSoundMuteEvent();			}				if (e.keyCode==32) {				trace("check score screen space bar pressed");				removeListeners();				removeChild(highscoreCheckScreen);				gameLoop.highscoreScreenFinshed();				checkStarted=false;			}											}							} // end class} // end package