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

util.inserter_types_array = {}
for _, value in pairs(util.inserter_types) do
  table.insert(util.inserter_types_array, value)
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
  local stack_size = 1 + ( inserter.stack_size_bonus or 0 )
  return util.calculate_throughput(rotation_speed, stack_size)
end

--- Calculate throughput for an inserter entity with research bonus (runtime)
---@param inserter LuaEntity
---@param force LuaForce
---@return number
function util.calculate_entity_throughput(inserter, force)
  local prototype = inserter.prototype
  local rotation_speed = prototype.get_inserter_rotation_speed(inserter.quality) or DEFAULT_ROTATION_SPEED
  local stack_size = 1 + (prototype.inserter_stack_size_bonus or 0) + force.inserter_stack_size_bonus
  return util.calculate_throughput(rotation_speed, stack_size)
end

--- Format throughput to 2 decimal places (returns string for runtime)
---@param throughput number
---@return string
function util.format_throughput_string(throughput)
  return string.format("%.2f", throughput)
end

return util
