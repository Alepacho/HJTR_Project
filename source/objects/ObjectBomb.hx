package objects;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.math.FlxPoint;
import resources.ResGame;
import utils.Math2;

class ObjectBomb extends FlxSprite
{
	static inline final GRAVITY:Float = Config.GRAVITY;
	static inline final SPEED:Float = 20;
    static inline final KILL_DISTANCE:Float = 32;

    public var objPlayer:ObjectPlayer = null;
    public var objTileMap:ObjectTileMap = null;
    public var objCamera:ObjectCamera = null;
    public var grpBats:FlxGroup = null;

    var tick:Int = 200;

	public function new(x:Float = 0, y:Float = 0)
	{
		super(x, y);
		this.acceleration.y = GRAVITY;

		loadGraphic("assets/images/bomb.png", false, 8, 8);
	}

    function clampPosition() {
        x = Math2.clamp(x, 0, objTileMap.width - 16);
    }

	public function throwAway(direction:Float)
	{
		velocity.x = Math.cos(direction) * SPEED;
		velocity.y = Math.sin(direction) * SPEED;
	}

    override function update(elapsed:Float):Void {
        super.update(elapsed);

        this.clampPosition();

        if (tick > 0) {
            tick--;
        } else {
            this.kill();
            objCamera.shake();
			FlxG.sound.play("assets/sounds/explosion.wav");

            // destroy near blocks
            var _x = Math.floor(this.x / 24) * 24;
            var _y = Math.floor(this.y / 24) * 24;
            for (yy in 0...3) {
                for (xx in 0...3) {
                    var p = FlxPoint.weak(_x + xx * 24, _y + yy * 24);
                    objTileMap.removeTileAt(p);
                }
            }
            
            // attack bats if in distance
            for (_ => value in grpBats) {
                var bat = cast(value, ObjectBat);
                if (Math2.distance(this.getPosition(), bat.getPosition()) < KILL_DISTANCE * 1.5) {
                    bat.kill();
                }
            }

            // attack player if in distance
            if (Math2.distance(this.getPosition(), objPlayer.getPosition()) < KILL_DISTANCE) {
                objPlayer.throwBack(this.getPosition());
                ResGame.health -= 20;
            }
        }
    }
}
