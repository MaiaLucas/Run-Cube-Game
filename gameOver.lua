local composer = require( "composer" )
local scene = composer.newScene()

math.randomseed( os.time() )

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
local back
local gameOver
----------------------------------------------------------
----------------------------------------------------------
----------------------------------------------------------

local function backToMenu()
    -- audio.stop( 2 )
    audio.play( menumusic, {channel=1, loops=-1} )  
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
        bg1 = display.newImageRect("images/game-over.png", 600, 380)
        bg1.x = X
        bg1.y = Y
        bg1.alpha = 1

        ----------------------
        -------- BACK --------

        back = display.newImageRect( "images/back.png", 50, 30 )
        back.x = X
        back.y = Y+120

        gameOver = display.newImageRect( "images/gameOver.png", 300, 150 )
        gameOver.x = X
        gameOver.y = Y-50

        ------------------------
        -------- INSERT --------
        sceneGroup:insert(bg1)
        sceneGroup:insert(back)
        sceneGroup:insert(gameOver)

end

function scene:show( event )
    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        back:addEventListener( "tap", backToMenu )
        audio.stop(1)
        audio.stop(3)
        deathmusic = audio.loadSound( "sound/gameOver.wav" )
        audio.play( deathmusic, {channel=2, loops=-1} )

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
        audio.stop(2)
  
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