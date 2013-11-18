package
{
    import org.flixel.*;
 
    public class GameState extends FlxState
    {
		//game
		public var time:Number=0;
		public var musicTime:Number=0;
		public var second:Number = 1;
		public var lblScore:FlxText;
		public var lblHealth:FlxText;
		public var lblWave:FlxText;
		public var pause:Boolean = false;
		public var _hud:FlxText;
		
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
		public var enemiesWaveMin:Number = 1;
		public var enemiesWaveMax:Number = 1;
		public var enemiesWaveKilled:Number = 0;
		
		
		//gameplay
		public var easy:Boolean = true;
		public var changeEnemyColor:Boolean = false;
		public var whiteMode:Boolean = false;
		public var whiteModeTimerMax:Number;
		public var backwardsMode:Boolean = false;
		public var bonus:Bonus;
		public var dubModeTimerLeft:Number = 0;
		public var dubModeChangeBgState:Number = 0;
		public var dubModeColor:uint;
		public var emitter:FlxEmitter	
		public var waveOn:Boolean = false;
		
		public var keyLeftPressed:Boolean = false;
		public var keyRightPressed:Boolean = false;
		public var keyQPressed:Boolean = false;
		public var keyWPressed:Boolean = false;
		public var firstEnemyDown:Boolean = false;

		
		//paths
		public var enemyPath:FlxPath;
		public var pathTopCircle:FlxPath;
		public var pathSpirals:FlxPath;
		public var pathTrapezium:FlxPath;
		public var pathBird:FlxPath;
		

		public var wave:Number = 5;
		
		 
		[Embed(source="sounds/laser.mp3")] private var soundLaser:Class;
		[Embed(source = "sounds/hit.mp3")] private var soundsHit:Class;
		[Embed(source = "sounds/miss.mp3")] private var soundsMiss:Class;
	//	[Embed(source="sounds/1_Twilight_Zone.mp3")] private var musicTwilight:Class;
		
		public var music:Number = 0;
		
		override public function create():void
        {
			
			
			emitter = new FlxEmitter(100,100); //x and y of the emitter
			var particles:int = 5;
			
			for(var i:int = 0; i < particles; i++)
			{
				var particle:FlxParticle = new FlxParticle();
				particle.makeGraphic(2, 2, colorWhite);
				particle.exists = false;
				emitter.add(particle);
			}
			
			add(emitter);
			
			/*
			enemyPath = new FlxPath();
			enemyPath.addPoint(makePoint(50, 10));
			enemyPath.addPoint(makePoint(90, 10));
			enemyPath.addPoint(makePoint(90, 30));
			enemyPath.addPoint(makePoint(50, 30));
			enemyPath.addPoint(makePoint(10, 30));
			enemyPath.addPoint(makePoint(10, 10));
			*/
			
			
			/*
			enemyPath.add(FlxG.width/10, FlxG.height/6);
			enemyPath.add(FlxG.width-FlxG.width/10, FlxG.height/6);
			enemyPath.add(FlxG.width-FlxG.width/10, FlxG.height/10);
			enemyPath.add(FlxG.width/10, FlxG.height/10);
			*/
			
			
			pathTopCircle = new FlxPath();
			pathTopCircle.addPoint(makePoint(15,15));
			pathTopCircle.addPoint(makePoint(20,20));
			pathTopCircle.addPoint(makePoint(80,20));
			pathTopCircle.addPoint(makePoint(85,15));
			pathTopCircle.addPoint(makePoint(80,10));
			pathTopCircle.addPoint(makePoint(20,10));
			
			pathTrapezium = new FlxPath();
			
			pathTrapezium.addPoint(makePoint(20,10));
			pathTrapezium.addPoint(makePoint(20,20));
			pathTrapezium.addPoint(makePoint(50,20));
			pathTrapezium.addPoint(makePoint(90,20));
			pathTrapezium.addPoint(makePoint(65,70));
			pathTrapezium.addPoint(makePoint(25,40));
			pathTrapezium.addPoint(makePoint(75,15));
			
			pathBird = new FlxPath();
			pathBird.addPoint(makePoint(50,0));
			pathBird.addPoint(makePoint(30,20));
			pathBird.addPoint(makePoint(5,5));
			pathBird.addPoint(makePoint(15,5));
			pathBird.addPoint(makePoint(8,50));
			pathBird.addPoint(makePoint(50,65));
			pathBird.addPoint(makePoint(92,50));
			pathBird.addPoint(makePoint(90,5));
			pathBird.addPoint(makePoint(95,5));
			pathBird.addPoint(makePoint(70,20));
			pathBird.addPoint(makePoint(40,0));
			
			//	pathTopCircle.addPoint(makePoint(,));
			
			pathSpirals = new FlxPath();
			pathSpirals.addPoint(makePoint(20,0));
			pathSpirals.addPoint(makePoint(0,20));
			pathSpirals.addPoint(makePoint(20,40));
			pathSpirals.addPoint(makePoint(40,20));
			pathSpirals.addPoint(makePoint(20,10));
			pathSpirals.addPoint(makePoint(10,15));
			pathSpirals.addPoint(makePoint(15,25));
			pathSpirals.addPoint(makePoint(50,50));
			
			pathSpirals.addPoint(makePoint(80,0));
			pathSpirals.addPoint(makePoint(100,20));
			pathSpirals.addPoint(makePoint(80,40));
			pathSpirals.addPoint(makePoint(60,20));
			pathSpirals.addPoint(makePoint(80,10));
			pathSpirals.addPoint(makePoint(90,15));
			pathSpirals.addPoint(makePoint(85,25));
			
			enemyPath = pathSpirals;
			
			
			FlxG.mouse.show();

			//PLAYER
			player1 = new Player;
			add(player1);
			player1.alpha=0;
			//shootsGrp
			shootsGrp = new FlxGroup();
			for (var h:int = 0; h < 50; h++) {
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
			lblHealth.alpha=0;

			lblScore = new FlxText(0, 13, 100, "Score: 0");
			add(lblScore);
			lblScore.alpha=0;
			
			lblWave = new FlxText(0, 26, 400, "Wave: 1");
			add(lblWave);
			lblWave.alpha = 0;
			
			_hud = new FlxText(0, FlxG.height/2, FlxG.width, "");
			add(_hud);
			_hud.setFormat(null, 20, colorWhite, "center", player1.currentColor);
			_hud.alpha=0;
			
			//GAMEPLAY
			bonus = new Bonus();
			add(bonus);
			bonus.kill();
			
			
			super.create();
			 
		}
		
		public function playMusic(musicpath:String):void{
			
			FlxG.stream(musicpath, 1, false, true);	
			musicTime = 0;
		}
		
		public function hudShow(msg:String):void{
			_hud.text = msg;
			_hud.alpha = 1;
		}
		
		public function hudHide():void{
			_hud.alpha = 0;
		}
		
		public function watchWave(badguys:FlxGroup, interval:Number, directions:FlxPath):void {
		
			if (delayWave1<=0 && second <=0 && enemiesWave1 > 0) {
				addEnemy(0, directions, enemySpeed);
				delayWave1 = interval;
			}
			
			if (second<=0) {
					delayWave1--;
					//FlxG.log("second ->" + second);
					//FlxG.log("interval ->" + interval);
					//FlxG.log("delaywave1 ->" + delayWave1);
					//FlxG.log("enemiesWave1 ->" + enemiesWave1);
			}
		}
		
		public function getRandomColor(level:Number):uint {
			var randomcolor:Number = level * FlxG.random();
						//FlxG.log("RANDOMCOLOR! ->" + randomcolor + "level : " + level);
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
					
					badGuy.reset(directions.head().x, 0);
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
					
					badGuy.pathAngle = 80;
					
					enemiesWave1--;

				}else {
					FlxG.log("badguy null!");
				}
				
				
			
		}
		
		public function checkAlive():void {
			//FlxG.log(" count living" + enemyGrp.countLiving() );
			if(waveOn && enemyGrp.countLiving() < enemiesWaveMin){
				enemiesWave1 = enemiesWaveMax-enemyGrp.countLiving();
				switch(wave)
				{
					case 4:
					{
						if(enemyPath==pathTopCircle){
						 	enemyPath = pathTrapezium;	
						}else{
							enemyPath = pathTopCircle;
						}
						break;
					}
						
					
				}
				//enemiesWave1 = enemiesWaveLast *1.5;
			}else{
					if (enemyGrp.countLiving() <= 0) {
						if(delayWave1<0){
							
							
							wave++;
							enemiesWaveKilled++;
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
								case 1:
									break;
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
									time = 52.5;
									enemiesWave1 = 5;
									enemiesWaveLast = enemiesWave1;
									break;
								case 4://green
									waveOn = true;
									
									playMusic("sounds/Prepare_To_Die.mp3");
									//								FlxG.stream("sounds/1_Twilight_Zone2.mp3", 1, false, true);	
									
									time = 70;
									delayWave1 = 5;
									enemiesWave1 = 8;
									enemiesWaveLast = enemiesWave1;
									enemySpeed = 60;
									enemiesWaveMin = 5;
									enemiesWaveMax = 10;
									
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
			}
			
		}
		
		
		public function overlapShootEnemy(tiro: Shoot, inimigo: Enemy):void {
			if (tiro.currentColor==inimigo.currentColor || whiteMode || inimigo.currentColor == colorWhite) {
				inimigo.kill();
				firstEnemyDown = true;
				FlxG.play(soundsHit, 1, false);
				FlxG.score += 10;
				emitter.x = inimigo.x;
				emitter.y = inimigo.y;
				emitter.kill();
				emitter.revive();
				emitter.start(true, 0.2);
				
			}else {
				inimigo.currentColor = getRandomColor(wave);
				//if(inimigo.pathSpeed > enemySpeed*1.5 ){
					inimigo.pathSpeed = inimigo.pathSpeed*1.2;	
				//}
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
			whiteModeTimerMax = 10;
			
			
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
			
			public function setDubMode(time:Number):void{
				dubModeTimerLeft = time;
				dubModeChangeBgState = 1;
				var dub:Number = 1*FlxG.random();
				var dubColor:uint;
					if(dub>0 && dub<0.1){
						dubColor = 0x7705F2AB;
						
					}
					if(dub>0.1 && dub<0.2){
						dubColor = 0x77770BF9;
						
					}
					if(dub>0.2 && dub<0.3){
						dubColor = 0x77330000;
						
					}
					if(dub>0.3 && dub<0.4){
						dubColor = 0x77AABBBB;
						
					}
					if(dub>0.4 && dub<0.5){
						dubColor = 0x77000BB0;
						
					}
					if(dub>0.5 && dub<0.6){
						dubColor = 0x7700BB00;
						
					}
					if(dub>0.6 && dub<0.7){
						dubColor = 0x77AA0000;
						
					}
					if(dub>0.7 && dub<0.8){
						dubColor = 0x77AABB00;
						
					}
					if(dub>0.8 && dub<0.9){
						dubColor = 0x77AABBFF;
						
					}
					if(dub>0.9 && dub<1){
						dubColor = 0x77FFFFFF;
						
					}
					if (FlxG.bgColor==dubColor) 
					{
						setDubMode(time);
					}else{
						FlxG.bgColor = dubColor;
					}
			}
			
			public function watchDubMode():void{
				/*
				("dubModeTimerLeft ->" + dubModeTimerLeft);
				FlxG.log("dubModeChangeBgState" + dubModeChangeBgState);
				FlxG.log("BACKGROUND" + FlxG.bgColor);
				*/
				if (dubModeChangeBgState==0) 
				{
					FlxG.bgColor = 0xFF000000;
					dubModeTimerLeft=0;
				}else if(dubModeChangeBgState==1 && dubModeTimerLeft>0){
					dubModeTimerLeft -=FlxG.elapsed;
					FlxG.log("dubmode time -> " + dubModeTimerLeft);
					//if(FlxG.bgColor == 0xFF000000){
					//	setDubMode(dubModeTimerLeft);
						//	FlxG.bgColor = 0xcccccccc;
					//}
				}else if (dubModeChangeBgState==1 && dubModeTimerLeft<=0) 
				{
					
					dubModeChangeBgState = 0;
				}
				
			
			}
			
			public function makePoint(x:Number, y:Number):FlxPoint {
				return new FlxPoint((FlxG.width / 100) * x, (FlxG.height / 100) * y);
				
			}
			

			public function isTime(currentTime:Number):Boolean{
				var james:Number = time-currentTime;
				if(james<0.1 && james>-0.1){
					//FlxG.log("TRU");
					return true
				}
				return false;
			}
			
			public function isMusicTime(currentTime:Number):Boolean{
				var boogie:Number = musicTime-currentTime;
				if(boogie<0.1 && boogie>-0.1){
					//FlxG.log("TRU");
					return true
				}
				return false;
			}
			
			public function gameControl():void{
			
				/*
				if (isTime()) 
				{
				hudShow("");
				}
				 * */
				if (FlxG.keys.justReleased("M")) { //THE KEY 
					enemyPath = pathTopCircle;
					time = 70;
					player1.alpha = 1;
					keyLeftPressed = true;
					keyRightPressed = true;
					firstEnemyDown = true;
					keyQPressed = true;
					lblHealth.alpha = 1;
					lblScore.alpha = 1;
					lblWave.alpha = 1;
					wave = 3;
					delayWave1 = 5;
					enemiesWave1 = 0;
					enemiesWaveLast = enemiesWave1;
					enemySpeed = 60;
					enemyGrp.kill();
					enemyGrp.revive();
					
				}
				
				if (FlxG.keys.pressed("LEFT")) { //LEFT KEY 
					keyLeftPressed = true;
				}
				
				if (FlxG.keys.pressed("RIGHT")) { //RIGHT KEY 
					keyRightPressed = true;
				}
				
				if (FlxG.keys.pressed("Q")) { //RIGHT KEY 
					keyQPressed = true;
				}
				
				if (isTime(1)) 
				{
					hudShow("Welcome to stepColor!");
				}
				if (isTime(3)) 
				{
					hudShow("If you know THE KEY press it in 3...");
				}
				if (isTime(4)) 
				{
					hudShow("If you know THE KEY press it in 2...");
				}
				if (isTime(5)) 
				{
					hudShow("If you know THE KEY press it in 1...");
				}
				if (isTime(6)) 
				{
					hudShow("If you know THE KEY press it NOW!");
				}
				if (isTime(10)) 
				{
					hudShow("You don`t know THE KEY right? Ok... ");
				}
				
				if (isTime(15)) 
				{
					hudShow("Welcome to stepColor!");
				}
				
				if (isTime(20)) 
				{
					hudShow("This beathiful shinny red block, is you!");
					player1.alpha = 1;
				}
				
				if (isTime(23.5)) 
				{
					keyLeftPressed = false;
					keyRightPressed = false;
				}
				
				if (isTime(24)) 
				{
					hudShow("You can move to left and right using arrow keys! DO IT!");
				}
				
				if (isTime(28) && (!keyLeftPressed && !keyRightPressed)) 
				{
					hudShow("Come on... Don`t be shine!");
					
				}
				if (time>31 && (!keyLeftPressed && !keyRightPressed)) 
				{
					time = 23;
					
				}
				
				if (isTime(30) && (keyLeftPressed && keyRightPressed)) 
				{
					hudShow("Goooood boooooooy!!!");
				}
				if(isTime(32))
				{
					wave = 1;
					enemiesWave1 = 1;
					delayWave1 = 0;
					//watchWave(enemyGrp, enemyTimerMax, pathTopCircle);	
					enemyTimerMax = 1;
					enemyPath = pathTopCircle;
					hudShow("Ok... you have an enemy, avoid his mortal lazer shoots!");
					firstEnemyDown = false;
					
					
				}
				if(isTime(34)){
					lblHealth.alpha = 1;
					lblScore.alpha = 1;
					lblWave.alpha = 1;
					hudShow("Press Q to fire!");
				}
				
				if(time>37 && (!keyQPressed)){
					time = 33;
				}
				
				if(isTime(36)){
					hudHide();
				}
					
				
				if(time>45 && (!firstEnemyDown)){
					hudShow("Dude, you suck...");
					time = 33;
				}
				
				if(time>34 && time < 47 && (firstEnemyDown)){
					hudShow("All right!");
					time = 48;
				}
					
				if(isTime(49)){
					hudShow("Now lets have more action...");
					wave = 2;
					enemiesWave1 = 3;
					//delayWave1 = 0;
					//watchWave(enemyGrp, enemyTimerMax, pathTopCircle);	
					enemyTimerMax = 1;
				}
				if(isTime(52)){
					hudHide();
					//time = 51;
				}
				
				if(isTime(54.5) && wave==3){
					hudShow("A GREEN one? Press W");
				}
				
				if(isTime(60)){
					hudHide();
				}
				
				if(isTime(68)){
					time = 61;
				}
				
				if(isTime(71)){
					hudShow("Please loud your sound and enjoy...");
				}
				
				if(isTime(73)){
					hudShow("Welcome to stepColor!");
				}
				
				if(isTime(75)){
					hudHide();
//					FlxG.play(musicTwilight, 1, false)
				}
				
				
				if (player1.health<=0 && time <70) 
				{
					hudShow("Seriously? You're dead at the tutorial stage?");
					player1.health = 5;
					enemyGrp.kill();
					enemyGrp.revive();
					player1.revive();
					player1.alpha = 0;
					time = 0;
					
				}
			}
		
		public function watchGame():void{
		//	FlxG.log("time ->"+ time);
			//FlxG.log("musicTime ->"+ musicTime);

			switch(wave)
			{
				case 4:
				{
					/*
					if(isMusicTime(28.9)){
						backwardsMode = true;
					}
					if(isMusicTime(29.4)){
						backwardsMode = false;
					}
					if(isMusicTime(29.8)){
						backwardsMode = true;
					}
					if(isMusicTime(30.2)){
						backwardsMode = false;
					}
					if(isMusicTime(30.7)){
						backwardsMode = true;
					}
					if(isMusicTime(31.1)){
						backwardsMode = false;
					}
					if(isMusicTime(31.54)){
						backwardsMode = true;
					}*/
					
					
					if (isMusicTime(28.9) || isMusicTime(29.4) || isMusicTime(29.8) || isMusicTime(30.2) || isMusicTime(30.7) || isMusicTime(31.1) || isMusicTime(31.54) || isMusicTime(32.42) || isMusicTime(32.82) || isMusicTime(33.26) || isMusicTime(33.68) || isMusicTime(34.11) || isMusicTime(34.6) || isMusicTime(35.8) || isMusicTime(36.2) || isMusicTime(36.68) || isMusicTime(37.11) || isMusicTime(37.5) || isMusicTime(37.97) || isMusicTime(38.4) || isMusicTime(39.28) || isMusicTime(39.68) || isMusicTime(40.11) || isMusicTime(40.54) || isMusicTime(40.97) || isMusicTime(41.40) || isMusicTime(83.82) || isMusicTime(84.68) || isMusicTime(85.11) || isMusicTime(85.54) || isMusicTime(85.97) || isMusicTime(138.68) || isMusicTime(139.11) || isMusicTime(139.54) || isMusicTime(139.97) || isMusicTime(140.40) || isMusicTime(140.83) || isMusicTime(141.25) || isMusicTime(142.13) || isMusicTime(142.54) || isMusicTime(142.97) || isMusicTime(143) || isMusicTime(143.83) || isMusicTime(144.26) || isMusicTime(145.54) || isMusicTime(145.973) || isMusicTime(146.40) || isMusicTime(146.82) || isMusicTime(147.25) || isMusicTime(147.69) || isMusicTime(148.11) || isMusicTime(148.95) || isMusicTime(149.40) || isMusicTime(149.83) || isMusicTime(193.5) || isMusicTime(193.7) || isMusicTime(194.4) || isMusicTime(194.82) || isMusicTime(195.25) || isMusicTime(195.68)  ) 
					{
						backwardsMode = !backwardsMode;
					}
					
					if(isMusicTime(55.9) ||  isMusicTime(60.2) ||  isMusicTime(60.2) ||  isMusicTime(76.8) ||  isMusicTime(90) ||  isMusicTime(94.4) ||  isMusicTime(104.1) ||  isMusicTime(165.9) ||  isMusicTime(172.8) ||  isMusicTime(180) ||  isMusicTime(186.4) ||  isMusicTime(90) ||  isMusicTime(199) ||  isMusicTime(213.7)){
						setDubMode(2);
					}
					
					if(isTime(83.7) ||  isMusicTime(110.9) ||  isMusicTime(193.4) ||  isMusicTime(220)){
						dubModeTimerLeft=0
							dubModeChangeBgState = 0;
					}
					
					
					if((musicTime>60 && musicTime<63) || (musicTime>73.4 && musicTime<76.58) || (musicTime>80.37 && musicTime<83.42) || (musicTime>94.14 && musicTime<97.48) || (musicTime>100.9 && musicTime<104.10) || (musicTime>169.5 && musicTime<172.6) || (musicTime>176.38 && musicTime<179.531 || (musicTime>183.26 && musicTime<186.30) || (musicTime>190.1 && musicTime<193.29) || (musicTime>196.57 && musicTime<200) || (musicTime>204 && musicTime<207.50) || (musicTime>210.65 && musicTime<213.8) || (musicTime>100.9 && musicTime<104.10)  )  ){
						changeEnemyColor = true;
					}else{
						changeEnemyColor = false;
					}
					
					if(isMusicTime(240)){
						waveOn = false;
					}
					
					if(isMusicTime(120) || isMusicTime(222) || (isMusicTime(250) && enemyGrp.countLiving()>3)){
							bonus.reset(30+((FlxG.width-60)*FlxG.random()), 0);
						
					}
						
						

					break;
				}
					
			}
			
			
		}
			
		override public function update():void
        {
			time += FlxG.elapsed;
			musicTime += FlxG.elapsed;
			
			gameControl();
			
			watchGame();
			
			second -= FlxG.elapsed;
			
			
			if(FlxG.keys.pressed("D")){
				setDubMode(3);
			}
			
			watchDubMode();
			
			
			
			
			lblControl();
			if(time>32){
				watchWave(enemyGrp, enemyTimerMax, enemyPath);
			}
			
			testShoot();
		
			FlxG.overlap(shootsGrp, enemyGrp, overlapShootEnemy);
			
			if (bonus.alive) {
				FlxG.overlap(bonus, player1, overlapBonus);
			}
			
			

			
			if (FlxG.keys.pressed("B")) { 
				bonus.reset(30+((FlxG.width-60)*FlxG.random()), 0);
				//	bonus.reset(FlxG.width*FlxG.random(), 0);
			}
			
			
			for each (var enemy:Enemy in enemyGrp.members) { //do stuff with enemies here
				if (enemy.alive) {//we dont have to look to the dead ones, and its makes a HUGE difference
				
					FlxG.overlap(enemy.shoots, player1, overlapEnemyShoot);
					/*
					if (FlxG.keys.justPressed("K")){ //kill all enemy with K
					   killAll(enemy);
					}
					
					if (FlxG.keys.pressed("C")){ 
					   changeEnemyColor = true;
					}else {
						changeEnemyColor = false;
					}
					
					if (FlxG.keys.pressed("X")){ 
						enemy.x = FlxG.width*FlxG.random();
					}
					
					if (FlxG.keys.pressed("V")) { 
						backwardsMode = true;
					}else {
						backwardsMode = false;
					}*/
					
					/*
					if (FlxG.keys.pressed("S")) { 
						whiteMode = true;
					}else {
						whiteMode = false;
					}
					*/
					if (backwardsMode) {
					   enemy.pathSpeed = -enemySpeed;
					}else if(!backwardsMode && enemy.pathSpeed<0){
					   enemy.pathSpeed = enemySpeed;
					}
					
					if (changeEnemyColor) {
						changeEnemyColors(enemy);
					}
					
					
					if (whiteMode && enemy.currentColor!=colorWhite) {
						FlxG.log("WHITE MODE " + whiteModeTimerMax); 
						enemy.currentColor = colorWhite;
						enemy.pathSpeed = 0;
						enemy.velocity.x = 0;
						enemy.velocity.y = 0;
						
						
					}else if(enemy.currentColor==colorWhite && whiteModeTimerMax<=0){
							changeEnemyColors(enemy);
							enemy.pathSpeed = enemySpeed;
					}
					
					
				}
				
				
			}
			
			
			if (second<=0) {
				second = 1;
				if (time > 60){
					checkAlive();
				}
			}
			
			if (whiteModeTimerMax<=0 && whiteMode) {
				whiteMode = false;
			}else if(whiteModeTimerMax>0){
				whiteModeTimerMax -= FlxG.elapsed;
			}
			
			super.update();
			
		}
		
	}
}