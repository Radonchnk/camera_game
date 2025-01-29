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

-- creates list of rooms in the set 
function generate_dungeon()
    -- 2d array where 1 is a room and 0 is absence of a room
    -- + 2 table one is walls and 2nd is enemies
    return {{{1, {}, {}}, {1, {}, {}}}}
end

-- Function to create a fixed 16x16 level with a user-defined cube of 1s
-- and adds corridor ways to it
function create_room(a, directions, thickness)

    local size = 16

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
function setup_walls(current_level_wall, level_wall_data)
    for y = 1, 16 do
        for x = 1, 16 do
            if level_wall_data[y][x] == 1 then
                add(current_level_wall, class_wall:new(tile_to_pixel(x - 1), tile_to_pixel(y - 1)), #current_level_wall+1)
            end
        end
    end
end

-- just kind of makes emenies
function setup_enemies(current_level_enemies) 
    add(current_level_enemies, class_enemy:new(tile_to_pixel(7), tile_to_pixel(7), 8, 6, "enemie1"), #current_level_enemies+1)
end

function generate_dungeon(num_rooms, grid_size)
    local grid = {}

    -- Initialize empty grid
    for y = 1, grid_size do
        grid[y] = {}
        for x = 1, grid_size do
            grid[y][x] = 0 -- No room
        end
    end

    local directions = {{0, 1}, {1, 0}, {0, -1}, {-1, 0}} -- Down, Right, Up, Left

    -- Start dungeon at (1,1)
    local rooms = {{1, 1}}
    grid[1][1] = {1, {}, {}} -- Room exists at (1,1)

    while #rooms < num_rooms do
        -- Pick a random existing room
        local index = flr(rnd(#rooms)) + 1
        local room = rooms[index]
        local r, c = room[1], room[2]

        -- Try random directions until a valid spot is found
        for _ = 1, 4 do
            local dir = directions[flr(rnd(#directions)) + 1]
            local new_r, new_c = r + dir[1], c + dir[2]

            if new_r > 0 and new_r <= grid_size and new_c > 0 and new_c <= grid_size and grid[new_r][new_c] == 0 then
                grid[new_r][new_c] = {1, {}, {}} -- Place a room
                add(rooms, {new_r, new_c}, #rooms)
                break
            end
        end
    end

    return grid
end

function generate_room_connections(grid)
    local directions = { {0, 1, "e"}, {1, 0, "s"}, {0, -1, "w"}, {-1, 0, "n"} }
    
    for y = 1, #grid do
        for x = 1, #grid[y] do
            if grid[y][x] ~= 0 then
                local connections = ""

                -- Check each direction
                for _, dir in ipairs(directions) do
                    local ny, nx, symbol = y + dir[1], x + dir[2], dir[3]
                    if ny > 0 and ny <= #grid and nx > 0 and nx <= #grid[y] and grid[ny][nx] ~= 0 then
                        connections = connections .. symbol
                    end
                end

                -- Call create_room with detected connections
                local room = create_room(12, connections, 6)
                setup_walls(grid[y][x][2], room)
                setup_enemies(grid[y][x][3])
            end
        end
    end
end