package states;

import flixel.FlxG;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import objects.ObjectCamera;
import objects.ObjectDoor;
import objects.ObjectDrill;
import objects.ObjectPlayer;
import objects.ObjectPowerUp;
import objects.ObjectTable;
import objects.ObjectTileMap;
import resources.ResGame;
import substates.PlayPauseSubstate;

class ShopState extends FlxState
{
	var objPlayer:ObjectPlayer;
	var objDrill:ObjectDrill;
	var objCamera:ObjectCamera;
	var objDoor:ObjectDoor;
	var objTileMap:ObjectTileMap;
	var tables:FlxGroup;
	var grpPowerUps:FlxGroup;

	var enteringCave:Bool = false;

	var textResources:FlxText;
	var textPowerUp:FlxText;

	function createTileMap()
	{
		var data = [
			[0, 0, 0, 0, 0, 0, 0],
			[0, 0, 0, 0, 0, 0, 0],
			[0, 0, 0, 0, 0, 0, 0],
			[3, 3, 3, 3, 3, 3, 3],
		];
		objTileMap = new ObjectTileMap();
		objTileMap.loadMapFrom2DArray(data, "assets/images/tiles.png");
		add(objTileMap);

		FlxG.worldBounds.set(0, 0, objTileMap.width, objTileMap.height);
	}

	override function create():Void
	{
		super.create();
		this.bgColor = FlxColor.BLACK;
		this.camera.zoom = 3;
		this.createTileMap();

		FlxG.sound.playMusic("assets/music/shop.mp3", 1, true);


		tables = new FlxGroup();
		grpPowerUps = new FlxGroup();
		{
			var table = new ObjectTable(0 * 24, 2 * 24);
			tables.add(table);

			var powerup = new ObjectPowerUp(0 * 24, 1 * 24 + 12);
			grpPowerUps.add(powerup);
		}
		{
			var table = new ObjectTable(1 * 24, 2 * 24);
			tables.add(table);

			var powerup = new ObjectPowerUp(1 * 24, 1 * 24 + 12);
			grpPowerUps.add(powerup);
		}
		{
			var table = new ObjectTable(2 * 24, 2 * 24);
			tables.add(table);

			var powerup = new ObjectPowerUp(2 * 24, 1 * 24 + 12);
			grpPowerUps.add(powerup);
		}
		add(tables);
		add(grpPowerUps);

		{
			objDoor = new ObjectDoor(6 * 24, 2 * 24);
			add(objDoor);
		}

		{
			objPlayer = new ObjectPlayer(objTileMap.width / 2, 0);
			objPlayer.tileMap = objTileMap;
			add(objPlayer);

			objDrill = new ObjectDrill(objPlayer.x, objPlayer.y);
			objDrill.player = objPlayer;
			objPlayer.drill = objDrill;
			add(objDrill);
		}

		{
			objCamera = new ObjectCamera(objPlayer.x, objPlayer.y);
			objCamera.target = objPlayer;
			objPlayer.objCamera = objCamera;
			add(objCamera);
		}

		{
			textResources = new FlxText(0, 0, 0, 'Gold: ${ResGame.gold}\nDiamond: ${ResGame.diamond}\nRuby: ${ResGame.ruby}\nEmerald: ${ResGame.emerald}\n');
			textResources.color = FlxColor.WHITE;
			textResources.scrollFactor.set(0, 0);
			textResources.x += FlxG.width / this.camera.zoom;
			textResources.y += FlxG.height / this.camera.zoom;
			add(textResources);
		}
		{
			textPowerUp = new FlxText(0, 0, 0, 'POWERUP_INFO\nCOST: 10 gold');
			textPowerUp.alpha = 0;
			add(textPowerUp);
		}
	}

	override function update(elapsed:Float):Void
	{
		textPowerUp.alpha = 0;

		super.update(elapsed);

		if (FlxG.keys.anyJustPressed([ESCAPE]))
		{
			this.openSubState(new PlayPauseSubstate());
		}

		FlxG.collide(objPlayer, objTileMap);
		FlxG.overlap(objPlayer, objDoor, (a:ObjectPlayer, b:ObjectDoor) ->
		{
			if (a.onOverlapDoor(b))
			{
				if (enteringCave)
					return;
				enteringCave = true;
				FlxG.camera.fade(FlxColor.BLACK, 1, false, () ->
				{
					trace("Entering cave...");
					FlxG.sound.pause();
					FlxG.switchState(PlayState.new);
				});
			}
		});
		FlxG.overlap(objPlayer, grpPowerUps, (a:ObjectPlayer, b:ObjectPowerUp) ->
		{
			textPowerUp.alpha = 1;
			textPowerUp.x = b.x;
			textPowerUp.y = b.y - 32;
			textPowerUp.text = '${b.getInfo()}\ncost: 10 ${b.getCurrencyName()}';

			if (a.use)
			{
				b.use(a);
			}
		});

		textResources.text = 'Gold: ${ResGame.gold}\nDiamond: ${ResGame.diamond}\nRuby: ${ResGame.ruby}\nEmerald: ${ResGame.emerald}\n';
	}
}
