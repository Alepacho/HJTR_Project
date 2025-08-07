package objects;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;

class ObjectDrill extends FlxSprite
{
	public var player:ObjectPlayer = null;
	public var targetDistance:Float = 20;

	var tick:Int = 0;

	// private var firstSprite:FlxSprite;

	public function new(x:Float = 0, y:Float = 0)
	{
		super(x, y);

		loadGraphic("assets/images/drill.png", true, 16, 16);
		animation.add("normal", [0]);
		animation.add("power", [1]);
		animation.add("run", [0, 1], 30);
	}

	public function playAnimation()
	{
		animation.play("run");
		tick = 20;
	}

	public function isDrilling() {
		return tick > 0;
	}

	function updateAngle()
	{
		if (player.isDead())
			return;

		var mousePosition = FlxG.mouse.getPosition();
		var angle = mousePosition.degreesFrom(FlxPoint.weak(player.x + 8, player.y + 8));

		this.x = player.x + Math.cos(angle * (Math.PI / 180)) * targetDistance;
		this.y = player.y + 8 + Math.sin(angle * (Math.PI / 180)) * targetDistance;
		this.angle = angle;
	}

	override function update(elapsed:Float):Void
	{
		super.update(elapsed);
		if (player != null)
		{
			this.updateAngle();
		}

		if (tick > 0)
			tick--;
		else
		{
			animation.play("normal");
		}
	}
}
