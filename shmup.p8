pico-8 cartridge // http://www.pico-8.com
version 38
__lua__
-- current episode: 5

function _init()
	shipx=64
	shipy=64
	
	shipsx=0
	shipsy=0
	
	shipspr=2
	
	flamespr=5
	
	bulx=0
	buly=0

	muzzle=0
end

function _draw()
	cls(0)
	spr(shipspr,shipx,shipy)
	spr(flamespr,shipx,shipy+8)
	
	spr(16,bulx,buly)

	if muzzle>0 then	
		circfill(shipx+4,shipy-3,muzzle,7)
	end
end

function _update()
	shipsx=0
	shipsy=0
	shipspr=2
	if btn(⬅️) then
		shipsx=-2
		shipspr=1
	end
	if btn(➡️) then
		shipsx=2
		shipspr=3
	end
	if btn(⬆️) then
		shipsy=-2
	end
	if btn(⬇️) then
		shipsy=2
	end
	if btnp(❎) then
		buly=shipy-3
		bulx=shipx
		muzzle=5
		sfx(0)
	end
	
	shipx=shipx+shipsx
	shipy=shipy+shipsy
	
	flamespr=flamespr+1
	if flamespr>8 then
		flamespr=5
	end
	
	buly=buly-4
	
	if muzzle>0 then
		muzzle=muzzle-2
	end
	
	if shipx>120 then
		shipx=0
	end
	if shipx<0 then
		shipx=120
	end
	if shipy>120 then
		shipy=0
	end
	if shipy<0 then
		shipy=120
	end
end
__gfx__
00000000000220000002200000022000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000028820000288200002882000000000000077000000770000007700000c77c0000000000000000000000000000000000000000000000000000000000
007007000028820000288200002882000000000000c77c000007700000c77c000cccccc000000000000000000000000000000000000000000000000000000000
0007700000888e2002e88e2002e882000000000000cccc00000cc00000cccc0000cccc0000000000000000000000000000000000000000000000000000000000
00077000027c88202e87c8e202887c2000000000000cc000000cc000000cc0000000000000000000000000000000000000000000000000000000000000000000
007007000211882028811882028811200000000000000000000cc000000000000000000000000000000000000000000000000000000000000000000000000000
00000000025588200285582002885520000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000002992000029920000299200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00999900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
09aaaa90000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
9aa77aa9000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
9a7777a9000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
9a7777a9000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
9aa77aa9000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
09aaaa90000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00999900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
00010000300502b050230501e05000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
