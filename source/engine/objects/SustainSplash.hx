package objects;

class SustainSplash extends FlxSprite
{
	public static var startCrochet:Float;
	public static var frameRate:Int;

	public var strumNote:StrumNote;
	public var parentGroup:FlxTypedGroup<SustainSplash>;

	public var destroyTimer:FlxTimer;

	public function new():Void
	{
		super();

		frames = Paths.getSparrowAtlas('holdSplash');
		animation.addByPrefix('hold', 'holdSplash0', 24, true);
		animation.addByPrefix('end', 'holdSplashEnd0', 24, false);
		animation.play('hold', true, false, 0);
		animation.curAnim.frameRate = frameRate;
		animation.curAnim.looped = true;

		destroyTimer = new FlxTimer();
	}

	override function update(elapsed:Float)
	{
		if (strumNote != null)
			this.alpha = strumNote.alpha * ClientPrefs.data.splashAlpha;
		if (this.x != strumNote.x || this.y != strumNote.y)
			setPosition(strumNote.x, strumNote.y);
		/*if (this.angle != strumNote.angle)
			angle = strumNote.angle;*/
		super.update(elapsed);
	}

	public function setupSusSplash(strum:StrumNote, end:Note, ?playbackRate:Float = 1):Void
	{
		final lengthToGet:Int = !end.isSustainNote ? end.tail.length : end.parent.tail.length;
		final timeToGet:Float = !end.isSustainNote ? end.strumTime : end.parent.strumTime;
		final timeThingy:Float = (startCrochet * lengthToGet + (timeToGet - Conductor.songPosition + ClientPrefs.data.ratingOffset)) / playbackRate * .001;

		end.extraData['holdSplash'] = this;

		clipRect = new flixel.math.FlxRect(0, !PlayState.isPixelStage ? 0 : -210, frameWidth, frameHeight);

		if (end.shader != null && !PlayState.SONG.disableNoteRGB)
		{
			shader = new objects.NoteSplash.PixelSplashShaderRef().shader;
			shader.data.r.value = end.shader.data.r.value;
			shader.data.g.value = end.shader.data.g.value;
			shader.data.b.value = end.shader.data.b.value;
			shader.data.mult.value = end.shader.data.mult.value;
		}

		setPosition(strum.x, strum.y);
		offset.set(PlayState.isPixelStage ? 112.5 : 106.25, 100);

		strumNote = strum;
		alpha = ClientPrefs.data.splashAlpha - (1 - strumNote.alpha);

		destroyTimer.start(timeThingy, (idk:FlxTimer) ->
		{
			if (!end.mustPress) // for opponent notes
			{
				die(end);
				return;
			}

			alpha = ClientPrefs.data.splashAlpha - (1 - strumNote.alpha);

			clipRect = null;

			final badNotes:Array<String> = ['glitchNote'];
			try
			{
				if (ClientPrefs.data.splashAlpha != 0
					&& !badNotes.contains(end.noteType)
					|| (end.animation.exists(Note.colArray[end.prevNote.noteData % Note.colArray.length] + 'hold')
						|| end.animation.exists(Note.colArray[end.noteData % Note.colArray.length] + 'holdend')))
				{
					// alpha = ClientPrefs.data.splashAlpha - (1 - strumNote.alpha);
					animation.play('end', true, false, 0);
					animation.curAnim.looped = false;
					animation.curAnim.frameRate = 24;
					animation.finishCallback = (idkEither:Dynamic) ->
					{
						die(end);
					}
				}
			}
			catch (e:Dynamic)
			{
				trace('Failed to play end animation! $e');
			}
		});
	}

	override function kill():Void
	{
		super.kill();

		this.visible = false;
	}

	/*
		override function revive():Void
		{
		 super.revive();
		 this.visible = true;
		}
	 */
	public function die(?end:Note = null):Void
	{
		kill();

		if (parentGroup != null)
			parentGroup.remove(this);

		if (end != null)
		{
			end.extraData['holdSplash'] = null;
		}
	}
}
