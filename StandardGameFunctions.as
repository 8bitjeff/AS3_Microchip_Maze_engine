/**
* ...
* @author Default
* @version 0.1
*/

package {

	public class GameUtils {
		public static function stringToBoolean(value:String) {
			
			switch(value) {
				case "1":
				case "true":
				case "yes":
					return true;
				case "0":
				case "false":
				case "no":
					return false;
				default:
					return Boolean(value);
			}

		}
	}
	
	
	
		
	
}