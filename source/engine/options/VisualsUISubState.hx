package options;

#if native
import lime.ui.WindowVSyncMode;
#end
import objects.Note;
import objects.StrumNote;

class VisualsUISubState extends BaseOptionsMenu
{
	public static var pauseMusics:Array<String> = ['None', 'Horror Break'];

	var noteOptionID:Int = -1;
	var notes:FlxTypedGroup<StrumNote>;
	var notesTween:Array<FlxTween> = [];
	var noteY:Float = 90;

	public function new()
	{
		title = 'Visuals and UI';
		rpcTitle = 'Visuals & UI Settings Menu'; // for Discord Rich Presence

		var option:Option = new Option('Note Splash Opacity', 'How much transparent should the Note Splashes be.', 'splashAlpha', 'percent');
		option.scrollSpeed = 1.6;
		option.minValue = 0.0;
		option.maxValue = 1;
		option.changeValue = 0.1;
		option.decimals = 1;
		addOption(option);

		var option:Option = new Option('Hide HUD', 'If checked, hides most HUD elements.', 'hideHud', 'bool');
		addOption(option);

		var option:Option = new Option('Flashing Lights', "Uncheck this if you're sensitive to flashing lights!", 'flashing', 'bool');
		addOption(option);

		var option:Option = new Option('Camera Zooms', "If unchecked, the camera won't zoom in on a beat hit.", 'camZooms', 'bool');
		addOption(option);

		var option:Option = new Option('Score Text Zoom on Hit', "If unchecked, disables the Score text zooming\neverytime you hit a note.", 'scoreZoom',
			'bool');
		addOption(option);

		var option:Option = new Option('Health Bar Opacity', 'How much transparent should the health bar and icons be.', 'healthBarAlpha', 'percent');
		option.scrollSpeed = 1.6;
		option.minValue = 0.0;
		option.maxValue = 1;
		option.changeValue = 0.1;
		option.decimals = 1;
		addOption(option);

		#if native
		var option:Option = new Option('VSync',
			'If checked, Enables VSync fixing any screen tearing at the cost of capping the FPS to screen refresh rate.',
			'vsync', 'bool');
		option.onChange = onChangeVSync;
		addOption(option);

		#if android
		var option:Option = new Option('Downscale Game',
			'If checked, Renders the game at a lower resolution (near 0.67x) for better performance.\n(Must restart the game to have an effect)',
			'downscaleGame', 'bool');
		option.onChange = onChangeScaleSize;
		addOption(option);
		#end
		#end

		var option:Option = new Option('Pause Screen Song:', "Which song do you prefer for the Pause Screen?", 'pauseMusic', 'string', pauseMusics);
		addOption(option);
		option.onChange = onChangePauseMusic;

		#if DISCORD_ALLOWED
		var option:Option = new Option('Discord Rich Presence',
			"Uncheck this to prevent accidental leaks, it will hide the Application from your \"Playing\" box on Discord", 'discordRPC', 'bool');
		addOption(option);
		#end

		var option:Option = new Option('Combo Stacking', "If unchecked, Ratings and Combo won't stack, saving on System Memory and easier to read",
			'comboStacking', 'bool');
		addOption(option);

		super();
		add(notes);
	}

	var changedMusic:Bool = false;

	function onChangePauseMusic()
	{
		if (ClientPrefs.data.pauseMusic == 'None')
			FlxG.sound.music.volume = 0;
		else
			FlxG.sound.playMusic(Paths.music(Paths.formatToSongPath(ClientPrefs.data.pauseMusic)));

		changedMusic = true;
	}

	override function destroy()
	{
		if (changedMusic && !OptionsState.onPlayState)
			FlxG.sound.playMusic(Paths.music('freakyMenu'), 1, true);
		super.destroy();
	}

	#if native
	function onChangeVSync()
		FlxG.stage.application.window.setVSyncMode(ClientPrefs.data.vsync ? WindowVSyncMode.ON : WindowVSyncMode.OFF);

	#if android
	function onChangeScaleSize()
		File.saveContent(lime.system.System.applicationStorageDirectory + 'scaleSize.txt', (ClientPrefs.data.downscaleGame ? '${(720 / 1.5) / 720}' : '1'));
	#end
	#end
}
