-- Inserter Throughput Mod - Runtime Script
-- Sets a RuntimeTooltipField on inserters with accurate throughput (includes research bonuses)

local util = require("util")

local THROUGHPUT_FIELD_ID = 1

---@param inserter LuaEntity
local function update_tooltip(inserter)
  inserter.set_tooltip_field({
    id = THROUGHPUT_FIELD_ID,
    name = { "runtime-tooltip-fields.throughput-name" },
    value = { "runtime-tooltip-fields.throughput-value", util.format_throughput_string(util.calculate_entity_throughput(inserter, inserter.force)) },
  })
end

---@param force LuaForce
local function update_force_inserters(force)
  for _, surface in pairs(game.surfaces) do
    for _, inserter in pairs(surface.find_entities_filtered({ type = "inserter", force = force })) do
      update_tooltip(inserter)
    end
  end
end

local function initialize()
  for _, force in pairs(game.forces) do
    update_force_inserters(force)
  end
end

---@param event EventData.on_built_entity|EventData.on_robot_built_entity|EventData.script_raised_built|EventData.script_raised_revive
local function on_entity_built(event)
  local entity = event.entity
  if entity.valid then
    update_tooltip(entity)
  end
end

---@param event EventData.on_research_finished
local function on_research_finished(event)
  update_force_inserters(event.research.force)
end

script.on_init(initialize)
script.on_configuration_changed(initialize)

local inserter_filter = { { filter = "type", type = "inserter" } }
script.on_event(defines.events.on_built_entity, on_entity_built, inserter_filter)
script.on_event(defines.events.on_robot_built_entity, on_entity_built, inserter_filter)
script.on_event(defines.events.script_raised_built, on_entity_built, inserter_filter)
script.on_event(defines.events.script_raised_revive, on_entity_built, inserter_filter)
script.on_event(defines.events.on_research_finished, on_research_finished)
