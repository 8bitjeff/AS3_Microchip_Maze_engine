/**
* ...
* @author Jeff Fulton
* @version 0.1
*/

package  {
	
	
	public class Level3DataXML implements iLevelData{
	
		var XMLData:XML;
		
		public function Level3DataXML(){
			trace("level 3 data");
		XMLData= 
<level>
	<framerate>45</framerate>
	<backgroundtile>19</backgroundtile>
	<playerstartrow>9</playerstartrow>
	<playerstartcol>7</playerstartcol>
	<enemytype num="5">EnemyRat</enemytype>
	<enemytype num="1">EnemySnakeBlue</enemytype>
	<enemytype num="5">EnemySnakPurple</enemytype>
	<bonustimelimit>120</bonustimelimit>
	<timebonus>10</timebonus>
	<extramanamount>15000</extramanamount>
	<enemytoeatforbonusxplus>5</enemytoeatforbonusxplus>
	<attackbonusperkill>25</attackbonusperkill>
	<enemystartFrameDelay>50</enemystartFrameDelay>
	<enemyrestartFrameDelay>200</enemyrestartFrameDelay>
	<levelspeedadjust>0</levelspeedadjust>
<tilerow>
<tilecol>12</tilecol><tilecol>15</tilecol><tilecol>12</tilecol><tilecol>12</tilecol><tilecol>12</tilecol><tilecol>12</tilecol><tilecol>12</tilecol><tilecol>12</tilecol><tilecol>12</tilecol><tilecol>12</tilecol><tilecol>12</tilecol><tilecol>12</tilecol><tilecol>12</tilecol><tilecol>15</tilecol><tilecol>12</tilecol>
</tilerow>
<tilerow>
<tilecol>15</tilecol><tilecol>15</tilecol><tilecol>12</tilecol><tilecol>26</tilecol><tilecol>15</tilecol><tilecol>15</tilecol><tilecol>220</tilecol><tilecol>205</tilecol><tilecol>15</tilecol><tilecol>85</tilecol><tilecol>15</tilecol><tilecol>15</tilecol><tilecol>12</tilecol><tilecol>15</tilecol><tilecol>15</tilecol>
</tilerow>
<tilerow>
<tilecol>12</tilecol><tilecol>15</tilecol><tilecol>12</tilecol><tilecol>15</tilecol><tilecol>15</tilecol><tilecol>15</tilecol><tilecol>15</tilecol><tilecol>15</tilecol><tilecol>15</tilecol><tilecol>15</tilecol><tilecol>15</tilecol><tilecol>15</tilecol><tilecol>12</tilecol><tilecol>15</tilecol><tilecol>12</tilecol>
</tilerow>
<tilerow>
<tilecol>12</tilecol><tilecol>15</tilecol><tilecol>15</tilecol><tilecol>12</tilecol><tilecol>15</tilecol><tilecol>15</tilecol><tilecol>15</tilecol><tilecol>15</tilecol><tilecol>15</tilecol><tilecol>15</tilecol><tilecol>15</tilecol><tilecol>12</tilecol><tilecol>15</tilecol><tilecol>15</tilecol><tilecol>12</tilecol>
</tilerow>
<tilerow>
<tilecol>12</tilecol><tilecol>15</tilecol><tilecol>15</tilecol><tilecol>15</tilecol><tilecol>12</tilecol><tilecol>12</tilecol><tilecol>12</tilecol><tilecol>112</tilecol><tilecol>12</tilecol><tilecol>12</tilecol><tilecol>12</tilecol><tilecol>15</tilecol><tilecol>15</tilecol><tilecol>15</tilecol><tilecol>12</tilecol>
</tilerow>
<tilerow>
<tilecol>12</tilecol><tilecol>106</tilecol><tilecol>15</tilecol><tilecol>15</tilecol><tilecol>15</tilecol><tilecol>15</tilecol><tilecol>15</tilecol><tilecol>15</tilecol><tilecol>15</tilecol><tilecol>15</tilecol><tilecol>15</tilecol><tilecol>15</tilecol><tilecol>15</tilecol><tilecol>15</tilecol><tilecol>12</tilecol>
</tilerow>
<tilerow>
<tilecol>12</tilecol><tilecol>15</tilecol><tilecol>15</tilecol><tilecol>12</tilecol><tilecol>15</tilecol><tilecol>15</tilecol><tilecol>15</tilecol><tilecol>15</tilecol><tilecol>15</tilecol><tilecol>15</tilecol><tilecol>15</tilecol><tilecol>12</tilecol><tilecol>15</tilecol><tilecol>15</tilecol><tilecol>12</tilecol>
</tilerow>
<tilerow>
<tilecol>15</tilecol><tilecol>15</tilecol><tilecol>69</tilecol><tilecol>12</tilecol><tilecol>15</tilecol><tilecol>15</tilecol><tilecol>15</tilecol><tilecol>26</tilecol><tilecol>15</tilecol><tilecol>15</tilecol><tilecol>15</tilecol><tilecol>12</tilecol><tilecol>69</tilecol><tilecol>15</tilecol><tilecol>15</tilecol>
</tilerow>
<tilerow>
<tilecol>12</tilecol><tilecol>15</tilecol><tilecol>15</tilecol><tilecol>12</tilecol><tilecol>15</tilecol><tilecol>15</tilecol><tilecol>15</tilecol><tilecol>15</tilecol><tilecol>15</tilecol><tilecol>15</tilecol><tilecol>15</tilecol><tilecol>12</tilecol><tilecol>15</tilecol><tilecol>15</tilecol><tilecol>12</tilecol>
</tilerow>
<tilerow>
<tilecol>12</tilecol><tilecol>15</tilecol><tilecol>15</tilecol><tilecol>15</tilecol><tilecol>15</tilecol><tilecol>15</tilecol><tilecol>15</tilecol><tilecol>15</tilecol><tilecol>15</tilecol><tilecol>15</tilecol><tilecol>15</tilecol><tilecol>15</tilecol><tilecol>15</tilecol><tilecol>15</tilecol><tilecol>12</tilecol>
</tilerow>
<tilerow>
<tilecol>12</tilecol><tilecol>15</tilecol><tilecol>15</tilecol><tilecol>15</tilecol><tilecol>12</tilecol><tilecol>12</tilecol><tilecol>12</tilecol><tilecol>12</tilecol><tilecol>12</tilecol><tilecol>12</tilecol><tilecol>12</tilecol><tilecol>15</tilecol><tilecol>15</tilecol><tilecol>15</tilecol><tilecol>12</tilecol>
</tilerow>
<tilerow>
<tilecol>12</tilecol><tilecol>15</tilecol><tilecol>15</tilecol><tilecol>12</tilecol><tilecol>15</tilecol><tilecol>15</tilecol><tilecol>15</tilecol><tilecol>15</tilecol><tilecol>15</tilecol><tilecol>15</tilecol><tilecol>15</tilecol><tilecol>12</tilecol><tilecol>15</tilecol><tilecol>15</tilecol><tilecol>12</tilecol>
</tilerow>
<tilerow>
<tilecol>12</tilecol><tilecol>15</tilecol><tilecol>12</tilecol><tilecol>15</tilecol><tilecol>15</tilecol><tilecol>15</tilecol><tilecol>15</tilecol><tilecol>218</tilecol><tilecol>15</tilecol><tilecol>15</tilecol><tilecol>15</tilecol><tilecol>15</tilecol><tilecol>12</tilecol><tilecol>15</tilecol><tilecol>12</tilecol>
</tilerow>
<tilerow>
<tilecol>15</tilecol><tilecol>15</tilecol><tilecol>112</tilecol><tilecol>15</tilecol><tilecol>15</tilecol><tilecol>115</tilecol><tilecol>15</tilecol><tilecol>128</tilecol><tilecol>15</tilecol><tilecol>85</tilecol><tilecol>15</tilecol><tilecol>15</tilecol><tilecol>112</tilecol><tilecol>15</tilecol><tilecol>15</tilecol>
</tilerow>
<tilerow>
<tilecol>12</tilecol><tilecol>15</tilecol><tilecol>12</tilecol><tilecol>12</tilecol><tilecol>12</tilecol><tilecol>12</tilecol><tilecol>12</tilecol><tilecol>12</tilecol><tilecol>12</tilecol><tilecol>12</tilecol><tilecol>12</tilecol><tilecol>12</tilecol><tilecol>12</tilecol><tilecol>15</tilecol><tilecol>12</tilecol>
</tilerow>
</level>
		}

	public function getXML():XML {
			return XMLData;
		}
		
	} // end class
}// end package