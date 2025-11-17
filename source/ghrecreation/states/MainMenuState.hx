package states;

import flixel.FlxObject;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import lime.app.Application;
import options.OptionsState;

class MainMenuState extends MusicBeatState
{
	public static var shadowEngineVersion:String = '0.1.2*'; // asterisk cuz GHR has SE 0.2.x backports.
	public static var psychEngineVersion:String = '0.7.3';
	public static var gachaHorrorVersion:String = '2.5'; // This is also used for Discord RPC
	public static var curSelected:Int = 0;

	var spookything:FlxSprite;
	var boyfriend:FlxSprite;
	var topbar:FlxSprite;
	var bottombar:FlxSprite;
	var quotesbar:FlxSprite;
	var modinfo:FlxSprite;

	var menuItems:FlxTypedGroup<FlxSprite>;

	var optionShit:Array<String> = ['freeplay', 'gallery', 'credits', 'options'];

	override function create()
	{
		#if DISCORD_ALLOWED
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		persistentUpdate = persistentDraw = true;

		spookything = new FlxSprite().loadGraphic(Paths.image('mainmenu/background/SpookyVille'));
		spookything.antialiasing = ClientPrefs.data.antialiasing;
		spookything.updateHitbox();
		spookything.screenCenter();
		add(spookything);

		boyfriend = new FlxSprite(427, 146).loadGraphic(Paths.image('mainmenu/background/BoyfriendSprite'));
		boyfriend.antialiasing = ClientPrefs.data.antialiasing;
		boyfriend.scale.set(0.75, 0.75);
		boyfriend.updateHitbox();
		add(boyfriend);

		quotesbar = new FlxSprite().loadGraphic(Paths.image('mainmenu/background/QuotesBar'));
		quotesbar.antialiasing = ClientPrefs.data.antialiasing;
		quotesbar.updateHitbox();
		add(quotesbar);

		modinfo = new FlxSprite(982, 0).loadGraphic(Paths.image('mainmenu/background/ModInfo'));
		modinfo.antialiasing = ClientPrefs.data.antialiasing;
		modinfo.updateHitbox();
		add(modinfo);

		var modinfoText = new FlxText(0, 0, modinfo.width + 230, '', 1, true);
		modinfoText.setFormat(Paths.font("Comfortaa-Bold.ttf"), 50, 0xFFB9B2E5, FlxTextAlign.CENTER /*, FlxTextBorderStyle.OUTLINE, 0xFF4F0A5F*/);
		modinfoText.text = 'This mod is to\nFunk-Up the old\nGacha Life\nGlitches you would\nSee on YouTube!\nThis mod is on the\nVersion $gachaHorrorVersion Aspect.\n\nThis mod was built\nWith Friday Night\nFunkin\' Shadow\nEngine V$shadowEngineVersion\nMade by HomuHomu833\nand the\nPsych Engine Team';
		modinfoText.scale.set(0.56, 0.56);
		modinfoText.updateHitbox();
		modinfoText.x = ((modinfo.width - modinfoText.width) / 2) + modinfo.x;
		modinfoText.y = ((modinfo.height - modinfoText.height) / 2) + modinfo.y;
		add(modinfoText);

		bottombar = new FlxSprite(0, 611).loadGraphic(Paths.image('mainmenu/background/BottomBar'));
		bottombar.antialiasing = ClientPrefs.data.antialiasing;
		bottombar.updateHitbox();
		add(bottombar);

		topbar = new FlxSprite(293, -60).loadGraphic(Paths.image('mainmenu/background/TopBar'));
		topbar.antialiasing = ClientPrefs.data.antialiasing;
		topbar.updateHitbox();
		add(topbar);

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		for (i in 0...optionShit.length)
		{
			var offset:Float = 208 - (Math.max(optionShit.length, 4) - 4) * 80;
			var menuItem:FlxSprite = new FlxSprite((i * 225) + offset, 611);
			menuItem.antialiasing = ClientPrefs.data.antialiasing;
			menuItem.frames = Paths.getSparrowAtlas('mainmenu/menu_' + optionShit[i]);
			menuItem.animation.addByPrefix('idle', optionShit[i] + " basic", 24);
			menuItem.animation.addByPrefix('selected', optionShit[i] + " white", 24);
			menuItem.animation.play('idle');
			menuItem.ID = i;
			menuItems.add(menuItem);
			var scr:Float = (optionShit.length - 4) * 0.135;
			if (optionShit.length < 6)
				scr = 0;
			menuItem.scrollFactor.set(0, scr);
			menuItem.updateHitbox();
		}

		changeItem();

		FlxG.mouse.visible = true;

		super.create();
	}

	var selectedSomethin:Bool = false;

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.8)
			FlxG.sound.music.volume += 0.5 * elapsed;

		if (!selectedSomethin)
		{
			for (i in 0...menuItems.length)
			{
				if (FlxG.mouse.justMoved && i != curSelected)
				{
					if (FlxG.mouse.overlaps(menuItems.members[i]))
					{
						curSelected = i;
						changeItem(0);
					}
				}
			}

			if (controls.UI_LEFT_P)
				changeItem(-1);

			if (controls.UI_RIGHT_P)
				changeItem(1);

			for (item in 0...menuItems.members.length)
			{
				if (item == curSelected)
				{
					menuItems.members[item].animation.play('selected');
					menuItems.members[item].centerOffsets();
				}
				else
				{
					menuItems.members[item].animation.play('idle');
					menuItems.members[item].updateHitbox();
				}
			}

			if (controls.BACK)
			{
				selectedSomethin = true;
				FlxG.sound.play(Paths.sound('cancelMenu'));
				MusicBeatState.switchState(new TitleState());
			}

			if (FlxG.mouse.justPressed && FlxG.mouse.overlaps(menuItems.members[curSelected]) || controls.ACCEPT)
			{
				FlxG.sound.play(Paths.sound('confirmMenu'));
				/*if (optionShit[curSelected] == 'donate')
					{
						CoolUtil.browserLoad('https://ninja-muffin24.itch.io/funkin');
					}
					else */
				{
					selectedSomethin = true;

					FlxFlicker.flicker(menuItems.members[curSelected], 1, 0.06, false, false, function(flick:FlxFlicker)
					{
						switch (optionShit[curSelected])
						{
							case 'freeplay':
								MusicBeatState.switchState(new states.FreeplayState.FreeplaySelectState());
							case 'gallery':
								MusicBeatState.switchState(new GalleryState());
							case 'credits':
								MusicBeatState.switchState(new states.CreditsState());
							case 'options':
								MusicBeatState.switchState(new OptionsState());
								OptionsState.onPlayState = false;
								if (PlayState.SONG != null)
								{
									PlayState.stageUI = 'normal';
								}
						}
					});

					for (i in 0...menuItems.members.length)
					{
						if (i == curSelected)
							continue;
						FlxTween.tween(menuItems.members[i], {alpha: 0}, 0.4, {
							ease: FlxEase.quadOut,
							onComplete: function(twn:FlxTween)
							{
								menuItems.members[i].kill();
							}
						});
					}
				}
			}
		}

		super.update(elapsed);
	}

	function changeItem(huh:Int = 0)
	{
		FlxG.sound.play(Paths.sound('scrollMenu'));
		curSelected += huh;

		if (curSelected >= menuItems.length)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = menuItems.length - 1;
	}
}
