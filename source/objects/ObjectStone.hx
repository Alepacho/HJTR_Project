package objects;

import flixel.FlxSprite;

class ObjectStone extends FlxSprite {
    static inline final GRAVITY:Float = Config.GRAVITY;
    public var onFloor:Bool = false;

    public var tick:Int = 0;

    public function new(x:Float = 0, y:Float = 0) {
        super(x, y);
        this.acceleration.y = GRAVITY;

        loadGraphic("assets/images/stone.png", false, 24, 24);
    }

    override function update(elapsed:Float):Void {
        onFloor = this.isTouching(FLOOR);
        
        super.update(elapsed);

        if (!onFloor) {
            if (tick > 0) {
                tick--;
            } else {
                this.acceleration.y = GRAVITY;
            }
        } else {
            tick = 100;
            this.acceleration.y = 0;
        }
    }
}
