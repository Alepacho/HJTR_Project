package states;

import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import objects.ObjectCamera;
import objects.ObjectDoor;
import objects.ObjectDrill;
import objects.ObjectPlayer;
import objects.ObjectTileMap;
import resources.ResGame;

class ShopState extends FlxState
{
	var objPlayer:ObjectPlayer;
	var objDrill:ObjectDrill;
	var objCamera:ObjectCamera;
	var objDoor:ObjectDoor;
	var objTileMap:ObjectTileMap;

	var enteringCave:Bool = false;

	var textResources:FlxText;

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
	}

	override function update(elapsed:Float):Void
	{
		super.update(elapsed);

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
					FlxG.switchState(PlayState.new);
				});
			}
		});

		textResources.text = 'Gold: ${ResGame.gold}\nDiamond: ${ResGame.diamond}\nRuby: ${ResGame.ruby}\nEmerald: ${ResGame.emerald}\n';
	}
}
