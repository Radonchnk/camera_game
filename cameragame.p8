pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
-- add includes onyly in
-- pico8 redactor
--buttons ⬅️➡️⬆️⬇️

#include main.lua
#include player/inputs.lua
#include utils/utils.lua
#include utils/collision_engine.lua
#include player/item.lua
#include player/player_class.lua
#include utils/tiling.lua
#include map/wall_class.lua
#include map/level_setup.lua
#include projectile/projectile_class.lua
#include enemy/enemy_class.lua
#include enemy/enemy_manager.lua
#include items/item_classes.lua
#include ui/ui.lua
__gfx__
0116d0000500500000d611000611600000016d000111000000d6100000001110204200000a000000000024022400420000004440099009900444000000044000
6d5d555005005000555d5d601d11d1000115d5000dd65d00005d511000d56dd04244444a04009000094444240244200000422009400000049002240000489400
11d50000d5005d000005d11015dd510006dd5000111d65500005dd600556d1110498000004004000000098404489440004440a0940a00a0490a0444004498440
11d500006d55d6000005d1106d55d600611d5505611d55055055d1165055d1160489000004004000000089402498420049800000420000240000098402400420
6d5d555015dd5100555d5d60d5005d00111d655006dd50000556d1110005dd604244449024894200a44444240400400048900000024004200000089442000024
0116d0001d11d10000d61100050050000dd65d000115d50000d56dd0005d51102042000044984400000024020400400004440a090448944090a0444040a00a04
000000000611600000000000050050000111000000016d000000111000d610000000000002442000000000000900400000422009004984009002240040000004
00000000000000000000000000000000000000000000000000000000000000000000000024004200000000000000a00000004440000440000444000009900990
000a0000000000000066600000000000000000000000000000000000000000000090090000000000000000000000000000000000000000000000000000000000
0022420000e00e000665660000080000000800000008000000090000000000000a0900a800000000000000000000000000000000000000000000000000000000
020420200e0000e0656665600080800000808000008090000080000000900000900a050900000000000000000000000000000000000000000000000000000000
0402404000088000666566600555080005550900055500000555000005550000a900a00000000000000000000000000000000000000000000000000000000000
40244204000880006566656056555090565550005655500056555000565550000000009000000000000000000000000000000000000000000000000000000000
404894040e0000e006656600555550005555500055555000555550005555500090a50a0900000000000000000000000000000000000000000000000000000000
0449844000e00e000066600055555000555550005555500055555000555550000800900000000000000000000000000000000000000000000000000000000000
0024420000000000000555550555000005550000055500000555000005550000009a090000000000000000000000000000000000000000000000000000000000
94400449000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
49922994066660000666600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
49822894060000000600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
022aa2200001e0000001c00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
022aa220000e1000000c100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
49822894000000600000006000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
49922994000666600006666000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
94400449000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
88000088000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
8000000800dddd0000d000d00005500000dddd0000ddddd00d0000d0006666000ddddd0000666600000000000000000000000000000000000000000000000000
000000000d0000d00ddd00d00059a5000d0000d00d0000000d0000d0060000600d0dc00006000060000000000000000000000000000000000000000000000000
000000000d0000000d0d00d0050a90500d0000d000dddd000dddddd0060c106000060000060e1060000000000000000000000000000000000000000000000000
0000000000dddd000d00d0d0050110500ddddd00000000d00d0000d00601c060000600000601e060000000000000000000000000000000000000000000000000
00000000000000d00d00ddd0011001100d000000000000d00d0000d006000060000d000006000060000000000000000000000000000000000000000000000000
800000080ddddd000d000d00010000100d0000000ddddd000d0000d0006666000000d60000666600000000000000000000000000000000000000000000000000
88000088000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
011000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
011200000315503105031050315503105001050010500105001050010500105001050010500105031550315303155031050310503155001050010500105001050010500105001050010500105001050010503153
911200000c05300000000000c053000000000000000000000000000000000000000000000000000c0530c0530c05300000000000c05300000000000000000000000000000000000000000000000000000000c033
cf12000001611036110061104611026110461103611046110a6110e61110621126310261100611046110161102611056110661102611006110161106611026110161103611006110561100611026110261105611
0112000003155031050310503155031050010503133031250d7210f03503025001050f03303023031550314303155061350310503155001050813503135031230f72112035030250010514033030230315503143
491200000c05300000000000c05300000000000c033000003061500000000000000000000000000c0530c0530c05300000000000c05300000000000c03300000306150c05300000000000c053000000c03300000
891200001d7201e7211e7201e7221e7221e7221e7211f7212072120720207202072020722207222072220723035140651403504035140050408514035140f0001d7201e7211e7251972019722197201b7211b720
0112000003155031050310503155031050010503133031250d7210f03503025001050f03303023031550314303155061350310503155001050813503135031230f72112035030250010514033030230315503143
491200000c05300000000000c05300000000000c033000003061500000000000000000000000000c0530c05330615246150000030615000003061530610306150c0530c053000000c05330615000000c03300000
411000000c0161001613026170260c0161001613026170260c0161001613026170260c0161001613026170260c0161001613026170260c0161001613026170260c0161001613026170260c016100161302617026
411000001001613016170261a0261001613016170261a0261001613016170261a0261001613016170261a0261001613016170261a0261001613016170261a0261001613016170261a0261001613016170261a026
411000000c0160f01613026160260c0160f01613026160260c0160f01613026160260c0160f01613026160260c0160f01613026160260c0160f01613026160260c0160f01613026160260c0160f0161302616026
4110000013016160161a0261d02613016160161a0261d02613016160161a0261d02613016160161a0261d02613016160161a0261d02613016160161a0261d02613016160161a0261d02613016160161a0261d026
011000000c0730005000050000500c0730005000050000500c0730005000050000500c0730005000050000500c0730005000050000500c0730005000050000500c0730005000050000500c073000500005000050
011000000c0730405004050040500c0730405004050040500c0730405004050040500c0730405004050040500c0730405004050040500c0730405004050040500c0730405004050040500c073040500405004050
011000000c0730705007050070500c0730705007050070500c0730705007050070500c0730705007050070500c0730705007050070500c0730705007050070500c0730705007050070500c073070500705007050
491000000033000320003100031524630246202461500005003320032000310003152463024620246150000500330003200031000315246302462024615000050033000320003100031502330023200231002315
491000000433004320043100431524630246202461500005043300432004310043152463024620246150000504330043200431004315246302462024615000050433004320043100431506330063200631006315
491000000733007320073100731524630246202461500005073300732007310073152463024620246150000507330073200731007315246302462024615000050733007320073100731509330093200931009315
411000000c0161001613026170260c0001000013000170000c0161001613026170260c0161001613026170260c0161001613026170260c0001000013000170000c0161001613026170260c016100161302617026
411000001001613016170261a0261000013000170001a0001001613016170261a0261001613016170261a0261001613016170261a0261000013000170001a0001001613016170261a0261001613016170261a026
411000000c0160f01613026160260c0000f00013000160000c0160f01613026160260c0160f01613026160260c0160f01613026160260c0000f00013000160000c0160f01613026160260c0160f0161302616026
4110000013016160161a0261d02613000160001a0001d00013016160161a0261d02613016160161a0261d02613016160161a0261d02613000160001a0001d00013016160161a0261d02613016160161a0261d026
011000000c0730005000050000500c0730000000000000000c0730005000050000500c0730005000170000500c0730005000050000500c0730000000000000000c0730005000050000500c073000500017000550
011000000c0730405004050040500c0730400004000040000c0730405004050040500c0730405004170040500c0730405004050040500c0730400004000040000c0730405004050040500c073040500417004550
011000000c0730705007050070500c0730700007000070000c0730705007050070500c0730705007170070500c0730705007050070500c0730700007000070000c0730705007050070500c073070500717007550
011700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000031110f1111b111
01170000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000246151e620
0117000003073030000306503562030000306503562080650307303000030650356203000065550b062100650307303000030650356203000030650356208065030730d052080650355204065095550e05213055
011700001b1121b1101b1101b1101b1121b1121b1121b1121b1111a1111b1111a1111b1111a1111b1111a1111b1111a1111b1111b1121b1121b1121b1121b1121b1121b1121b1121b1111c1111d1111e11120111
011700000c0030f053246250f053000000f053246250f0530c0030f053246250f053000000f053246151e6200c0030f053246250f053000000f053246250f053000000f053246250f05324625246250f0531e620
0117000008073030000806508562030000806508562090650807303000080650856203000095550e062075650307303000030650356203000030650356208065030730d052080650355204065095550e05213055
01170000201101f1112011120110201122011220112201122011221115201151b1251612510125151251a1251b1101a1111b1111b1101b1121b1121b1121b1121b1121b1121b1121b1121b1121b1121b1121b112
891200001972119720197201972219722197221672016722167250a715227150a715167152e7150a71522713035000171519715017150f71527715037151b7131472014721147251672016722167201472114720
011200000b15503105031050b15503105001050b1330612512721140350b02500105170330b0230b1550b1430a1550b135031050a155001050e1350a135081231072114035040250010514033040230415504143
491200000c0530c0331b7130c033306151b7130c0531b7130c0530c0331b7130c033306150c033197130c0330c0530c0331b7130c033306151b7130c0531b7130c0530c0331b7130c033306150c033197130c033
8912000014720167211672503520035220352006520065220a2040a11501115031150d1150a1150f11508115035000a11501115031150d1150a115161151411514700147000d7000f7210f7220f7250d7220d722
011200000b1550b105031050b15503105001050b133061250b7210d0350b02500105170330b0230b1550b1430b1550d135031050b155001050f1350b1350b1230f721120350b02500105170330b0230b15507143
491200000c0530c0331b7130c033306151b7130c0531b7130c0530c0331b7130c033306150c033197130c03330615246150000030615000003061530610306150c0530c053000000c05330615000000c03300000
891200000f7220f7220f7220f7220f7120f7120f7120f7150f0040f0040f0040f0040f0040f0040f0040f0040852208525197000b5220b525277000e5220e5131570010500145000f70110711107121071210712
011200000a15503105031050a15503105001050a1330512512721140350b02500105160330a0230a155051430a1550b135031050a155001050e1350a135081231072114035040250010514033040230415504143
c9120000194201b4211b4201e4201e4221e42220420204201b4201b4201b4201b4201a4211a4151b4001b4002142422421224221b4201b4221b4221e4201e4201942019422194201b4211b4221b4201642016422
c9120000194201b2211b4201e4201e2221e42220420202201b4201b2201b4201b4201a4211a4151b4001b4002142422221224221b4201b2221b4221e4201e2201942019222194201b4211b2221b4202242022222
c912000022420232212342022420222222242223420232201e4201e2201e4201e4201e2211e4251e4001e20023424232212342222420222222242223420232201e4201e2221e4202342123222234202542025222
c912000025420262212642022420222222242226420262202642026220264202642025221254251e4001e20029424292212942226420262222642229420292202e4202e2222e4202a4012c2212c4202842028222
c91200002742027420274252e4002e4002e4002e4002e40025400254002540022400224002240025400254003140031400314002e4002e4002e40031400314003240032400324002e4002e4002e4003240032400
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
550300003a6403764036630356203a7303774036741367313673137721377213872138721397313a7313a70138701397013a7013870139701397013a7013c7013c7013d7013770137001370013b0010000100001
ab0900001722017220172301721017220172101721017220172201723017210172301721017220172101721017230172201721017220172101722017210172201722017210172101721017220172101722017230
000b00003f0333f0333f0333f0333f0333f0333f0333f033000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
080a0000330333303333033330333303333033330333303330000300003c000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
090500002a0502c0502e05031050310403103031020310102e0003100033000330003300033000330003300000000000000000033000000000000000000330000000000000000003300000000000000000000000
010600003105033050330403303033020330153600500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010e00000c15300010000130010000100001000010000100001000010000100001000010000100001000010000100001000010000100001000010000100001000010000100001000010000100001000010000100
090300001b5501d5501f55021550235502555027550295502b5502b5502b5502b5502b5402b5302b5202b5102b5002b5002b5002b5002b5002150036500385003a50030500305000050000500005000050000500
__music__
01 10144344
00 11154344
00 12144344
00 13164344
01 10141754
00 11151855
00 12141754
00 13161956
00 1a1e1754
00 1b1f1855
00 1c1e1754
02 1d201956
01 23214344
00 23244350
00 26274322
00 23424025
02 26424325
01 0809340a
00 08094c0a
00 0b0c4c0a
00 0b0c4c0a
00 0e0c4e0a
00 290c4e0a
00 0e0c0d0a
00 0e0c280a
00 0e0c2b0a
00 290f2e0a
00 0e2a5a0a
00 0e2a4e0a
00 0e2a300a
00 0e2a310a
00 2c2a320a
02 2f2d330a
00 40404040
00 40404040
00 40404040

