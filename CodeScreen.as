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


	public class CodeScreen extends MovieClip {
		private var codeScreen:codeentryscreen_mc=new codeentryscreen_mc;
		private var gameLoop:GameLoop;
		private var letterIndex:int=0;
		private var maxIndex=10;
		private var currentStringLetter:String;
		private var letterFrame:String;
		private var cursorNumString:String;
		private var entryString:String;
		private var aEntryString:Array;
		private var ctr1:int;
		private var searchResult:Number;
		private var aLevelPassword:Array;
		private var codeAccepted:Boolean=false;
		
		
		public function CodeScreen(gameLoopval:GameLoop) {
			gameLoop=gameLoopval;
			codeScreen.x=40;
			codeScreen.y=40;
			addChild(codeScreen);
			
		}
		
		public function reset():void {
			addListeners();
			letterIndex=0;
			setCursorOn(0);
			entryString="";
			aEntryString=[];
			codeAccepted=false;
			aLevelPassword=gameLoop.getaLevelPassword();
			codeScreen.letter0.visible=false;
			codeScreen.letter1.visible=false;
			codeScreen.letter2.visible=false;
			codeScreen.letter3.visible=false;
			codeScreen.letter4.visible=false;
			codeScreen.letter5.visible=false;
			codeScreen.letter6.visible=false;
			codeScreen.letter7.visible=false;
			codeScreen.letter8.visible=false;
			codeScreen.letter9.visible=false;
			codeScreen.letter10.visible=false;
			codeScreen.checkmark_mc.visible=false;
			codeScreen.instr1_mc.visible=true;
			codeScreen.instr2_mc.visible=false;
		}
		
		function setCursorOn(cursonNum:int) {
			
			codeScreen.cursor0.visible=false;
			codeScreen.cursor1.visible=false;
			codeScreen.cursor2.visible=false;
			codeScreen.cursor3.visible=false;
			codeScreen.cursor4.visible=false;
			codeScreen.cursor5.visible=false;
			codeScreen.cursor6.visible=false;
			codeScreen.cursor7.visible=false;
			codeScreen.cursor8.visible=false;
			codeScreen.cursor9.visible=false;
			codeScreen.cursor10.visible=false;
			cursorNumString="cursor"+String(cursonNum);
			codeScreen[cursorNumString].visible=true;
			
		}
		
		
			
		public function addListeners():void {
			gameLoop.stage.addEventListener(KeyboardEvent.KEY_DOWN,keyDownListener,false,0,true);
		}
		
		public function removeListeners():void {
			gameLoop.stage.removeEventListener(KeyboardEvent.KEY_DOWN,keyDownListener);
		}
		
		function keyDownListener(e:KeyboardEvent):void {
			
			
			
			trace("e.keyCode=" + e.keyCode);
			if ((e.keyCode >= 65 && e.keyCode <=90) || (e.keyCode >= 97 && e.keyCode <=122)) {
				trace("valid letter key pressed");
				currentStringLetter=String.fromCharCode(e.charCode);
				currentStringLetter=currentStringLetter.toLowerCase();
				letterFrame="arcade_"+currentStringLetter;
				trace("e.charCode=" + currentStringLetter);
				trace("going to letter frame");
				codeScreen["letter"+letterIndex].gotoAndStop(letterFrame);
				codeScreen["letter"+letterIndex].visible=true;
				aEntryString[letterIndex]=currentStringLetter;
				letterIndex++;
				codeScreen.instr1_mc.visible=true;
				codeScreen.instr2_mc.visible=false;
				codeScreen.checkmark_mc.visible=false;
				if (letterIndex > maxIndex) {
					letterIndex=maxIndex;
				}else{
					setCursorOn(letterIndex);
				}
				
			}
			
			if (e.keyCode==8 || e.keyCode==37) {
				codeAccepted=false;
				trace("backspace key");
				codeScreen["letter"+letterIndex].visible=false;
				aEntryString[letterIndex]="";
				letterIndex--;
				codeScreen.instr1_mc.visible=true;
				codeScreen.instr2_mc.visible=false;
				codeScreen.checkmark_mc.visible=false;
				if (letterIndex < 0) {
					letterIndex=0;
				}
				setCursorOn(letterIndex);
			}
			
			
			if (e.keyCode==13){ 
				checkEntry();
			}
				
			if (e.keyCode==27) {
				//escape
				removeListeners();
				gameLoop.codeScreenFinished(GameLoop.STATE_SYSTEM_MENUSCREEN);
			}
		
			if (codeAccepted && e.keyCode==83) {
				removeListeners();
				gameLoop.setbLevelOverride(true);
				gameLoop.setiLevelOverride(searchResult);
				gameLoop.codeScreenFinished(GameLoop.STATE_SYSTEM_GAMEPLAY);
			}
		
		}
		
		function checkEntry():void {
			entryString=aEntryString.join("");
			trace("entryString=" + entryString);
			searchResult=aLevelPassword.indexOf(entryString);
			trace("searchResult=" + searchResult);
			if (searchResult != -1) {
				codeAccepted=true;
				codeScreen.checkmark_mc.visible=true;
				codeScreen.instr1_mc.visible=false;
				codeScreen.instr2_mc.visible=true;
				codeScreen.instr2_mc.levelnum_txt.text=String(searchResult);
				gameLoop.soundManager.codeAccepted();
			}else{
				codeScreen.checkmark_mc.visible=false;
				codeAccepted=false;
			}
		}
	
	} // end class

} // end package