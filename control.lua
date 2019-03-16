local lib = require('lib')

local function on_player_changed_position(event)
  local player = game.players[event.player_index]
  local dozer = player.vehicle
  if dozer and dozer.name == 'bulldozer' and dozer.speed > 0 then
    local dozer_inv = dozer.get_inventory(defines.inventory.car_trunk)
    local area = lib.adjust_area(dozer.bounding_box, dozer.orientation)
    for _, ent in pairs(dozer.surface.find_entities_filtered {area = area, type = 'resource', invert = true}) do
      if ent.valid and ent.type ~= 'player' and ent.type ~= 'car' then
        if ent.type == 'cliff' then
          ent.destroy{do_cliff_correction=true,raise_destroy=true}
        elseif ent.minable then
          if dozer_inv.can_insert('raw-fish') then
            player.surface.play_sound({
              position = player.position,
              path = 'utility/axe_mining_ore',
              volume_modifier = 0.3,
            })
            player.mine_entity(ent)
          else
            player.print({'bulldozer.full'})
          end
        end
      end
    end
  end
end
script.on_event(defines.events.on_player_changed_position, on_player_changed_position)

-- TODO instead of event.buffer.get_contents() iterate stacks and transfer
local function on_player_mined_entity(event)
  local player = game.players[event.player_index]
  local dozer = player.vehicle
  if dozer and dozer.name == 'bulldozer' and dozer.speed > 0 then
    local dozer_inv = dozer.get_inventory(defines.inventory.car_trunk)
    for name, count in pairs(event.buffer.get_contents()) do
      if dozer_inv.can_insert({name = name, count = count}) then
        event.buffer.remove({name = name, count = dozer_inv.insert({name = name, count = count})})
      end
    end
  end
end
script.on_event(defines.events.on_player_mined_entity, on_player_mined_entity)

local inventories_to_clear = {
  defines.inventory.fuel,
  defines.inventory.burnt_result,
  defines.inventory.chest,
  defines.inventory.furnace_source,
  defines.inventory.furnace_result,
  defines.inventory.furnace_modules,
  defines.inventory.player_quickbar,
  defines.inventory.roboport_robot,
  defines.inventory.roboport_material,
  defines.inventory.robot_cargo,
  defines.inventory.robot_repair,
  defines.inventory.assembling_machine_input,
  defines.inventory.assembling_machine_output,
  defines.inventory.assembling_machine_modules,
  defines.inventory.lab_input,
  defines.inventory.lab_modules,
  defines.inventory.mining_drill_modules,
  defines.inventory.rocket_silo_rocket,
  defines.inventory.rocket_silo_result,
  defines.inventory.rocket,
  defines.inventory.car_trunk,
  defines.inventory.car_ammo,
  defines.inventory.cargo_wagon,
  defines.inventory.turret_ammo,
  defines.inventory.beacon_modules,
  defines.inventory.character_corpse,
}
local function on_pre_player_mined_item(event)
  local player = game.players[event.player_index]
  local dozer = player.vehicle
  if dozer and dozer.name == 'bulldozer' and dozer.speed > 0 then
    local entity = event.entity
    local dozer_inv = dozer.get_inventory(defines.inventory.car_trunk)
    for _, inventory_id in ipairs(inventories_to_clear) do
      local inventory = entity.get_inventory(inventory_id)
      if inventory and inventory.valid and not inventory.is_empty() then
        for name, count in pairs(inventory.get_contents()) do
          if dozer_inv.can_insert({name = name, count = count}) then
            inventory.remove({name = name, count = dozer_inv.insert({name = name, count = count})})
          end
        end
      end
    end
  end
end
script.on_event(defines.events.on_pre_player_mined_item, on_pre_player_mined_item)
