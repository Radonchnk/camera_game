-- define a "class" (table)
enemie = {}
enemie.__index = enemie

enemie_proj_list = {}
-- constructor
function enemie:new(x, y, width, height)
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
        collision = 0
    end

end


-- enemie ai and shit
function enemie:update()
    -- stupid baka
end

-- method to draw the enemie
function enemie:draw()
    spr(17, self.x, self.y, 1, 1)
end

-- transfers collision box draw signal
function enemie:draw_collision_box()
    self.collision_box:draw()
end

function enemie:shoot()
    add(enemie_proj_list, projectile:new(p.x,p.y,p.dir, 6))
end