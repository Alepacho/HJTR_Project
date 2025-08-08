package substates;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import states.MenuState;

class PlayPauseSubstate extends FlxSubState
{
	var textPaused:FlxText = null;
	var btnBack:FlxButton = null;
	var btnExit:FlxButton = null;
	// var sprBackground:FlxSprite = null;
    var tick:Int = 0;
    
	override function create():Void
	{
		super.create();

		// {
		// 	sprBackground = new FlxSprite();
		// 	sprBackground.makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
        //     add(sprBackground);
        // }

		{
			textPaused = new FlxText(0, 0, 0, 'Paused');
            textPaused.color = FlxColor.WHITE;
            textPaused.setBorderStyle(FlxTextBorderStyle.OUTLINE_FAST, FlxColor.BLACK);
			textPaused.screenCenter();
			add(textPaused);
		}

		{
			btnBack = new FlxButton(0, 0, "Back", () ->
			{
				close();
			});
            btnBack.screenCenter();
            btnBack.y += textPaused.height * 2;
			add(btnBack);
		}

        {
            btnExit = new FlxButton(0, 0, 'Exit to menu', () -> {
                FlxG.switchState(MenuState.new);
                close();
            });
            btnExit.screenCenter();
            btnExit.y += textPaused.height * 4;
            add(btnExit);
        }
	}

    override function update(elapsed:Float):Void {
        super.update(elapsed);

        if ((tick % 100) < 50) {
            textPaused.alpha = 0;
        } else {
            textPaused.alpha = 1;
        }

        tick++;
    }
}
