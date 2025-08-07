package utils;

import flixel.math.FlxPoint;

class Math2 {
	static public function deg2rad(value:Float)
	{
        return value * (Math.PI / 180);
	}

	static public function clamp(value:Float, min:Float, max:Float)
	{
        return Math.min(Math.max(value, min), max);
    }
	static public function distance(a:FlxPoint, b:FlxPoint)
	{
		return a.distanceTo(b);
	}
}