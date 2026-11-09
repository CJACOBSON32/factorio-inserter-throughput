-- Inserter Throughput Mod - Utility Functions

local util = {}

local DEFAULT_ROTATION_SPEED = 0.014

--- Calculate throughput from rotation speed and effective stack size
---@param rotation_speed number
---@param stack_size number
---@return number throughput in items/second
function util.calculate_throughput(rotation_speed, stack_size)
  return stack_size * rotation_speed * 60 / (2 * math.pi)
end

--- Get effective stack size from prototype bonus and optional research bonus
---@param prototype_bonus number|nil
---@param research_bonus number|nil
---@return number
function util.get_effective_stack_size(prototype_bonus, research_bonus)
  local stack_size = 1
  if prototype_bonus then
    stack_size = stack_size + prototype_bonus
  end
  if research_bonus then
    stack_size = stack_size + research_bonus
  end
  return stack_size
end

--- Calculate throughput for an inserter prototype (data stage)
---@param inserter InserterPrototype
---@return number
function util.calculate_prototype_throughput(inserter)
  local rotation_speed = inserter.rotation_speed or DEFAULT_ROTATION_SPEED
  local stack_size = util.get_effective_stack_size(inserter.stack_size_bonus, nil)
  return util.calculate_throughput(rotation_speed, stack_size)
end

--- Calculate throughput for an inserter entity with research bonus (runtime)
---@param inserter LuaEntity
---@param force LuaForce
---@return number
function util.calculate_entity_throughput(inserter, force)
  local prototype = inserter.prototype
  local rotation_speed = prototype.rotation_speed or DEFAULT_ROTATION_SPEED
  local stack_size = util.get_effective_stack_size(
    prototype.stack_size_bonus,
    force.inserter_stack_size_bonus
  )
  return util.calculate_throughput(rotation_speed, stack_size)
end

--- Format throughput to 2 decimal places (returns number for data stage)
---@param throughput number
---@return number
function util.format_throughput_number(throughput)
  return math.floor(throughput * 100 + 0.5) / 100
end

--- Format throughput to 2 decimal places (returns string for runtime)
---@param throughput number
---@return string
function util.format_throughput_string(throughput)
  return string.format("%.2f", throughput)
end

return util
