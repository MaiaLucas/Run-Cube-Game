local score = 0
local scoreText
local died = false

local level = 2
local velocityLevel = level*0.5

-- Show Background Level 1
local backgroundLevel1 = display.newImageRect("background.jpg", 720, 480)
backgroundLevel1.x = display.contentCenterX
backgroundLevel1.y = display.contentCenterY

-- Score bar
local uiGroup = display.newGroup()
scoreText = display.newText( uiGroup, "Score: " .. score, 20, 20, native.systemFont, 20 )
display.setStatusBar( display.HiddenStatusBar )

-- Set floor and sky limit
local floor = display.newRect( 130, 300, 1000, 10 )
floor:setFillColor( 0,1,0 )
floor.alpha = 1
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

--------------- Functions ---------------
local function updateText()
    score = score + 1
    scoreText.text = "Score: " .. score
end

-- local function pushCube()
--     cube:applyLinearImpulse( 0, -0.091, cube.x, cube.y )
-- end


local spawnTimer = timer.performWithDelay( 500, updateText, -1 )
local spawnedObjects = {}
math.randomseed( os.time() )

---- Create obstacles
 local function createObstacles() 

    local newObstacle
    local randomHeight = math.random( 70, 120 )
    local randomRadius = randomHeight/2
    -- Obstacles on bottom
     local whereFrom = math.random( 3 )
    whereFrom = 1

    if ( whereFrom == 1 ) then
        -- From the bottom 
        newObstacle = display.newImageRect("obstacle-1.png", 100, randomHeight )
        physics.addBody( newObstacle, "dynamic", { radius = randomRadius, bounce = 0 } )
        print(randomHeight)
        print(randomRadius)
        newObstacle.gravityScale = 0
        newObstacle.myName = "obstacle"

        newObstacle.x = display.contentWidth+150
        newObstacle.y = display.contentHeight-(randomRadius + 20)
        newObstacle:setLinearVelocity( -100*velocityLevel , 0 )
    -- elseif ( whereFrom == 2 ) then
    --     -- From the top
    --     newObstacle.x = math.random( display.contentWidth )
    --     newObstacle.y = -60
    --     newObstacle:setLinearVelocity( 10 , 0 )
    -- elseif ( whereFrom == 3 ) then
    --     -- From the right
    --     newObstacle.x = display.contentWidth + 60
    --     newObstacle.y = math.random( 500 )
    --     newObstacle:setLinearVelocity( 10 , 0 )
     end

 end 

---- Start game
-- local function pushCube(event)

--     local cube = event.target
--     local phase = event.phase

--     if( "began" == phase ) then
--         display.currentStage:setFocus( cube )
--         cube.touchOffsetY = event.y - cube.y
--         --cube:applyLinearImpulse( 0, -0.75, cube.x, cube.y )

--     elseif( "moved" == phase ) then
--         --cube.y = event.y - cube.touchOffsetY
--         cube:applyLinearImpulse( 0, -0.75, cube.x, cube.y )

--     elseif( "ended" == phase or "canceled" == pahse ) then
--         display.currentStage:setFocus( nil )
--     end

--     return true
-- end

local function pushCube()
    cube:applyLinearImpulse( 0, -0.10, cube.x, cube.y )
end


physics.addBody( cube, "dynamic", { radius=15, bounce=-0.1 } )
backgroundLevel1:addEventListener( "tap", pushCube )

---- Game looping
local function gameLoop()
    createObstacles()
end

gameLoopTimer = timer.performWithDelay( 500, gameLoop, 0 )

 local function restoreCube()
 
    cube.isBodyActive = false
    cube.x = display.contentCenterX-200
    cube.y = display.contentCenterY+100

    -- Fade in the cube
    transition.to( cube, { alpha=1, time=4000,
        onComplete = function()
            cube.isBodyActive = true
            died = false
            score = 0
        end
    } )
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
                timer.performWithDelay( 1000, restoreCube )
            end
        end
    end

end


Runtime:addEventListener( "collision", onCollision )



 


