require "util"

function addPos(p1,p2)
  if not p1.x then
    error("Invalid position", 2)
  end
  local p2 = p2 or {x=0,y=0}
  return {x=p1.x+p2.x, y=p1.y+p2.y}
end

function subPos(p1,p2)
  local p2 = p2 or {x=0,y=0}
  return {x=p1.x-p2.x, y=p1.y-p2.y}
end

local rot = {}
for i=0,7 do
  local rad = i* (math.pi/4)
  rot[i] = {cos=math.cos(rad),sin=math.sin(rad)}
end
local r2d = 180/math.pi

function rotate(pos, deg)
  --local cos = rot[rad].cos
  --local sin = rot[rad].sin
  --local r = {{x=cos,y=-sin},{x=sin,y=cos}}
  local ret = {x=0,y=0}
  local rad = deg/r2d
  ret.x = (pos.x*math.cos(rad)) - (pos.y*math.sin(rad))
  ret.y = (pos.x*math.sin(rad)) + (pos.y*math.cos(rad))
  --ret.x = pos.x * r[1].x + pos.y * r[1].y
  --ret.y = pos.x * r[2].x + pos.y * r[2].y
  return ret
end

function pos2Str(pos)
  if not pos.x or not pos.y then
    pos = {x=0,y=0}
  end
  return util.positiontostr(pos)
end

function fixPos(pos)
  local ret = {}
  if pos.x then ret[1] = pos.x end
  if pos.y then ret[2] = pos.y end
  return ret
end

local RED = {r = 0.9}
local GREEN = {g = 0.7}
local YELLOW = {r = 0.8, g = 0.8}

local blacklisttype = {
    ["rail-remnants"]=true, ["fish"]=true, car=true, locomotive=true, ["cargo-wagon"]=true, unit=true, tree=true,
    ["unit-spawner"]=true, player=true, decorative=true, resource=true, smoke=true, explosion=true,
    corpse=true, particle=true, ["flying-text"]=true, projectile=true, ["particle-source"]=true, turret=true,
    sticker=true, ["logistic-robot"] = true, ["combat-robot"]=true, ["construction-robot"]=true, projectile=true, ["ghost"]=true,
    ["entity-ghost"]=true, ["leaf-particle"]=true
  }
  
  local blacklistname = {
    ["stone-rock"]=true, ["item-on-ground"]=true
  }

