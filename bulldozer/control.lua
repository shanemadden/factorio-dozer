require "Settings"
require "bulldozer"
require "GUI"

remote.add_interface("bulldozer",{})

defaultSettings = {
    collect = true
  }
  
removeStone = true

  function resetMetatable(o, mt)
    setmetatable(o,{__index=mt})
    return o
  end

  local function onTick(event)
    if event.tick % 10 == 0  then
      for pi, player in pairs(game.players) do
        if (player.vehicle ~= nil and player.vehicle.name == "bulldozer") then
          if player.gui.left.bull == nil then
            BULL.onPlayerEnter(player)
            GUI.createGui(player)
          end
        end
        if player.vehicle == nil and player.gui.left.bull ~= nil then
          BULL.onPlayerLeave(player)
          GUI.destroyGui(player)
        end
      end
    end
    for i, bull in ipairs(global.bull) do
	  --if not bull then
		  bull:collect(event)
		  if bull.driver and bull.driver.name ~= "bull_player" then
			GUI.updateGui(bull)
		  end
	  --end
    end
  end
  
  local function onGuiClick(event)
    local index = event.player_index or event.name
    local player = game.players[index]
    if player.gui.left.bull ~= nil then
      local bull = BULL.findByPlayer(player)
      if bull then
        GUI.onGuiClick(event, bull, player)
      else
        player.print("Gui without bulldozer, wrooong!")
        GUI.destroyGui(player)
      end
    end
  end
  
  function on_preplayer_mined_item(event)
    local ent = event.entity
    local cname = ent.name
    if ent.type == "car" and cname == "bulldozer" then
      for i=1,#global.bull do
        if global.bull[i].vehicle == ent then
          global.bull[i].delete = true
        end
      end
    end
  end

  function on_player_mined_item(event)
    if event.item_stack.name == "bulldozer" then
      for i=#global.bull,1,-1 do
        if global.bull[i].delete then
          table.remove(global.bull, i)
        end
      end
    end
  end
  
  local function on_player_created(event)
    local player = game.players[event.player_index]
    local gui = player.gui
    if gui.top.bull ~= nil then
      gui.top.bull.destroy()
    end
  end

  script.on_event(defines.events.on_player_created, on_player_created)
  
  local function initGlob()
    if global.version == nil or global.version < "0.0.1" then
      global = {}
      global.settings = {}
      global.version = "0.0.1"
    end
    if remote.interfaces["roadtrain"] then
      remote.call("roadtrain","settowbar","bulldozer",true)
      remote.call("roadtrain","settowbar","car",false)
    end
    global.players = global.players or {}
    global.bull = global.bull or {}
    -- global.players={}
    
    if global.version < "1.0.4" then
      for pi, player in pairs(game.players) do
        local settings = Settings.loadByPlayer(player)
        settings = resetMetatable(settings,Settings)
        settings:update(util.table.deepcopy(stg))
      end
    end
    for i,bull in ipairs(global.bull) do
      bull = resetMetatable(bull, BULL)
      bull.index = nil
    end
    for name, s in pairs(global.players) do
      s = resetMetatable(s,Settings)
    end
    global.version = "1.0.4"
  end
  
  local function on_init() initGlob() end

  local function on_load()
    initGlob()
  end
  
  local function on_entity_died(event)
    if event.entity.name == "bulldozer" then
      for i=#global.bull,1,-1 do
        if event.entity == global.bull[i].vehicle then
          if global.bull[i].driver then

          	-- removed because gui is automatically removed. this caused errors.
            --local gui = player.gui
            --if gui.top.bull ~= nil then
            --  gui.top.bull.destroy()
            --end
          end
          table.remove(global.bull, i)
        end
      end
    end
  end
  
  script.on_init(on_init)
  script.on_load(on_load)
  script.on_configuration_changed(on_load)
  script.on_event(defines.events.on_tick, onTick)
  script.on_event(defines.events.on_gui_click, onGuiClick)
  script.on_event(defines.events.on_player_mined_item, on_player_mined_item)
  script.on_event(defines.events.on_preplayer_mined_item, on_preplayer_mined_item)
  script.on_event(defines.events.on_built_entity, on_built_entity)
  script.on_event(defines.events.on_entity_died, on_entity_died)