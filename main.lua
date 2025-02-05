-- to check tokens type: INFO

-- May god help you
--              (c) Artem

screen_size = 128 -- screen is cube 128 by 128, used to delete bullets that are outside screen

player_proj_list = {}
enemy_proj_list = {}

-- perk stuff
perks_used = {}
masochist = 0
reflection = 0
sacrifice = 0

-- boss stuff
boss_fight = false
boss_access = 30
won_game = false

dungeon = {}
snapshot = {{}, {}}
p = {}
main_branch = {}
in_snapshot = false

pickup_queue = {}
temp_objects_queue = {}
dead = false
-- debug toggles

debug_mode = true
collision_box_toggle = false

in_menu = true
music(3)

-- executes on startup
function _init()
    draw_title_screen()
end 

-- draw every frame
function _draw()
    -- main menu
    if in_menu then
        draw_title_screen()
        if btn(4) then
            new_run()
            music(0)
            in_menu = false
        end
        return
    end

    -- death screen
    if dead then
        player_proj_list = {}
        enemy_proj_list = {}

        dungeon = {}
        snapshot = {{}, {}}
        p = {}
        main_branch = {}
        in_snapshot = false

        boss_fight = false
        
        pickup_queue = {}
        temp_objects_queue = {}
        draw_death_screen()
        if btn(4) then
            dead = false
            new_run()
            music(0)
        end
        return
    end

    -- win screen
    if won_game then
        draw_win_screen()
        if btn(4) then
            new_run()
            music(0)
            won_game = false
        end
        return
    end

    -- reset perk values for stacking purposes
    p.max_health_points = 50
    masochist = 0
    reflection = 0
    sacrifice = 0

    -- apply perks
    for i=1,#perks_used do
        if perks_used[i] == "apple" then
            p.max_health_points = 1.5*p.max_health_points
        elseif perks_used[i] == "masochism" then
            masochist += 1
        elseif perks_used[i] == "reflection" then
            reflection += 1
        elseif perks_used[i] == "blood sacrifice" then
            p.max_health_points = 0.5*p.max_health_points
            sacrifice += 1
        end
    end

    
    walls = dungeon[p.current_room_y][p.current_room_x][2]
    enemies = dungeon[p.current_room_y][p.current_room_x][3]
    items = dungeon[p.current_room_y][p.current_room_x][4]

    cls()
    p:draw()

    for i = 1, #walls do
        walls[i]:draw()
    end
    -- render items and add to queue to get picked up if player is on the same tile
    for i = 1, #items do
        items[i]:draw()
        items[i]:update()
        if items[i].type == "explosive" then
            add(temp_objects_queue, items[i])
        else
            if sqrt((p.x-items[i].x)^2 + (p.y-items[i].y)^2) < 6 then
                add(pickup_queue, items[i])
            end
        end
    end
    -- pick up items
    for i = 1, #pickup_queue do
        -- pick up items and remove from screen
        pickup_queue[i]:pickup()
        del(items, pickup_queue[i])
    end

    for i = 1, #temp_objects_queue do
        -- remove exploded bomb after sufficient rendering
        if temp_objects_queue[i].spr == 24 and temp_objects_queue[i].value < -5 then
            del(items, temp_objects_queue[i])
        end
    end
    pickup_queue = {}
    
    paused = false --change when in ui elements

    for i = 1, #player_proj_list do
        if not paused then
            player_proj_list[i]:update()
        end
    
    end

    kill_dead_enemies()
    
    -- delete projectiles before updating them
    for i = 1, #delete_queue do
        del(player_proj_list, delete_queue[1])
        del(enemy_proj_list, delete_queue[1])
        del(delete_queue, delete_queue[1])
    end

    for j = 1, #player_proj_list do
        player_proj_list[j]:draw()
    end


    -- update enemies
    for i = 1, #enemies do
        if not paused and not enemies[i].perk then
            enemies[i]:update()
        end
        if not (enemies[i] == nil) then
            -- enemies could be deleted during update()
            enemies[i]:draw()
            if not enemies[i].perk then
                enemies[i]:draw_hp_bar()
            end
        end
    end

    -- update enemy projectiles
    for j = 1, #enemy_proj_list do
        if not paused then
            enemy_proj_list[j]:update()
        end
        enemy_proj_list[j]:draw()
    end

    p:draw_inventory()
    p:draw_hp_bar()
    draw_ui()
    -- debug shit
    if collision_box_toggle then
        p:draw_collision_box()

        for i = 1, #walls do
            walls[i]:draw_collision_box()
        end

        for i = 1, #enemies do
            enemies[i]:draw_collision_box()
        end

        for i = 1, #player_proj_list do
            player_proj_list[i]:draw_collision_box()
        end
    
        for i = 1, #enemy_proj_list do
            enemy_proj_list[i]:draw_collision_box()
        end

    end
end 