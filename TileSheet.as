/**
* ...
* @author Jeff Fulton
* @version 0.1
*/

package  {
	
	import flash.display.Bitmap;
	import flash.display.Shape;
	import flash.geom.*;
	import flash.display.BitmapData;
	import BasicGameTile;
	import TilesheetDataXML;
	
	public class TileSheet {
	
		var bitmapSheet:BitmapData;
		var aTileData:Array=[]; //1d array of all tiles in sheet- not a 2d array like tilemap
		var tilesheetXML:TilesheetDataXML;
		var tileXML:XML;
		var height:int;
		var width;int;
		var tileSize:int;
		var tilesPerRow:int;
		
		public function TileSheet(widthVal, heightVal,tilesizeVal){
			height=heightVal;
			width=widthVal;
			tileSize=tilesizeVal;
			tilesPerRow=width/tileSize;
			bitmapSheet=new tileSheet_png(widthVal,heightVal);
			//trace("new tile sheet. width=" + bitmapSheet.width + " height=" + bitmapSheet.height);
			loadTilesheetXML();
		}

		public function dispose() {
			bitmapSheet=null;
			tilesheetXML=null;
			tileXML=null;
			
			var ctr1:int;
			for (ctr1=0;ctr1<aTileData.length;ctr1++) {
				aTileData[ctr1]=null;
			}
		}
		
		public function loadTilesheetXML() {
			tilesheetXML=new TilesheetDataXML();
			tileXML=tilesheetXML.getXML();
			var numtiles:int = tileXML.tile.length();
			//trace("tileXML.tile.length() = " + tileXML.tile.length());
			// loop through xml and set properties if BasicGameTiles in aTileData
			for (var tileNum=0;tileNum < numtiles;tileNum++) {
				var tempTile:BasicGameTile= new BasicGameTile();
				var sourceX:int=(tileNum % tilesPerRow)*tileSize;
				var sourceY:int=(int(tileNum/tilesPerRow))*tileSize;
				var tileBitmapData:BitmapData=new BitmapData(tileSize,tileSize,true,0x00000000);
				tileBitmapData.copyPixels(bitmapSheet,new Rectangle(sourceX,sourceY,tileSize,tileSize),new Point(0,0));
				tempTile.aTileBitmapData.push(tileBitmapData);
				//tempTile.initBitmap()
				//tempTile.mapRow=int(tileNum/tilesPerRow);
				//tempTile.mapCol=int(tileNum % tilesPerRow);
				tempTile.tileSize=tileSize;
				//trace("tempTile.mapRow=" + tempTile.mapRow);
				//trace("tempTile.mapCol=" + tempTile.mapCol);
				
				if (tileXML.tile[tileNum].@w=="1") tempTile.isWalkable=true;
				//if (tempTile.isWalkable) trace("tile sheet is walkable")
				if (tileXML.tile[tileNum].@c=="1") tempTile.isCollectible=true;
				if (tileXML.tile[tileNum].@p=="1") {
					tempTile.isPowerUp=true;
					tempTile.powerUpType=int(tileXML.tile[tileNum].@pt);
				}
				if (tileXML.tile[tileNum].@t=="1") {
					tempTile.isTransport=true;
					if (tileXML.tile[tileNum].@tid !=null) {
						tempTile.transportID=tileXML.tile[tileNum].@tid;
					}else{
						tempTile.isTransport=false;
					}
				}
				
				if (tileXML.tile[tileNum].@r=="1") {
					tempTile.isReceiver=true;
					if (tileXML.tile[tileNum].@tid !=null) {
						tempTile.transportID=tileXML.tile[tileNum].@tid;
					}else{
						tempTile.isReceiver=false;
					}
				}
				
				if (tileXML.tile[tileNum].@k=="1") tempTile.isKey=true;
				//if (tempTile.isKey) trace("tile sheet is key")
				if (tileXML.tile[tileNum].@d=="1") tempTile.isDoor=true;
				if (tileXML.tile[tileNum].@a=="1") {
						//trace("looking for animated tiles");
						var aList:String = new String(tileXML.tile[tileNum].@aList);
						//trace("got a list");
						if (aList!=null)  {
							if (tempTile.isDoor) {
								tempTile.animate=false;
							}else{
								tempTile.animate=true;
							}
							var aTempList:Array=aList.split(",");
							////trace("aTempList.length=" + aTempList.length);
							for (var ctr1:int=0;ctr1<aTempList.length;ctr1++) {
								var tileNumber=int(aTempList[ctr1]);
							//	if (tempTile.isKey) trace ("alist=" + tileNumber);
								////trace("tileNumber=" + tileNumber);
								var animTileBitmapData=new BitmapData(tileSize,tileSize,true,0x00000000);
								sourceX=(tileNumber % tilesPerRow)*tileSize;
								sourceY=(int(tileNumber/tilesPerRow))*tileSize;
								////trace("sourceX=" + sourceX);
								////trace("sourceY=" + sourceY);
								animTileBitmapData.copyPixels(bitmapSheet,new Rectangle(sourceX,sourceY,tileSize,tileSize),new Point(0,0));
								tempTile.animationFrameDelay=10;
								tempTile.aTileBitmapData.push(animTileBitmapData);
							}
							
						}else{
							tempTile.animate=false;
						}
					}
					
					if (tileXML.tile[tileNum].@eg=="1") {
						tempTile.isEnemyGenerator=true;
					}
				
				
				
				aTileData.push(tempTile);
			}
			
		}
		
		public function getaTileData():Array {
			return aTileData;
		}
		
		public function getbitmapSheet():BitmapData {
			return bitmapSheet;
		}
		
	} // end class
}// end package