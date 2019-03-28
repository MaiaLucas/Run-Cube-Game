local composer = require( "composer" )
local scene = composer.newScene()

math.randomseed( os.time() )

-- Set physics
local physics = require("physics")
physics.start()
--physics.setDrawMode("hybrid")

----------------------------------------------------------
W = display.contentWidth  
H = display.contentHeight 

X = display.contentCenterX
Y = display.contentCenterY
----------------------------------------------------------

-- Background day
local bg1 = display.newImageRect("images/background/amanhecer.png", 600, 380)
bg1.x = X
bg1.y = Y
bg1.alpha = 1

local bg2 = display.newImageRect("images/background/manha.png", 600, 380)
bg2.x = X
bg2.y = Y
bg2.alpha = 0

local bg3 = display.newImageRect("images/background/meio-dia.png", 600, 380)
bg3.x = X
bg3.y = Y
bg3.alpha = 0

local bg4 = display.newImageRect("images/background/entardecer.png", 600, 380)
bg4.x = X
bg4.y = Y
bg4.alpha = 0

local bg5 = display.newImageRect("images/background/anoitecer.png", 600, 380)
bg5.x = X
bg5.y = Y
bg5.alpha = 0

local bg6 = display.newImageRect("images/background/noite.png", 600, 380)
bg6.x = X
bg6.y = Y
bg6.alpha = 0

-- Set floor and sky limit
local floor = display.newRect( 130, 305, 1000, 10 )
floor:setFillColor( 1 )
floor.alpha = 0
floor.name = "Floor"
physics.addBody( floor, "static" )

local sky = display.newRect( 130, 1, 1000, 10 )
sky:setFillColor( 0.7 )
sky.alpha = 0
sky.name = "Sky"
physics.addBody( sky, "static", { isSensor = true } )

-- Show the square
local square4 = display.newImageRect("images/square/full-life.png", 30, 30)
square4.x = X-220
square4.y = Y+100
square4.myName = "square"
square4.alpha = 1
square4.isBullet = true
physics.addBody( square4, "dynamic", { bounce = 0, isSensor = false } )

local square3 = display.newImageRect("images/square/3-life.png", 30, 30)
square3.x = X-220
square3.y = Y+100
square3.myName = "square"
square3.alpha = 0
square3.isBullet = true
physics.addBody( square3, "dynamic", { bounce = 0, isSensor = false } )

local square2 = display.newImageRect("images/square/half-life.png", 30, 30)
square2.x = X-220
square2.y = Y+100
square2.myName = "square"
square2.alpha = 0
square2.isBullet = true
physics.addBody( square2, "dynamic", { bounce = 0, isSensor = false } )

local square1 = display.newImageRect("images/square/1-life.png", 30, 30)
square1.x = X-220
square1.y = Y+100
square1.myName = "square"
square1.alpha = 0
square1.isBullet = true
physics.addBody( square1, "dynamic", { bounce = 0, isSensor = false } )

-- SHow the button
local button = display.newImageRect("images/button.png", 70, 70)
button.x = X+200
button.y = Y+100
button.myName = "button"
button.alpha = 0.3
button:toFront()
physics.addBody( button, "static", { radius = 30, bounce = 0, isSensor = true } )

----------------------------------------------------------
----------------------------------------------------------
----------------------------------------------------------
local bgAmanhecer
local bgManha
local bgMeioDia
local bgEntardecer
local bgAnoitecer
local bgNoite
local bgChange

local square4 -- full life
local square3 -- 3/4 life
local square2 -- half life
local square1 -- 1/4 life
--local square

local life = 4

local level = 1
local levelAtual = 1
local velocity = level*0.5
local contador = 0

--local placar
local pontuacao = 0
local text
-- local button

-- local floor
-- local sky

local uiGroup = display.newGroup()
local daysCount
local ttlDays = 1
local txDays = display.newText( "Day: " .. ttlDays, 0, 40, native.systemFont, 20 )
txDays:setFillColor( 0 )

display.setStatusBar( display.HiddenStatusBar )

----------------------------------------------------------
----------------------------------------------------------
----------------------------------------------------------
local function pushSquare()

    square:applyLinearImpulse( 0, -0.05, square.x, square.y )

    square4.x = square.x
    square4.y = square.y

    square3.x = square.x
    square3.y = square.y

    square2.x = square.x
    square2.y = square.y
    
    square1.x = square.x
    square1.y = square.y

    if( life == 4 ) then 
        square4.alpha = 1
        square3.alpha = 0
        square2.alpha = 0
        square1.alpha = 0
    
    elseif( life == 3 ) then
        square4.alpha = 0
        square3.alpha = 1
        square2.alpha = 0
        square1.alpha = 0

    elseif( life == 2 ) then
        square4.alpha = 0
        square3.alpha = 0
        square2.alpha = 1
        square1.alpha = 0

    elseif( life == 1 ) then
        square4.alpha = 0
        square3.alpha = 0
        square2.alpha = 1
        square1.alpha = 0
    end
    
