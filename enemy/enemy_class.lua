-- define a "class" (table)
enemy = {}
enemy.__index = enemy

enemy_proj_list = {}
-- constructor
function enemy:new(x, y, width, height)
    local obj = setmetatable({}, self)
    obj.x = x
    obj.y = y
    obj.speed = 2
    obj.base_spr = 1
    obj.dir = 1

    obj.width = width or 8
    obj.height = height or 8
    
    obj.collision_box = collision_entity:new(x,y,obj.width,obj.height)

    return obj
end

-- method to move the enemy
function enemy:move(dx, dy)

    self.x += dx * self.speed
    self.y += dy * self.speed
    self.collision_box:offset(dx * self.speed,  dy * self.speed)
    radius_walls = get_close_elements(self, walls, 16)

    collision = 0

    for i = 1, #radius_walls do
        if do_collide(self.collision_box, radius_walls[i].collision_box) then
            collision = 1
        end
        collision = 0
    end

    if collision == 1 then
        self.x -= dx * self.speed
        self.y -= dy * self.speed
        self.collision_box:offset(-dx * self.speed, -dy * self.speed)
        collision = 0
    end

end


-- enemy ai and shit
function enemy:update()
    -- stupid baka
end

-- method to draw the enemy
function enemy:draw()
    spr(16, self.x, self.y, 1, 1)
end

-- transfers collision box draw signal
function enemy:draw_collision_box()
    self.collision_box:draw()
end

function enemy:shoot()
    add(enemy_proj_list, projectile:new(p.x,p.y,p.dir, 6))
end