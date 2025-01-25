-- define a "class" (table)
player = {}
player.__index = player

player_proj_list = {}
-- constructor
function player:new(x, y)
    local obj = setmetatable({}, self)
    obj.size = 8 -- in pixels for w and h
    obj.x = x
    obj.y = y
    obj.speed = 2
    obj.base_spr = 1
    obj.dir = 1

    x = obj.x
    y = obj.y
    obj.width = obj.size
    obj.height = obj.size
    
    obj.colission_box = colission_entity:new(x,y,obj.width,obj.height)

    return obj
end

-- method to move the player
function player:move(dx, dy)

    log(self.x)
    log(self.y)
    

    self.x += dx * self.speed
    self.y += dy * self.speed
    self.colission_box:offset(dx * self.speed,  dy * self.speed)
    radius_walls = get_close_elements(self, walls, 16)

    collision = 0

    for i = 1, #radius_walls do
        if do_collide(self.colission_box, radius_walls[i].colission_box) then
            colission = 1
            log("collision")
        end
    end

    if colission == 1 then
        self.x -= dx * self.speed
        self.y -= dy * self.speed
        self.colission_box:offset(-dx * self.speed, -dy * self.speed)
        colission = 0
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