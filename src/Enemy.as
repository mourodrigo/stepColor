package 
{
	import org.flixel.*;
	import Math;
		/**
	 * ...
	 * @author mourodrigo
	 */
	public class Enemy extends FlxSprite
	{
		public var selfwidth:Number = 10;
		public var selfheight:Number = 10;
		public var colorState:Number = 1;
		public var speed:Number = 25;
		public var currentColor:uint= 0xFFFF0000;
		public var lastColor:uint;
		public var colorWhite:uint = 0xFFFFFFFF;
		
		//SHOOT
		public var shoots:FlxGroup;
		public var tiroYVelocity:Number = 75;
		public var timerShoot:Number = 0;
		public var timerShootMax:Number = 4;
		
		//public var stupid:Number;
									
		public function Enemy(shootsGrp :FlxGroup) 
		{
			super((FlxG.width / 2) - selfwidth/2, 0);
			
			makeGraphic(selfwidth, selfheight, currentColor);
		
			shoots = shootsGrp;
			
			
			
			
			kill();
			
			
			
			}
			
			
		public function testShoot():void {
			timerShoot -= FlxG.elapsed;
			if (timerShoot <= 0) {
			
				timerShoot = timerShootMax + FlxG.random(); //STUPID AI
				//FlxG.log(timerShoot);
				var t:Shoot = shoots.getFirstAvailable() as Shoot;
				
				if (t != null) {
					t.reset(x, y);
					if (currentColor == colorWhite) {
						t.kill();
					}else {
						t.velocity.y = tiroYVelocity;
					}
				}
				
					t.currentColor = currentColor;
				 

//				FlxG.play(soundLaser, 1, false);

				
			}
			
				
		}	
			
		override public function update():void {
			super.update();
			
			if (FlxU.getDistance(new FlxPoint(x,y), path.tail())<10) {
				followPath(path, speed);
			}
	/*
			if (!onScreen()) {
				kill();
			}
		*/	
			if (currentColor != lastColor) {
				lastColor = currentColor;
				makeGraphic(selfwidth, selfheight, currentColor);
			}
			
			testShoot();
						
		}
	}
	
}