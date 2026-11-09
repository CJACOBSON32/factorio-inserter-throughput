-- Inserter Throughput Mod
-- Adds throughput information to inserter tooltips using custom_tooltip_fields

-- Calculate throughput for inventory-to-inventory transfers (180° rotation each way)
-- Formula: stack_size * rotation_speed * 60 / (2 * pi) items/second
---@param inserter InserterPrototype
local function calculate_throughput(inserter)
  local rotation_speed = inserter.rotation_speed or 0.014 -- default inserter rotation speed
  local stack_size = 1 -- Base stack size (without research bonuses)

  if inserter.stack_size_bonus then
    stack_size = stack_size + inserter.stack_size_bonus
  end

  -- For a full cycle (pick up + place), the inserter rotates 2 * 180° = 2π radians
  -- Time in seconds = 2π / (rotation_speed * 60)
  -- Throughput = stack_size / time = stack_size * rotation_speed * 60 / (2π)
  local throughput = stack_size * rotation_speed * 60 / (2 * math.pi)

  return throughput
end

-- Format throughput to a reasonable number of decimal places
--@param throughput number
local function format_throughput(throughput)
  return math.floor(throughput * 100 + 0.5) / 100
end

-- Add custom_tooltip_fields to all inserter prototypes
for name, inserter in pairs(data.raw["inserter"]) do
  local throughput = calculate_throughput(inserter)

  -- Initialize custom_tooltip_fields if it doesn't exist
  inserter.custom_tooltip_fields = inserter.custom_tooltip_fields or {}

  -- Add throughput field
  inserter.custom_tooltip_fields.throughput = format_throughput(throughput)
end
