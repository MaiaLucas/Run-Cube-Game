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

local lives
local life

local phraseLife
local phraseObstacle
local obstacles

local retangle
local trapeze
local parallelogram

local tutorial
local text
----------------------------------------------------------
----------------------------------------------------------
----------------------------------------------------------
local hora = 0

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

local function backToMenu()
    -- audio.play(  )  
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
        bg1 = display.newImageRect("images/amanhecer.png", 600, 380)
        bg1.x = X
        bg1.y = Y
        bg1.alpha = 1

        bg2 = display.newImageRect("images/manha.png", 600, 380)
        bg2.x = X
        bg2.y = Y
        bg2.alpha = 0

        bg3 = display.newImageRect("images/meio-dia.png", 600, 380)
        bg3.x = X
        bg3.y = Y
        bg3.alpha = 0

        bg4 = display.newImageRect("images/entardecer.png", 600, 380)
        bg4.x = X
        bg4.y = Y
        bg4.alpha = 0

        bg5 = display.newImageRect("images/anoitecer.png", 600, 380)
        bg5.x = X
        bg5.y = Y
        bg5.alpha = 0

        bg6 = display.newImageRect("images/noite.png", 600, 380)
        bg6.x = X
        bg6.y = Y
        bg6.alpha = 0

        --------------------------
        -------- TUTORIAL --------
        tutorial = display.newImageRect("images/tutorial.png", 150, 30)
        tutorial.x = X
        tutorial.y = Y-130
        tutorial.alpha = 1

        phraseLife = display.newImageRect("images/tutorialLives.png", 250, 30)
        phraseLife.x = X-100
        phraseLife.y = Y-50
        phraseLife.alpha = 1

        phraseObstacle = display.newImageRect("images/tutorialObstacle.png", 450, 30)
        phraseObstacle.x = X
        phraseObstacle.y = Y
        phraseObstacle.alpha = 1

        -------------------------
        -------- OBJECTS --------

        lives = display.newImageRect("images/square/sprite-life.png", 150, 30 )
        lives.x = X+170
        lives.y = Y-50
        lives.alpha = 1

        obstacles = display.newImageRect("images/obstacle.png", 150, 30 )
        obstacles.x = X-155
        obstacles.y = Y+50
        obstacles.alpha = 1

        retangle = display.newImageRect("images/obstaculo-5.png", 30, 50 )
        retangle.x = X-50
        retangle.y = Y+50
        retangle.alpha = 1

        trapeze = display.newImageRect( "images/obstaculo-4.png", 40, 30 )
        trapeze.x = X
        trapeze.y = Y+50
        trapeze.alpha = 1

        parallelogram = display.newImageRect( "images/obstaculo-3.png", 40, 50 )
        parallelogram.x = X+50
        parallelogram.y = Y+50

        ----------------------
        -------- BACK --------

        back = display.newImageRect( "images/back.png", 50, 30 )
        back.x = X
        back.y = Y+120

        ------------------------
        -------- INSERT --------
        sceneGroup:insert(bg1)
        sceneGroup:insert(bg2)
        sceneGroup:insert(bg3)
        sceneGroup:insert(bg4)
        sceneGroup:insert(bg5)
        sceneGroup:insert(bg6)

        sceneGroup:insert(tutorial)
        sceneGroup:insert(phraseLife)
        sceneGroup:insert(phraseObstacle)

        sceneGroup:insert(lives)
        sceneGroup:insert(obstacles)

        sceneGroup:insert(retangle)
        sceneGroup:insert(trapeze)
        sceneGroup:insert(parallelogram)

        sceneGroup:insert(back)

end

function scene:show( event )
    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        bgChange = timer.performWithDelay( 350, changeBackground, 0 )
        back:addEventListener( "tap", backToMenu )

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