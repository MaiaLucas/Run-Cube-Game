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

local square
local life

local retangle
local trapeze
local parallelogram

local tutorial
local text
----------------------------------------------------------
----------------------------------------------------------
----------------------------------------------------------

local function createObstacle()
    local whereFrom = math.random( 3 )

    if( whereFrom == 1 ) then 
        
        retangle:setLinearVelocity( -100, 0 )

        sceneGroup:insert(retangle)
        obstacleTable[#obstacleTable+1] = retangle

    elseif( whereFrom == 2 ) then
        
        trapeze:setLinearVelocity( -150, 0 )

        sceneGroup:insert(trapeze)
        obstacleTable[#obstacleTable+1] = trapeze

    elseif( whereFrom == 3 ) then
        
        parallelogram:setLinearVelocity( -200, 0 )

        sceneGroup:insert(parallelogram)
        obstacleTable[#obstacleTable+1] = parallelogram

    end
end

local function goToGame()
    -- audio.play(  )
    if( #obstacleTable ~= 0 ) then
        for i = #obstacleTable, 1, -1  do
            
            local thisObstacle = obstacleTable[i]
            display.remove( thisObstacle )
            table.remove( obstacleTable, i )

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

        ------------------------------
        -------- OPTION GROUP --------
        optGroup = display.newImageRect("images/opt-group.png", 150, 50)
        optGroup.x = X
        optGroup.y = Y-100
        optGroup.alpha = 1
        physics.addBody( optGroup, "static", { isSensor = false } )

        -------------------------
        -------- OBJECTS --------

        square = display.newImageRect("images/square.png", 45, 95 )
        square.x = W+100
        square.y = H-70
        square.alpha = 1
        physics.addBody( square, "dynamic", { isSensor = true } )

        retangle = display.newImageRect("images/obstaculo-5.png", 45, 95 )
        retangle.x = W+100
        retangle.y = H-70
        retangle.alpha = 1
        physics.addBody( retangle, "dynamic", { isSensor = true } )

        trapeze = display.newImageRect( "images/obstaculo-4.png", 60, 40 )
        trapeze.x = W+100
        trapeze.y = H-150
        trapeze.alpha = 1
        physics.addBody( trapeze, "dynamic", { isSensor = true } )

        parallelogram = display.newImageRect( "images/obstaculo-3.png", 50, 80 )
        parallelogram.x = W+100
        parallelogram.y = H-250
        physics.addBody( parallelogram, "dynamic", { radius = 25, isSensor = true } )

        ----------------------
        -------- TEXT --------

        ------------------------
        -------- INSERT --------
        sceneGroup:insert(bg1)

end

function scene:show( event )
    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then

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