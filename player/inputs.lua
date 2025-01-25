function _update()
    -- player movements
    if btn(0) then 
        p:move(-1, 0)   -- left
        p.base_spr = 2
        p.dir = 0
        --log("move left")
    end

    if btn(1) then 
        p:move(1, 0)    -- right
        p.base_spr = 0
        p.dir = 1
        --log("move right")
    end

    if btn(2) then 
        p:move(0, -1)   -- up
        p.base_spr = 1
        p.dir = 2
        --log("move up")
    end 

    if btn(3) then 
        p:move(0, 1)    -- down
        p.base_spr = 3
        p.dir = 3
        --log("move down")
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