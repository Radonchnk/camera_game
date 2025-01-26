class_item = {}
class_item.__index = class_item -- idfk why i'm doing this

function class_item:new(sprite)
    local obj = setmetatable({}, self)

    obj.sprite_index = 1
    obj.selected = true

    return obj
end

function class_item:draw(x, y)
    if self.selected then
        spr(48, x, y)
    end
    spr(self.sprite_index, x, y)
end

function class_item:select(x, y)

end

function class_item:update()
    -- called once per frame
end