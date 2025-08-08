package substates;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;

class MenuCreditsSubstate extends FlxSubState
{
	var textFirst:FlxText = null;
	var btnBack:FlxButton = null;
	var sprBackground:FlxSprite = null;

	override function create():Void
	{
		super.create();

		{
			sprBackground = new FlxSprite();
			sprBackground.makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
            add(sprBackground);
        }

		{
			textFirst = new FlxText(0, 0, 0, 'Made by me, Alepacho :^)\nSpecially for Haxe Jam 2025: Summer Jam.');
			textFirst.screenCenter();
			add(textFirst);
		}

		{
			btnBack = new FlxButton(0, 0, "Back", () ->
			{
				close();
			});
			add(btnBack);
		}
	}
}