BULL = {
  new = function(player)
    local new = {
      vehicle = player.vehicle,
      driver=player, active=false
    }
    new.settings = Settings.loadByPlayer(player)
    setmetatable(new, {__index=BULL})
    return new
  end,

  onPlayerEnter = function(player)
    local i = BULL.findByVehicle(player.vehicle)
    if i then
      global.bull[i].driver = player
      global.bull[i].settings = Settings.loadByPlayer(player)
    else
      table.insert(global.bull, BULL.new(player))
    end
  end,

  onPlayerLeave = function(player)
    for i,f in ipairs(global.bull) do
      if f.driver and f.driver.name == player.name then
        f:deactivate()
        f.driver = false
        f.settings = false
        break
      end
    end
  end,

  findByVehicle = function(bull)
    for i,f in ipairs(global.bull) do
      if f.vehicle == bull then
        return i
      end
    end
    return false
  end,

  findByPlayer = function(player)
    for i,f in ipairs(global.bull) do
      if f.vehicle == player.vehicle then
        f.driver = player
        return f
      end
    end
    return false
  end,
  
  removeTrees = function(self,pos, area)
    if not area then
      area = {{pos.x - 1.5, pos.y - 1.5}, {pos.x + 1.5, pos.y + 1.5}}
    else
      local tl, lr = fixPos(addPos(pos,area[1])), fixPos(addPos(pos,area[2]))
      area = {{tl[1],tl[2]},{lr[1],lr[2]}}
    end
    
    --self:fillWater(area)
    
    for _, entity in ipairs(game.surfaces[1].find_entities_filtered{area = area, type = "tree"}) do
      if self.settings.collect then
        if self:addItemToCargo("raw-wood", 1) then
          entity.die()
        else
          self:deactivate("Error (Storage Full)",true)
        end
      else 
        entity.die()
      end
    end
    if self.settings.collect then
      self:pickupItems(pos, area)
    end
    self:blockprojectiles(pos,area)
    for _, entity in ipairs(game.surfaces[1].find_entities{{area[1][1], area[1][2]}, {area[2][1], area[2][2]}}) do
      if not blacklisttype[entity.type] and not blacklistname[entity.name] then
        if self.settings.collect then
          for i=1,4,1 do
            --game.player.print(i)
            local success, inv = pcall(function(e, i) return e.get_inventory(i) end, entity, i)
            if inv ~= nil and success then
              for k,v in pairs(inv.get_contents()) do
                if self:addItemToCargo(k,v) then
                  self:removeItemFromTarget(entity,k,v,i)
                 else
                  self:deactivate("Error (Storage Full)",true)
                 return
                end
              end
            end
          end
          -- required due to entities having different name than item. similar to stone problem.
          if entity.name == "straight-rail" then
            if self:addItemToCargo("rail", 1) then
              entity.destroy()
              return
            end
          end
          -- have to have this due to curved "recipe"
          if entity.name == "curved-rail" then
            if self:addItemToCargo("rail", 4) then
              entity.destroy()
              return
            end
          end

          if self:addItemToCargo(entity.name, 1) then
            entity.destroy()
          else
            self:deactivate("Error (Storage Full)",true)
          end
        else
          entity.die()
        end
      end
    end
   
    if removeStone then
      for _, entity in ipairs(game.surfaces[1].find_entities_filtered{area = area, name = "stone-rock"}) do
        if self.settings.collect then
          if self:addItemToCargo("stone", 5) then
            entity.die()
          else
            self:deactivate("Error (Storage Full)",true)
          end
        else
          entity.die()
        end
      end
    end
  end,
  
      
  blockprojectiles = function(self,pos, area)
    for _, entity in ipairs(game.surfaces[1].find_entities_filtered{area = area, name="acid-projectile-purple"}) do
      entity.destroy()
    end
  end,

  pickupItems = function(self,pos, area)
    for _, entity in ipairs(game.surfaces[1].find_entities_filtered{area = area, name="item-on-ground"}) do
      if self:addItemToCargo(entity.stack.name, entity.stack.count) then
        entity.destroy()
      else
        self:flyingText("Storage Full", RED, true)
      end
    end
  end,
  
    fillWater = function(self, area)
         -- following code mostly pulled from landfill mod itself and adjusted to fit
        local tiles = {}
        local st, ft = area[1],area[2]
        for x = st[1], ft[1], 1 do
          for y = st[2], ft[2], 1 do
            table.insert(tiles,{name="sand", position={x, y}})
          end
        end
        game.set_tiles(tiles) 
  end,

  activate = function(self)
        self.active = true
  end,

  deactivate = function(self, reason, full)
    self.active = false
    if reason then
      self:print("Deactivated: "..reason)
    end
  end,

  toggleActive = function(self)
    if not self.active then
      self:activate()
      return
    else
      self:deactivate()
    end
  end,

  addItemToCargo = function(self, item, count)
    local count = count or 1
    local entity = self.vehicle
    if remote.interfaces["roadtrain"] then
      itemadded = remote.call("roadtrain","addtocargo",self.vehicle,item,count)
      if itemadded then
        return true
      end
    end
    if entity.get_inventory(2).can_insert({name = item, count = count}) then
      entity.get_inventory(2).insert({name = item, count = count})
      return true
    end
    return false
  end,
  
  removeItemFromTarget = function(self,entity,item,count,inv)
    local count = count or 1
    entity.get_inventory(inv).remove({name = item, count = count})
  end,
  
  print = function(self, msg)
    if self.driver.name ~= "bull_player" then
      self.driver.print(msg)
    else
      self:flyingText(msg, RED, true)
    end
  end,
  
  flyingText = function(self, line, color, show, pos)
    if show then
      local pos = pos or addPos(self.vehicle.position, {x=0,y=-1})
      color = color or RED
      game.surfaces[1].create_entity({name="flying-text", position=pos, text=line, color=color})
    end
  end,
  
  collect = function(self,event)
    if self.driver then
      if self.active then         
        local blade={{x=-2,y=-3},{x=-1,y=-3},{x=0,y=-3},{x=1,y=-3},{x=2,y=-3},{x=-2,y=-2},{x=-1,y=-2},{x=0,y=-2},{x=1,y=-2},{x=2,y=-2}}
        local ori = math.floor(self.vehicle.orientation * 360)        
        pos=self.driver.position
        for _,bs in ipairs(blade) do
          local rbs=rotate(bs,ori)
          area={subPos(rbs,{x=0.5,y=0.5}),addPos(rbs,{x=0.5,y=0.5})}
          --area={{x=-2,y=-3},{x=2,y=-2}}
          self:removeTrees(pos,area)
        end
      end
    end
  end,
  
}
