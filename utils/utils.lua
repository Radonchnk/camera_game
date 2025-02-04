function log(message, file)
    -- Write the message to a file called "log.txt" in the carts directory
    -- to follow: tail -f log.txt
    if file == nil then
        file = "log.txt"
    end
    printh(message, file)
end