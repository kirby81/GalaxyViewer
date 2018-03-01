-- dofile("galaxy.lua")
-- title:  The galaxy
-- author: Etienne Ellie
-- desc:   The solar system's planets
-- script: lua

NB_POINTS = 1500
ROTATION_STEP = .6
RADIUS = 50
EARTH = {
	NAME = "Planet: Earth",
	DIAM = "Diameter: 12.756 Km",
	COLOR = {4, 5, 13}
}
MARS = {
	NAME = "Planet: Mars",
	DIAM = "Diameter: 6.792 Km",
	COLOR = {4, 6, 9}
}
MOON = {
	NAME = "Satellite: Moon",
	DIAM = "Diameter: 3.474 Km",
	COLOR = {3, 7, 10}
}
GALAXY = {EARTH, MARS, MOON}
desc_drawer = {
	STEP = 0.5,
	name = 1,
	diam = 1,
	t = 0
}

-- Round a number
function round(num, dec)
	local mult = 10 ^ (dec or 0)
	return math.floor(num * mult + 0.5) / mult
end

-- Get angle into radian
function rad(angle)
	return round(math.rad(angle), 2)
end

-- Get cos
function cos(number)
	return round(math.cos(number), 2)
end

-- Get sin
function sin(number)
	return round(math.sin(number), 2)
end

-- Get a random latitude (theta)
function getRandomLatitude()
	local theta = rad(math.random(-90,90))
	return theta
end

-- Get a random longitude (phi)
function getRandomLongitude()
	local phi = rad(math.random(-180,180))
	return phi
end

-- Get a random sphere point
-- return the parameterize point
function getRandomPointOnSphere(radius)
	local theta = getRandomLatitude()
	local phi = getRandomLongitude()
	local xx = radius * cos(theta) * cos(phi)
	local yy = radius * cos(theta) * sin(phi)
	local zz = radius * sin(theta)
	return {x=xx, y=yy, z=zz}
end

-- Rotate the planet
function rotatePlanet(angle)
	local cos_theta = cos(rad(angle))
	local sin_theta = sin(rad(angle))
	for i=0, NB_POINTS do
		planet[i].x = round(cos_theta * planet[i].x - sin_theta * planet[i].z, 2)
		planet[i].z = round(sin_theta * planet[i].x + cos_theta * planet[i].z, 2)
	end
end

-- Draw the planet
function drawPlanet()
	for i=0, NB_POINTS do
		if draw_invisible == false then
			if planet[i].z >= 0 then
				pix(planet[i].x + 60, planet[i].y + 68, planet[i].color)
			end
  else
			pix(planet[i].x + 60, planet[i].y + 68, planet[i].color)
		end
	end			
end  

-- Change display planet
function changePlanet(incr)
	current_planet = (current_planet + incr) % (#GALAXY + 1)
	if current_planet == 0 then
		if incr < 0 then
			current_planet = #GALAXY
		else
			current_planet = 1
		end
	end
	planet = initPlanet()
end

-- Init a planet
function initPlanet()
	local planet = {}
	local palette = GALAXY[current_planet].COLOR
	for i=0, NB_POINTS do
		planet[i] = getRandomPointOnSphere(50)
		planet[i].color = palette[math.random(1, #palette)]
 end
	desc_drawer.name = 0
	desc_drawer.diam = 0
	return planet
end

-- Draw planet description
function drawDescription()
	local name = GALAXY[current_planet].NAME
	local diam = GALAXY[current_planet].DIAM
		
	print(name:sub(1,desc_drawer.name),130,25,15)
	print(diam:sub(1,desc_drawer.diam),130,35,15)

	if desc_drawer.t % 1 == 0 then
		if desc_drawer.name < #name+1 then
			desc_drawer.name = desc_drawer.name + 1
		end
		if desc_drawer.diam < #diam+1 and desc_drawer.name >= #name+1 then
			desc_drawer.diam = desc_drawer.diam + 1
		end
	end
	desc_drawer.t = desc_drawer.t + desc_drawer.STEP
end

-- Game init
function init()
	current_planet = 1
	draw_invisible = false
	planet = initPlanet()
end

-- Game draw
function draw()
	cls(0)
	drawPlanet()
	drawDescription()
end

-- Game inputs
function inputs()
	if btnp(3) then
	 changePlanet(1)
 elseif btnp(2) then
	 changePlanet(-1)
	elseif btnp(4) then
		draw_invisible = not draw_invisible
	end
end

-- Game loop
function TIC()
	inputs()
	rotatePlanet(ROTATION_STEP)
	draw(true)
end

init()

-- <WAVES>
-- 000:00000000ffffffff00000000ffffffff
-- 001:0123456789abcdeffedcba9876543210
-- 002:0123456789abcdef0123456789abcdef
-- </WAVES>

-- <SFX>
-- 000:070007000700070007000700070007000700070007000700070007000700070007000700070007000700070007000700070007000700070007000700400000000000
-- 001:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000005000000000
-- 003:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000005000000000
-- </SFX>

-- <TRACKS>
-- 000:0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002903df
-- </TRACKS>

-- <PALETTE>
-- 000:140c1c44243430346d4e4a4e854c30346524d04648757161597dced27d2c8595a16daa2cd2aa996dc2cadad45edeeed6
-- </PALETTE>

