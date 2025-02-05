class_boss = {}
class_boss.__index = class_boss

function class_boss:new(x, y)
    local obj = setmetatable({}, self)

    obj.x = x
    obj.y = y
    obj.spr = 26
    obj.width = 16
    obj.height = 16
    obj.max_health_points = 250
    obj.health_points = 250
    obj.collision_box = class_collision_entity:new(x,y,obj.width,obj.height)
    obj.speed = 1.5
    obj.reload_speed = 1
    obj.reload_value = 1
    obj.follow = true
    return obj
end

function class_boss:draw_collision_box()
    self.collision_box:draw()
end

function class_boss:draw()
    spr(self.spr, self.x, self.y, 2, 2)
end

function class_boss:draw_hp_bar()
    rectfill(self.x+2, self.y-2, self.x+10+2, self.y-2, 5)
    rectfill(self.x+2, self.y-2, self.x+flr(self.health_points/self.max_health_points*10)+2, self.y-2, 8)
end

function class_boss:move(dx, dy)
    self.x += dx * self.speed
    self.y += dy * self.speed
    self.collision_box:offset(dx * self.speed,  dy * self.speed)

    -- check player against walls & enemies 
    collision_walls = collision_to_list(self, walls, 16)
    collision_player = collision_to_list(self, {p}, 16)
    collision_enemies = collision_to_list(self, enemies, 16)

    -- when object collides, size of fuction return is 2 because object is being passed too
    if #collision_walls == 2 or #collision_player == 2 or #collision_enemies == 2 then
        self.x -= dx * self.speed
        self.y -= dy * self.speed
        self.collision_box:offset(-dx * self.speed, -dy * self.speed)

        -- knocks player back and deals damage
        if self.name == "melee" and #collision_player == 2 and self.cooldown_timer == 0 then
            p:take_damage(5)
            if self.dir == 0 then
                p:update(-2, 0)
                self.x += 2
                self.collision_box:offset(2,  0)
            elseif self.dir == 1 then
                p:update(2, 0)
                self.x -= 2
                self.collision_box:offset(-2,  0)
            elseif self.dir == 2 then
                p:update(0, -2)
                self.y += 2
                self.collision_box:offset(0,  2)
            elseif self.dir == 3 then
                p:update(0, 2)
                self.y -= 2
                self.collision_box:offset(0,  -2)
            end
        end
    end
end

function class_boss:rotate(direction)
    if direction == "left" then
        self.dir = 0
    elseif direction == "right" then
        self.dir = 1
    elseif direction == "up" then
        self.dir = 2
    elseif direction == "down" then
        self.dir = 3
    elseif direction == "up left" then
        self.dir = 4
    elseif direction == "up right" then
        self.dir = 5
    elseif direction == "down left" then
        self.dir = 6
    elseif direction == "down right" then
        self.dir = 7
    end
end

function class_boss:shoot()
    log(self.reload_value)
    if self.reload_value == self.reload_speed then
        add(enemy_proj_list, class_projectile:new(self, self.x+8, self.y+8, self.dir, 6, 6, 50))
        self.reload_value = 0
    else
        self.reload_value += 1
    end
end

function class_boss:process_death()
    add(dead_enemies, self, #dead_enemies+1)
    won_game = true
end

function class_boss:take_damage(damage)
    self.health_points -= damage
    if self.health_points < 1 then
        self.health_points = 0
        self:process_death()
    end
end

function class_boss:dash(dx, dy)
    self:move(2*dx, 2*dy)
end

function class_boss:spawn_minion()
    add(enemies, spawn_enemy("melee", tile_to_pixel(13-flr(rnd(12))), tile_to_pixel(13-flr(rnd(12)))), #enemies+1)
end

function class_boss:bombs()
    add(items,class_effect_item:new(tile_to_pixel(13-flr(rnd(12))), tile_to_pixel(13-flr(rnd(12))), "explosive"), #items+1)
    add(items,class_effect_item:new(tile_to_pixel(13-flr(rnd(12))), tile_to_pixel(13-flr(rnd(12))), "explosive"), #items+1)
    add(items,class_effect_item:new(tile_to_pixel(13-flr(rnd(12))), tile_to_pixel(13-flr(rnd(12))), "explosive"), #items+1)
end
function class_boss:follow_player()
    if self.health_points < 100 then
        self.speed = 2
    end

    local rng = flr(rnd(301))
    -- calculate distance to player
    local dx = p.x - self.x
    local dy = p.y - self.y
    local distance = sqrt(dx^2 + dy^2)

    -- move towards the player if the distance is greater than a threshold
    if distance > 8 then
        -- normalize the direction vector and move
        local dir_x = (dx / distance)
        local dir_y = (dy / distance)
        if rng < 5 then
            self:dash(dir_x, dir_y)
        else
            if follow then
                self:move(dir_x, dir_y)
            else
                self:move(-0.25*dir_x, -0.25*dir_y)
            end
        end
    end

    -- rotate towards player
    if abs(dx) > abs(dy) then
        if dx > 8 then
            self:rotate("right")
        elseif dx < -8 then
            self:rotate("left")
        end
    else
        if dy > 8 then
            self:rotate("down")
        elseif dy < -8 then
            self:rotate("up")
        end
    end

    if self.health_points > 50 then
        if rng < 50 then
            follow = not follow
        end
    else
        if rng > 200 then
            follow = true
        else
            follow = false
        end
    end

    if rng < 3 and #items < 3 and self.health_points < 150 then
        self:bombs()
    end

    if rng < 4 and #enemies < 3 then
        self:spawn_minion()
    end

end

function class_boss:update()
    log(self.health_points)
    local rng = flr(rnd(101))
    self:follow_player()
    if rng > 75 then
        self:shoot()
    end
end
