package 
{
	import org.flixel.*;
	import Math;
		/**
	 * ...
	 * @author mourodrigo
	 */
	public class Bonus extends FlxSprite
	{
		public var selfwidth:Number = 10;
		public var selfheight:Number = 10;
		public var colorWhite:uint = 0xFFFFFFFF;
	
		//public var stupid:Number;
									
		public function Bonus() 
		{
			super(FlxG.width*FlxG.random(), 0);
			
			makeGraphic(selfwidth, selfheight, colorWhite);
		
			
			}
			
			
			
			
		override public function update():void {
			super.update();
			if (!onScreen) {
				kill();
			}
			velocity.y = 50;
						
		}
	}
	
}