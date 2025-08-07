package objects;

import flixel.FlxSprite;

class ObjectTable extends FlxSprite
{
	public function new(x:Float = 0, y:Float = 0)
	{
        super(x, y);

        loadGraphic("assets/images/table.png", false, 24, 24);
    }
}
