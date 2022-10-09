pico-8 cartridge // http://www.pico-8.com
version 38
__lua__
-- shmup
-- current episode: 10

function _init()
	blinkt=1

	stars={}
	bullets={}
	
	for i=1,100 do
		add(stars, {
			x=rnd(128),
			y=rnd(128),
			s=rnd(1.5)+0.5,
		})
	end
	
	mode="start"
end

function _update()
	blinkt+=0.2
	if mode=="game" then
		update_game()
	elseif mode=="start" then
		update_start()
	elseif mode=="gameover" then
		update_gameover()
	end
end

function _draw()
	if mode=="game" then
		draw_game()
	elseif mode=="start" then
		draw_start()
	elseif mode=="gameover" then
		draw_gameover()
	end
end

function startgame()
	shipx=62
	shipy=110
	
	shipsx=0
	shipsy=0
	
	shipspr=2
	
	flamespr=5
	
	bulx=-10
	buly=-10

	muzzle=0

	lives=1
	score=30000
	
	mode="game"
end
-->8
--tools
function starfield()
	for i=1,#stars do
		local star=stars[i]
		local col=6
		local dx=0
		
		-- custom change: move stars with ship position
		if shipx~=nil then
			local dx=(64-star.x)/7
		end
		
		if star.s<1 then
			col=1
			dx=dx/1.5
		elseif star.s<1.5 then
			col=13
			dx=dx/2
		end
		
		pset(star.x+dx,star.y,col)
	end
end

function animatestars()
	for i=1,#stars do
		local star=stars[i]
		star.y=star.y+star.s
		if star.y>128 then
			star.y=0
			star.x=rnd(128)
		end
	end
end

function blink()
	local cols={5,6,7,6}
	if blinkt>#cols then
		blinkt=1
	end
	return cols[flr(blinkt)]
end
-->8
--update

function update_start()
	if btnp(🅾️) or btnp(❎) then
		startgame()
	end
	animatestars()
end

function update_gameover()
	if btnp(🅾️) or btnp(❎) then
		startgame()
	end
	animatestars()
end

function update_game()
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
		add(bullets,{
			x=shipx,
			y=shipy-3,
		})
		muzzle=5
		sfx(0)
	end
	
	shipx=shipx+shipsx
	shipy=shipy+shipsy
	
	flamespr=flamespr+1
	if flamespr>8 then
		flamespr=5
	end
	
	for i=1,#bullets do
		local bullet=bullets[i]
		bullet.y-=4
	end
	
	for i=#bullets,1,-1 do
		local bullet=bullets[i]
		if bullet.y<0 then
			del(bullets,bullet)
		end
	end
	
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
	
	animatestars()
end
-->8
--draw

function draw_start()
	cls(0)
	
	starfield()
	
	print("shmup",52,40,12)
	print("press ❎ or 🅾️ to start",18,80,blink())
end

function draw_gameover()
	cls(0)
	
	starfield()
	
	print("game over",45,40,8)
	print("press ❎ or 🅾️ to restart",17,80,blink())
end

function draw_game()
	cls(0)
	
	starfield()
	
	spr(shipspr,shipx,shipy)
	spr(flamespr,shipx,shipy+8)
	
	for i=1,#bullets do
		local bullet=bullets[i]
		spr(16,bullet.x,bullet.y)
	end

	if muzzle>0 then	
		circfill(shipx+4,shipy-1,muzzle,7)
	end

	print("score: "..score,50,1,12)
	
	for i=1,4 do
		if lives>=i then
			spr(13,(i-1)*9,1)
		else
			spr(14,(i-1)*9,1)
		end
	end
end
__gfx__
00000000000220000002200000022000000000000000000000000000000000000000000000000000000000000000000000000000088008800880088000000000
000000000028820000288200002882000000000000077000000770000007700000c77c0000000000000000000000000000000000888888888008800800000000
007007000028820000288200002882000000000000c77c000007700000c77c000cccccc000000000000000000000000000000000888888888000000800000000
0007700000888e2002e88e2002e882000000000000cccc00000cc00000cccc0000cccc0000000000000000000000000000000000888888888000000800000000
00077000027c88202e87c8e202887c2000000000000cc000000cc000000cc0000000000000000000000000000000000000000000088888800800008000000000
007007000211882028811882028811200000000000000000000cc000000000000000000000000000000000000000000000000000008888000080080000000000
00000000025588200285582002885520000000000000000000000000000000000000000000000000000000000000000000000000000880000008800000000000
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
