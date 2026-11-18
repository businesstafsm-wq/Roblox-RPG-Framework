--!strict
-- Server-side quest progress; grant rewards only once via Claim.
local QuestService = {}

local DEFINITIONS = {
    FirstSteps = { title = "First Steps", event = "DefeatTrainingDummy", required = 3, xp = 100 },
    GatherWood = { title = "Gather Wood", event = "CollectWood", required = 5, xp = 75 },
}

export type QuestState = { active: {[string]: number}, completed: {[string]: boolean} }

function QuestService.New(): QuestState
    return { active = {}, completed = {} }
end

function QuestService.Accept(state: QuestState, questId: string): boolean
    if not DEFINITIONS[questId] or state.completed[questId] or state.active[questId] ~= nil then
        return false
    end
    state.active[questId] = 0
    return true
end

function QuestService.RecordEvent(state: QuestState, eventName: string, amount: number)
    if amount <= 0 or amount % 1 ~= 0 then return end
    for questId, progress in pairs(state.active) do
        local definition = DEFINITIONS[questId]
        if definition and definition.event == eventName then
            state.active[questId] = math.min(definition.required, progress + amount)
        end
    end
end

function QuestService.Claim(state: QuestState, questId: string): (boolean, number)
    local definition = DEFINITIONS[questId]
    if not definition or state.completed[questId] then return false, 0 end
    local progress = state.active[questId]
    if progress == nil or progress < definition.required then return false, 0 end
    state.active[questId] = nil
    state.completed[questId] = true
    return true, definition.xp
end

function QuestService.GetDefinitions()
    return table.clone(DEFINITIONS)
end

return QuestService