end
button:addEventListener( "tap", pushSquare )
----------------------------------------------------------
local obstacleTable = {}
local pausarObstaculo = false
local hora = 0
----------------------------------------------------------
local function changeBackground()
    hora = hora + 1

    if( hora == 1 ) then

        bg1.alpha = 1
        bg2.alpha = 0
        bg3.alpha = 0
        bg4.alpha = 0
        bg5.alpha = 0
        bg6.alpha = 0    

    elseif( hora == 2 ) then -- manhã
        bg1.alpha = 0
        bg2.alpha = 1
        bg3.alpha = 0
        bg4.alpha = 0
        bg5.alpha = 0
        bg6.alpha = 0
    elseif( hora == 3 ) then -- meio dia
        bg1.alpha = 0
        bg2.alpha = 0
        bg3.alpha = 1
        bg4.alpha = 0
        bg5.alpha = 0
        bg6.alpha = 0
    elseif( hora == 4 ) then -- entardecer
        bg1.alpha = 0
        bg2.alpha = 0
        bg3.alpha = 0
        bg4.alpha = 1
        bg5.alpha = 0
        bg6.alpha = 0
    elseif( hora == 5 ) then -- anoitecer
        bg1.alpha = 0
        bg2.alpha = 0
        bg3.alpha = 0
        bg4.alpha = 0
        bg5.alpha = 1
        bg6.alpha = 0
    elseif( hora == 6 ) then -- noite
        bg1.alpha = 0
        bg2.alpha = 0
        bg3.alpha = 0
        bg4.alpha = 0
        bg5.alpha = 0
        bg6.alpha = 1

        hora = 0
    end

end

