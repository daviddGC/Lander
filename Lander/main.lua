io.stdout:setvbuf('no')
local music = {}
local sons = {}
local lander = {}
local base = {}
local backgrnd = {}
local j = 1
local i = 0
local over
local gamestate = 1
r=0
g=0
b=0
lander.x = 0
lander.y = 0
lander.angle = 0
lander.vx = 0
lander.vy = 0
lander.speed = 3
lander.lives = 3
lander.touche = false
lander.image = love.graphics.newImage("images/ship.png")
lander.score = 0
lander.info = love.graphics.newImage("images/infos.png")
lander.imgengl = love.graphics.newImage("images/enginesr1.png")
lander.imgengr = love.graphics.newImage("images/enginesl1.png")
lander.imgeng = love.graphics.newImage("images/engines4.png")
lander.explo={}
lander.explo[1] = love.graphics.newImage("images/shipexp1.png")
lander.explo[2] = love.graphics.newImage("images/shipexp2.png")
lander.explo[3] = love.graphics.newImage("images/shipexp3.png")
base.x1 = 470
base.y1 = 515
base.x2 = 130
base.y2 = 410
font = love.graphics.newFont("images/digifit.ttf")
love.graphics.setFont(font)
music.intro = love.audio.newSource("sons/Utopian Impulse.mp3","stream")
music.game = love.audio.newSource("sons/Panoramic Musings.mp3","stream")
sons.engine =love.audio.newSource("sons/engines.wav","static")
sons.explo =love.audio.newSource("sons/Explosion.wav","static")
sons.success = love.audio.newSource("sons/success.wav","static")
base.img = love.graphics.newImage("images/basei.png")
backgrnd.menu = love.graphics.newImage("images/Menu.jpg")
backgrnd.fond = love.graphics.newImage("images/fond.jpg")
backgrnd.lvl1 = love.graphics.newImage("images/lvl1.png")
backgrnd.lvl1i = love.graphics.newImage("images/lvl1i.png")
local image = love.image.newImageData( "images/lvl1.png" )
local pixels = {}

function love.load()
  largeur = love.graphics.getWidth()
  hauteur = love.graphics.getHeight()
  lander.x = largeur/2
  lander.y = hauteur/4
  init()
end

function init()
  lander.fuel = 1000
  lander.score = 0
  lander.lives = 3
  over = false
end

function re_init()
  lander.fuel = 1000
  lander.x = largeur/2
  lander.y = hauteur/4
  lander.touche = false
  lander.angle = 0
  i = 0
end

 function landbase(bx1,by1)
    px = lander.x - lander.image:getWidth()/2
    py = lander.y + lander.image:getHeight()/2
    if py > by1 and py < by1+5 and px > bx1 and px < bx1+50 then
      if math.floor(lander.angle) > -5 and math.floor(lander.angle) < 5 and lander.vy < 1 then 
      
      lander.vx=0
      lander.vy=0
      if lander.fuel < 1000 then
        sons.success:play()
        lander.fuel = lander.fuel + 1
        lander.score = lander.score + 3
      end
      else
      lander.touche = true
      end
    end
  end

function checkangle()
  if lander.angle > 360 then
    lander.angle = lander.angle - 360
  end
  if lander.angle < -360 then
    lander.angle = lander.angle + 360
  end  
end

function game_update(dt)
  music.intro:stop()
  music.game:play()
  lander.vy= lander.vy + (0.6 * dt)  
  landbase(base.x1,base.y1)
  landbase(base.x2,base.y2)
    
  collide()
  if love.keyboard.isDown("space") and over == true then
      over = "false"
      init()
      re_init()
      gamestate = 1
  end
  
  if lander.touche == false and lander.fuel > 0 then
    if love.keyboard.isDown("right") then
      sons.engine:play()
      lander.angle = lander.angle + 90 * dt
      checkangle()
      lander.score = lander.score + 1
      lander.fuel = lander.fuel - 1 
    end
    if love.keyboard.isDown("left") then
      lander.angle = lander.angle - 90 * dt
      checkangle()
      sons.engine:play()
      lander.score = lander.score + 1
      lander.fuel = lander.fuel - 1 
    end
    if love.keyboard.isDown("up") then
      sons.engine:play()
      local angle_rad = math.rad(lander.angle-90)
      local force_x = math.cos(angle_rad) * (lander.speed  * dt)
      local force_y = math.sin(angle_rad) * (lander.speed  * dt)
      lander.vx = lander.vx + force_x
      lander.vy = lander.vy + force_y
      lander.score = lander.score + 1
      lander.fuel = lander.fuel - 1 
    end  
  end
  -- délimitation des déplacements au bord de l'écran
  if lander.x >0+lander.image:getWidth() and lander.x <800 - lander.image:getWidth()   then
    lander.x = lander.x + lander.vx
  elseif lander.x <= 0 + lander.image:getWidth() then
     lander.x = lander.x + 1
     lander.vx = 0
  elseif lander.x >= 800 - lander.image:getWidth() then
     lander.x = lander.x - 1
     lander.vx = 0
  end
  if lander.y > 0+lander.image:getHeight() and lander.y <600-lander.image:getHeight() then
    lander.y = lander.y + lander.vy
  elseif lander.y <= 0 + lander.image:getHeight() then
    lander.y = lander.y + 1
    lander.vy = 0
  elseif lander.y >= 600-lander.image:getHeight() then
     lander.y = lander.y - 1
     lander.vy = 0
  end
