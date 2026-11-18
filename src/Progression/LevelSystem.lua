local LevelSystem = {}

LevelSystem.MaxLevel = 125

function LevelSystem.GetXPRequired(level)
    return math.floor(100 * level ^ 1.5)
end

function LevelSystem.AddXP(data, amount)
    assert(type(data) == "table", "Expected player data")
    assert(type(amount) == "number" and amount >= 0, "Invalid XP")

    data.Level = data.Level or 1
    data.XP = data.XP or 0

    if data.Level >= LevelSystem.MaxLevel then
        data.Level = LevelSystem.MaxLevel
        data.XP = 0
        return data
    end

    data.XP += amount

    while data.Level < LevelSystem.MaxLevel do
        local required = LevelSystem.GetXPRequired(data.Level)

        if data.XP < required then
            break
        end

        data.XP -= required
        data.Level += 1
    end

    if data.Level >= LevelSystem.MaxLevel then
        data.XP = 0
    end

    return data
end

return LevelSystem
