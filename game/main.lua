local score = 0
local scoreText
local died = false

local level = 2
local velocityLevel = level*0.5

local obstacleTable = {}

-- Show Background Level 1
local backgroundLevel1 = display.newImageRect("background.jpg", 720, 480)
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
local function updateText()
    score = score + 1
    scoreText.text = score .. " m"
end

local spawnTimer = timer.performWithDelay( 500*velocityLevel, updateText, -1 )

local spawnedObjects = {}
math.randomseed( os.time() )

local sheetOptions = { width = 150, height = 75, numFrames = 4 }
local sequences = {
    {
        name = "normalRun",
        start = 1,
        count = 4,
        time = 400,
        loopCount = 0,
        loopDirection = "forward"
    }
}

---- Create obstacles
 local function createObstacles() 

    local whereFrom = math.random( 2 )
    whereFrom = 2
    
    local timing = math.random( 1500, 90000 )

    print(timing)

    if ( whereFrom == 1 ) then
        -- From the bottom  
        local tree = display.newImageRect("obstacle-1.png", 90, 100 )
        physics.addBody( newObstacle, "dynamic", { bounce = 0 } )
        tree.gravityScale = 10
        tree.myName = "tree"

        tree.x = display.contentWidth+150
        tree.y = display.contentHeight-50
        tree:setLinearVelocity( -80*velocityLevel, 0 )

        table.insert( obstacleTable, tree )

    elseif ( whereFrom == 2 ) then
        -- From the top and middle 
    end

    local bird = display.newImageSheet( "obstacle-2.png", sheetOptions )
        local player = display.newSprite( newObstacle, sequences )
        player.x = display.contentWidth
        player.y = display.contentHeight-(math.random( 70, 100 ))
        player:rotate(90)
        player:play()

end 

local function pushCube( event )

    local phase = event.phase

    if( "began" == phase ) then
        display.currentStage:setFocus( cube )
    elseif( "ended" == phase or "canceled" == phase ) then
        display.currentStage:setFocus( nil )
    end

    cube:applyLinearImpulse( 0, -0.05, cube.x, cube.y )

end

backgroundLevel1:addEventListener( "tap", pushCube )

---- Game looping
local function gameLoop()
    createObstacles()

    for i = #obstacleTable, 1, -1 do
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

gameLoopTimer = timer.performWithDelay( 500, gameLoop )

 local function restartGame()
 
    -- cube.isBodyActive = false
    -- cube.x = display.contentCenterX-200
    -- cube.y = display.contentCenterY+100

    score = 0
    died = false
    -- Fade in the cube
    -- transition.to( cube, { alpha=1, time=4000,
    --     onComplete = function()
    --         cube.isBodyActive = true
    --         died = false
    --     end
    -- } )

end

local function onCollision( event )
 
    if ( event.phase == "began" ) then
        
        local obj1 = event.object1
        local obj2 = event.object2

        if ( ( obj1.myName == "cube" and obj2.myName == "obstacle" ) or
            ( obj1.myName == "obstacle" and obj2.myName == "cube" ) )
        then
            if ( died == false ) then
                died = true
                --display.remove( cube )
                cube.alpha = 0
                timer.performWithDelay( 1000, restartGame )
            end
        end
    end

end

Runtime:addEventListener( "collision", onCollision )

