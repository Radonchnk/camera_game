-- define a "class" (table)
enemie = {}
enemie.__index = enemie

enemie_proj_list = {}
-- constructor
function enemie:new(x, y, width, height)
    local obj = setmetatable({}, self)
    obj.x = x
    obj.y = y
    obj.speed = 1
    obj.base_spr = 1
    obj.dir = 1

    -- can shoot every 10 sframes
    self.reload_speed = 10
    self.reload_value = 0

    obj.width = width or 8
    obj.height = height or 8
    
    obj.collision_box = collision_entity:new(x,y,obj.width,obj.height)

    return obj
end

-- method to move the enemie
function enemie:move(dx, dy)

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
        ision = 0
    end

end


-- enemie ai and actions
function enemie:update()
    -- calculate distance to player
    local dx = p.x - self.x
    local dy = p.y - self.y
    local distance = sqrt(dx^2 + dy^2)

    -- move towards the player if the distance is greater than a threshold
    if distance > 32 then
        -- normalize the direction vector and move
        local dir_x = dx / distance
        local dir_y = dy / distance
        self:move(dir_x, dir_y)
    end

    -- shoot at the player if close enough
    if distance <= 64 then
        self:shoot()
    end
end

-- method to draw the enemie
function enemie:draw()
    spr(16, self.x, self.y, 1, 1)
end

-- transfers collision box draw signal
function enemie:draw_collision_box()
    self.collision_box:draw()
end

function enemie:shoot()
    if self.reload_value == 0 then
        add(enemie_proj_list, projectile:new(self.x,self.y,self.dir, 6, 6))
        self.reload_value = self.reload_speed
    else
        self.reload_value -= 1
    end
end