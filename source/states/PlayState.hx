package states;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.math.FlxMath;
import flixel.math.FlxRandom;
import flixel.text.FlxText;
import flixel.tile.FlxBaseTilemap.FlxTilemapAutoTiling;
import flixel.tile.FlxTilemap;
import flixel.util.FlxColor;
import objects.ObjectBat;
import objects.ObjectBomb;
import objects.ObjectDoor;
import objects.ObjectPlayer;
import objects.ObjectStone;
import resources.ResGame;
import substates.PlayPauseSubstate;
import utils.Math2;

class PlayState extends FlxState
{
	var objectPlayer:objects.ObjectPlayer;
	var objectCamera:objects.ObjectCamera;
	var objectDrill:objects.ObjectDrill;
	var objectTileMap:objects.ObjectTileMap;
	var objectDoor:ObjectDoor = null;

	var textScore:FlxText;
	var textPlayerHealth:FlxText;
	var textGameOver:FlxText;
	var textGameOverTick:Int = 0;
	var textBombs:FlxText;

	var objectsBat:FlxGroup;
	var objectsStone:FlxGroup;
	public var bombs:FlxGroup;

	var enteringShop:Bool = false;
	var restarting:Bool = false;

	var random:FlxRandom = new FlxRandom();

	private function createTileMap()
	{
		var height = 16 + ResGame.floor * 2;
		var width = 16;

		var data = new Array<Array<Int>>();
		for (y in 0...height)
		{
			var row = new Array<Int>();
			for (x in 0...width)
			{
				var tile = random.int(1, 2);
				var empty = random.int(0, 100);

				if (x == 0 || x == 15) tile = 3;
				if (y == (height - 1)) tile = 3;

				if (empty <= 15 && tile != 3) {
					if (random.int(0, 100) >= 50) {
						var check = random.int(0, 100);
						if (check > 0 && check < 15) {
							tile = 4; // gold
						} else if (check > 15 && check < 40) {
							tile = 5; // diamond
						} else if (check > 40 && check < 60) {
							tile = 6; // ruby
						} else if (check > 60 && check < 100) {
							tile = 7; // emerald
						} else tile = 0;
					} else {
						var chance = random.int(0, 100);
						tile = 0;
						if (chance < 35) {
							// spawn objects
							objectsBat.add(new objects.ObjectBat(x * 24 + 4, y * 24 + 4));
						} else if (chance >= 35 && chance < 50) {
							var stone = new objects.ObjectStone(x * 24, y * 24);
							objectsStone.add(stone);
						} else tile = 0;
					}
				}

				if (y == (height - 2) && x == Math.floor(width / 2) && objectDoor == null) {
					tile = 0;
					objectDoor = new ObjectDoor(x * 24, y * 24);
					add(objectDoor);
				} 
				
				row.push(tile);
			}
			data.push(row);
		}
		// trace(data);
		objectTileMap = new objects.ObjectTileMap();
		objectTileMap.loadMapFrom2DArray(data, "assets/images/tiles.png", 24, 24, FlxTilemapAutoTiling.OFF, 0, 1, 1);
		add(objectTileMap);
	}

