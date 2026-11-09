-- Inserter Throughput Mod
-- Adds base throughput to tooltips (data stage)

local util = require("util")

-- Add custom_tooltip_fields to all inserter prototypes (shows base throughput)
for _, inserter in pairs(data.raw["inserter"]) do
  local throughput = util.calculate_prototype_throughput(inserter)

  if not inserter.custom_tooltip_fields then
    inserter.custom_tooltip_fields = {}
  end

  table.insert(inserter.custom_tooltip_fields, {
    name = { "custom-tooltip-fields.throughput-name" },
    value = { "custom-tooltip-fields.throughput-value", tostring(util.format_throughput_number(throughput)) },
  })
end
