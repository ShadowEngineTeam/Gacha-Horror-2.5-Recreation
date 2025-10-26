local defaultNotePos = {}
local spin = false
local arrowMoveX = 14
local arrowMoveY = 14
local oppoNoteAlpha = 0;

function onCreate()
    addCharacterToList('Isabelle', 'dad')
    addCharacterToList('hellbro', 'dad')
    addCharacterToList('monk', 'dad')
    precacheImage('stages/Gacha Hell/Pixie')
    precacheImage('stages/Gacha Hell/Isabelle')
    precacheImage('stages/Gacha Hell/Monk')
    precacheImage('stages/Gacha Hell/HellBro')
    -- if not lowQuality then
    -- precacheImage('characters/Arhullex_Dead')
    -- end
    precacheImage('noteSkins/MonkArrows')
end

function onCreatePost()
    makeLuaSprite("Stage1", "stages/Gacha Hell/Pixie", -250, 10)
    scaleObject("Stage1", 2.25, 2)
    addLuaSprite("Stage1", false)

    makeLuaSprite("Stage2", "stages/Gacha Hell/Isabelle", -250, 0)
    scaleObject("Stage2", 2.25, 2)
    addLuaSprite("Stage2", false)
    setProperty("Stage2.visible", false)

    makeLuaSprite("Stage3", "stages/Gacha Hell/Monk", -250, 0)
    scaleObject("Stage3", 2.25, 2)
    addLuaSprite("Stage3", false)
    setProperty("Stage3.visible", false)

    makeLuaSprite("Stage4", "stages/Gacha Hell/HellBro", -200, 0)
    scaleObject("Stage4", 2.25, 2)
    addLuaSprite("Stage4", false)
    setProperty("Stage4.visible", false)

    makeLuaSprite('BlackScreenHUD', 'empty', -550, -150)
    makeGraphic('BlackScreenHUD', 2500, 1920, '000000')
    setObjectCamera('BlackScreenHUD', 'hud')
    addLuaSprite('BlackScreenHUD', true)
    setProperty("BlackScreenHUD.visible", false)

    makeLuaText("Captions", " ", 1200, 55, 330)
    addLuaText("Captions", true)
    setTextSize("Captions", 80)
    setTextBorder("Captions", 4, "410000")
    setTextColor("Captions", "9A0000")
    setTextFont("Captions", "Comfortaa-Bold.ttf")
    setTextAlignment("Captions", "center")

    setProperty('iconP1.flipX', true)
    setProperty('iconP2.flipX', true)
    setProperty('boyfriend.flipX', false)
end

function onUpdatePost()
    local dadX = getProperty('iconP2.x')
    local bfX = getProperty('iconP1.x')

    setProperty('iconP1.x', dadX)
    setProperty('iconP2.x', bfX)
end

function onUpdate(elapsed)
    songPos = getPropertyFromClass('backend.Conductor', 'songPosition')
    currentBeat = (songPos / 1000) * (bpm / 60)
    if spin == true then
        for i = 0, 7 do
            setPropertyFromGroup('strumLineNotes', i, 'x',
                defaultNotePos[i + 1][1] + arrowMoveX * math.sin((currentBeat + i * 0.5) * math.pi))
            setPropertyFromGroup('strumLineNotes', i, 'y',
                defaultNotePos[i + 1][2] + arrowMoveY * math.cos((currentBeat + i * 0.15) * math.pi))
        end
    end
end

function onSongStart()
    if not middlescroll then
        noteTweenX(defaultPlayerStrumX0, 4, defaultOpponentStrumX0, 0.5, "cubeOut")
        noteTweenX(defaultPlayerStrumX1, 5, defaultOpponentStrumX1, 0.5, "cubeOut")
        noteTweenX(defaultPlayerStrumX2, 6, defaultOpponentStrumX2, 0.5, "cubeOut")
        noteTweenX(defaultPlayerStrumX3, 7, defaultOpponentStrumX3, 0.5, "cubeOut")

        noteTweenAngle("NoteAngle1", 4, -360, 0.25, cubeOut)
        noteTweenAngle("NoteAngle2", 5, -360, 0.25, cubeOut)
        noteTweenAngle("NoteAngle3", 6, -360, 0.25, cubeOut)
        noteTweenAngle("NoteAngle4", 7, -360, 0.25, cubeOut)

        noteTweenX(defaultOpponentStrumX0, 0, defaultPlayerStrumX0, 0.5, "cubeOut")
        noteTweenX(defaultOpponentStrumX1, 1, defaultPlayerStrumX1, 0.5, "cubeOut")
        noteTweenX(defaultOpponentStrumX2, 2, defaultPlayerStrumX2, 0.5, "cubeOut")
        noteTweenX(defaultOpponentStrumX3, 3, defaultPlayerStrumX3, 0.5, "cubeOut")

        noteTweenAngle("NoteAngle5", 0, 360, 0.25, cubeOut)
        noteTweenAngle("NoteAngle6", 1, 360, 0.25, cubeOut)
        noteTweenAngle("NoteAngle7", 2, 360, 0.25, cubeOut)
        noteTweenAngle("NoteAngle8", 3, 360, 0.25, cubeOut)
    end
    oppoNoteAlpha = getPropertyFromClass('states.PlayState', 'instance.oppoNoteAlpha')
