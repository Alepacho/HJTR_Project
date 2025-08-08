package objects;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import resources.ResGame;
import states.PlayState;
import utils.Math2;

class ObjectPlayer extends FlxSprite
{
	static inline final SPEED:Float = 100;
	static inline final FRICTION:Float = 0.7;
	static inline final GRAVITY:Float = Config.GRAVITY;
	static inline final JUMP_FORCE:Float = -250;

	public var currentState:FlxState = null;
	public var objCamera:ObjectCamera = null;
	public var tileMap:ObjectTileMap = null;
	public var drill:ObjectDrill = null;

	public var onCreateBomb:() -> Void = () -> {};

	// public var health:Int = 100;

	var invulnerability:Bool = false;
	var invulnerabilityTimer:Int = 0;
	var facingSide:Bool = true;
	var velx:Float = 0;
	var onFloor:Bool = false;
	var drilling:Bool = false;
	var drillTimer:Int = 0;
	var isDrilling:Bool = false;
	public var use:Bool = false;

	var throwBomb:Bool = false;

	public function new(x:Float = 0, y:Float = 0)
	{
		super(x, y);
		// makeGraphic(16, 16, FlxColor.BLUE);
		this.maxVelocity.x = SPEED;
		this.maxVelocity.y = Math.abs(JUMP_FORCE);
		this.acceleration.y = GRAVITY;
		this.drag.x = SPEED * 4;

		loadGraphic("assets/images/player.png", true, 16, 24);
		animation.add("run_left", [0, 1], 7, true, true);
		animation.add("run_right", [0, 1], 7, true, false);
		animation.add("idle_left", [0], 1, true, true);
		animation.add("idle_right", [0], 1, true, false);
		animation.add("jump_left", [2], 1, true, true);
		animation.add("jump_right", [2], 1, true, false);
		animation.add("dead", [3], 1, true, false);

		// NOTE: make hitbox a bit smaller so player can get through blocks while jumping
		this.scale.y = 0.9;
		this.updateHitbox();
		this.scale.y = 1.0;
	}

	private function updateMovement()
	{
		if (isDead()) {
			acceleration.x = 0;
			return;
		}

		var up:Bool = false;
		var down:Bool = false;
		var left:Bool = false;
		var right:Bool = false;
		var space:Bool = false;

		up = FlxG.keys.anyPressed([UP, W]);
		down = FlxG.keys.anyPressed([DOWN, S]);
		left = FlxG.keys.anyPressed([LEFT, A]);
		right = FlxG.keys.anyPressed([RIGHT, D]);
		space = FlxG.keys.anyJustPressed([SPACE]);

		if (up && down)
			up = down = false;
		if (left && right)
			left = right = false;

		velx = 0;
		// velocity.x *= FRICTION;
		acceleration.x = 0;

		//  else {
		// 	acceleration.y = GRAVITY;
		// }

		if (up || down || left || right)
		{
			velx = (right ? 1 : 0) - (left ? 1 : 0);
			acceleration.x = velx * SPEED;
		}

		if (space && onFloor)
		{
			trace('Player jump! ${velocity}');
			y--;
			velocity.y = JUMP_FORCE / 2 - ResGame.legs;
		}
	}

	function updateAnimations()
	{
		if (isDead())
		{
			animation.play("dead");
			return;
		}

		if (!onFloor) {
			if (!facingSide) {
				animation.play("jump_left");
			} else {
				animation.play("jump_right");
			}
			return;
		}

		if (velx > 0)
		{
			animation.play("run_right");
			facingSide = true;
		}
		else if (velx < 0)
		{
			animation.play("run_left");
			facingSide = false;
		}
		else
		{
			if (facingSide)
			{
				animation.play("idle_right");
			}
			else
			{
				animation.play("idle_left");
			}
		}
	}

	function clampPosition()
	{
		// lerp function
		// x = Math.min(Math.max(x, 0), tileMap.width - 16);
		x = Math2.clamp(x, 0, tileMap.width - 16);
	}

	public function throwBack(position:FlxPoint, distance:Float = 75)
	{
		var angle = position.degreesTo(this.getPosition());
		angle = Math2.deg2rad(angle);
		velocity.set(Math.cos(angle) * distance, Math.sin(angle) * distance);
	}

	public function isDead()
	{
		if (ResGame.health <= 0)
			return true;
		return false;
	}

	public function onCollideBat(bat:ObjectBat):Void
	{
		// trace('colliding bat: ${bat.getPosition()}');
		if (invulnerability == true)
			return;
		if (isDead())
			return;

		if (isDrilling)
		{
			// attack
			if (drillTimer > 0) bat.onGetAttacked();
		}
		else
		{
			throwBack(bat.getPosition());
			invulnerability = true;
			invulnerabilityTimer = 100;
			ResGame.health -= 10;
			FlxG.sound.play("assets/sounds/player_attacked.wav");
		}
	}

	public function onCollideStone(stone:ObjectStone) {
		if (invulnerability == true)
			return;
		if (isDead())
			return;

		if (stone.onFloor) return;
		if ((stone.y + 24) > this.y) return;

		ResGame.health = 0;
	}

	public function onOverlapDoor(door:ObjectDoor):Bool {
		if (use) return true;
		return false;
	}

	function attackDrill()
	{
		if (isDead())
			return;
		// if (!drilling)
		// 	return;
		FlxG.sound.play("assets/sounds/drill.wav");

		drill.playAnimation();
	}

	function updateInvulnerability() {
		if (invulnerability)
		{
			this.alpha = invulnerabilityTimer % 2;
			if (invulnerabilityTimer > 0)
			{
				invulnerabilityTimer--;
			}
			else
			{
				invulnerability = false;
			}
		}
		else
			this.alpha = 1;
	}

	function throwBombFn()
	{
		if (ResGame.bombs <= 0)
			return;
		onCreateBomb();
		ResGame.bombs--;
		// if (currentState != null)
		// {
		// 	if (Std.isOfType(currentState, PlayState))
		// 	{
		// 		var s = cast(currentState, PlayState);

		// 	}
		// }
	}

	override function update(elapsed:Float):Void
	{
		isDrilling = drill.isDrilling();
		onFloor = this.isTouching(FLOOR);
		// drilling= false;
		super.update(elapsed);

		this.updateMovement();
		this.updateAnimations();
		this.clampPosition();

		use = FlxG.keys.anyJustPressed([ENTER, F, E]);
		throwBomb = FlxG.keys.anyJustPressed([G, TAB]);

		if (throwBomb)
		{
			this.throwBombFn();
		}

		drilling = FlxG.mouse.pressed;
		if (drillTimer > 0) {
			drillTimer--;
		}

		if (drilling) {
			if (drillTimer <= 0) {
				drillTimer = 50 - Std.int(Math2.clamp(ResGame.drillPower, 0, 45));
				this.attackDrill();
			}
		}

		if (isDrilling) {
			var p = FlxPoint.weak(drill.x + 8, drill.y + 8);
			// tileMap.removeTileAt(FlxPoint.weak(x + 8, y + 16 + 8));
			if (tileMap.removeTileAt(p))
			{
				objCamera.shake(0.001);
				// throwBack(p);
			}
		}

		this.updateInvulnerability();

		// clamp it just for sure
		ResGame.health = FlxMath.maxInt(ResGame.health, 0);

		if (Config.DEBUG)
		{
			if (FlxG.keys.anyJustPressed([ONE]))
			{
				FlxG.resetState();
				ResGame.reset();
			}

			if (FlxG.keys.anyJustPressed([TWO])) {
				ResGame.gold += 10;
				ResGame.diamond += 10;
				ResGame.ruby += 10;
				ResGame.emerald += 10;
			}
		}
	}
}
