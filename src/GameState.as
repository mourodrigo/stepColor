package
{
    import org.flixel.*;
 
    public class GameState extends FlxState
    {
		//game
		public var second:Number = 1;
		public var lblScore:FlxText;
		public var lblHealth:FlxText;
		public var lblWave:FlxText;
		public var pause:Boolean = false;

		//player
		public var player1:Player;
		
		//shoots
		public var shootsGrp:FlxGroup;
		public var shootYVelocity:Number = 75;
		public var timerShoot:Number = 0;
		public var timerShootMax:Number = 0.4;
		
		//colors
		public var colorBlue:uint = 0xFF0000FF;
		public var colorRed:uint = 0xFFFF0000;
		public var colorGreen:uint = 0xFF00FF00;
		public var colorYellow:uint = 0xFFFFFF66;
		public var colorWhite:uint = 0xFFFFFFFF;
		
		//enemies
		public var enemySpeed:Number = 50;
		public var enemyGrp:FlxGroup;
		//public var inimigos1Velocidade:Number = 2;
		public var enemyTimer:Number = 0;
		public var enemyTimerMax:Number = 0.5;
		
		//waves
		public var delayWave1:Number = 0;
		public var enemiesWave1:Number = 1;
		public var enemiesWaveLast:Number = 1;
		
		//gameplay
		public var easy:Boolean = true;
		public var changeEnemyColor:Boolean = false;
		public var whiteMode:Boolean = false;
		public var whiteModeTimerMax:Number;
		public var backwardsMode:Boolean = false;
		public var bonus:Bonus;
		
		
		//paths
		public var enemyPath:FlxPath;

		public var wave:Number = 5;
		
		 
		[Embed(source="sounds/laser.mp3")] private var soundLaser:Class;
		[Embed(source = "sounds/hit.mp3")] private var soundsHit:Class;
		[Embed(source = "sounds/miss.mp3")] private var soundsMiss:Class;
		[Embed(source="sounds/music_killTheNoise.mp3")] private var killthenoise:Class;
		public var music:Number = 0;
		
		override public function create():void
        {
			enemyPath = new FlxPath();
			enemyPath.addPoint(makePoint(50, 10));
			enemyPath.addPoint(makePoint(90, 10));
			enemyPath.addPoint(makePoint(90, 30));
			enemyPath.addPoint(makePoint(50, 30));
			enemyPath.addPoint(makePoint(10, 30));
			enemyPath.addPoint(makePoint(10, 10));
			
			/*
			enemyPath.add(FlxG.width/10, FlxG.height/6);
			enemyPath.add(FlxG.width-FlxG.width/10, FlxG.height/6);
			enemyPath.add(FlxG.width-FlxG.width/10, FlxG.height/10);
			enemyPath.add(FlxG.width/10, FlxG.height/10);
			*/
			FlxG.mouse.show();

			//PLAYER
			player1 = new Player;
			add(player1);
			
			//shootsGrp
			shootsGrp = new FlxGroup();
			for (var i:int = 0; i < 50; i++) {
				shootsGrp.add(new Shoot());
			}
			add(shootsGrp);
			
			//enemies
			enemyGrp = new FlxGroup();
			for (var x:int = 0; x < 50; x++) {
				
				var shoots:FlxGroup = new FlxGroup();
				for (var z:int = 0; z < 20; z++) {
					shoots.add(new Shoot());
				}
				add(shoots);
				
				enemyGrp.add(new Enemy(shoots));
				
			}
			add(enemyGrp);
		
			enemiesWaveLast = enemiesWave1;
			//LABELS
			
			
			lblHealth = new FlxText(0, 0, 200, "Health: |");
			add(lblHealth);

			lblScore = new FlxText(0, 13, 100, "Score: 0");
			add(lblScore);

			lblWave = new FlxText(0, 26, 100, "Wave: 1");
			add(lblWave);
			
			//FlxG.play(killthenoise, 1, false)
			
			//GAMEPLAY
			bonus = new Bonus();
			add(bonus);
			bonus.kill();
			
			
			super.create();
			 
		}
		
		public function watchWave(badguys:FlxGroup, interval:Number, directions:FlxPath):void {
			 
			
			if (delayWave1<=0 && second <=0 && enemiesWave1 > 0) {
				/*if (music==0) {
					music = 1;
					//FlxG.play(stream1, 1, false);
				}*/
				addEnemy(0, directions, enemySpeed);
				delayWave1 = interval;
			}
			
			if (second<=0) {
					delayWave1--;
					//FlxG.log("second ->" + second);
					FlxG.log("interval ->" + interval);
					FlxG.log("delaywave1 ->" + delayWave1);
					FlxG.log("enemiesWave1 ->" + enemiesWave1);
			
		
			}
			
			
		}
		
		public function getRandomColor(level:Number):uint {
			var randomcolor:Number = level * FlxG.random();
						FlxG.log("RANDOMCOLOR! ->" + randomcolor + "level : " + level);
						if (randomcolor<=2) {
							return colorRed;
						}
						if (randomcolor>2 && randomcolor<=4) {
							return colorGreen;
						}
						if (randomcolor>4 && randomcolor<=6) {
							return colorYellow;
						}
						if (randomcolor>6) {
							return colorBlue;
						}
						
						return colorBlue;
		}
		
		public function addEnemy(color:uint, directions:FlxPath, speed:Number):void {
			var badGuy:Enemy= enemyGrp.getFirstAvailable() as Enemy;
			
			
				
				if (badGuy != null) {
					//FlxG.log("badguy not null");
					badGuy.reset(FlxG.width*FlxG.random(), 0);
					//badGuy.velocity.x = -badGuy.xVelocity;
					//\badGuy.velocity.y = 1;
					badGuy.selfwidth = 10;
					badGuy.selfheight = 10;
					badGuy.speed = speed;
					//FlxG.log("add enemy cor ->" + color );
					if (color!=0) {
						badGuy.currentColor = color;
						FlxG.log("set color!");

					}else {
						/*
						var wavecolors:Number = wave / 2;
						if (wavecolors>4) {
							wavecolors = 4;
						}
						*/
						
						badGuy.currentColor = getRandomColor(wave);
						
					}
					badGuy.followPath(directions, speed);
					
				
					enemiesWave1--;

				}else {
					FlxG.log("badguy null!");
				}
				
				
			
		}
		
		public function checkAlive():void {
			FlxG.log(" count living" + enemyGrp.countLiving() );
				if (enemyGrp.countLiving() <= 0) {
					wave++;
					lblScore.text = "wave ->" + wave;
					/*
					enemyPath.remove(enemyPath.tail());
					enemyPath.add(FlxG.width/4, FlxG.height-FlxG.height/10);
					enemyPath.add(FlxG.width/10, FlxG.height/2);
					enemyPath.add((FlxG.width/4)*3, FlxG.height-FlxG.height/10);
					enemyPath.add(FlxG.width/10, FlxG.height/10);
					enemySpeed = enemySpeed * 2;
					*/
					
					switch(wave) {
						case 2://red
							enemiesWave1 = 4;
							enemiesWaveLast = enemiesWave1;
							enemyPath = new FlxPath();
							enemyPath.addPoint(makePoint(10, 20));
							enemyPath.addPoint(makePoint(90, 20));
							enemyPath.addPoint(makePoint(10, 30));
							enemyPath.addPoint(makePoint(30, 10));
							break;
						case 3://green
							enemiesWave1 = 4;
							enemiesWaveLast = enemiesWave1;
							break;
						case 4://green
							enemiesWave1 = 8;
							enemiesWaveLast = enemiesWave1;
							enemySpeed = 60;
							break;
						case 5://yellow
							enemiesWave1 = 3;
							enemiesWaveLast = enemiesWave1;
							break;
						case 6://yellow
							enemiesWave1 = 6;
							enemiesWaveLast = enemiesWave1;
							break;
						case 7://blue
							enemiesWave1 = 6;
							enemiesWaveLast = enemiesWave1;
							enemySpeed = 75;
							break;
						case 8://blue
							enemiesWave1 = 8;
							enemiesWaveLast = enemiesWave1;
							break;
						case 9:
							enemiesWave1 = 10;
							enemiesWaveLast = enemiesWave1;
							break;
						
						if (wave>=10) {
							enemiesWave1 = enemiesWaveLast*2;
							enemiesWaveLast = enemiesWave1;
							
						}
						
						
					}
					
					/*
					if (easy && wave <= 8) {
						enemiesWave1 = enemiesWaveLast * 2;
						enemiesWaveLast = enemiesWave1;
					}else if (!easy && wave <= 8) {
						enemiesWave1 = enemiesWaveLast;
						enemiesWaveLast = enemiesWave1;
					}else {
						enemiesWave1 = 30;
					}
					
					if (easy) {
						easy = false;
					}else {
						easy = true;
					}
					*/
					
					
					
				}
		}
		
		
		public function overlapShootEnemy(tiro: Shoot, inimigo: Enemy):void {
			if (tiro.currentColor==inimigo.currentColor || whiteMode) {
				inimigo.kill();
				FlxG.play(soundsHit, 1, false);
				FlxG.score += 10;
				
			}else {
				inimigo.currentColor = getRandomColor(wave);
				
				if (inimigo.width>8) {
					inimigo.makeGraphic(inimigo.selfwidth * 0.8, inimigo.selfheight * 0.8, inimigo.currentColor);
					inimigo.selfwidth = inimigo.selfwidth * 0.8;
					inimigo.selfheight = inimigo.selfheight * 0.8;
				}
				
				FlxG.play(soundsMiss, 1, false);

			}
				tiro.kill();
		}
		
		public function overlapBonus(bonus:Bonus, player:Player):void {
			
			
			bonus.kill();
			whiteMode = true;
			whiteModeTimerMax = 5;
			
			
		}
		
		public function testShoot():void {
			timerShoot -= FlxG.elapsed;
			if ( (FlxG.keys.pressed("Q") ||
			 	 (FlxG.keys.pressed("W") && wave>2) ||
				 (FlxG.keys.pressed("E") && wave>4) ||
				 (FlxG.keys.pressed("R") && wave>6) ) && timerShoot <= 0 && player1.alive) {
				
				timerShoot = timerShootMax;
				
				var t:Shoot = shootsGrp.getFirstAvailable() as Shoot;
				
				if (t != null) {
					t.reset(player1.x, player1.y);
					t.velocity.y = -shootYVelocity*3;
				}
				
				if (FlxG.keys.pressed("Q")){
					player1.currentColor = colorRed;
					t.currentColor = colorRed;
				}else if (FlxG.keys.pressed("W") && wave > 2) {
					player1.currentColor= colorGreen;
					t.currentColor = colorGreen;
				}else if (FlxG.keys.pressed("E") && wave > 4){
					player1.currentColor= colorYellow;
					t.currentColor = colorYellow;
				}else if (FlxG.keys.pressed("R") && wave >6){
					player1.currentColor= colorBlue;
					t.currentColor = colorBlue;
				} 

				FlxG.play(soundLaser, 1, false);

				
			}
			
				
			//inimigos1.members.forEach(
		
			
		}
		
		public function overlapEnemyShoot(tiro: Shoot, currentPlayer: Player):void {
			if (tiro.currentColor == currentPlayer.currentColor) {
					tiro.kill();
					currentPlayer.health = currentPlayer.health - tiro.damage*2;
					FlxG.log("player health -> "+ currentPlayer.health);
					
				}else {
					currentPlayer.currentColor = tiro.currentColor;
					currentPlayer.health = currentPlayer.health - tiro.damage;
					FlxG.log("player health -> "+ currentPlayer.health);
				}
				
				if (currentPlayer.health <= 0) {
					currentPlayer.kill();
					FlxG.log("player health -> "+ currentPlayer.health);
				}
				if (currentPlayer.health == 2) {
					lblHealth.color = colorRed;
				
				}
				
				
			}
			
			public function lblControl():void {
				
				var rememberLife:Number = 0;
				lblHealth.text = "";
				
				for (rememberLife = 0; rememberLife <= player1.health; rememberLife++  ) {
					lblHealth.text = lblHealth.text + "|";
				}
				

				lblHealth.text = "Health: " + lblHealth.text;

				lblScore.text = "Score: " + FlxG.score;
				
				lblWave.text = "Wave: " + wave;
		
			}
			
			public function killAll(dead:Enemy):void {
				dead.kill();
			}
			
			public function changeEnemyColors(coloredGuy:Enemy):void {
				coloredGuy.currentColor = getRandomColor(wave);
			}
			
			public function makePoint(x:Number, y:Number):FlxPoint {
				return new FlxPoint((FlxG.width / 100) * x, (FlxG.height / 100) * y);
				
			}
			
			
		override public function update():void
        {
			second -= FlxG.elapsed;
			
			lblControl();
			
			watchWave(enemyGrp, enemyTimerMax, enemyPath);
			
			testShoot();
		
			FlxG.overlap(shootsGrp, enemyGrp, overlapShootEnemy);
			
			if (bonus.alive) {
				FlxG.overlap(bonus, player1, overlapBonus);
			}
			
			for each (var enemy:Enemy in enemyGrp.members) { //do stuff with enemies here
				if (enemy.alive) {//we dont have to look to the dead ones, and its makes a HUGE difference
				
					FlxG.overlap(enemy.shoots, player1, overlapEnemyShoot);
				
					if (FlxG.keys.justPressed("K")){ //kill all enemy with K
					   killAll(enemy);
					}
					
					if (FlxG.keys.pressed("L")){ 
					   changeEnemyColor = true;
					}else {
						changeEnemyColor = false;
					}
					
					if (FlxG.keys.pressed("D")) { 
						backwardsMode = true;
					}else {
						backwardsMode = false;
					}
					/*
					if (FlxG.keys.pressed("S")) { 
						whiteMode = true;
					}else {
						whiteMode = false;
					}
					*/
					if (backwardsMode) {
					   enemy.pathSpeed = -enemySpeed;
					}else {
					   enemy.pathSpeed = enemySpeed;
					}
					
					if (changeEnemyColor) {
						changeEnemyColors(enemy);
					}
					
					if (FlxG.keys.pressed("A")) { 
						
						bonus.reset(FlxG.width*FlxG.random(), 0);
					}
					
					if (whiteMode) {
						FlxG.log("WHITE MODE " + whiteModeTimerMax); 
						enemy.currentColor = colorWhite;
						enemy.pathSpeed = 0;
						enemy.velocity.x = 0;
						enemy.velocity.y = 0;
						
						whiteModeTimerMax -= FlxG.elapsed;
						if (whiteModeTimerMax<=0) {
							changeEnemyColors(enemy);
							enemy.pathSpeed = enemySpeed;
						}
					}
					
					
				}
				
				
			}
			
			
			if (second<=0) {
				second = 1;
				checkAlive();
			}
			
			if (whiteModeTimerMax<=0) {
				whiteMode = false;
			}
			
			super.update();
			
		}
		
	}
}