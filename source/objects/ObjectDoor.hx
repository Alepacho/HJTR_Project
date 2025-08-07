package objects;

import flixel.FlxSprite;

class ObjectDoor extends FlxSprite {
	public function new(x:Float = 0, y:Float = 0)
    {
        super(x, y);

        loadGraphic("assets/images/door.png", false, 24, 24);
    }

    override function update(elapsed:Float):Void {
        super.update(elapsed);
    }
}