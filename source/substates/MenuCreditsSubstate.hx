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
			textFirst = new FlxText(0, 0, 0,
				'Game made by me, Alepacho :^)\nSFX is also made by me.\n\nMain menu theme: "Funky n Blinky - 8bit by Lenny Pixels" from "Free Music Archive" (CC BY)\nGameplay theme: "Strange Signal - 8bit by Lenny Pixels" from "Free Music Archive" (CC BY)\nShop theme: "The Beat of Nuts n Bolts - 8bit by Lenny Pixels" from "Free Music Archive" (CC BY)\n\nSpecially for Haxe Jam 2025: Summer Jam.');
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