	override public function create()
	{
		super.create();
		this.bgColor = FlxColor.BLACK;

		this.camera.zoom = 3;
		objectsBat = new FlxGroup();
		objectsStone = new FlxGroup();
		bombs = new FlxGroup();
		add(bombs);

		FlxG.sound.playMusic("assets/music/gameplay.mp3", 1, true);

		this.createTileMap();

		FlxG.worldBounds.set(0, 0, objectTileMap.width, objectTileMap.height);
		

		{
			objectPlayer = new objects.ObjectPlayer(objectTileMap.width / 2, -64);
			objectPlayer.tileMap = objectTileMap;
			objectPlayer.currentState = this;
			objectPlayer.onCreateBomb = () ->
			{
				var bomb = new ObjectBomb(objectPlayer.x, objectPlayer.y);
				var dir = objectPlayer.getPosition().degreesTo(objectDrill.getPosition());
				bomb.throwAway(Math2.deg2rad(dir));
				bomb.objTileMap = objectTileMap;
				bomb.objPlayer = objectPlayer;
				bomb.objCamera = objectCamera;
				bomb.grpBats = objectsBat;
				bombs.add(bomb);
				FlxG.sound.play("assets/sounds/bomb.wav");
			};
			add(objectPlayer);
		}

		{
			objectDrill = new objects.ObjectDrill(objectPlayer.x, objectPlayer.y);
			objectDrill.player = objectPlayer;
			objectPlayer.drill = objectDrill;
			add(objectDrill);
		}

		{
			objectCamera = new objects.ObjectCamera(objectPlayer.x, objectPlayer.y);
			objectCamera.target = objectPlayer;
			objectPlayer.objCamera = objectCamera;
			add(objectCamera);
		}

		// {
		// 	var objectBat = new objects.ObjectBat(objectPlayer.x, objectPlayer.y);
		// 	add(objectBat);
		// }

		// {
		// 	var objectStone = new objects.ObjectStone(objectPlayer.x, objectPlayer.y - 64);
		// 	objectsStone.add(objectStone);
		// }

		for (object in objectsBat) {
			var bat = cast(object, ObjectBat);
			bat.player = objectPlayer;
			bat.tileMap = objectTileMap;
		}

		add(objectsBat);
		add(objectsStone);

		{
			textScore = new FlxText(0, 0, 0, 'Score: ${ResGame.score}', 8);
			textScore.color = FlxColor.WHITE;
			textScore.scrollFactor.set(0, 0);
			// textScore2.screenCenter();
			textScore.x += FlxG.width / this.camera.zoom;
			textScore.y += FlxG.height / this.camera.zoom;
			// textScore.y;

			textScore.setBorderStyle(FlxTextBorderStyle.OUTLINE_FAST, FlxColor.BLACK);
			add(textScore);
		}

		{
			textPlayerHealth = new FlxText(0, 0, 0, 'Health: ${ResGame.health}');
			textPlayerHealth.color = FlxColor.WHITE;
			textPlayerHealth.scrollFactor.set(0, 0);
			textPlayerHealth.x += FlxG.width / this.camera.zoom;
			textPlayerHealth.y += FlxG.height / this.camera.zoom;
			textPlayerHealth.y += textScore.height;
			textPlayerHealth.setBorderStyle(FlxTextBorderStyle.OUTLINE_FAST, FlxColor.BLACK);

			add(textPlayerHealth);
		}

		{
			textBombs = new FlxText(0, 0, 0, 'Bombs: ${ResGame.bombs}');
			textBombs.color = FlxColor.WHITE;
			textBombs.scrollFactor.set(0, 0);
			textBombs.x += FlxG.width / this.camera.zoom;
			textBombs.y += FlxG.height / this.camera.zoom;
			textBombs.y += textScore.height + textPlayerHealth.height;
			textBombs.setBorderStyle(FlxTextBorderStyle.OUTLINE_FAST, FlxColor.BLACK);

			add(textBombs);
		}

		{
			textGameOver = new FlxText(0, 0, 0, "       Game Over!\nPress 'ENTER' to restart.");
			textGameOver.color = FlxColor.RED;
			textGameOver.scrollFactor.set(0, 0);
			textGameOver.screenCenter();
			textGameOver.setBorderStyle(FlxTextBorderStyle.OUTLINE_FAST, FlxColor.BLACK);
			add(textGameOver);
		}
	}

	function restartGame() {
		if (restarting) return;
		restarting = true;
		FlxG.camera.fade(FlxColor.BLACK, 1, false, () -> {
			trace("Entering menu...");
			FlxG.sound.pause();
			FlxG.switchState(MenuState.new);
		});
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.keys.anyJustPressed([ESCAPE]))
		{
			this.openSubState(new PlayPauseSubstate());
		}

		FlxG.collide(objectPlayer, objectTileMap);
		FlxG.collide(objectTileMap, objectsBat);
		FlxG.collide(objectTileMap, objectsStone);
		// FlxG.collide(objectTileMap, objectsStone);
		FlxG.collide(objectTileMap, bombs);
		FlxG.collide(objectsStone, bombs);

		FlxG.collide(objectPlayer, objectsStone, (a:ObjectPlayer, b:ObjectStone) -> {
			a.onCollideStone(b);
		});
		FlxG.overlap(objectPlayer, objectsBat, (a:FlxObject, b:FlxObject) -> {
			// trace('is player: ${Std.isOfType(a, ObjectPlayer)}');
			var player = cast(a, ObjectPlayer);
			player.onCollideBat(cast(b, ObjectBat));
		});
		FlxG.overlap(objectPlayer, objectDoor, (a:ObjectPlayer, b:ObjectDoor) -> {
			if (a.onOverlapDoor(b)) {
				if (enteringShop) return;
				enteringShop = true;
				FlxG.camera.fade(FlxColor.BLACK, 1, false, () -> {
					trace("Entering shop...");
					ResGame.floor += 1;
					FlxG.sound.pause();
					FlxG.switchState(ShopState.new);
				});
			}
		});

		if (objectPlayer.isDead() && FlxG.keys.anyJustPressed([ENTER]))
		{
			this.restartGame();
		}

		if (ResGame.score > ResGame.highscore) {
			ResGame.highscore = ResGame.score;
		}

		// textScore1.text = 'Score: ${ResGame.score}';
		textScore.text = 'Score: ${ResGame.score}';
		textPlayerHealth.text = 'Health: ${ResGame.health}';
		textBombs.text = 'Bombs: ${ResGame.bombs}';

		if (objectPlayer.isDead()) {
			textGameOverTick++;
			if ((textGameOverTick % 60) < 30) textGameOver.alpha = 0; else textGameOver.alpha = 1;
		} else {
			textGameOver.alpha = 0;
		}
	}
}