end

function menu_update(dt)
  music.game:stop()
  music.intro:play()
  if love.keyboard.isDown("return") then
     gamestate = 2
  end
end

function love.update(dt)
  if gamestate == 1 then
    menu_update(dt)
  end
  if gamestate == 2 then
    game_update(dt)
  end
end

-- collision avec le décor
function collide()
  
  r, g, b, a = image:getPixel( lander.x, lander.y )
  if r == 128 then
    lander.touche = true 
    if i == 0 then
      sons.explo:play()
    end
    i= i + 1
    j = math.ceil(i/10)
    lander.vy = 0
    lander.vx = 0
    if j == 4  and over == false then
      lander.lives = lander.lives - 1
      if lander.lives <= 0 then
        over = true
      else
      re_init()
      end
    end
  else
    lander.touche = false
    b=0
  end
end

function game_draw()
  love.graphics.draw(backgrnd.fond)
  love.graphics.draw(backgrnd.lvl1)
  love.graphics.draw(backgrnd.lvl1i)
  love.graphics.draw(lander.info)
  love.graphics.draw(base.img,base.x1,base.y1,0,3,3)
  love.graphics.draw(base.img,base.x2,base.y2,0,3,3)
  love.graphics.setColor(185,58,255,255)
  love.graphics.print(tostring(lander.score),200,30,0,2,3)
  love.graphics.print(tostring(lander.lives),720,30,0,2,3)
  love.graphics.rectangle("fill",440,48,100*(lander.fuel/1000),20)
  love.graphics.setColor(255,255,255,255)
  if lander.touche == false then
    love.graphics.draw(lander.image, lander.x,lander.y, math.rad(lander.angle),2,2, lander.image:getWidth()/2, lander.image:getHeight()/2)
  
    if love.keyboard.isDown("right") and lander.fuel > 0 then
      love.graphics.draw(lander.imgengr, lander.x,lander.y,math.rad(lander.angle),2,2,lander.imgeng:getWidth()/2, lander.imgeng:getHeight()/3)
    end
    if love.keyboard.isDown("left") and lander.fuel > 0 then
      love.graphics.draw(lander.imgengl, lander.x,lander.y,math.rad(lander.angle),2,2,lander.imgeng:getWidth()/2, lander.imgeng:getHeight()/3)
    end
    if love.keyboard.isDown("up") and lander.fuel > 0 then
      love.graphics.draw(lander.imgeng, lander.x,lander.y,math.rad(lander.angle),2,2,lander.imgeng:getWidth()/2, lander.imgeng:getHeight()/3)
    end
  else
    if j < 4 then
      love.graphics.draw(lander.explo[j], lander.x,lander.y, math.rad(lander.angle),2,2, lander.image:getWidth()/2, lander.image:getHeight()/2) 
    end
   if over == true then
      love.graphics.setColor(185,58,255,255)
      love.graphics.print("GAME OVER",100,300,0,7,7)
      love.graphics.print("press space to continue",150,550,0,2,2)
      love.graphics.setColor(255,255,255,255)
   end
end
end
function menu_draw()
  love.graphics.draw(backgrnd.menu)
  love.graphics.setColor(76,255,0,255)
  love.graphics.print("press return to start",150,500,0,2,2)
  love.graphics.setColor(255,255,255,255)
end

function love.draw()
  if gamestate == 1 then
    menu_draw()
  end
  if gamestate == 2 then
    game_draw() 
  end
end
  

