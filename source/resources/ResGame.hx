package resources;

class ResGame
{
	static public var score:Int = 0;
	static public var highscore:Int = 0;
	static public var floor:Int = 1;

	static public var bombs:Int = 3;
	static public var legs:Int = 0;
	static public var health:Int = 100;
	static public var drillPower:Int = 0;

	static public var gold:Int = 0;
	static public var diamond:Int = 0;
	static public var ruby:Int = 0;
	static public var emerald:Int = 0;

	static public function reset()
	{
		score = 0;
		floor = 1;

		bombs = 3;
		legs = 0;
		health = 100;
		drillPower = 0;

		gold = 0;
		diamond = 0;
		ruby = 0;
		emerald = 0;
	}
}
