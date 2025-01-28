level = {
    {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
    {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
    {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
    {1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
    {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
    {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
    {1, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 1},
    {1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
    {1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
    {1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
    {1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
    {1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
    {1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
    {1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
    {1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
    {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1}
}

-- list of all walls
walls = {}


-- creates list of rooms in the set 
function generate_dungeon()
    return {{1, 1}}
end

-- Function to create a fixed 16x16 level with a user-defined cube of 1s
-- and adds corridor ways to it
function create_room(a, directions, thickness)

    local size = 16
    if a < 1 or a > size - 2 then
        log("ERROR: Size 'a' must be between 1 and " .. (size - 2) .. ".")
    end

    local level = {}
    local offset = flr((size - a) / 2) -- Center the cube in the grid

    for y = 1, size do
        level[y] = {}
        for x = 1, size do
            if (y >= offset + 1 and y <= offset + a) and (x >= offset + 1 and x <= offset + a) then
                level[y][x] = 0 -- Inner cube of 1s
            else
                level[y][x] = 1 -- Outer cube
            end
        end
    end


    local size = #level -- Assuming the grid is square (NxN)

    -- Check if the thickness is valid
    if thickness < 1 or thickness > size then
        printh("ERROR: Thickness must be between 1 and " .. size .. ".")
        return level
    end

    -- Center point for corridors
    local mid = flr(size / 2)

    -- Helper function to carve a corridor
    local function carve_corridor(start_x, start_y, dx, dy, length)
        for i = 0, length - 1 do
            local x = start_x + dx * i
            local y = start_y + dy * i

            -- Ensure we stay within bounds
            if x < 1 or x > size or y < 1 or y > size then
                break
            end

            -- Carve based on thickness
            for tx = -flr(thickness / 2), flr(thickness / 2) do
                for ty = -flr(thickness / 2), flr(thickness / 2) do
                    local nx = x + tx
                    local ny = y + ty

                    -- Ensure thickness carving is within bounds
                    if nx >= 1 and nx <= size and ny >= 1 and ny <= size then
                        level[ny][nx] = 0
                    end
                end
            end
        end
    end

    -- Maximum length of corridors is half the grid size to prevent overwriting walls
    local max_length = flr(size / 2)

    -- Parse the directions string manually
    for i = 1, #directions do
        local char = sub(directions, i, i) -- Get the current character
        if char == "n" then
            carve_corridor(mid, 1, 0, 1, max_length) -- North corridor
        elseif char == "e" then
            carve_corridor(size, mid, -1, 0, max_length) -- East corridor
        elseif char == "s" then
            carve_corridor(mid, size, 0, -1, max_length) -- South corridor
        elseif char == "w" then
            carve_corridor(1, mid, 1, 0, max_length) -- West corridor
        end
    end

    return level
end



-- placehoder that reads from level 2d table
function setup_walls(level_wall_data)
    for y = 1, 16 do
        for x = 1, 16 do
            if level_wall_data[y][x] == 1 then
                add(walls, class_wall:new(tile_to_pixel(x - 1), tile_to_pixel(y - 1)), #walls+1)
            end
        end
    end
end

enemies = {}

-- just kind of makes emenies
function setup_enemies() 
    add(enemies, class_enemy:new(tile_to_pixel(7), tile_to_pixel(7), 8, 6, "enemie1"), #enemies+1)
end