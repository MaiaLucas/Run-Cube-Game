local composer = require( "composer" )

-- Set physics
local physics = require("physics")
physics.start()
--physics.setDrawMode("hybrid")
 
local scene = composer.newScene()

local meters = 0
local metersText
local metersLoop

local score = 0
local scoreText
local scoreLoop

local level = 1
local velocityLevel = level*0.5
local updateLevel

local extraPointTable = {}
local obstacleTable = {}

math.randomseed( os.time() )
-- Show Background Level 1
local background = display.newImageRect("images/background-day.jpg", 600, 380)
background.x = display.contentCenterX
background.y = display.contentCenterY

-- Meters bar
local uiGroup = display.newGroup()
metersText = display.newText( uiGroup, meters, 0, 20, native.systemFont, 20 )
metersText:setFillColor( 0.2, 0.6, 0.9 )

scoreText = display.newText( uiGroup, score, 0, 40, native.systemFont, 20 )
scoreText:setFillColor( 0 )

display.setStatusBar( display.HiddenStatusBar )

-- Set floor and sky limit
local floor = display.newRect( 130, 290, 1000, 10 )
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
local square = display.newImageRect("images/quadrado.png", 30, 30)
square.x = display.contentCenterX-200
square.y = display.contentCenterY+100
--square.myName = "square"
physics.addBody( square, "dynamic", { bounce=-0.1 } )

--------------- Functions ---------------

local function pushSquare()
    square:applyLinearImpulse( 0, -0.05, square.x, square.y )
end

background:addEventListener( "tap", pushSquare )

local function updateVelocity()
    level = level + 1 
end
velocityLevel = level*0.5

updateLevel = timer.performWithDelay( 100000, updateVelocity, -1 )

---- Create obstacles
local function createObstacles()

    local whereFrom = math.random( 3 )

    if ( whereFrom == 1 ) then
        -- Retangle
        local newObstacle = display.newImageRect("images/obstaculo-1.png", 45, 95 )
        physics.addBody( newObstacle, "dynamic", { bounce = 0, isSensor = false } )
        newObstacle.gravityScale = 10
        newObstacle.myName = "obstacle"
        newObstacle.x = display.contentWidth+100
        newObstacle.y = display.contentHeight-50
        newObstacle:setLinearVelocity( -300*velocityLevel, 0 )

        obstacleTable[#obstacleTable+1] = newObstacle

    elseif( whereFrom == 2 ) then
        -- Pentagon
        local newObstacle = display.newImageRect( "images/obstaculo-2.png", 40, 40 )
        physics.addBody( newObstacle, "dynamic", { bounce = 0, isSensor = true } )
        newObstacle.gravityScale = 0
        newObstacle.myName = "obstacle"
        newObstacle.x = display.contentWidth+100
        newObstacle.y = display.contentHeight-150
        newObstacle:setLinearVelocity( -300*velocityLevel, 0 )

        obstacleTable[#obstacleTable+1] = newObstacle

    elseif( whereFrom == 3 ) then
        -- Parallelogram
        local newObstacle = display.newImageRect( "images/obstaculo-3.png", 50, 80 )
        physics.addBody( newObstacle, "dynamic", { radius = 25, bounce = 0, isSensor = true } )
        newObstacle.gravityScale = 0
        newObstacle.myName = "obstacle"
        newObstacle.x = display.contentWidth+100
        newObstacle.y = display.contentHeight-250
        newObstacle:setLinearVelocity( -300*velocityLevel, 0 )

        obstacleTable[#obstacleTable+1] = newObstacle

    end
 
end

---- Extra Points
local function extraPoint()

    local whereFrom = math.random( 2 )

    if ( whereFrom == 1 ) then
        -- Triangle
        local extra = display.newImageRect("images/pontos-extras-1.png", 40, 40 )
        physics.addBody( extra, "dynamic", { bounce = 0, isSensor = true } )
        extra.gravityScale = 0
        extra.myName = "extra"
        extra.x = display.contentWidth+100
        extra.y = display.contentHeight-math.random( 50, 200 )
        extra:setLinearVelocity( -100*velocityLevel, 0 )

        extraPointTable[#extraPointTable+1] = extra

    elseif( whereFrom == 2 ) then
        -- Circle
        local extra = display.newImageRect( "images/pontos-extras-2.png", 40, 40 )
        physics.addBody( extra, "dynamic", { bounce = 0, isSensor = true } )
        extra.gravityScale = 0
        extra.myName = "extra"
        extra.x = display.contentWidth+100
        extra.y = display.contentHeight-math.random( 100, 200 )
        extra:setLinearVelocity( -100*velocityLevel, -10 )

        extraPointTable[#extraPointTable+1] = extra
    
    end

end

---- Game looping
local function updateMeters()
    meters = meters + 1
    metersText.text = meters .. " m"  
end

metersLoop = timer.performWithDelay( 2000*velocityLevel, updateMeters, -1 )

local function gameLoop()

    createObstacles()

    if( #obstacleTable ~= 0 ) then
        for i = #obstacleTable, 1, -1  do
            local thisObstacle = obstacleTable[i]

            if ( thisObstacle.x < -100 or thisObstacle.x > display.contentWidth + 100 )
            then
                display.remove( thisObstacle )
                table.remove( obstacleTable, i )
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
            end
        end
    end

    return true
end

scoreLoop = timer.performWithDelay( 10000, extraPoint, 0 )
gameLoopTimer = timer.performWithDelay( 5000*velocityLevel, gameLoop, 0 )

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

        --
        timer.cancel(metersLoop)
        timer.cancel(scoreLoop)
        timer.cancel(updateLevel)

        display.remove( obj1 )
        display.remove( obj2 )

        timer.cancel(gameLoopTimer)

        local text = display.newText("Distância: " .. meters .. " m", display.contentCenterX, 150, native.systemFont, 25)
        local text2 = display.newText("Scores: " .. score, display.contentCenterX, 100, native.systemFont, 30)
        text2:setFillColor( 0.2, 0.6, 0.9 )
        text:setFillColor( 0 )
    end
    --
end

Runtime:addEventListener( "collision", onCollision )