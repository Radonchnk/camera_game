-- define a "class" (table) for each item
class_effect_item = {}
class_effect_item.__index = class_effect_item
-- these are lists, i promise

-- constructor
function class_effect_item:new(x, y, type)
    local obj = setmetatable({}, self)

    obj.x = x
    obj.y = y
    obj.type = type -- what item it is (healing, explosive)
    
    if type == "health" then
        obj.spr = 17
        obj.value = 7
    elseif type == "explosive" then
        obj.spr = 19
        obj.value = 5
    elseif type == "film" then
        obj.spr = 18
        obj.value = 1

    end

    return obj
end

function class_effect_item:pickup()
    if self.type == "health" then
        p.health_points += self.value
        if p.health_points > p.max_health_points then
            p.health_points = p.max_health_points
        end
    elseif self.type == "film" then
        p.film += 1
    end
end

function class_effect_item:update()
    if self.type == "explosive" then
        if self.value == 0 then
            if self.spr == 23 then
                -- explosion
                self.spr = 24
                self.value = -1

                if sqrt((p.x-self.x)^2 + (p.y-self.y)^2) < 24 then
                    p:take_damage(20)
                end

                for i = 1, #enemies do
                    if sqrt((enemies[i].x-self.x)^2 + (enemies[i].y-self.y)^2) < 24 then
                        enemies[i]:take_damage(20)
                    end
                end
            else
                self.spr += 1
                self.value = 5
            end
        else
            self.value -= 1
        end
    end
end

function class_effect_item:draw()
    spr(self.spr, self.x, self.y, 1, 1)
end