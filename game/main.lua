local score = 0
local scoreText
local scoreLoop
local died = false

local level = 1
local velocityLevel = level*0.5

local spawnTimer
local obstacleTable = {}


math.randomseed( os.time() )
-- Show Background Level 1
local backgroundLevel1 = display.newImageRect("background.jpg", 700, 380)
backgroundLevel1.x = display.contentCenterX
backgroundLevel1.y = display.contentCenterY

-- Score bar
local uiGroup = display.newGroup()
scoreText = display.newText( uiGroup, score, 0, 20, native.systemFont, 20 )
scoreText:setFillColor( 0,0,0 )
display.setStatusBar( display.HiddenStatusBar )

-- Set floor and sky limit
local floor = display.newRect( 130, 300, 1000, 10 )
floor:setFillColor( 0,1,0 )
floor.alpha = 0
floor.name = "Floor"

local sky = display.newRect( 130, 1, 1000, 10 )
sky:setFillColor( 0,1,0 )
sky.alpha = 0
sky.name = "Sky"

-- Show the cube
local cube = display.newImageRect("cube.png", 60, 60)
cube.x = display.contentCenterX-200
cube.y = display.contentCenterY+100
cube.myName = "cube"

-- Set physics
local physics = require("physics")
physics.start()
physics.addBody( floor, "static" )
physics.addBody( sky, "static" )
physics.addBody( cube, "dynamic", { radius=15, bounce=-0.1 } )
physics.setDrawMode("hybrid")


--------------- Functions ---------------


local function pushCube()
    cube:applyLinearImpulse( 0, -0.05, cube.x, cube.y )
end
backgroundLevel1:addEventListener( "tap", pushCube )

local sheetOptions =
{
    width = 950,
    height = 1250,
    numFrames = 4,
}

local sequences = {
    -- consecutive frames sequence
    {
        name = "normalRun",
        start = 1,
        count = 4,
        time = 300,
        loopCount = 0,
        loopDirection = "forward"
    }
}

---- Create obstacles
local function createObstacles()

    local whereFrom = math.random( 2 )

    gameLoopTimer = timer.performWithDelay( 5000, whereFrom, -1 )

    if ( whereFrom == 1 ) then
        -- From the bottom
        local newObstacle = display.newImageRect("obstacle-1.png", 90, 100 )
        physics.addBody( newObstacle, "dynamic", { bounce = 0 } )
        newObstacle.gravityScale = 10
        newObstacle.myName = "obstacle"
        newObstacle.x = display.contentWidth+100
        newObstacle.y = display.contentHeight-50
        newObstacle:setLinearVelocity( -100*velocityLevel, 0 )

        obstacleTable[#obstacleTable+1] = newObstacle

    elseif( whereFrom == 2 ) then
        local obstacle2 = graphics.newImageSheet( "obstacle-2.png", sheetOptions )
        local newObstacle2 = display.newSprite( obstacle2, sequences )
        physics.addBody( newObstacle2, "dynamic", { radius = 25, bounce = 0 } )
        newObstacle2.gravityScale = 0
        newObstacle2.myName = "obstacle"
        newObstacle2.x = display.contentWidth+100
        newObstacle2.y = display.contentHeight-math.random(150, 300 )
        newObstacle2:scale(0.1, 0.1)
        newObstacle2:play()
        newObstacle2:setLinearVelocity( -100*velocityLevel, 0 )

        obstacleTable[#obstacleTable+1] = newObstacle2
        --table.insert( obstacleTable, newObstacle2 )
    end

    
end 

---- Game looping
local pauseObstacle = false
local function startGameLoop()
    print("startGameLoop")
    pauseObstacle = false
end


local function updateText()
    score = score + 1
    scoreText.text = score .. " m"
    
end

scoreLoop = timer.performWithDelay( 1000, updateText, -1 )

local function gameLoop()

    createObstacles()
    
    -- if( not pauseObstacle ) then
    --     print("entrou")
    --     createObstacles()
    -- end

    -- print("teste")

    -- level = level + 1
    -- --timer.cancel(gameLoopTimer)
    -- --velocityLevel = level*0.5

    -- delayLevelTimer = timer.performWithDelay( 1000, startGameLoop, 1 )
    -- pauseObstacle = true
    -- delayLevelTimer = timer.performWithDelay( 1000/velocityLevel, gameLoop, 0 )
        print(#obstacleTable)
    if( #obstacleTable ~= 0 ) then
        for i = #obstacleTable, 1, -1  do
            local thisObstacle = obstacleTable[i]

            if ( thisObstacle.x < -100 or thisObstacle.x > display.contentWidth + 100 )
            then
                --print("teste1 " .. thisObstacle)
                display.remove( thisObstacle )
                table.remove( obstacleTable, i )
                print(#obstacleTable .. "removeu")
            end
        end
    end

    return true
end

gameLoopTimer = timer.performWithDelay( 5000, gameLoop, 0 )

local function onCollision( event )
 
    local obj1 = event.object1
    local obj2 = event.object2
        
    if ( ( obj1.myName == "cube" and obj2.myName == "obstacle" ) or 
         ( obj1.myName == "obstacle" and obj2.myName == "cube" ) ) then

        --
        timer.cancel(scoreLoop)
        timer.cancel(gameLoopTimer)

        -- display.remove( obj1 )
        -- display.remove( obj2 )

        local text = display.newText("scores: " .. score, display.contentCenterX, 100, native.systemFont, 50)
    end

end

Runtime:addEventListener( "collision", onCollision )



