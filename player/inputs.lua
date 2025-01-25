function _update()
    -- player movements
    local movement_directions = {0,0,0,0}
    if btn(0) then 
        p:move(-1, 0)   -- left
        p.base_spr = 2
        p.dir = 0
        --log("move left")

        movement_directions[0] = 1

    end

    if btn(1) then 
        p:move(1, 0)    -- right
        p.base_spr = 0
        p.dir = 1
        --log("move right")

        movement_directions[1] = 1
    end

    if btn(2) then 
        p:move(0, -1)   -- up
        p.base_spr = 1
        p.dir = 2
        --log("move up")

        movement_directions[2] = 1
    end 

    if btn(3) then 
        p:move(0, 1)    -- down
        p.base_spr = 3
        p.dir = 3
        --log("move down")

        movement_directions[3] = 1
    end

    if movement_directions[0] == 1 and movement_directions[2] == 1then
        p.base_spr = 6 
        p.dir = 4 -- up + left
        log("up left")
    elseif movement_directions[1] == 1 and movement_directions[2] == 1 then
        p.base_spr = 4
        p.dir = 5 -- up + right
        log("up right")
    elseif movement_directions[0] == 1 and movement_directions[3] == 1then
        p.base_spr = 7
        p.dir = 6 -- down + left
        log("down left")
    elseif movement_directions[1] == 1 and movement_directions[3] == 1 then
        p.base_spr = 5
        p.dir = 7 -- down + right
    end

    -- player keyboard inputs
    local key = stat(31)
    if key ~= "" then
        log("Key pressed: " .. key)
    end

    if key == "x" then
        player:shoot()
    end

    -- debug toggles and shit
    if key == "c" and debug_mode == 1 then
        if collision_box_toggle == 1 then
            collision_box_toggle = 0
            log("Collision borders: OFF")
        else
            collision_box_toggle = 1
            log("Collision borders: ON")
        end
    end
end