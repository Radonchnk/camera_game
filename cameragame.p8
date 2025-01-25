pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
-- add includes onyly in
-- pico8 redactor
--	buttons ⬅️➡️⬆️⬇️

#include main.lua
#include player/inputs.lua
#include utils/log.lua
#include utils/collision_engine.lua
#include player/player_class.lua
#include utils/tiling.lua
#include map/wall_class.lua
#include map/level_setup.lua
#include projectile/projectile_class.lua
#include enemy/enemy_class.lua


--#include main.lua
__gfx__
0116d0000500500000d6110006116000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
6d5d555005005000555d5d601d11d100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
11d50000d5005d000005d11015dd5100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
11d500006d55d6000005d1106d55d600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
6d5d555015dd5100555d5d60d5005d00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0116d0001d11d10000d6110005005000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000061160000000000005005000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
20420000000044400044000094400449000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4244444a004220090400420049922994000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0498000004440a092442002049822894000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
04890000498000004984242a022aa220000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
424444904890000048944240022aa220000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2042000004440a092442002049822894000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000004220090400420049922994000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000044400044000094400449000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
44444444000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
44444444000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
44444444000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
44444444000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
44444444000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
44444444000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
44444444000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
44444444000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
88000088000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
80000008000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
80000008000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
88000088000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
