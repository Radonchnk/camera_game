function _update()
    -- player movements
    if not paused then
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
            -- log("up left")
        elseif movement_directions[1] == 1 and movement_directions[2] == 1 then
            p.base_spr = 4
            p.dir = 5 -- up + right
            -- log("up right")
        elseif movement_directions[0] == 1 and movement_directions[3] == 1then
            p.base_spr = 7
            p.dir = 6 -- down + left
            -- log("down left")
        elseif movement_directions[1] == 1 and movement_directions[3] == 1 then
            p.base_spr = 5
            p.dir = 7 -- down + right
        end
        
        if btn(5) then -- x
            p:shoot()
        end
    end
    
    if btn(4) and not already_toggled_inventory then -- o
        already_toggled_inventory = true
        showing_inventory = not showing_inventory
    end
    
    if not btn(4) then
        already_toggled_inventory = false
    end

    -- debug toggles and shit, DO NOT USE THIS FOR ACTUAL INPUT
    -- do not use arrow keys / Z C N / X V M (these are inputs direction, O and X respectively)
    -- for player 1, SFED / LSHIFT / TAB W Q A (same as above)
    -- (these are reserved for actual input)
    if debug_mode and stat(30) then
        key = stat(31)
        if key == "t" and debug_mode then
            if collision_box_toggle then
                collision_box_toggle = false
                log("Collision borders: OFF")
            else
                collision_box_toggle = true
                log("Collision borders: ON")
            end
        end
    end
end