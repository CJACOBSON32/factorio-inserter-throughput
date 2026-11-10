-- Inserter Throughput Mod - Utility Functions

local util = {}

local DEFAULT_ROTATION_SPEED = 0.014

util.inserter_types = {
  inserter = "inserter",
  fast_inserter = "fast-inserter",
  long_hand_inserter = "long-handed-inserter",
  bulk_inserter = "bulk-inserter",
  stack_inserter = "stack-inserter",
  burner_inserter = "burner-inserter",
}

local BASE_STACK_SIZES = {
  [util.inserter_types.inserter] = 1,
  [util.inserter_types.fast_inserter] = 1,
  [util.inserter_types.long_hand_inserter] = 1,
  [util.inserter_types.bulk_inserter] = 2,
  [util.inserter_types.stack_inserter] = 5,
  [util.inserter_types.burner_inserter] = 1
}

util.inserter_types_array = {}
for _, value in pairs(util.inserter_types) do
  table.insert(util.inserter_types_array, value)
end

---Fetch the base stack size for an inserter prototype
---@param type string
---@param force LuaForce
---@return integer
local function get_inserter_stack_size_bonus(type, force)
  local inserter_base_stack_sizes = {
    [util.inserter_types.burner_inserter] = force.inserter_stack_size_bonus,
    [util.inserter_types.inserter] = force.inserter_stack_size_bonus,
    [util.inserter_types.fast_inserter] = force.inserter_stack_size_bonus,
    [util.inserter_types.long_hand_inserter] = force.inserter_stack_size_bonus,
    [util.inserter_types.bulk_inserter] = force.bulk_inserter_capacity_bonus,
    [util.inserter_types.stack_inserter] = force.bulk_inserter_capacity_bonus
  }
  
  return inserter_base_stack_sizes[type]
end

--- Calculate throughput from rotation speed and effective stack size
---@param rotation_speed number
---@param stack_size number
---@return number throughput in items/second
function util.calculate_throughput(rotation_speed, stack_size)
  return stack_size * rotation_speed * 60
end

--- Calculate throughput for an inserter prototype (data stage)
---@param inserter InserterPrototype
---@return number
function util.calculate_prototype_throughput(inserter)
  local rotation_speed = inserter.rotation_speed or DEFAULT_ROTATION_SPEED
  local stack_size = BASE_STACK_SIZES[inserter.type]
  return util.calculate_throughput(rotation_speed, stack_size)
end

--- Calculate throughput for an inserter entity with research bonus (runtime)
---@param inserter LuaEntity
---@param force LuaForce
---@return number
function util.calculate_entity_throughput(inserter, force)
  local prototype = inserter.prototype
  local rotation_speed = prototype.get_inserter_rotation_speed(inserter.quality) or DEFAULT_ROTATION_SPEED
  local stack_size = 1 + get_inserter_stack_size_bonus(inserter.name, force)

  if inserter.name == util.inserter_types.stack_inserter then
    stack_size = stack_size + 4
  end

  game.print("stack_size: " .. stack_size .. " inserter_name: " .. inserter.name)

  return util.calculate_throughput(rotation_speed, stack_size)
end

--- Format throughput to 2 decimal places (returns string for runtime)
---@param throughput number
---@return string
function util.format_throughput_string(throughput)
  return string.format("%.2f", throughput)
end

return util
