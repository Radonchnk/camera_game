-- so... out screen is 128x128
-- and every single tile is 8 by 8
-- therefore we have screen that can have 16 by 16 sprites, which we will tile up
-- hear me out what if we restrict item, mob, object, and player spawn to tiles
-- this file will translate tile index (x, y) to real pixel index

function  tile_to_pixel(tile)
    return tile * 8
end