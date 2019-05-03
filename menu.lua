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

local function gotoPressToStart()
    -- audio.play(  )
    if( #obstacleTable ~= 0 ) then
        for i = #obstacleTable, 1, -1  do
            
            local thisObstacle = obstacleTable[i]
            display.remove( thisObstacle )
            table.remove( obstacleTable, i )

        end
    end
    audio.stop(1)
    composer.gotoScene( "game", { time=500, effect="crossFade" } )
  
end

local function gotoPressToOption()
    -- audio.play(  )
    if( #obstacleTable ~= 0 ) then
        for i = #obstacleTable, 1, -1  do
            
            local thisObstacle = obstacleTable[i]
            display.remove( thisObstacle )
            table.remove( obstacleTable, i )

        end
    end
    composer.gotoScene( "option", { time=500, effect="crossFade" } )

end

local function gotoTutorial()
    -- audio.play(  )
    if( #obstacleTable ~= 0 ) then
        for i = #obstacleTable, 1, -1  do
            
            local thisObstacle = obstacleTable[i]
            display.remove( thisObstacle )
            table.remove( obstacleTable, i )

        end
    end
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
        bg1 = display.newImageRect("images/amanhecer.png", 640, 320)
        bg1.x = X
        bg1.y = Y
        bg1.alpha = 1

        bg2 = display.newImageRect("images/manha.png", 640, 320)
        bg2.x = X
        bg2.y = Y
        bg2.alpha = 0   

        bg3 = display.newImageRect("images/meio-dia.png", 640, 320)
        bg3.x = X
        bg3.y = Y
        bg3.alpha = 0

        bg4 = display.newImageRect("images/entardecer.png", 640, 320)
        bg4.x = X
        bg4.y = Y
        bg4.alpha = 0

        bg5 = display.newImageRect("images/anoitecer.png", 640, 320)
        bg5.x = X
        bg5.y = Y
        bg5.alpha = 0

        bg6 = display.newImageRect("images/noite.png", 640, 320)
        bg6.x = X
        bg6.y = Y
        bg6.alpha = 0

        house = display.newImageRect("images/house.png", 100, 100)
        house.x = X-200
        house.y = Y+70
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
        sceneGroup:insert(bg1)
        sceneGroup:insert(bg2)
        sceneGroup:insert(bg3)
        sceneGroup:insert(bg4)
        sceneGroup:insert(bg5)
        sceneGroup:insert(bg6)
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
        
        bgChange = timer.performWithDelay( 1000, changeBackground, -1 )
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
        timer.cancel(bgChange)
  
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