pico-8 cartridge // http://www.pico-8.com
version 38
__lua__
-- shmup
-- current episode: 12

function _init()
	blinkt=1

	stars={}
	
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
	ship={
		x=62,
		y=110,
		sx=0,
		sy=0,
		sprt=2,
	}
	
	flamespr=5

	muzzle=0

	lives=4
	score=30000
	
	bullets={}
	enemies={}
	
	add(enemies,{
		x=60,
		y=60,
		sprt=21
	})
	
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

function drawsprt(sprt)
	spr(sprt.sprt,sprt.x,sprt.y)
end

function col(a,b)
	if 
		(a.x>b.x+7)
		or (a.x+7<b.x)
		or (a.y>b.y+7)
		or (a.y+7<b.y)
	then 
		return false 
	end
	 
	return true
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
	ship.sx=0
	ship.sy=0
	ship.sprt=2
	if btn(⬅️) then
		ship.sx=-2
		ship.sprt=1
	end
	if btn(➡️) then
		ship.sx=2
		ship.sprt=3
	end
	if btn(⬆️) then
		ship.sy=-2
	end
	if btn(⬇️) then
		ship.sy=2
	end
	if btnp(❎) then
		add(bullets,{
			x=ship.x,
			y=ship.y-3,
			sprt=16,
		})
		muzzle=5
		sfx(0)
	end
	
	ship.x+=ship.sx
	ship.y+=ship.sy
	
	flamespr=flamespr+1
	if flamespr>8 then
		flamespr=5
	end
	
	for enemy in all(enemies) do
		enemy.y+=0.1
		enemy.sprt+=0.2
		if enemy.sprt>25 then
			enemy.sprt=21
		end
	end
	
	for enemy in all(enemies) do
		if col(enemy,ship) then
			lives-=1
			sfx(1)
			del(enemies,enemy)
		end
	end
	
	for enemy in all(enemies) do
		for bullet in all(bullets) do
			if col(enemy,bullet) then
				sfx(1)
				del(enemies,enemy)
			end
		end
	end
	
	for bullet in all(bullets) do
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
	
	if ship.x>120 then
		ship.x=120
	end
	if ship.x<0 then
		ship.x=0
	end
	if ship.y>120 then
		ship.y=120
	end
	if ship.y<0 then
		ship.y=0
	end
	
	if lives<=0 then
		mode="gameover"
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
	
	drawsprt(ship)
	spr(flamespr,ship.x,ship.y+8)
	
	for enemy in all(enemies) do
		drawsprt(enemy)
	end
	
	for bullet in all(bullets) do
		drawsprt(bullet)
	end

	if muzzle>0 then	
		circfill(ship.x+4,ship.y-1,muzzle,7)
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
00999900000000000000000000000000000000000330033003300330033003300330033000000000000000000000000000000000000000000000000000000000
09aaaa900000000000000000000000000000000033b33b3333b33b3333b33b3333b33b3300000000000000000000000000000000000000000000000000000000
9aa77aa9000000000000000000000000000000003bbbbbb33bbbbbb33bbbbbb33bbbbbb300000000000000000000000000000000000000000000000000000000
9a7777a9000000000000000000000000000000003b7717b33b7717b33b7717b33b7717b300000000000000000000000000000000000000000000000000000000
9a7777a9000000000000000000000000000000000b7117b00b7117b00b7117b00b7117b000000000000000000000000000000000000000000000000000000000
9aa77aa9000000000000000000000000000000000037730000377300003773000037730000000000000000000000000000000000000000000000000000000000
09aaaa90000000000000000000000000000000000303303003033030030330300303303000000000000000000000000000000000000000000000000000000000
00999900000000000000000000000000000000000300003030000003030000300330033000000000000000000000000000000000000000000000000000000000
__sfx__
00010000300502b050230501e05000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00050000276501f650146501265010650086500165000650116000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
