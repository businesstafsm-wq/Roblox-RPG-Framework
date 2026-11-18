--!strict
-- Pure inventory logic. Run on the server and persist the returned state yourself.
local InventoryService = {}

local ITEMS = {
    HealthPotion = { maxStack = 20, slot = nil },
    IronSword = { maxStack = 1, slot = "Weapon" },
    LeatherArmor = { maxStack = 1, slot = "Chest" },
    Wood = { maxStack = 99, slot = nil },
}

export type Inventory = { items: {[string]: number}, equipped: {[string]: string} }

function InventoryService.New(): Inventory
    return { items = {}, equipped = {} }
end

function InventoryService.Add(inventory: Inventory, itemId: string, quantity: number): boolean
    local definition = ITEMS[itemId]
    if not definition or quantity <= 0 or quantity % 1 ~= 0 then return false end
    local current = inventory.items[itemId] or 0
    if current + quantity > definition.maxStack then return false end
    inventory.items[itemId] = current + quantity
    return true
end

function InventoryService.Remove(inventory: Inventory, itemId: string, quantity: number): boolean
    if quantity <= 0 or quantity % 1 ~= 0 then return false end
    local current = inventory.items[itemId] or 0
    if current < quantity then return false end
    inventory.items[itemId] = current - quantity
    if inventory.items[itemId] == 0 then
        inventory.items[itemId] = nil
        for slot, equippedId in pairs(inventory.equipped) do
            if equippedId == itemId then inventory.equipped[slot] = nil end
        end
    end
    return true
end

function InventoryService.Equip(inventory: Inventory, itemId: string): boolean
    local definition = ITEMS[itemId]
    if not definition or not definition.slot or (inventory.items[itemId] or 0) < 1 then
        return false
    end
    inventory.equipped[definition.slot] = itemId
    return true
end

function InventoryService.GetDefinitions()
    return table.clone(ITEMS)
end

return InventoryService
