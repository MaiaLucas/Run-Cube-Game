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

local title

local optGroup
local start
local exit
local credits

local sound

----------------------------------------------------------
----------------------------------------------------------
----------------------------------------------------------

local function backToMenu()   
    composer.gotoScene( "menu", { time=500, effect="crossFade" } )
end

local function soundOff()
    if( on.alpha == 1 ) then
        on.alpha  = 0
        off.alpha = 1

        audio.stop(1)
        audio.stop(2)
        audio.stop(3)

        booleanSound = false
    end
end

local function soundOn()
    if( off.alpha == 1 ) then
        on.alpha  = 1
        off.alpha = 0

        audio.play( menumusic, {channel=1, loops=0} )

        booleanSound = true
    end
end

local function goToCredits()  
    composer.gotoScene( "credits", { time=500, effect="crossFade" } )
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

        ------------------------------
        -------- OPTION GROUP --------
        optGroup = display.newImageRect("images/opt-group.png", 150, 50)
        optGroup.x = X
        optGroup.y = Y-100
        optGroup.alpha = 1
        physics.addBody( optGroup, "static", { isSensor = false } )
        
        -------------------------
        -------- OPTIONS --------

        sound = display.newImageRect("images/sound.png", 100, 30)
        sound.x = X-90
        sound.y = Y-50
        sound.alpha = 1
        physics.addBody( sound, "static", { isSensor = false } )
        sound:toFront()

        on = display.newImageRect("images/on.png", 50, 20)
        on.x = X
        on.y = Y-50
        on.alpha = 1
        physics.addBody( on, "static", { isSensor = false } )
        on:toFront()

        off = display.newImageRect("images/off.png", 50, 20)
        off.x = X
        off.y = Y-50
        off.alpha = 0
        physics.addBody( off, "static", { isSensor = false } )
        off:toFront()

        exit = display.newImageRect("images/back.png", 90, 30)
        exit.x = X
        exit.y = Y+100
        exit.alpha = 1
        physics.addBody( exit, "static", { isSensor = false } )

        credits = display.newImageRect("images/credits.png", 100, 30)
        credits.x = X
        credits.y = Y
        credits.alpha = 1
        physics.addBody( credits, "static", { isSensor = false } )
        credits:toFront()

        ------------------------
        -------- INSERT --------
        sceneGroup:insert(bg3)
        sceneGroup:insert(house)

        sceneGroup:insert(optGroup)
        sceneGroup:insert(exit)
        sceneGroup:insert(sound)
        sceneGroup:insert(credits)
        sceneGroup:insert(on)
        sceneGroup:insert(off)

        sceneGroup:insert(sky)
        sceneGroup:insert(floor)

end

function scene:show( event )
    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then

        exit:addEventListener( "tap", backToMenu )
        credits:addEventListener( "tap", goToCredits )
        
        on:addEventListener( "tap", soundOff )
        off:addEventListener( "tap", soundOn )

        if( booleanSound == false ) then
            on.alpha  = 0
            off.alpha = 1
        elseif( booleanSound == true ) then
            on.alpha  = 1
            off.alpha = 0
        end


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
        exit:removeEventListener( "tap", backToMenu )
        credits:removeEventListener( "tap", goToCredits )
  
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