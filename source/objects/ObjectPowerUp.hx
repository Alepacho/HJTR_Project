package objects;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.math.FlxRandom;
import flixel.util.FlxColor;
import resources.ResGame;

enum PowerUpCurrency {
    GOLD;
    DIAMOND;
    RUBY;
    EMERALD;
}

enum PowerUpType {
    BOMBS;
    LEGS;
    DRILL;
    HEALTH;
}

class ObjectPowerUp extends FlxSprite
{
    var tick:Int = 0;
    var startPosition:FlxPoint;
    public var type:PowerUpType = PowerUpType.BOMBS;
    public var currency:PowerUpCurrency = PowerUpCurrency.GOLD;

	public function new(x:Float = 0, y:Float = 0) {
        super(x, y);

        loadGraphic("assets/images/powerups.png", true, 24, 24);
        animation.add('bombs', [0]);
        animation.add('legs', [1]);
        animation.add('drill', [2]);
        animation.add('health', [3]);

        var rnd = new FlxRandom();
        tick += rnd.int(0, 360);

        setType(rnd);
        setCurrency(rnd);
        startPosition = new FlxPoint(x, y);
    }

    function setType(rnd:FlxRandom) {
        var p = rnd.int(0, 3);
            switch (p) {
                case 0: type = PowerUpType.BOMBS;
                case 1: type = PowerUpType.LEGS;
                case 2: type = PowerUpType.DRILL;
                case 3: type = PowerUpType.HEALTH;
            }
    }

    public function getCurrencyName() {
        switch (currency) {
            case GOLD: return 'gold';
            case DIAMOND: return 'diamond';
            case RUBY: return 'ruby';
            case EMERALD: return 'emerald';
        }
    }

    function setCurrency(rnd:FlxRandom) {
        var p = rnd.int(0, 3);
        switch (p) {
            case 0: currency = PowerUpCurrency.GOLD;
            case 1: currency = PowerUpCurrency.DIAMOND;
            case 2: currency = PowerUpCurrency.RUBY;
            case 3: currency = PowerUpCurrency.EMERALD;
        }
    }

    public function getPowerUpName() {
        switch (type) {
            case BOMBS: return 'bombs';
            case LEGS: return 'legs'; 
            case DRILL: return 'drill'; 
            case HEALTH: return 'health';
        }
        return 'health';
    }

    public function getInfo() {
        switch (type) {
            case BOMBS: return '+3 bombs';
            case LEGS: return '+5 jump height';
            case DRILL: return '+1 drill speed';
            case HEALTH: return '+10 health';
        }
    }

    function getColor() {
        switch (currency) {
            case GOLD: return FlxColor.YELLOW;
            case DIAMOND: return FlxColor.CYAN;
            case RUBY: return FlxColor.RED;
            case EMERALD: return FlxColor.LIME;
        }
    }

    function canBuy():Bool {
        switch (currency) {
            case GOLD: {
                if (ResGame.gold < 10) return false;
            }
            case DIAMOND: {
                if (ResGame.diamond < 10) return false;
            }
            case RUBY: {
                if (ResGame.ruby < 10) return false;
            }
            case EMERALD: {
                if (ResGame.emerald < 10) return false;

            }
        }
        return true;
    }

    public function use(player:ObjectPlayer) {
        if (!canBuy()) return;
		trace('using powerup! ${getPowerUpName()} (${getInfo()})');

        switch (currency) {
            case GOLD: {
                ResGame.gold -= 10;
            }
            case DIAMOND: {
                ResGame.diamond -= 10;
            }
            case RUBY: {
                ResGame.ruby -= 10;
            }
            case EMERALD: {
                ResGame.emerald -= 10;
            }
        }

        switch (type) {
            case BOMBS:
                ResGame.bombs += 3;
            case LEGS:
                ResGame.legs += 5;
            case DRILL:
                ResGame.drillPower += 1;
            case HEALTH:
                ResGame.health += 10;
        }
		FlxG.sound.play("assets/sounds/buy.wav");
        this.kill();
    }

    override function update(elapsed:Float):Void {
        super.update(elapsed);

        this.color = getColor();
        this.y = startPosition.y + Math.sin(tick / 100.0) * 4;
        animation.play(getPowerUpName());

        tick++;
    }
}
