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

local retangle
local trapeze
local parallelogram

local title
local title1
local start
local tutorial

local btnStart
local opt
----------------------------------------------------------
----------------------------------------------------------
----------------------------------------------------------


local function gotoPressToStart()
    audio.stop(1)
    composer.gotoScene( "game", { time=500, effect="crossFade" } )
end

local function gotoPressToOption()
    composer.gotoScene( "option", { time=500, effect="crossFade" } )
end

local function gotoTutorial()
    composer.gotoScene( "tutorial", { time=500, effect="crossFade" } )
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

        -----------------------
        -------- TITLE --------
        title = display.newImageRect("images/run.png", 150, 40)
        title.x = X
        title.y = Y-80
        title.alpha = 1
        physics.addBody( title, "static", { isSensor = false } )
        --title:toFront()

        title1 = display.newImageRect("images/square-title.png", 350, 70)
        title1.x = X
        title1.y = Y-20
        title1.alpha = 1
        physics.addBody( title1, "static", { isSensor = false } )
        title1:toFront()

        ----------------------------------
        -------- START AND OPTION --------
        tutorial = display.newImageRect("images/tutorial.png", 150, 30)
        tutorial.x = X
        tutorial.y = Y+60
        tutorial.alpha = 1
        physics.addBody( tutorial, "static", { isSensor = false } )
        tutorial:toFront()

        start = display.newImageRect("images/start.png", 150, 30)
        start.x = X
        start.y = Y+100
        start.alpha = 1
        physics.addBody( start, "static", { isSensor = false } )
        start:toFront()

        opt = display.newImageRect("images/option.png", 30, 30)
        opt.x = X+260
        opt.y = Y-135
        opt.alpha = 1
        physics.addBody( opt, "static", { isSensor = false } )
        opt:toFront()

        ------------------------
        -------- INSERT --------
        sceneGroup:insert(bg3)
        sceneGroup:insert(house)

        sceneGroup:insert(title)
        sceneGroup:insert(title1)
        sceneGroup:insert(start)
        sceneGroup:insert(tutorial)
        sceneGroup:insert(opt)

        sceneGroup:insert(sky)
        sceneGroup:insert(floor)

end

function scene:show( event )
    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then

        start:addEventListener( "touch", gotoPressToStart )
        opt:addEventListener( "touch", gotoPressToOption )
        tutorial:addEventListener( "touch", gotoTutorial )

    elseif ( phase == "did" ) then

    end
end

function scene:hide( event )

    local sceneGroup = self.view
    local phase = event.phase
  
    if ( phase == "will" ) then
  
    elseif ( phase == "did" ) then

    end
end

function scene:destroy( event )
  
    local sceneGroup = self.view

end

----------------------------------------------------------
----------------------------------------------------------
----------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene