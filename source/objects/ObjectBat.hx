package objects;

import flixel.FlxObject;
import flixel.FlxSprite;
import utils.Math2;

class ObjectBat extends FlxSprite
{
	public var player:ObjectPlayer = null;
    public var tileMap:ObjectTileMap = null;

    public static final SPEED:Float = 10;

	public function new(x:Float = 0, y:Float = 0)
	{
		super(x, y);

		loadGraphic("assets/images/bat.png", true, 16, 16);
		animation.add("fly", [0, 1, 2, 3], 7);
	}

    function clampPosition() {
        x = Math2.clamp(x, 0, tileMap.width - 16);
    }

    public function onGetAttacked() {
        this.kill();
    }

	override function update(elapsed:Float):Void
	{
		super.update(elapsed);

		animation.play("fly");

        this.clampPosition();

		if (player != null) {
            var dir = this.getPosition().degreesTo(player.getPosition());
            dir = Math2.deg2rad(dir);
            acceleration.x = Math.cos(dir) * SPEED;
            acceleration.y = Math.sin(dir) * SPEED;
        }
	}
}
