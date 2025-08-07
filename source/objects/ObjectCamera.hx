package objects;

import flixel.FlxCamera.FlxCameraFollowStyle;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;

class ObjectCamera extends FlxObject
{
    public var target:FlxObject = null;

	public function new(x:Float = 0, y:Float = 0)
	{
		super(x, y);
	}

    override function update(elapsed:Float):Void {
        super.update(elapsed);

        if (target != null) {
            FlxG.camera.follow(target, FlxCameraFollowStyle.LOCKON, 1 / 3);
        }
    }

    public function shake(power:Float = 0.05, duration:Float = 0.5) {
        FlxG.camera.shake(power / 3, duration);
    }
}
