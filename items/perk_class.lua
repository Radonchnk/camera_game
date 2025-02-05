-- define a "class" (table) for each item
class_perk_item = {}
class_perk_item.__index = class_perk_item
-- these are lists, i promise

-- constructor
function class_perk_item:new(x, y, name)
    local obj = setmetatable({}, self)
    log(name)
    obj.x = x
    obj.y = y
    obj.name = name -- what perk it is
    obj.perk = true

    if name == "apple" then
        local value = 3
        obj.spr = 35
        obj.description = "+50% max hp"
        obj.cost = value
        obj.base_cost = value

    elseif name == "masochism" then
        local value = 7
        obj.spr = 36
        obj.description = "getting hit has a 5% chance to generate camera film"
        obj.cost = value
        obj.base_cost = value

    elseif name == "reflection" then
        local value = 5
        obj.spr = 37
        obj.description = "light has a 25% chance to bounce off a surface"
        obj.cost = value
        obj.base_cost = value

    elseif name == "blood sacrifice" then
        local value = 2
        obj.spr = 38
        obj.description = "lose half of max hp, all film costs are halved"
        obj.cost = value
        obj.base_cost = value
    end

    return obj
end

function class_perk_item:draw()
    self.cost = self.base_cost*(0.5^sacrifice)
    spr(self.spr, self.x, self.y, 1, 1)
    if sqrt((p.x-self.x)^2 + (p.y-self.y)^2) < 4 then
        text_timer = text_display_time
        display_text = self.name .. " -- cost: " .. self.cost
    end
end

function class_perk_item:purchase()
    sfx(61)
    if p.film >= self.cost and sqrt((p.x-self.x)^2 + (p.y-self.y)^2) < 4 then
        p.film -= self.cost
        add(perks_used, self.name, #perks_used+1)
        add(dead_enemies, self, #dead_enemies+1)
    end
end