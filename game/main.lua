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

-- Set physics
local physics = require("physics")
physics.start()
physics.setGravity( 0, 90 )
physics.addBody( floor, "static" )
physics.addBody( sky, "static" )

math.randomseed( os.time() )

-- Configure image sheet
local sheetOptions =
{
    frames =
    {
 
    },
}

----- Functions
local function updateText()

    scoreText.text = "Score: " .. score

end

local function pushCube()
    cube:applyLinearImpulse( 0, -0.091, cube.x, cube.y )
end

physics.addBody( cube, "dynamic", { radius=15, bounce=-0.1 } )
backgroundLevel1:addEventListener( "touch", pushCube )


 


