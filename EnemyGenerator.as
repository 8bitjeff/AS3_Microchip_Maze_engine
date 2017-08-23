/**
* ...
* @author Jeff Fulton
* @version 0.1
*/

package  {
	
	import GamePlay;

	
	public class EnemyGenerator {
		var row:int;
		var col:int;
		public var gamePlay:GamePlay;
		
		
		public function EnemyGenerator(rowVal:int,colVal:int,gp:GamePlay) {
			
			row=rowVal;
			col=colVal;
			gamePlay=gp;
			
			
		}
	}
}
		