end

function opponentNoteHit(id, direction, noteType, isSustainNote)
    if getProperty('dad.curCharacter') == 'Isabelle' or getProperty('dad.curCharacter') == 'hellbro' then
        cameraShake('game', 0.01, 0.1)
        cameraShake('hud', 0.01, 0.1)
    end
end

function onBeatHit()
    if curBeat == 192 then
        cameraFlash('hud', '000000', 3, true)
        setProperty("Stage2.visible", true)
        setProperty("Stage1.visible", false)
        setProperty("boyfriend.visible", false)
        setProperty("dad.x", 300)
        setProperty("dad.y", 0)

        if not middlescroll then
            noteTweenX("NoteMove1", 4, 420, 1, 'cubeOut')
            noteTweenX("NoteMove2", 5, 530, 1, 'cubeOut')
            noteTweenX("NoteMove3", 6, 640, 1, 'cubeOut')
            noteTweenX("NoteMove4", 7, 750, 1, 'cubeOut')

            noteTweenAngle("MNoteAngle1", 4, 360, 1, 'cubeOut')
            noteTweenAngle("MNoteAngle2", 5, 360, 1, 'cubeOut')
            noteTweenAngle("MNoteAngle3", 6, 360, 1, 'cubeOut')
            noteTweenAngle("MNoteAngle4", 7, 360, 1, 'cubeOut')
        end

        noteTweenAlpha("NoteMove5", 0, 0, 0.01, 'cubeOut')
        noteTweenAlpha("NoteMove6", 1, 0, 0.01, 'cubeOut')
        noteTweenAlpha("NoteMove7", 2, 0, 0.01, 'cubeOut')
        noteTweenAlpha("NoteMove8", 3, 0, 0.01, 'cubeOut')
    end

    if curBeat == 200 then
        for i = 0, 7 do
            x = getPropertyFromGroup('strumLineNotes', i, 'x')

            y = getPropertyFromGroup('strumLineNotes', i, 'y')

            table.insert(defaultNotePos, {x, y})
        end
        runHaxeCode([[PlayState.instance.changeNoteSkin(false, "noteSkins/MonkArrows");]])
    end

    if curBeat == 384 then
        cameraFlash('hud', '000000', 3, true)
        setProperty("Stage3.visible", true)
        setProperty("Stage2.visible", false)
        setProperty("boyfriend.visible", true)
        setProperty("dad.x", 300)
        setProperty("dad.y", -100)
        setProperty("dad.flipX", false)
        setProperty("boyfriend.x", -200)
        doTweenColor('boyfriend.ColorTween', 'boyfriend', '0xFFA14C4C', 0.05, 'quadInOut')
        doTweenColor('dad.ColorTween', 'dad', '0xFFA14C4C', 0.05, 'quadInOut')
        setProperty('iconP2.flipX', false)

        noteTweenAlpha("NoteMove52", 0, oppoNoteAlpha, 0.01, 'cubeOut')
        noteTweenAlpha("NoteMove62", 1, oppoNoteAlpha, 0.01, 'cubeOut')
        noteTweenAlpha("NoteMove72", 2, oppoNoteAlpha, 0.01, 'cubeOut')
        noteTweenAlpha("NoteMove82", 3, oppoNoteAlpha, 0.01, 'cubeOut')

        if not middlescroll then
            noteTweenX(defaultPlayerStrumX0 .. 2, 4, defaultOpponentStrumX0, 0.5, "cubeOut")
            noteTweenX(defaultPlayerStrumX1 .. 2, 5, defaultOpponentStrumX1, 0.5, "cubeOut")
            noteTweenX(defaultPlayerStrumX2 .. 2, 6, defaultOpponentStrumX2, 0.5, "cubeOut")
            noteTweenX(defaultPlayerStrumX3 .. 2, 7, defaultOpponentStrumX3, 0.5, "cubeOut")

            noteTweenAngle("NoteAngle1" .. "2", 4, -360, 0.25, cubeOut)
            noteTweenAngle("NoteAngle2" .. "2", 5, -360, 0.25, cubeOut)
            noteTweenAngle("NoteAngle3" .. "2", 6, -360, 0.25, cubeOut)
            noteTweenAngle("NoteAngle4" .. "2", 7, -360, 0.25, cubeOut)

            noteTweenX(defaultOpponentStrumX0 .. 2, 0, defaultPlayerStrumX0, 0.5, "cubeOut")
            noteTweenX(defaultOpponentStrumX1 .. 2, 1, defaultPlayerStrumX1, 0.5, "cubeOut")
            noteTweenX(defaultOpponentStrumX2 .. 2, 2, defaultPlayerStrumX2, 0.5, "cubeOut")
            noteTweenX(defaultOpponentStrumX3 .. 2, 3, defaultPlayerStrumX3, 0.5, "cubeOut")

            noteTweenAngle("NoteAngle5" .. "2", 0, 360, 0.25, cubeOut)
            noteTweenAngle("NoteAngle6" .. "2", 1, 360, 0.25, cubeOut)
            noteTweenAngle("NoteAngle7" .. "2", 2, 360, 0.25, cubeOut)
            noteTweenAngle("NoteAngle8" .. "2", 3, 360, 0.25, cubeOut)
        end
    end

    if curBeat == 512 then
        setProperty("Stage3.visible", false)
        if not middlescroll then
            noteTweenX("NoteMove12", 4, 420, 1, 'cubeOut')
            noteTweenX("NoteMove22", 5, 530, 1, 'cubeOut')
            noteTweenX("NoteMove32", 6, 640, 1, 'cubeOut')
            noteTweenX("NoteMove42", 7, 750, 1, 'cubeOut')

            noteTweenAngle("MNoteAngle12", 4, 360, 1, 'cubeOut')
            noteTweenAngle("MNoteAngle22", 5, 360, 1, 'cubeOut')
            noteTweenAngle("MNoteAngle32", 6, 360, 1, 'cubeOut')
            noteTweenAngle("MNoteAngle42", 7, 360, 1, 'cubeOut')
        end

        noteTweenAlpha("NoteMove52", 0, 0, 0.01, 'cubeOut')
        noteTweenAlpha("NoteMove62", 1, 0, 0.01, 'cubeOut')
        noteTweenAlpha("NoteMove72", 2, 0, 0.01, 'cubeOut')
        noteTweenAlpha("NoteMove82", 3, 0, 0.01, 'cubeOut')
    end

    if curBeat == 572 then
        spin = true
        setProperty("BlackScreenHUD.visible", true)
        setTextString("Captions", "GO TO HELL")
    end

    if curBeat == 576 then
        cameraFlash('hud', '000000', 3, true)
        setProperty("BlackScreenHUD.visible", false)
        doTweenColor('dad.ColorTween', 'dad', '0xFFFFFFFF', 0.05, 'quadInOut')
        setProperty("boyfriend.visible", false)
        setTextString("Captions", " ")
        setProperty('iconP2.flipX', true)

        setProperty("Stage4.visible", true)
        setProperty("Stage3.visible", false)

        setProperty("dad.x", 0)
        setProperty("dad.y", -250)
    end

    if curBeat == 640 then
        noteTweenAlpha("NoteMove522", 4, 0, 64, 'linear')
        noteTweenAlpha("NoteMove622", 5, 0, 64, 'linear')
        noteTweenAlpha("NoteMove722", 6, 0, 64, 'linear')
        noteTweenAlpha("NoteMove822", 7, 0, 64, 'linear')
    end

    if curBeat == 780 then
        setProperty("BlackScreenHUD.visible", true)
        setProperty("BlackScreenHUD.alpha", 0)
        doTweenAlpha("BlackScreenHUD2312", "BlackScreenHUD", 1, 5, 'linear')
    end

    if curBeat == 800 then
        setTextString("Captions", "YOU")
    end
    if curBeat == 804 then
        setTextString("Captions", "HAVE COME")
    end
    if curBeat == 810 then
        setTextString("Captions", "ALL THE WAY")
    end
    if curBeat == 816 then
        setTextString("Captions", "HERE")
    end
    if curBeat == 820 then
        setTextString("Captions", "NOW")
    end
    if curBeat == 824 then
        setTextString("Captions", "YOU WILL GET")
    end
    if curBeat == 829 then
        setTextString("Captions", "TO DECIDE")
    end
    if curBeat == 834 then
        setTextString("Captions", "IF")
    end
    if curBeat == 837 then
        setTextString("Captions", "YOUR FLESH")
    end
    if curBeat == 842 then
        setTextString("Captions", "WILL BE")
    end
    if curBeat == 845 then
        setTextString("Captions",
            "SAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA")
    end
end

function onEndSong()
    runHaxeCode([[CoolUtil.browserLoad('https://youtu.be/ZCxnGpm9UFE');]])
end
