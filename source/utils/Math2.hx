package utils;

class Math2 {
    static public function deg2rad(value:Float) {
        return value * (Math.PI / 180);
    }

    static public function clamp(value:Float, min:Float, max:Float) {
        return Math.min(Math.max(value, min), max);
    }
}