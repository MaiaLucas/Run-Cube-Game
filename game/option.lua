local composer = require( "composer" )
local scene = composer.newScene()

math.randomseed( os.time() )
-- Set physics
local physics = require("physics")
physics.start()
----------------------------------------------------------
W = display.contentWidth  
H = display.contentHeight 

X = display.contentCenterX
Y = display.contentCenterY
----------------------------------------------------------

----------------------------------------------------------
----------------------------------------------------------
----------------------------------------------------------
local bg1
local bg2
local bg3
local bg4
local bg5
local bg6
local bgChange

local retangle
local trapeze
local parallelogram

local title

local optGroup
local start
local exit

local sound
local on
local off

local opt

----------------------------------------------------------
----------------------------------------------------------
----------------------------------------------------------

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

    print('menu')
    if( whereFrom == 1 ) then 
        retangle = display.newImageRect("images/obstaculo-5.png", 45, 95 )
        physics.addBody( retangle, "dynamic", { isSensor = true } )
        retangle.gravityScale = 0
        retangle.myName = "obstacle"

        retangle.x = W+100
        retangle.y = H-70
        retangle:setLinearVelocity( -100, 0 )

        sceneGroup:insert(retangle)
        obstacleTable[#obstacleTable+1] = retangle

    elseif( whereFrom == 2 ) then
        trapeze = display.newImageRect( "images/obstaculo-4.png", 60, 40 )
        physics.addBody( trapeze, "dynamic", { isSensor = true } )
        trapeze.gravityScale = 0
        trapeze.myName = "obstacle"

        trapeze.x = W+100
        trapeze.y = H-150
        trapeze:setLinearVelocity( -150, 0 )

        sceneGroup:insert(trapeze)
        obstacleTable[#obstacleTable+1] = trapeze

    elseif( whereFrom == 3 ) then
        parallelogram = display.newImageRect( "images/obstaculo-3.png", 50, 80 )
        physics.addBody( parallelogram, "dynamic", { radius = 25, isSensor = true } )
        parallelogram.gravityScale = 0
        parallelogram.myName = "obstacle"

        parallelogram.x = W+100
        parallelogram.y = H-250
        parallelogram:setLinearVelocity( -200, 0 )

        sceneGroup:insert(parallelogram)
        obstacleTable[#obstacleTable+1] = parallelogram

    end
    exit:toFront()
    optGroup:toFront()
end

local function gameLoop()

    createObstacle()

    -- Remove obstacles
    if( #obstacleTable ~= 0 ) then
        for i = #obstacleTable, 1, -1  do
            local thisObstacle = obstacleTable[i]

            if ( ( thisObstacle.x < -100 ) or ( thisObstacle.x > W + 100 ) )
            then
                display.remove( thisObstacle )
                table.remove( obstacleTable, i )
                print("removeu obstaculo")
            end
        end
    end

end

local function gotoPressToExit()
    -- audio.play(  )
    if( #obstacleTable ~= 0 ) then
        for i = #obstacleTable, 1, -1  do
            
            local thisObstacle = obstacleTable[i]
            display.remove( thisObstacle )
            table.remove( obstacleTable, i )
            print("removeu obstaculo")

        end
    end
    
    composer.gotoScene( "menu", { time=500, effect="crossFade" } )
  
  end

--                      COMPOSER                        --
----------------------------------------------------------
----------------------------------------------------------
----------------------------------------------------------
--                      COMPOSER                        --


composer.recycleOnSceneChange = true;
function scene:create( event )
    sceneGroup = self.view

        ----------------------------
        -------- BACKGROUND --------
        bg1 = display.newImageRect("images/background/amanhecer.png", 600, 380)
        bg1.x = X
        bg1.y = Y
        bg1.alpha = 1

        bg2 = display.newImageRect("images/background/manha.png", 600, 380)
        bg2.x = X
        bg2.y = Y
        bg2.alpha = 0

        bg3 = display.newImageRect("images/background/meio-dia.png", 600, 380)
        bg3.x = X
        bg3.y = Y
        bg3.alpha = 0

        bg4 = display.newImageRect("images/background/entardecer.png", 600, 380)
        bg4.x = X
        bg4.y = Y
        bg4.alpha = 0

        bg5 = display.newImageRect("images/background/anoitecer.png", 600, 380)
        bg5.x = X
        bg5.y = Y
        bg5.alpha = 0

        bg6 = display.newImageRect("images/background/noite.png", 600, 380)
        bg6.x = X
        bg6.y = Y
        bg6.alpha = 0

        -------------------------------
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

        -----------------------
        -------- TITLE --------
        -- title = display.newImageRect("images/opt-group.png", 100, 40)
        -- title.x = X
        -- title.y = Y-80
        -- title.alpha = 1
        -- physics.addBody( title, "static", { isSensor = false } )
        -- title:toFront()

        optGroup = display.newImageRect("images/opt-group.png", 350, 250)
        optGroup.x = X
        optGroup.y = Y
        optGroup.alpha = 1
        physics.addBody( optGroup, "static", { isSensor = false } )
        
        ----------------------------------
        -------- START AND OPTION --------
        -- start = display.newImageRect("images/start.png", 100, 20)
        -- start.x = X
        -- start.y = Y+100
        -- start.alpha = 1
        -- physics.addBody( start, "static", { isSensor = false } )
        -- start:toFront()

        sound = display.newImageRect("images/sound.png", 50, 20)
        sound.x = X-100
        sound.y = Y-50
        sound.alpha = 1
        physics.addBody( sound, "static", { isSensor = false } )
        sound:toFront()

        exit = display.newImageRect("images/exit-x.png", 20, 20)
        exit.x = X+150
        exit.y = Y-100
        exit.alpha = 1
        physics.addBody( exit, "static", { isSensor = false } )

        ------------------------
        -------- INSERT --------
        sceneGroup:insert(bg1)
        sceneGroup:insert(bg2)
        sceneGroup:insert(bg3)
        sceneGroup:insert(bg4)
        sceneGroup:insert(bg5)
        sceneGroup:insert(bg6)

        --sceneGroup:insert(title)
        sceneGroup:insert(optGroup)
        sceneGroup:insert(exit)

        sceneGroup:insert(sky)
        sceneGroup:insert(floor)

end

function scene:show( event )
    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        
        bgChange = timer.performWithDelay( 350, changeBackground, 0 )
        gameLoopTimer = timer.performWithDelay( 2000, gameLoop, 0 )
        exit:addEventListener( "tap", gotoPressToExit )

    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
        --audio.play( musicGame )
    end
end

function scene:hide( event )

    local sceneGroup = self.view
    local phase = event.phase
  
    if ( phase == "will" ) then
      -- Code here runs when the scene is on screen (but is about to go off screen)
        timer.cancel(gameLoopTimer)
        timer.cancel(bgChange)
  
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