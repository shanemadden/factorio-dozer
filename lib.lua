local lib = {}

function lib.expand(area, x, y)
    area.left_top.x = area.left_top.x - x
    area.left_top.y = area.left_top.y - y

    area.right_bottom.x = area.right_bottom.x + x
    area.right_bottom.y = area.right_bottom.y + y
    return area
end

function lib.translate(pos, direction, distance)
    if direction == defines.direction.north then
        pos.x = pos.x
        pos.y = pos.y - distance
    elseif direction == defines.direction.northeast then
        pos.x = pos.x + distance
        pos.y = pos.y - distance
    elseif direction == defines.direction.east then
        pos.x = pos.x + distance
        pos.y = pos.y
    elseif direction == defines.direction.southeast then
        pos.x = pos.x + distance
        pos.y = pos.y + distance
    elseif direction == defines.direction.south then
        pos.x = pos.x
        pos.y = pos.y + distance
    elseif direction == defines.direction.southwest then
        pos.x = pos.x - distance
        pos.y = pos.y + distance
    elseif direction == defines.direction.west then
        pos.x = pos.x - distance
        pos.y = pos.y
    elseif direction == defines.direction.northwest then
        pos.x = pos.x - distance
        pos.y = pos.y - distance
    end
    return pos
end

function lib.orientation_to_8way(o)
    if o >= .9375 or o < .0625 then
        return defines.direction.north
    elseif o >= .0625 and o < .1875 then
        return defines.direction.northeast
    elseif o >= .1875 and o < .3125 then
        return defines.direction.east
    elseif o >= .3125 and o < .4375 then
        return defines.direction.southeast
    elseif o >= .4375 and o < .5625 then
        return defines.direction.south
    elseif o >= .5625 and o < .6875 then
        return defines.direction.southwest
    elseif o >= .6875 and o < .8125 then
        return defines.direction.west
    elseif o >= .8125 and o < .9375 then
        return defines.direction.northwest
    end
end

function lib.adjust_area(area, o)
    local dir = lib.orientation_to_8way(o)
    lib.expand(area, .5, .5)
    lib.translate(area.left_top, dir, 2)
    lib.translate(area.right_bottom, dir, 2)
    return area
end

return lib
