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
local bg3
local house

local exit
local credits
local developer
local supervisor
local copyright

----------------------------------------------------------
----------------------------------------------------------
----------------------------------------------------------

local function backToMenu()
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
        bg3 = display.newImageRect("images/meio-dia.PNG", 680, 380)
        bg3.x = X
        bg3.y = Y
        bg3.alpha = 1

        house = display.newImageRect("images/house.png", 100, 100)
        house.x = X-200
        house.y = Y+100
        house.alpha = 1

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
    
        -------------------------
        -------- CREDITS --------

        exit = display.newImageRect("images/back.png", 90, 30)
        exit.x = X
        exit.y = Y+100
        exit.alpha = 1
        physics.addBody( exit, "static", { isSensor = false } )

        credits = display.newImageRect("images/credits.png", 150, 30)
        credits.x = X
        credits.y = Y-130
        credits.alpha = 1
        physics.addBody( credits, "static", { isSensor = false } )

        developer = display.newImageRect("images/developer.png", 250, 30)
        developer.x = X
        developer.y = Y-70
        developer.alpha = 1
        physics.addBody( developer, "static", { isSensor = false } )

        supervisor = display.newImageRect("images/supervisor.png", 350, 30)
        supervisor.x = X
        supervisor.y = Y-20
        supervisor.alpha = 1
        physics.addBody( supervisor, "static", { isSensor = false } )

        copyright = display.newImageRect("images/copyright.png", 450, 30)
        copyright.x = X
        copyright.y = Y+30
        copyright.alpha = 1
        physics.addBody( copyright, "static", { isSensor = false } )

        ------------------------
        -------- INSERT --------
        sceneGroup:insert(bg3)
        sceneGroup:insert(house)

        sceneGroup:insert(exit)
        sceneGroup:insert(credits)
        sceneGroup:insert(developer)
        sceneGroup:insert(supervisor)
        sceneGroup:insert(copyright)

        sceneGroup:insert(sky)
        sceneGroup:insert(floor)

end

function scene:show( event )
    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        exit:addEventListener( "tap", backToMenu )

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
        exit:removeEventListener( "tap", backToMenu )
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