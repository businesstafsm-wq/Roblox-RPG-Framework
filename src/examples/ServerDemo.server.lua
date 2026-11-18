--!strict
-- Example usage: place source modules in ServerScriptService/RPGModules.
-- Copy this Script into ServerScriptService. Remove after testing.
local ServerScriptService = game:GetService("ServerScriptService")
local modules = ServerScriptService:WaitForChild("RPGModules")
local LevelSystem = require(modules.Progression.LevelSystem)
local InventoryService = require(modules.Inventory.InventoryService)
local QuestService = require(modules.Quests.QuestService)
local DialogueService = require(modules.NPCs.DialogueService)
local FormatUtils = require(modules.UI.FormatUtils)

local progress = LevelSystem.AddXP({ Level = 1, XP = 0 }, 250)
print("Progress:", progress.Level, progress.XP)

local inventory = InventoryService.New()
assert(InventoryService.Add(inventory, "IronSword", 1))
assert(InventoryService.Equip(inventory, "IronSword"))
print("Equipped weapon:", inventory.equipped.Weapon)

local quests = QuestService.New()
assert(QuestService.Accept(quests, "FirstSteps"))
QuestService.RecordEvent(quests, "DefeatTrainingDummy", 3)
local claimed, rewardXP = QuestService.Claim(quests, "FirstSteps")
assert(claimed)
progress = LevelSystem.AddXP(progress, rewardXP)
print("Quest reward:", rewardXP, FormatUtils.Level(progress.Level))

local start = DialogueService.GetStart("VillageElder")
if start then
    local node = DialogueService.GetNode("VillageElder", start)
    print("NPC:", node and node.text)
end

-- CombatService is not called here: it needs real Player and character models.
