-- text displayed for short time to acknowledge snapshots being taken and loaded
text_display_time = 15
text_timer = 0
display_text = ""

function _update()
    if in_menu or dead then
        return
    end
    -- player movements
    if not paused then
        local movement_directions = {0,0,0,0}
        if btn(0) then
                p:update(-1, 0)   -- left
                p.base_spr = 2
                p.dir = 0
                --log("move left")
        
            movement_directions[0] = 1

        end

        if btn(1) then 
            p:update(1, 0)    -- right
            p.base_spr = 0
            p.dir = 1
            --log("move right")

            movement_directions[1] = 1
        end

        if btn(2) then 
            p:update(0, -1)   -- up
            p.base_spr = 1
            p.dir = 2
            --log("move up")

            movement_directions[2] = 1
        end 

        if btn(3) then
            p:update(0, 1)    -- down
            p.base_spr = 3
            p.dir = 3
            --log("move down")

            movement_directions[3] = 1
        end

        if btn(4) then
            for i=1,#enemies do
                if enemies[i].perk then
                    enemies[i]:purchase()
                end
            end
        end
        if movement_directions[0] == 1 and movement_directions[2] == 1then
            p.base_spr = 6 
            p.dir = 4 -- up + left
            -- log("up left")
        elseif movement_directions[1] == 1 and movement_directions[2] == 1 then
            p.base_spr = 4
            p.dir = 5 -- up + right
            -- log("up right")
        elseif movement_directions[0] == 1 and movement_directions[3] == 1 then
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

        -- TEMP USAGE OF KETBOARD INPUTS FOR SNAPSHOTS
        key = stat(31)
        if key == "y" then
            if in_snapshot == false then
                if boss_fight == false then
                    text_timer = text_display_time
                    display_text = "snapshot taken"
                    snapshot = take_snapshot()
                    sfx(56)
                else
                    text_timer = text_display_time
                    display_text = "in boss fight"
                end
            else
                text_timer = text_display_time
                display_text = "already in snapshot"
            end
        end
        if key == "u" and #snapshot[1] ~= 0 then
            if in_snapshot == false then
                -- load snapshot
                text_timer = text_display_time
                display_text = "entered snapshot"

                main_branch = take_snapshot()
                load_snapshot(snapshot)
                sfx(63)
                for i = 0, 3 do
                    poke(0x5f09 + i, i + 1) -- Map colors 0–15 to 16–31
                end
                in_snapshot = true
            else
                -- unload snapshot
                text_timer = text_display_time
                display_text = "exited snapshot"

                snapshot = take_snapshot()
                load_snapshot(main_branch)
                pal()
                poke(0x5f2e, 0)
                in_snapshot = false
            end
        end
        

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