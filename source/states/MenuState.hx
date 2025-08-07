package states;

import flixel.FlxG;
import flixel.FlxState;
import flixel.math.FlxPoint;
import flixel.system.scaleModes.RatioScaleMode;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import resources.ResGame;

class MenuState extends FlxState
{
	var playButton:FlxButton;
	var creditsButton:FlxButton;
	var htpButton:FlxButton;

	var titleText:FlxText;
	var subtitleText:FlxText;
	var textHighscore:FlxText;

	var tick:Float = 0;

	private function setWindowSettings()
	{
		FlxG.scaleMode = new RatioScaleMode();
	}

	private function createEntities()
	{
		{
			titleText = new FlxText(0, 0, 0, "Down Digger!", 64);
			titleText.screenCenter();
			titleText.color = FlxColor.WHITE;
			titleText.y = FlxG.height / 4; // Adjust position to center vertically
			add(titleText);
		}

		{
			subtitleText = new FlxText(0, 0, 0, "Taking to the Root!", 24);
			subtitleText.x = titleText.x + titleText.width / 2;
			subtitleText.y = titleText.y + titleText.height / 1.25;
			subtitleText.color = FlxColor.YELLOW;
			subtitleText.angle = -5;
			add(subtitleText);
		}

		{
			textHighscore = new FlxText(0, 0, 0, 'Highscore: ${ResGame.highscore}');
			add(textHighscore);
		}

		{
			playButton = new FlxButton(0, 0, "Play", () ->
			{
				FlxG.camera.fade(FlxColor.BLACK, 1, false, () ->
				{
					trace("Starting the game...");
					ResGame.reset();
					FlxG.switchState(PlayState.new);
				});
			});
			playButton.screenCenter();
			add(playButton);
		}

		{
			creditsButton = new FlxButton(0, 0, "Credits", () -> {
				// FlxG.switchState(PlayState.new);
			});
			creditsButton.screenCenter();
			creditsButton.y += creditsButton.height * 2;
			add(creditsButton);
		}

		{
			htpButton = new FlxButton(0, 0, "How to play", () -> {
				// FlxG.switchState(PlayState.new);
			});
			htpButton.screenCenter();
			htpButton.y += htpButton.height * 4;
			add(htpButton);
		}
	}

	override public function create()
	{
		super.create();

		// this.bgColor = FlxColor.PINK;
		this.setWindowSettings();
		this.createEntities();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		subtitleText.size = 20 + Math.floor((Math.sin(tick / 25) + 1) * 4);
		tick++;
	}
}
