package resources;

class ResGame
{
	static public var score:Int = 0;
	static public var highscore:Int = 0;

	static public var gold:Int = 0;
	static public var diamond:Int = 0;
	static public var ruby:Int = 0;
	static public var emerald:Int = 0;

	static public function reset()
	{
		score = 0;

		gold = 0;
		diamond = 0;
		ruby = 0;
		emerald = 0;
	}
}
