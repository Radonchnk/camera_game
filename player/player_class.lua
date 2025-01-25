-- define a "class" (table)
player = {}
player.__index = player

player_proj_list = {}
-- constructor
function player:new(x, y, width, height)
    local obj = setmetatable({}, self)
    obj.x = x
    obj.y = y
    obj.speed = 2
    obj.base_spr = 1
    obj.dir = 1

    obj.width = width or 8
    obj.height = height or 8
    
    obj.colission_box = colission_entity:new(x,y,obj.width,obj.height)

    return obj
end

-- method to move the player
function player:move(dx, dy)

    self.x += dx * self.speed
    self.y += dy * self.speed
    self.colission_box:offset(dx * self.speed,  dy * self.speed)

    -- check player against walls & enemies 
    collision_walls = collision_to_list(self, walls, 16)
    collision_enemies = collision_to_list(self, enemies, 16)

    -- when object collides, size of fuction return is 2 because object is being passed too
    if #collision_walls == 2 or #collision_enemies == 2 then
        self.x -= dx * self.speed
        self.y -= dy * self.speed
        self.colission_box:offset(-dx * self.speed, -dy * self.speed)
    end

end

-- method to draw the player
function player:draw()
    spr(self.base_spr, self.x, self.y, 1, 1)
end

-- transfers collision box draw signal
function player:draw_colission_box()
    self.colission_box:draw()
end

function player:shoot()
    add(player_proj_list, projectile:new(p.x,p.y,p.dir, 6))
end