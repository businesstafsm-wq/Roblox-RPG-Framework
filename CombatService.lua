--!strict
-- Server-only melee validation. Never trust client-provided damage or range.
local Players = game:GetService("Players")
local CombatService = {}

local RANGE = 9
local DAMAGE = 12
local COOLDOWN = 0.55
local lastAttack: {[Player]: number} = {}

function CombatService.TryAttack(attacker: Player, targetCharacter: Model): (boolean, string)
    if attacker.Parent ~= Players then return false, "Invalid attacker" end
    if typeof(targetCharacter) ~= "Instance" or not targetCharacter:IsA("Model") then
        return false, "Invalid target"
    end
    local now = os.clock()
    if now - (lastAttack[attacker] or -math.huge) < COOLDOWN then
        return false, "Cooldown"
    end
    local attackerCharacter = attacker.Character
    if not attackerCharacter or attackerCharacter == targetCharacter then
        return false, "Invalid characters"
    end
    local attackerHumanoid = attackerCharacter:FindFirstChildOfClass("Humanoid")
    local targetHumanoid = targetCharacter:FindFirstChildOfClass("Humanoid")
    local attackerRoot = attackerCharacter:FindFirstChild("HumanoidRootPart")
    local targetRoot = targetCharacter:FindFirstChild("HumanoidRootPart")
    if not attackerHumanoid or not targetHumanoid or not attackerRoot or not targetRoot then
        return false, "Missing character parts"
    end
    if not attackerRoot:IsA("BasePart") or not targetRoot:IsA("BasePart") then
        return false, "Invalid roots"
    end
    if attackerHumanoid.Health <= 0 or targetHumanoid.Health <= 0 then
        return false, "Not alive"
    end
    if (attackerRoot.Position - targetRoot.Position).Magnitude > RANGE then
        return false, "Out of range"
    end
    -- Add team checks, line of sight, hitboxes and anti-cheat rules for your game.
    lastAttack[attacker] = now
    targetHumanoid:TakeDamage(DAMAGE)
    return true, "Hit"
end

Players.PlayerRemoving:Connect(function(player)
    lastAttack[player] = nil
end)

return CombatService
