--!strict
-- Pure XP/level functions; store returned progress on your server.
local LevelSystem = {}
LevelSystem.MaxLevel = 125

export type Progress = { Level: number, XP: number }

function LevelSystem.GetXPRequired(level: number): number
    assert(level >= 1 and level % 1 == 0, "Level must be a positive integer")
    return math.floor(100 * level ^ 1.5)
end

function LevelSystem.AddXP(progress: Progress, amount: number): Progress
    assert(amount >= 0 and amount < math.huge and amount == amount, "Invalid XP amount")
    local level = math.clamp(math.floor(progress.Level), 1, LevelSystem.MaxLevel)
    local xp = math.max(0, progress.XP) + amount
    while level < LevelSystem.MaxLevel do
        local required = LevelSystem.GetXPRequired(level)
        if xp < required then break end
        xp -= required
        level += 1
    end
    if level == LevelSystem.MaxLevel then xp = 0 end
    return { Level = level, XP = xp }
end

return LevelSystem
