local score = 0
local scoreText
local died = false

local uiGroup = display.newGroup()

scoreText = display.newText( uiGroup, "Score: " .. score, 400, 80, native.systemFont, 36 )
display.setStatusBar( display.HiddenStatusBar )

-- Show Background Level 1
local backgroundLevel1 = display.newImageRect("background.jpg", 720, 480)
backgroundLevel1.x = display.contentCenterX
backgroundLevel1.y = display.contentCenterY

-- Set floor and sky limit
local floor = display.newRect( 130, 300, 1000, 10 )
floor:setFillColor( 0,1,0 )
floor.alpha = 0
floor.name = "Floor"

local sky = display.newRect( 130, 1, 1000, 10 )
sky:setFillColor( 0,1,0 )
sky.alpha = 0
sky.name = "Floor"

-- Show the cube
local cube = display.newImageRect("cube.png", 60, 60)
cube.x = display.contentCenterX-200
cube.y = display.contentCenterY
cube.myName = "cube"

-- Set physics
local physics = require("physics")
physics.start()
physics.setGravity( 0, 50 )
physics.addBody( floor, "static" )
physics.addBody( sky, "static" )

math.randomseed( os.time() )

--------------- Functions ---------------
local function updateText()

    scoreText.text = "Score: " .. score

end

-- local function pushCube()
--     cube:applyLinearImpulse( 0, -0.091, cube.x, cube.y )
-- end

---- Create obstacles
-- local function createObstacles() 

--     local newObstacle = display.newImageRect("obstacle-1.png", 100, 70)
--     table.insert( obstacleTable, newObstacle )
--     physics.addBody( newObstacle, "static", { radius = 15, bounce = 0 } )
--     newObstacle.myName = "obstacle"

--     local whereFrom = math.random( 3 )

--     if ( whereFrom == 1 ) then
--         -- From the up right
--         newObstacle.x = -60
--         newObstacle.y = math.random( 500 )
--         newObstacle:setLinearVelocity( 10 , 0 )
--     elseif ( whereFrom == 2 ) then
--         -- From the top
--         newObstacle.x = math.random( display.contentWidth )
--         newObstacle.y = -60
--         newObstacle:setLinearVelocity( 10 , 0 )
--     elseif ( whereFrom == 3 ) then
--         -- From the right
--         newObstacle.x = display.contentWidth + 60
--         newObstacle.y = math.random( 500 )
--         newObstacle:setLinearVelocity( 10 , 0 )
--     end

-- end 

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
    cube:applyLinearImpulse( 0, -0.90, cube.x, cube.y )
end


physics.addBody( cube, "dynamic", { radius=15, bounce=-0.1 } )
backgroundLevel1:addEventListener( "tap", pushCube )

---- Game looping
-- local function gameLoop()
--     createObstacles()

--     for i = #obstacleTable, 1, -1 do 
--     local thisObstacles = obstacleTable[i]
 
--         if ( thisObstacles.x < -100 or
--              thisObstacles.x > display.contentWidth + 100 or
--              thisObstacles.y < -100 or
--              thisObstacles.y > display.contentHeight + 100 )
--         then
--             display.remove( thisObstacles )
--             table.remove( obstacleTable, i )
--         end
--     end

-- end

-- gameLoopTimer = timer.performWithDelay( 500, gameLoop, 0 )

-- local function restoreCube()
 
--     cube.isBodyActive = false
--     cube.x = display.contentCenterX - 200
--     cube.y = display.contentHeight
 
--     -- Fade in the cube
--     transition.to( cube, { alpha=1, time=4000,
--         onComplete = function()
--             cube.isBodyActive = true
--             died = false
--         end
--     } )
-- end

-- local function onCollision( event )
 
--     if ( event.phase == "began" ) then
 
--         local obj1 = event.object1
--         local obj2 = event.object2
--     end

--     if ( ( obj1.myName == "cube" and obj2.myName == "obstacle" ) or
--             ( obj1.myName == "obstacle" and obj2.myName == "cube" ) )
--     then

--         if ( died == false ) then
--             died = true
--             display.remove( cube )
--             cube.alpha = 0
--             timer.performWithDelay( 1000, restoreCube )
--         end

--     end

-- end


-- Runtime:addEventListener( "collision", onCollision )



 


