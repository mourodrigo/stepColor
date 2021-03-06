package 
{
	import org.flixel.*;
	
		/**
	 * ...
	 * @author mourodrigo
	 */
	public class Player extends FlxSprite
	{
		public var selfwidth:Number = 20;
		public var selfheight:Number = 20;
		public var colorState:Number = 1;
		public var xVelocity:Number = 100;
		public var currentColor:uint;
		public var lastColor:uint;

		public function Player() 
		{
			super((FlxG.width / 2) - selfwidth/2, (FlxG.height) - selfheight);
			makeGraphic(selfwidth, selfheight, 0xFFFF0000);
		
			health = 20;
			}
			
		override public function update():void {
			super.update();
			
			
			if (currentColor != lastColor) {
				lastColor = currentColor;
				makeGraphic(selfwidth, selfheight, currentColor);
			}
			
			if (FlxG.keys.pressed("LEFT") && x>0) {
				velocity.x = -xVelocity;
			}else if (FlxG.keys.pressed("RIGHT") && x< FlxG.width-selfwidth) {
				velocity.x = xVelocity;
			}else {
				velocity.x = 0;
			}
		}
	}
	
}