function _update()
    -- player movements
    if not paused then
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
    
        if btn(5) then -- x
            player:shoot()
        end
    end

    if btn(4) and not already_toggled_inventory then -- o
        already_toggled_inventory = true
        showing_inventory = not showing_inventory
    end
    if not btn(4) then
        already_toggled_inventory = false
    end

    -- debug toggles and shit
    if key == "c" and debug_mode then
        if collision_box_toggle then
            collision_box_toggle = false
            log("Collision borders: OFF")
        else
            collision_box_toggle = true
            log("Collision borders: ON")
        end
    end
end