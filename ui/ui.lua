function draw_ui()
    -- draw film icon and value
    spr(18, 0, 0, 1, 1)
    print(p.film, 8, 1, 11)

    -- draw snapshot indicator
    if #snapshot[1] > 0 then
        if in_snapshot then
            spr(34, 0, 8, 1, 1) -- loaded snapshot icon
        else
            spr(33, 0, 8, 1, 1) -- unloaded snapshot icon
        end
    end

    -- write snapshot acknowledgement
    if text_timer > 0 then
        print(display_text, 9, 9, 12)
        text_timer -= 1
    end
end

function draw_death_screen()
    cls()
    print("you died", 50, 50, 8)
    print("z - new run", 45, 70, 7)
end