local function createObstacle()
    local whereFrom = math.random( 3 )
    --whereFrom = 2

    if( whereFrom == 1 ) then 
        local retangle = display.newImageRect("images/obstaculo-5.png", 45, 95 )
        physics.addBody( retangle, "dynamic", { isSensor = false } )
        retangle.gravityScale = 10
        retangle.myName = "obstacle"

        retangle.x = display.contentWidth+100
        retangle.y = display.contentHeight-50
        retangle:setLinearVelocity( -100*velocity, 0 )

        --sceneGroup:insert(retangle)
        obstacleTable[#obstacleTable+1] = retangle

    elseif( whereFrom == 2 ) then
        local trapeze = display.newImageRect( "images/obstaculo-4.png", 60, 40 )
        physics.addBody( trapeze, "dynamic", { isSensor = true } )
        trapeze.gravityScale = 0
        trapeze.myName = "obstacle"

        trapeze.x = display.contentWidth+100
        trapeze.y = display.contentHeight-150
        trapeze:setLinearVelocity( -150*velocity, 0 )

        --sceneGroup:insert(parallelogram)
        obstacleTable[#obstacleTable+1] = trapeze

    elseif( whereFrom == 3 ) then
        -- Parallelogram
        local parallelogram = display.newImageRect( "images/obstaculo-3.png", 50, 80 )
        physics.addBody( parallelogram, "dynamic", { radius = 25, isSensor = true } )
        parallelogram.gravityScale = 0
        parallelogram.myName = "obstacle"

        parallelogram.x = display.contentWidth+100
        parallelogram.y = display.contentHeight-250
        parallelogram:setLinearVelocity( -200*velocity, 0 )

        --sceneGroup:insert(parallelogram)
        obstacleTable[#obstacleTable+1] = parallelogram

    end
end

local function extraLife()
    local extra = display.newImageRect("images/square/1-life.png", 40, 40 )
    physics.addBody( extra, "dynamic", { bounce = 0, isSensor = true } )
    extra.gravityScale = 0
    extra.myName = "life"
    extra.x = display.contentWidth+100
    extra.y = display.contentHeight-math.random( 50, 200 )
    extra:setLinearVelocity( -150, 0 )

    obstacleTable[#obstacleTable+1] = extra
end

local function startGameLoop()
    print("startGameLoop")
    pausarObstaculo = false
   
end

local function gameLoop()

    if(not pausarObstaculo)then

        createObstacle()
    end
    
    levelAtual = math.floor( contador/16+1 )

    if( level ~= levelAtual ) then 
        
        level = levelAtual
        velocity = level*0.5
        
        timer.cancel(gameLoopTimer)
        delayLevelTimer = timer.performWithDelay(1000, startGameLoop, 1)
        pausarObstaculo = true
        gameLoopTimer = timer.performWithDelay(2500/velocity, gameLoop, 0)
    end

    -- Remove obstacles
    if( #obstacleTable ~= 0 ) then
        for i = #obstacleTable, 1, -1  do
            local thisObstacle = obstacleTable[i]

            if ( thisObstacle.x < -100 or thisObstacle.x > display.contentWidth + 100 )
            then
                display.remove( thisObstacle )
                table.remove( obstacleTable, i )
                print("removeu obstaculo")
            end
        end
    end

end

bgChange = timer.performWithDelay( 1000, changeBackground, -1 )
gameLoopTimer = timer.performWithDelay( 2500/velocity, gameLoop, 0 )

local function onCollision( event )
    
    local obj1 = event.object1
    local obj2 = event.object2

    if ( ( obj1.myName == "square" and obj2.myName == "life" ) or 
         ( obj1.myName == "life" and obj2.myName == "square" ) ) then

        --
        display.remove(obj2)

        for i = #obstacleTable, 1, -1 do
            if ( obstacleTable[i] == obj1 or obstacleTable[i] == obj2 ) then
                table.remove( obstacleTable, i )
                print(#obstacleTable .. "removeu")
                break
            end
        end

    end

    if ( ( obj1.myName == "square" and obj2.myName == "obstacle" ) or 
         ( obj1.myName == "obstacle" and obj2.myName == "square" ) ) then

        display.remove(obj1)
        display.remove(obj2)

        timer.cancel(gameLoopTimer)
        timer.cancel(bgChange)
        timer.cancel(daysCount)
        button:removeEventListener( "tap", pushSquare )

        local txt = display.newText( "GAME OVER", X, 150, native.systemFont, 30 )
    end
end
Runtime:addEventListener( "collision", onCollision )

local function days()
    ttlDays = ttlDays + 1
    txDays.text = "Day: " .. ttlDays
end

daysCount = timer.performWithDelay( 6000, days, -1 )

--                      COMPOSER                        --
----------------------------------------------------------
----------------------------------------------------------
----------------------------------------------------------
--                      COMPOSER                        --


composer.recycleOnSceneChange = true;
function scene:create( event )
    sceneGroup = self.view
end

function scene:show( event )
    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -------- BACKGROUND --------
        bgAmanhecer = display.newImageRect("images/morning.png", 600, 380)
        bgAmanhecer.x = X
        bgAmanhecer.y = Y
        bgAmanhecer.alpha = 1

        -------- SQUARE --------
        square4 = display.newImageRect("images/square/full-life.png", 30, 30)
        square4.x = X-200
        square4.y = Y+100
        square4.isBullet = true
        square4.alpha = 1
        square4.myName = "full"
        physics.addBody( square4, "dynamic", { bounce = 0, isSensor = true } )

        square = display.newImageRect("images/square/full-life.png", 30, 30)
        square.x = X-200
        square.y = Y+100
        square.isBullet = true
        square.alpha = 0.01
        square.myName = "square"
        physics.addBody( square, "dynamic", { bounce = 0, isSensor = true } )

        -------- BUTTON --------
        button = display.newImageRect("images/button.png", 70, 70)
        button.x = X+200
        button.y = Y+100
        button.myName = "button"
        button.alpha = 0.5
        physics.addBody( button, "static", { radius = 30, bounce = 0, isSensor = true } )

        -------- SKY AND FLOOR --------
        floor = display.newRect( 130, 299, 1000, 10 )
        floor:setFillColor( 1 )
        floor.alpha = 0
        floor.name = "Floor"
        physics.addBody( floor, "static" )
        
        sky = display.newRect( 130, 1, 1000, 10 )
        sky:setFillColor( 0.7 )
        sky.alpha = 0
        sky.name = "Sky"
        physics.addBody( sky, "static" )

        -------- SCORES --------

        -------- TIMER --------
        
        -------- INSERT --------
        sceneGroup:insert(bgAmanhecer)

        sceneGroup:insert(square4)

        sceneGroup:insert(button)

        sceneGroup:insert(sky)
        sceneGroup:insert(floor)

    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
        audio.play( musicGame )
    end
end

function scene:hide( event )

    local sceneGroup = self.view
    local phase = event.phase
  
    if ( phase == "will" ) then
      -- Code here runs when the scene is on screen (but is about to go off screen)
     
  
    elseif ( phase == "did" ) then
      -- Code here runs immediately after the scene goes entirely off screen
      
    end
end

function scene:destroy( event )
  
    local sceneGroup = self.view
    -- Code here runs prior to the removal of scene's view
  
end

----------------------------------------------------------
----------------------------------------------------------
----------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene
