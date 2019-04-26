local composer = require( "composer" )

-- Set physics
local physics = require("physics")
physics.start()
--physics.setDrawMode("hybrid")
 
local scene = composer.newScene()

math.randomseed( os.time() )

local meters = 0
local metersText
local metersLoop

local score = 0
local scoreText
local scoreLoop

local cloundScene
local grassScene
local backgroundScene

local velocityLevel = 1
local updateLevel

local life = 4
local cont = 0

local extraPointTable = {}
local obstacleTable = {}
local scenesTable = {}

-- Background day
local background1 = display.newImageRect("images/morning.png", 600, 380)
background1.x = display.contentCenterX
background1.y = display.contentCenterY

-- Meters bar
local uiGroup = display.newGroup()
metersText = display.newText( uiGroup, meters, 0, 20, native.systemFont, 20 )
metersText:setFillColor( 0.2, 0.6, 0.9 )

scoreText = display.newText( uiGroup, score, 0, 40, native.systemFont, 20 )
scoreText:setFillColor( 0 )

display.setStatusBar( display.HiddenStatusBar )

-- Set floor and sky limit
local floor = display.newRect( 130, 299, 1000, 10 )
floor:setFillColor( 1 )
floor.alpha = 0
floor.name = "Floor"
physics.addBody( floor, "static" )

local sky = display.newRect( 130, 1, 1000, 10 )
sky:setFillColor( 0.7 )
sky.alpha = 0
sky.name = "Sky"
physics.addBody( sky, "static" )

-- Show the square
local square = display.newImageRect("images/square/full-life.png", 30, 30)
square.x = display.contentCenterX-200
square.y = display.contentCenterY+100
--square.myName = "square"
physics.addBody( square, "dynamic", { bounce = 0 } )

-- SHow the button
local button = display.newImageRect("images/button.png", 70, 70)
button.x = display.contentCenterX+200
button.y = display.contentCenterY+100
button.myName = "button"
button.alpha = 0.5
button:toFront()
physics.addBody( button, "static", { radius = 30, bounce = 0, isSensor = true } )

--------------- Functions ---------------
local function pushSquare()
    square:applyLinearImpulse( 0, -0.05, square.x, square.y )
end
button:addEventListener( "tap", pushSquare )

---- Background movimentation 
local function cloudMoviment()

    local nuvem = display.newImageRect("images/nuvem.png", 65, 25 )
    physics.addBody( nuvem, "dynamic", { bounce = 0, isSensor = true } )
    nuvem.gravityScale = 0
    nuvem.myName = "nuvem"
    nuvem.x = display.contentWidth+100
    nuvem.y = display.contentHeight-math.random(200, 250)
    nuvem.alpha = 0.9
    nuvem:setLinearVelocity( -100, 0 )

    scenesTable[#scenesTable+1] = nuvem

end

local function grassMoviment()

    local grass = display.newImageRect("images/grass-test.png", 75, 5 )
    physics.addBody( grass, "dynamic", { bounce = 0, isSensor = true } )
    grass.gravityScale = 0
    grass.myName = "nuvem"
    grass.x = display.contentWidth+100
    grass.y = 292
    grass.alpha = 0.9
    grass:setLinearVelocity( -150, 0 )

    scenesTable[#scenesTable+1] = grass

end

local function updateVelocity()
    velocityLevel = velocityLevel + 1
    return velocityLevel
end

---- Create obstacles
local function createObstacles()

    local whereFrom = math.random( 3 )

    if ( whereFrom == 1 ) then
        -- Retangle
        local newObstacle = display.newImageRect("images/obstaculo-1.png", 45, 95 )
        physics.addBody( newObstacle, "dynamic", { isSensor = false } )
        newObstacle.gravityScale = 10
        newObstacle.myName = "obstacle"
        newObstacle.x = display.contentWidth+100
        newObstacle.y = display.contentHeight-50
        newObstacle:setLinearVelocity( -100, 0 )

        obstacleTable[#obstacleTable+1] = newObstacle

    elseif( whereFrom == 2 ) then
        -- Pentagon
        local newObstacle = display.newImageRect( "images/obstaculo-2.png", 40, 40 )
        physics.addBody( newObstacle, "dynamic", { isSensor = true } )
        newObstacle.gravityScale = 0
        newObstacle.myName = "obstacle"
        newObstacle.x = display.contentWidth+100
        newObstacle.y = display.contentHeight-150
        newObstacle:setLinearVelocity( -150, 0 )

        obstacleTable[#obstacleTable+1] = newObstacle

    elseif( whereFrom == 3 ) then
        -- Parallelogram
        local newObstacle = display.newImageRect( "images/obstaculo-3.png", 50, 80 )
        physics.addBody( newObstacle, "dynamic", { radius = 25, isSensor = true } )
        newObstacle.gravityScale = 0
        newObstacle.myName = "obstacle"
        newObstacle.x = display.contentWidth+100
        newObstacle.y = display.contentHeight-250
        newObstacle:setLinearVelocity( -200, 0 )

        obstacleTable[#obstacleTable+1] = newObstacle

    end
 
end

---- Extra Points
local function extraPoint()

    local whereFrom = math.random( 2 )
    whereFrom = 1
    local extra

    if ( whereFrom == 1 ) then
        -- square
        extra = display.newImageRect("images/square/1-life.png", 40, 40 )
        physics.addBody( extra, "dynamic", { bounce = 0, isSensor = true } )
        extra.gravityScale = 0
        extra.myName = "extra"
        extra.x = display.contentWidth+100
        extra.y = display.contentHeight-math.random( 50, 200 )
        extra:setLinearVelocity( -150, 0 )

        extraPointTable[#extraPointTable+1] = extra
    end
    -- elseif( whereFrom == 2 ) then
    --     -- Circle
    --     extra = display.newImageRect( "images/pontos-extras-2.png", 40, 40 )
    --     physics.addBody( extra, "dynamic", { bounce = 0, isSensor = true } )
    --     extra.gravityScale = 0
    --     extra.myName = "extra"
    --     extra.x = display.contentWidth+100
    --     extra.y = display.contentHeight-math.random( 100, 200 )
    --     extra:setLinearVelocity( -100*velocityLevel, -10 )

    --     extraPointTable[#extraPointTable+1] = extra
    -- end

end

---- Game looping
local function updateDistance()
    meters = meters + 1
    metersText.text = meters .. " m"  
end

local function gameLoop()

    createObstacles()

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

    if( #extraPointTable ~= 0 ) then
        for i = #extraPointTable, 1, -1  do
            local thisExtraPoint = extraPointTable[i]

            if ( thisExtraPoint.x < -100 or thisExtraPoint.x > display.contentWidth + 100 )
            then
                display.remove( thisExtraPoint )
                table.remove( extraPointTable, i )
                print("removeu ponto")
            end
        end
    end

    if( #scenesTable ~= 0 ) then
        for i = #scenesTable, 1, -1  do
            local thisScenes = scenesTable[i]

            if ( thisScenes.x < -100 or thisScenes.x > display.contentWidth + 100 )
            then
                display.remove( thisScenes )
                table.remove( scenesTable, i )
                --print("removeu cenário")
            end
        end
    end

    return true
end

--- Looping
updateLevel = timer.performWithDelay( 5000, updateVelocity, -1 )
-- Scenes
grassScene = timer.performWithDelay( 100, grassMoviment, 0 )
cloundScene = timer.performWithDelay( 6000, cloudMoviment, 0 )
-- Game
metersLoop = timer.performWithDelay( 1000, updateDistance, -1 )
scoreLoop = timer.performWithDelay( 25000, extraPoint, 0 )
gameLoopTimer = timer.performWithDelay( 2500, gameLoop, 0 )

local function showLife()

    if( life == 3 ) then
        square = display.newImageRect("images/3-life.png", 30, 30)
        square.x = display.contentCenterX-200
        square.y = display.contentCenterY+100
        square.myName = "square"
        physics.addBody( square, "dynamic", { bounce= 0 } )
    end

end

local function onCollision( event )
 
    local obj1 = event.object1
    local obj2 = event.object2

    if ( ( obj1.myName == "square" and obj2.myName == "extra" ) or 
         ( obj1.myName == "extra" and obj2.myName == "square" ) ) then

        --
        display.remove(obj2)

        for i = #extraPointTable, 1, -1 do
            if ( extraPointTable[i] == obj1 or extraPointTable[i] == obj2 ) then
                table.remove( extraPointTable, i )
                print(#extraPointTable .. "removeu")
                break
            end
        end

        score = score + 1
        scoreText.text = score

    end

    if ( ( obj1.myName == "square" and obj2.myName == "obstacle" ) or 
         ( obj1.myName == "obstacle" and obj2.myName == "square" ) ) then

        life = life - 1

        display.remove(obj1)
        display.remove(obj2)
                    
        --
        timer.cancel(metersLoop)
        timer.cancel(scoreLoop)
        timer.cancel(updateLevel)
        timer.cancel(cloundScene)
        timer.cancel(grassScene)
        timer.cancel(gameLoopTimer)
        --

        local text = display.newText("Distância: " .. meters .. " m", display.contentCenterX, 150, native.systemFont, 25)
        local text2 = display.newText("Scores: " .. score, display.contentCenterX, 100, native.systemFont, 30)
        text2:setFillColor( 0.2, 0.6, 0.9 )
        text:setFillColor( 0 )

    end
    --
end

Runtime:addEventListener( "collision", onCollision )