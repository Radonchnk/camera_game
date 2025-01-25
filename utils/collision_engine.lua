-- define a "class" 
collision_entity = {}
collision_entity.__index = collision_entity

-- constructor for the class
function collision_entity:new(x, y, width, height)
    local obj = setmetatable({}, self)
    -- x and y are at top left of collision box
    obj.x = x
    obj.y = y
    obj.width = width
    obj.height = height
    return obj
end

function collision_entity:offset(dx, dy)
    self.x += dx
    self.y += dy
end

-- draw function to draw corners as red pixels
function collision_entity:draw()
    -- Draw the four corners of the collision box
    spr(0, self.x, self.y, 1, 1)
end

-- get center of collision entity
function collision_entity:get_center()
    x = self.x + self.width/2
    y = self.y + self.height/2
    return {x, y}
end

-- checks if two objects collide
function do_collide(obj1, obj2)
    -- Check if the rectangles intersect (collision)
    if obj1.x < obj2.x + obj2.width and
       obj1.x + obj1.width > obj2.x and
       obj1.y < obj2.y + obj2.height and
       obj1.y + obj1.height > obj2.y then
        return true -- collision detected
    else
        return false -- no collision
    end
end

-- draw function to draw corners as red pixels
function collision_entity:draw()
    -- Draw the four corners of the collision box
    pset(self.x, self.y, 8)               -- top-left corner
    pset(self.x + self.width - 1, self.y, 8)  -- top-right corner
    pset(self.x, self.y + self.height - 1, 8)  -- bottom-left corner
    pset(self.x + self.width - 1, self.y + self.height - 1, 8)  -- bottom-right corner
end

-- get center of collision entity
function collision_entity:get_center()
    x = self.x + self.width/2
    y = self.y + self.height/2
    return {x, y}
end

-- distance between 2 elements
function vec_dist(vector1, vector2)
    return sqrt((vector2[1] - vector1[1])^2 + (vector2[2] - vector1[2])^2)
end

-- discards elements that are not in radius
function get_close_elements(obj1, obj_list, distance)
    close_elements = {}
    for i = 1, #obj_list do
        center_obj1 = obj1.collision_box:get_center()
        center_obj2 = obj_list[i].collision_box:get_center()
        if vec_dist(center_obj1, center_obj2) < distance then
            add(close_elements, obj_list[i], #close_elements+1)
        end
    end
    return close_elements
end
