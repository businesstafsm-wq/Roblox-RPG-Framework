--!strict
-- Dialogue definitions. UI should display text and choices, not run arbitrary commands.
local DialogueService = {}

local DIALOGUES = {
    VillageElder = {
        start = "welcome",
        nodes = {
            welcome = {
                text = "Welcome, adventurer! What brings you here?",
                choices = {
                    { text = "Any work available?", nextNode = "quest" },
                    { text = "Goodbye.", nextNode = "bye" },
                },
            },
            quest = { text = "Try practicing at the training grounds.", choices = {} },
            bye = { text = "Safe travels!", choices = {} },
        },
    },
}

function DialogueService.GetStart(npcId: string): string?
    local npc = DIALOGUES[npcId]
    return npc and npc.start or nil
end

function DialogueService.GetNode(npcId: string, nodeId: string)
    local npc = DIALOGUES[npcId]
    if not npc then return nil end
    local node = npc.nodes[nodeId]
    if not node then return nil end
    return { text = node.text, choices = table.clone(node.choices) }
end

function DialogueService.Select(npcId: string, nodeId: string, choiceIndex: number): string?
    local node = DialogueService.GetNode(npcId, nodeId)
    if not node or choiceIndex % 1 ~= 0 then return nil end
    local choice = node.choices[choiceIndex]
    return choice and choice.nextNode or nil
end

return DialogueService
