Observer = {
  onNotify = function(self, entity, event)

  end
}

GUI = {

   styleprefix = "bull_",

    defaultStyles = {
      label = "label",
      button = "button",
      checkbox = "checkbox"
    },

    bindings = {},

    callbacks = {},

    new = function(index, player)
      local new = {}
      setmetatable(new, {__index=GUI})
      return new
    end,

    onNotify = function(self, entity, event)

    end,

    add = function(parent, e, bind)
      local type, name = e.type, e.name
      if not e.style and GUI.defaultStyles[type] then
        e.style = GUI.styleprefix..type
      end
      if bind then
        if e.type == "checkbox" then
          e.state = Settings.loadByPlayer(parent.gui.player)[e.name]
        end
      end
      local ret = parent.add(e)
      if bind and e.type == "textfield" then
        ret.text = bind
      end
      return ret
    end,

    addButton = function(parent, e, bind)
      e.type = "button"
      if bind then
        GUI.callbacks[e.name] = bind
      end
      return GUI.add(parent, e, bind)
    end,
    
    createGui = function(player)
      if player.gui.left.bull ~= nil then return end
      local bull = GUI.add(player.gui.left, {type="frame", direction="vertical", name="bull"})
      local rows = GUI.add(bull, {type="table", name="rows", colspan=1})
      local buttons = GUI.add(rows, {type="table", name="buttons", colspan=3})
      GUI.addButton(buttons, {name="start"}, GUI.toggleStart)
      
      GUI.add(rows,{type="checkbox", name="collect",caption={"stg-collect"}},"collect")
      
    end,

    destroyGui = function(player)
      if player.gui.left.bull == nil then return end
      player.gui.left.bull.destroy()
    end,

    onGuiClick = function(event, bull, player)
      local name = event.element.name
      local psettings = Settings.loadByPlayer(player)
      if GUI.callbacks[name] then
        return GUI.callbacks[name](event, bull, player)
      end
      if name == "collect" then
        psettings[name] = not psettings[name]
      end
    end,

    toggleStart = function(event, bull, player)
      bull:toggleActive()
    end,
    
    updateGui = function(bull)
      if bull.driver.name ~= "bull_player" then
        bull.driver.gui.left.bull.rows.buttons.start.caption = bull.active and {"text-stop"} or {"text-start"}  
      end
    end,
}
