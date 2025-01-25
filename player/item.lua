item = {}
item.__index = item -- idfk why i'm doing this

function item:new(sprite)
    local obj = setmetatable({}, self)

    obj.sprite_index = 1
    obj.selected = true

    return obj
end

function item:draw(x, y)
    if self.selected then
        spr(48, x, y)
    end
    spr(self.sprite_index, x, y)
end

function item:select(x, y)

end

function item:update()
    -- called once per frame
end