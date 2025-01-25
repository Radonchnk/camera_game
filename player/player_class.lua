-- define a "class" (table)
player = {}
player.__index = player
log(player)

-- constructor
function player:new(x, y)
    local obj = setmetatable({}, self)
    obj.x = x or 0
    obj.y = y or 0
    obj.speed = 2
    return obj
end

-- method to move the player
function player:move(dx, dy)
    self.x += dx * self.speed
    self.y += dy * self.speed
end

-- method to draw the player
function player:draw()
    circfill(self.x, self.y, 4, 7)
end