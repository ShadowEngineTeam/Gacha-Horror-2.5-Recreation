function opponentNoteHit(i, d, t, s)
    if not getPropertyFromGroup('notes', i, 'sarahNote') then
        if guitarHeroSustains then
            if not s then
                if getProperty('health') > 0.3 then
                    setProperty('health', getProperty('health') - 0.020)
                end
            end
        else
            if getProperty('health') > 0.3 then
                setProperty('health', getProperty('health') - 0.020)
            end
        end
    end
end
