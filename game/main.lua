local score = 0
local scoreText
local scoreLoop
local died = false

local level = 1
local velocityLevel = level*0.05

local obstacleTable = {}


math.randomseed( os.time() )
-- Show Background Level 1
local backgroundLevel1 = display.newImageRect("background_level2.jpg", 700, 380)
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

---- Create obstacles
local function createObstacles()

    local whereFrom = math.random( 2 )
    whereFrom = 1

    if ( whereFrom == 1 ) then
        -- From the bottom
        local newObstacle = display.newImageRect("obstacle-1.png", 90, 100 )
        physics.addBody( newObstacle, "dynamic", { bounce = 0 } )
        newObstacle.gravityScale = 10
        newObstacle.myName = "obstacle"
        newObstacle.x = display.contentWidth+100
        newObstacle.y = display.contentHeight-50
        newObstacle:setLinearVelocity( -100*velocityLevel, 0 )

        table.insert( obstacleTable, newObstacle )
    end

end 

---- Game looping
local pauseObstacle = false
local function startGameLoop()
    print("startGameLoop")
    pauseObstacle = false
end

local function gameLoop()
    
    --if( not pauseObstacle ) then
        print("entrou")
        createObstacles()
    --end

    print("teste")
    --level = level + 1
    timer.cancel(gameLoopTimer)
    --velocityLevel = level*0.5

    --delayLevelTimer = timer.performWithDelay( 1000, startGameLoop, 1 )
    pauseObstacle = true
    delayLevelTimer = timer.performWithDelay( 1000/velocityLevel, gameLoop, 0 )


    for i = #obstacleTable, -1 do
        local thisObstacle = obstacleTable[i]
 
        if ( thisObstacle.x < -100 or
             thisObstacle.x > display.contentWidth + 100 or
             thisObstacle.y < -100 or
             thisObstacle.y > display.contentHeight + 100 )
        then
            display.remove( thisObstacle )
            table.remove( obstacleTable, i )
            
        end
    end

    return true
end

gameLoopTimer = timer.performWithDelay( 1000/velocityLevel, gameLoop, 0 )

local function onCollision( event )
    
        local obj1 = event.object1
        local obj2 = event.object2
        

        if ( ( obj1.myName == "cube" and obj2.myName == "obstacle" ) or ( obj1.myName == "obstacle" and obj2.myName == "cube" ) ) then

            if ( died == false ) then
                timer.cancel(gameLoopTimer)
                timer.cancel(scoreLoop)
                died = true
                cube.alpha = 0

                local text = display.newText("Game Over scores: " .. score, display.contentCenterX, 100, native.systemFont, 50)
            end
        end

end

Runtime:addEventListener( "collision", onCollision )

local function updateText()
    score = score + 1
    scoreText.text = score .. " m"
    
end

scoreLoop = timer.performWithDelay( 10000*velocityLevel, updateText, -1 )


