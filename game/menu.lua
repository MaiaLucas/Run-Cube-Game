local composer = require( "composer" )
local scene = composer.newScene()

math.randomseed( os.time() )
----------------------------------------------------------
W = display.contentWidth  
H = display.contentHeight 

X = display.contentCenterX
Y = display.contentCenterY
----------------------------------------------------------

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

        bgAmanhecer.alpha = 1
        bgManha.alpha = 0
        bgMeioDia.alpha = 0
        bgEntardecer.alpha = 0
        bgAnoitecer.alpha = 0
        bgNoite.alpha = 0    

    elseif( hora == 2 ) then -- manhã
        bgAmanhecer.alpha = 0 
        bgManha.alpha = 1
        bgMeioDia.alpha = 0
        bgEntardecer.alpha = 0
        bgAnoitecer.alpha = 0
        bgNoite.alpha = 0 
    elseif( hora == 3 ) then -- meio dia
        bgAmanhecer.alpha = 0
        bgManha.alpha = 0
        bgMeioDia.alpha = 1
        bgEntardecer.alpha = 0
        bgAnoitecer.alpha = 0
        bgNoite.alpha = 0 
    elseif( hora == 4 ) then -- entardecer
        bgAmanhecer.alpha = 0
        bgManha.alpha = 0
        bgMeioDia.alpha = 0
        bgEntardecer.alpha = 1
        bgAnoitecer.alpha = 0
        bgNoite.alpha = 0 
    elseif( hora == 5 ) then -- anoitecer
        bgAmanhecer.alpha = 0
        bgManha.alpha = 0
        bgMeioDia.alpha = 0
        bgEntardecer.alpha = 0
        bgAnoitecer.alpha = 1
        bgNoite.alpha = 0 
    elseif( hora == 6 ) then -- noite
        bgAmanhecer.alpha = 0
        bgManha.alpha = 0
        bgMeioDia.alpha = 0
        bgEntardecer.alpha = 0
        bgAnoitecer.alpha = 0
        bgNoite.alpha = 1

        hora = 0
    end

end

local function createObstacle()
    local whereFrom = math.random( 3 )
    --whereFrom = 1
    if( whereFrom == 1 ) then 
        local retangle = display.newImageRect("images/obstaculo-5.png", 45, 95 )
        physics.addBody( retangle, "dynamic", { isSensor = true } )
        retangle.gravityScale = 0
        retangle.myName = "obstacle"

        retangle.x = W+100
        retangle.y = H-50
        retangle:setLinearVelocity( -100, 0 )

        sceneGroup:insert(retangle)
        obstacleTable[#obstacleTable+1] = retangle

    elseif( whereFrom == 2 ) then
        local trapeze = display.newImageRect( "images/obstaculo-4.png", 60, 40 )
        physics.addBody( trapeze, "dynamic", { isSensor = true } )
        trapeze.gravityScale = 0
        trapeze.myName = "obstacle"

        trapeze.x = W+100
        trapeze.y = H-150
        trapeze:setLinearVelocity( -150, 0 )

        sceneGroup:insert(trapeze)
        obstacleTable[#obstacleTable+1] = trapeze

    elseif( whereFrom == 3 ) then
        -- Parallelogram
        local parallelogram = display.newImageRect( "images/obstaculo-3.png", 50, 80 )
        physics.addBody( parallelogram, "dynamic", { radius = 25, isSensor = true } )
        parallelogram.gravityScale = 0
        parallelogram.myName = "obstacle"

        parallelogram.x = W+100
        parallelogram.y = H-250
        parallelogram:setLinearVelocity( -200, 0 )

        sceneGroup:insert(parallelogram)
        obstacleTable[#obstacleTable+1] = parallelogram

    end
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

local function days()
    ttlDays = ttlDays + 1
    txDays.text = "Day: " .. ttlDays
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
        bgAmanhecer = display.newImageRect("images/background/amanhecer.png", 600, 380)
        bgAmanhecer.x = X
        bgAmanhecer.y = Y
        bgAmanhecer.alpha = 1

        bgManha = display.newImageRect("images/background/manha.png", 600, 380)
        bgManha.x = X
        bgManha.y = Y
        bgManha.alpha = 0

        bgMeioDia = display.newImageRect("images/background/meio-dia.png", 600, 380)
        bgMeioDia.x = X
        bgMeioDia.y = Y
        bgMeioDia.alpha = 0

        bgEntardecer = display.newImageRect("images/background/entardecer.png", 600, 380)
        bgEntardecer.x = X
        bgEntardecer.y = Y
        bgEntardecer.alpha = 0

        bgAnoitecer = display.newImageRect("images/background/anoitecer.png", 600, 380)
        bgAnoitecer.x = X
        bgAnoitecer.y = Y
        bgAnoitecer.alpha = 0

        bgNoite = display.newImageRect("images/background/noite.png", 600, 380)
        bgNoite.x = X
        bgNoite.y = Y
        bgNoite.alpha = 0

        -------------------------------
        -------- SKY AND FLOOR --------
        floor = display.newRect( 130, 299, 1000, 10 )
        floor:setFillColor( 1 )
        floor.alpha = 1
        floor.name = "Floor"
        physics.addBody( floor, "static" )
        
        sky = display.newRect( 130, 1, 1000, 10 )
        sky:setFillColor( 0.7 )
        sky.alpha = 1
        sky.name = "Sky"
        physics.addBody( sky, "static" )

        ------------------------
        -------- INSERT --------
        sceneGroup:insert(bgAmanhecer)
        sceneGroup:insert(bgManha)
        sceneGroup:insert(bgMeioDia)
        sceneGroup:insert(bgEntardecer)
        sceneGroup:insert(bgAnoitecer)
        sceneGroup:insert(bgNoite)

        sceneGroup:insert(sky)
        sceneGroup:insert(floor)

end

function scene:show( event )
    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        
        bgChange = timer.performWithDelay( 1000, changeBackground, -1 )
        gameLoopTimer = timer.performWithDelay( 2500, gameLoop, -1 )
        
        daysCount = timer.performWithDelay( 6000, days, -1 )

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