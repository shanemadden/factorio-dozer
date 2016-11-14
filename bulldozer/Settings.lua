require "util"

Settings = {
  new = function(player)
    local new = {
      collect=true
    }
    setmetatable(new, {__index=Settings})
    return new
  end,

  loadByPlayer = function(player)
    local name = player.name
    if name and name == "" then
      name = "noname"
    end
    local settings = util.table.deepcopy(defaultSettings)
    if not global.players[name] then
      global.players[name] = settings
    end
    -- game.player.print(name)
    global.players[name].player = player
    setmetatable(global.players[name], Settings)
    return global.players[name]
  end,
  
  update = function(self, key, value)
    if type(key) == "table" then
      for k,v in pairs(key) do
        self[k] = v
      end
    else
      self.key = value
    end
  end,
}
