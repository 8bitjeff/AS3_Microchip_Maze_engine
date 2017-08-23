/**
* ...
* @author Jeff Fulton
* @version 0.1
*/

package  {
	
	
	public class PowerUpType {
		
		var type:int;
		var playerAccAdjust:Number=0;
		var playerAccTimeAdd:Number=0;
		var playerInvincibleAdjust:Boolean=false;
		var playerInvincibleTimeAdd:Number=0;
		var playerEatEnemyAdjust:Boolean=false;
		var playerEatEnemyTimeAdd:Number=0;
		var playerScoreAdjust:Number=0;
		var playerBonusAdjust:Number=0;
		var playerBonusTimeAdjust:Number=0;
		var playerKillAllEnemyAdjust:Boolean=true;
		var playerBonusXAdjust:int=0;
		var title:String; //used for enemy and power ups in level in screen
		
		public function PowerUpType(typeval:int) {
			type=typeval;
		}
	}
}
		