--!strict
-- Display helpers that can be required on the client or server.
local FormatUtils = {}

function FormatUtils.CompactNumber(value: number): string
    local absolute = math.abs(value)
    local suffix = ""
    local divisor = 1
    if absolute >= 1e9 then divisor, suffix = 1e9, "B"
    elseif absolute >= 1e6 then divisor, suffix = 1e6, "M"
    elseif absolute >= 1e3 then divisor, suffix = 1e3, "K" end
    if divisor == 1 then return tostring(math.floor(value)) end
    return string.format("%.1f%s", value / divisor, suffix)
end

function FormatUtils.Health(current: number, maximum: number): string
    maximum = math.max(0, maximum)
    current = math.clamp(current, 0, maximum)
    return string.format("%d / %d", math.ceil(current), math.ceil(maximum))
end

function FormatUtils.Level(level: number): string
    return "Lv. " .. tostring(math.max(1, math.floor(level)))
end

return FormatUtils
