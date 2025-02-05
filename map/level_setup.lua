-- global variables for boss and shop
boss_room_coords = {}
shop_room_coords = {}

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
function setup_enemies(current_level, types, numbers)
    current_level_enemies = current_level[3]
    if current_level[1] == 1 then 
        local coordinates = {{3,3},{2,3},{3,2},{2,2},{4,3},{3,4},{4,4}}
        for i = 1, #types do
            for j = 1, numbers[i] do
                rand_coords = {13-flr(rnd(12)), 13-flr(rnd(12))}
                local duplicate = false
                for c = 1, #coordinates do
                    if coordinates[c][1] == rand_coords[1] and coordinates[c][2] == rand_coords[2] then
                        duplicate = true
                    end
                end

                while duplicate do
                    rand_coords = {13-flr(rnd(12)), 13-flr(rnd(12))}
                    duplicate = false
                    for c = 1, #coordinates do
                        if coordinates[c][1] == rand_coords[1] and coordinates[c][2] == rand_coords[2] then
                            duplicate = true
                        end
                    end
                end
                add(current_level_enemies, spawn_enemy(types[i], tile_to_pixel(rand_coords[1]), tile_to_pixel(rand_coords[2])), #current_level_enemies+1)
            end
        end
    elseif current_level[1] == 2 then
        -- shop
    elseif current_level[1] == 3 then
        -- bos
    elseif current_level[1] == 4 then
        -- first room
        rand_coords = {13-flr(rnd(12)), 13-flr(rnd(12))}
        add(current_level_enemies, spawn_enemy("turret", tile_to_pixel(rand_coords[1]), tile_to_pixel(rand_coords[2])), #current_level_enemies+1)
        rand_coords = {13-flr(rnd(12)), 13-flr(rnd(12))}
        add(current_level_enemies, spawn_enemy("melee", tile_to_pixel(rand_coords[1]), tile_to_pixel(rand_coords[2])), #current_level_enemies+1)
    end
end

-- Create skeleton of a dungeon with boss and shop rooms
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
    grid[1][1] = {4, {}, {}, {}} -- Room exists at (1,1)

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
                grid[new_r][new_c] = {1, {}, {}, {}} -- Place a room
                add(rooms, {new_r, new_c})
                break
            end
        end
    end

    -- Function to count room exits
    local function count_exits(r, c)
        local exits = 0
        for _, dir in ipairs(directions) do
            local nr, nc = r + dir[1], c + dir[2]
            if nr > 0 and nr <= grid_size and nc > 0 and nc <= grid_size and grid[nr][nc] ~= 0 then
                exits = exits + 1
            end
        end
        return exits
    end

    -- Ensure at least one room has only 1 entrance for the boss room
    local boss_room = nil
    for i = #rooms, 1, -1 do
        local r, c = rooms[i][1], rooms[i][2]
        if r ~= 1 or c ~= 1 then
            if count_exits(r, c) == 1 then
                boss_room = {r, c}
                grid[r][c] = {3, {}, {}, {}} -- Assign boss room
                break
            end
        end
    end

    -- If no suitable boss room found, force one to be a dead-end
    if not boss_room then
        for i = #rooms, 1, -1 do
            local r, c = rooms[i][1], rooms[i][2]
            if r ~= 1 or c ~= 1 then
                -- Remove all but one connection to force a dead-end
                for _, dir in ipairs(directions) do
                    local nr, nc = r + dir[1], c + dir[2]
                    if nr > 0 and nr <= grid_size and nc > 0 and nc <= grid_size and grid[nr][nc] ~= 0 then
                        grid[nr][nc] = 0 -- Remove connection
                        if count_exits(r, c) == 1 then
                            grid[r][c] = {3, {}, {}, {}} -- Assign boss room
                            boss_room = {r, c}
                            break
                        end
                    end
                end
            end
            if boss_room then break end
        end
    end

    -- Place shop room (Index 2) at a random location (excluding (1,1) and boss room)
    local shop_room = nil
    while not shop_room do
        local candidate = rooms[flr(rnd(#rooms - 1)) + 2] -- Avoid picking (1,1)
        if candidate[1] ~= boss_room[1] or candidate[2] ~= boss_room[2] then
            shop_room = candidate
            grid[shop_room[1]][shop_room[2]] = {2, {}, {}, {}} 
        end
    end

    boss_room_coords = boss_room
    shop_room_coords = shop_room

    return grid
end


function generate_room_from_index(grid, y, x)
    local directions = { {0, 1, "e"}, {1, 0, "s"}, {0, -1, "w"}, {-1, 0, "n"} }
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
    if rnd() > 0.9 then
        -- pedestal room (aiko reference??)
    else
        setup_enemies(grid[y][x], {"turret", "melee", "loot pot"}, {1+flr(rnd(3)), 2+flr(rnd(3)), flr(0.7*rnd(2))})
    end
    grid[y][x][4] = {}

end

function take_snapshot()
    local copy = {{}, {}}
    copy[1] = {p.x, p.y, p.current_room_x, p.current_room_y, p.collision_box.x, p.collision_box.y}
    copy[2] = dungeon
    local temp = {} 
    for y = 1, #dungeon do
        local temp_row = {}
        for x = 1, #dungeon[1] do
            if dungeon[y][x] ~= 0 then 
                local temp_walls = {}
                if #dungeon[y][x][2] > 0 then   
                    for k = 1, #dungeon[y][x][2] do
                        add(temp_walls, dungeon[y][x][2][k])
                    end
                end

                local temp_enemies = {}
                if #dungeon[y][x][3] > 0 then   
                    for k = 1, #dungeon[y][x][3] do
                        
                        local enemy_data = dungeon[y][x][3][k]

                        -- enemy x, y, width, height, base_speed, base_spr, reload_speed, burst, accuracy, max_hp, agility, loot_choices, loot_chances, type)
                        local enemy = class_enemy:new(
                            enemy_data.x,
                            enemy_data.y,
                            enemy_data.width or 8,  -- Default width if not specified
                            enemy_data.height or 8, -- Default height if not specified
                            enemy_data.speed,
                            enemy_data.base_spr,
                            enemy_data.reload_speed,
                            enemy_data.per_reload,
                            enemy_data.accuracy,
                            enemy_data.max_health_points,
                            enemy_data.agility,
                            enemy_data.loot,
                            enemy_data.probabilities,
                            enemy_data.name
                        )

                        add(temp_enemies, enemy)
                    end
                end

                local temp_items = {}
                if #dungeon[y][x][4] > 0 then   
                    for k = 1, #dungeon[y][x][4] do
                        add(temp_items, dungeon[y][x][4][k])
                    end
                end

                add(temp_row, {1, temp_walls, temp_enemies, temp_items})
            else
                add(temp_row, 0)
            end
        end
        add(temp, temp_row)
    end
    copy[2] = temp

    return copy
end

function load_snapshot(snap)
    if snap[1] ~= {} then
        p.x = snap[1][1]
        p.y = snap[1][2]
        p.current_room_x = snap[1][3]
        p.current_room_y = snap[1][4]
        p.collision_box.x = snap[1][5]
        p.collision_box.y = snap[1][6]
        dungeon = snap[2]
    end
end

function new_run()
    entry_delay = 45
    dead = false
    log("Game has started")

    if debug_mode then
        -- allow full keyboard input
        -- ONLY IN DEV MODE. BAD BAD BAD DO NOT USE THIS FOR ACTUAL INPUT
        poke(0x5F2D, 1)
    end

    -- initialise player
    p = class_player:new(tile_to_pixel(3), tile_to_pixel(3), 6, 6)

    dungeon = generate_dungeon(16, 6)

    -- Print dungeon grid
    log("dungeon structure: ")
    for y = 1, #dungeon do
        local row = ""
        for x = 1, #dungeon[y] do
            if dungeon[y][x] == 0 then
                row = row .. " 0 "
            else
                row = row .. " 1 "
            end
        end
        log(row)
    end

    generate_room_from_index(dungeon, p.current_room_y, p.current_room_x)

    -- to get room data for dungeon[p.current_room_y][p.current_room_x][2] is going to return walls, [3] going to return enemies, [4] for items
    -- make level and shit
    --local left_room = create_room(12, "e", 6)
    --local right_room = create_room(12, "w", 6)

    --setup_walls(dungeon[p.current_room_y][p.current_room_x][2], left_room)
    --setup_walls(dungeon[p.current_room_y][p.current_room_x+1][2], right_room)

    
    --setup_enemies(dungeon[p.current_room_y][p.current_room_x][3])
    --setup_enemies(dungeon[p.current_room_y][p.current_room_x+1][3])

    walls = dungeon[p.current_room_y][p.current_room_x][2]
    enemies = dungeon[p.current_room_y][p.current_room_x][3]
    items = dungeon[p.current_room_y][p.current_room_x][4]
end