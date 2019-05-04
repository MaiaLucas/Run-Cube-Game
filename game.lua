local composer = require( "composer" )
local scene = composer.newScene()

math.randomseed( os.time() )

-- Set physics
local physics = require("physics")
physics.start()
--physics.setDrawMode("hybrid")

----------------------------------------------------------
W = display.contentWidth  
H = display.contentHeight 

X = display.contentCenterX
Y = display.contentCenterY
----------------------------------------------------------

----------------------------------------------
-------- VARIAVEIS SETADAS NO :create --------
----------------------------------------------
local bgAmanhecer
local bgManha
local bgMeioDia
local bgEntardecer
local bgAnoitecer
local bgNoite
local bgChange

local retangle
local trapeze
local parallelogram

local fullLife 
local life3 
local halfLife 
local life1 
local square

local button
local back

local floor
local sky

local uiGroup = display.newGroup()
local daysCount
local ttlDays = 1
local txDays = display.newText( "Day: " .. ttlDays, 0, 45, native.systemFont, 20 )
txDays:setFillColor( 0 )

display.setStatusBar( display.HiddenStatusBar )

----------------------------------------------------------
local life = 4
local lifeLoop

local level = 1
local velocity = level*0.25

local pontuacao = 0
local text

local obstacleTable = {}
local pausarObstaculo = false

local died = false

local hora = 0
local dias = 5000
local contDias = dias*6
----------------------------------------------------------

---------------------------
-------- FUNCTIONS --------
---------------------------

local function pushSquare()
    square:applyLinearImpulse( 0, -0.05, square.x, square.y )

    jumpmusic = audio.loadSound( "sound/jump.wav" )
    audio.play( jumpmusic, {channel=4, loops=1} )
end

local function changeSquare()
    if( life == 4 ) then
        fullLife.alpha = 1
        life3.alpha    = 0
        halfLife.alpha = 0
        life1.alpha    = 0
    elseif( life == 3 ) then 
        fullLife.alpha = 0
        life3.alpha    = 1
        halfLife.alpha = 0
        life1.alpha    = 0
    elseif( life == 2 ) then
        fullLife.alpha = 0
        life3.alpha    = 0
        halfLife.alpha = 1
        life1.alpha    = 0
    elseif( life == 1 ) then
        fullLife.alpha = 0
        life3.alpha    = 0
        halfLife.alpha = 0
        life1.alpha    = 1
    end
end

local function changeBackground()
    hora = hora + 1

    if( hora == 1 ) then

        bgAmanhecer.alpha  = 1
        bgManha.alpha      = 0
        bgMeioDia.alpha    = 0
        bgEntardecer.alpha = 0
        bgAnoitecer.alpha  = 0
        bgNoite.alpha      = 0    

    elseif( hora == 2 ) then -- manhã
        bgAmanhecer.alpha  = 0 
        bgManha.alpha      = 1
        bgMeioDia.alpha    = 0
        bgEntardecer.alpha = 0
        bgAnoitecer.alpha  = 0
        bgNoite.alpha      = 0 
    elseif( hora == 3 ) then -- meio dia
        bgAmanhecer.alpha  = 0
        bgManha.alpha      = 0
        bgMeioDia.alpha    = 1
        bgEntardecer.alpha = 0
        bgAnoitecer.alpha  = 0
        bgNoite.alpha      = 0 
    elseif( hora == 4 ) then -- entardecer
        bgAmanhecer.alpha  = 0
        bgManha.alpha      = 0
        bgMeioDia.alpha    = 0
        bgEntardecer.alpha = 1
        bgAnoitecer.alpha  = 0
        bgNoite.alpha      = 0 
    elseif( hora == 5 ) then -- anoitecer
        bgAmanhecer.alpha  = 0
        bgManha.alpha      = 0
        bgMeioDia.alpha    = 0
        bgEntardecer.alpha = 0
        bgAnoitecer.alpha  = 1
        bgNoite.alpha      = 0 
    elseif( hora == 6 ) then -- noite
        bgAmanhecer.alpha  = 0
        bgManha.alpha      = 0
        bgMeioDia.alpha    = 0
        bgEntardecer.alpha = 0
        bgAnoitecer.alpha  = 0
        bgNoite.alpha      = 1

        hora = 0
    end

end

local function lifes()

    if( life == 4 ) then
        fullLife.alpha = 1
        life3.alpha    = 0
        halfLife.alpha = 0
        life1.alpha    = 0
    elseif( life == 3 ) then 
        fullLife.alpha = 0
        life3.alpha    = 1
        halfLife.alpha = 0
        life1.alpha    = 0
    elseif( life == 2 ) then
        fullLife.alpha = 0
        life3.alpha    = 0
        halfLife.alpha = 1
        life1.alpha    = 0
    elseif( life == 1 ) then
        fullLife.alpha = 0
        life3.alpha    = 0
        halfLife.alpha = 0
        life1.alpha    = 1
    end

end

local function createObstacle()
    local whereFrom = math.random( 3 )
    --whereFrom = 1

    if( whereFrom == 1 ) then 

        retangle = display.newImageRect("images/obstaculo-5.png", 45, 95 )
        physics.addBody( retangle, "dynamic", { isSensor = true } )
        retangle.gravityScale = 0
        retangle.myName       = "obstacle"

        retangle.x = W+100
        retangle.y = H-70
        retangle:setLinearVelocity( -300*velocity, 0 )

        sceneGroup:insert(retangle)
        obstacleTable[#obstacleTable+1] = retangle

    elseif( whereFrom == 2 ) then

        trapeze = display.newImageRect( "images/obstaculo-4.png", 60, 40 )
        physics.addBody( trapeze, "dynamic", { isSensor = true } )
        trapeze.gravityScale = 0
        trapeze.myName       = "obstacle"

        trapeze.x = W+100
        trapeze.y = H-150
        trapeze:setLinearVelocity( -300*velocity, 0 )

        sceneGroup:insert(trapeze)
        obstacleTable[#obstacleTable+1] = trapeze

    elseif( whereFrom == 3 ) then

        parallelogram = display.newImageRect( "images/obstaculo-3.png", 50, 80 )
        physics.addBody( parallelogram, "dynamic", { radius = 25, isSensor = true } )
        parallelogram.gravityScale = 0
        parallelogram.myName       = "obstacle"

        parallelogram.x = W+100
        parallelogram.y = H-250
        parallelogram:setLinearVelocity( -300*velocity, 0 )

        sceneGroup:insert(parallelogram)
        obstacleTable[#obstacleTable+1] = parallelogram
    end
    square:toFront()
    back:toFront()
end

local function extraLife()
    local extra = display.newImageRect("images/square/extra.png", 20, 20 )
    physics.addBody( extra, "dynamic", { bounce = 0, isSensor = true } )
    extra.gravityScale = 0
    extra.myName       = "life"
    extra.x = W+100
    extra.y = H-math.random( 50, 200 )
    extra:setLinearVelocity( -150, 0 )

    sceneGroup:insert(extra)
    obstacleTable[#obstacleTable+1] = extra
end

local function startGameLoop()
    pausarObstaculo = false
   
end

local function gameLoop()

    if(not pausarObstaculo)then
        createObstacle()
    end
    
    if( level ~= ttlDays ) then 
        
        level = ttlDays

        if(velocity <= 3) then
            velocity = level*0.25
        end

        timer.cancel(gameLoopTimer)
        delayLevelTimer = timer.performWithDelay(500/velocity, startGameLoop, 1)
        pausarObstaculo = true
        gameLoopTimer   = timer.performWithDelay(2500/velocity, gameLoop, 0)

    end
        
    -- Remove obstacles
    if( #obstacleTable ~= 0 ) then
        for i = #obstacleTable, 1, -1  do
            local thisObstacle = obstacleTable[i]

            if ( ( thisObstacle.x < -100 ) or ( thisObstacle.x > W + 100 ) )
            then
                display.remove( thisObstacle )
                table.remove( obstacleTable, i )
            end
        end
    end

end

local function restoreSquare()
 
    square.isBodyActive = false
    square.x = square.x
    square.y = square.y
 
    -- Fade in the square
    transition.to( square, { alpha=1, time=100,
        onComplete = function()
            square.isBodyActive = true
            died = false
        end
    } )
end

local function onCollision( event )
    
    local obj1 = event.object1
    local obj2 = event.object2

    -- Quando pega vida
    if ( ( obj1.myName == "square" and obj2.myName == "life" ) or ( obj1.myName == "life" and obj2.myName == "square" ) ) then

        if( life < 4 ) then
            life = life + 1
            lifes()
            
            lifeupmusic = audio.loadSound( "sound/lifeUp.wav" )
            audio.play( lifeupmusic, {channel=6, loops=1} )
        end

        if(obj2.myName == "life") then 
            display.remove(obj2)
        elseif(obj1.myName == "life") then
            display.remove(obj1)
        end


        if( #obstacleTable ~= 0 ) then
            for i = #obstacleTable, 1, -1  do
                local thisObstacle = obstacleTable[i]
    
                if ( thisObstacle == obj2 or thisObstacle == obj1 )
                then
                    display.remove( thisObstacle )
                    table.remove( obstacleTable, i )
                    
                end
            end
        end

    end

    -- Quando colide com um obstáculo
    if ( ( obj1.myName == "square" and obj2.myName == "obstacle" ) or ( obj1.myName == "obstacle" and obj2.myName == "square" ) ) then

        if ( died == false ) then
            died = true
            life = life - 1
            lifes()

            losemusic = audio.loadSound( "sound/life.wav" )
            audio.play( losemusic, {channel=5, loops=1} )

            if(obj2.myName == "obstacle") then 
                display.remove(obj2)
            elseif(obj1.myName == "obstacle") then
                display.remove(obj1)
            end

            if( #obstacleTable ~= 0 ) then
                for i = #obstacleTable, 1, -1  do
                    local thisObstacle = obstacleTable[i]
        
                    if ( thisObstacle == obj2 or thisObstacle == obj1 )
                    then
                        display.remove( thisObstacle )
                        table.remove( obstacleTable, i )
                        
                    end
                end
            end

            if( life == 0 ) then
                display.remove(obj1)
                display.remove(obj2)
                
                timer.cancel(gameLoopTimer)
                timer.cancel(bgChange)
                timer.cancel(daysCount)

                button:removeEventListener( "tap", pushSquare )

                composer.gotoScene( "gameOver", { time=500, effect="crossFade" } )
                --local txt = display.newText( "GAME OVER", X, 150, native.systemFont, 30 )
            else
                square.alpha = 1
                timer.performWithDelay( 1000, restoreSquare )
            end
        end

    end
end

local function days()
    ttlDays = ttlDays + 1
    txDays.text = "Day: " .. ttlDays
end

local function backToMenu()
      
    composer.gotoScene( "menu", { time=500, effect="crossFade" } )
    audio.play(menumusic, {channel=1, loops=0})
  
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
        bgAmanhecer = display.newImageRect("images/amanhecer.png", 680, 380)
        bgAmanhecer.x = X
        bgAmanhecer.y = Y
        bgAmanhecer.alpha = 1

        bgManha = display.newImageRect("images/manha.png", 680, 380)
        bgManha.x = X
        bgManha.y = Y
        bgManha.alpha = 0

        bgMeioDia = display.newImageRect("images/meio-dia.png", 680, 380)
        bgMeioDia.x = X
        bgMeioDia.y = Y
        bgMeioDia.alpha = 0

        bgEntardecer = display.newImageRect("images/entardecer.png", 680, 380)
        bgEntardecer.x = X
        bgEntardecer.y = Y
        bgEntardecer.alpha = 0

        bgAnoitecer = display.newImageRect("images/anoitecer.png", 680, 380)
        bgAnoitecer.x = X
        bgAnoitecer.y = Y
        bgAnoitecer.alpha = 0

        bgNoite = display.newImageRect("images/noite.png", 680, 380)
        bgNoite.x = X
        bgNoite.y = Y
        bgNoite.alpha = 0

        -----------------------
        -------- LIFES --------
        fullLife = display.newImageRect("images/square/full-life.png", 25, 25)
        fullLife.x = W-490
        fullLife.y = H-300
        fullLife.alpha = 1
        fullLife.myName = "life"
        physics.addBody( fullLife, "static", { bounce = 0, isSensor = false } )

        life3 = display.newImageRect("images/square/3-life.png", 25, 25)
        life3.x = W-490
        life3.y = H-300
        life3.isBullet = true
        life3.alpha = 0
        life3.isBullet = true
        life3.myName = "life"
        physics.addBody( life3, "static", { bounce = 0, isSensor = false } )

        halfLife = display.newImageRect("images/square/half-life.png", 25, 25)
        halfLife.x = W-490
        halfLife.y = H-300
        halfLife.alpha = 0
        halfLife.myName = "life"
        physics.addBody( halfLife, "static", { bounce = 0, isSensor = false } )

        life1 = display.newImageRect("images/square/1-life.png", 25, 25)
        life1.x = W-490
        life1.y = H-300
        life1.alpha = 0
        life1.myName = "life"
        physics.addBody( life1, "static", { bounce = 0, isSensor = false } )

        ------------------------
        -------- SQUARE --------
        square = display.newImageRect("images/square/full-life.png", 30, 30)
        square.x = X-200
        square.y = Y+100
        square.isBullet = true
        square.alpha = 1
        square.myName = "square"
        physics.addBody( square, "dynamic", { density = 0, isSensor = false } )
       
        ---------------------------------
        -------- BUTTON AND BACK --------
        button = display.newImageRect("images/placar.png", 680, 480)
        button.x = X
        button.y = Y
        button.myName = "button"
        button.alpha = 0.01
        physics.addBody( button, "static", { radius = 30, bounce = 0, isSensor = true } )

        back = display.newImageRect( "images/back.png", 50, 30 )
        back.x = X+250
        back.y = Y-135
        physics.addBody( back, "static", { radius = 30, bounce = 0, isSensor = true } )
        
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

        ------------------------
        -------- INSERT --------
        sceneGroup:insert(bgAmanhecer)
        sceneGroup:insert(bgManha)
        sceneGroup:insert(bgMeioDia)
        sceneGroup:insert(bgEntardecer)
        sceneGroup:insert(bgAnoitecer)
        sceneGroup:insert(bgNoite)

        sceneGroup:insert(fullLife)
        sceneGroup:insert(life3)
        sceneGroup:insert(halfLife)
        sceneGroup:insert(life1)

        sceneGroup:insert(square)
        sceneGroup:insert(button)
        sceneGroup:insert(back)

        sceneGroup:insert(sky)
        sceneGroup:insert(floor)

end

function scene:show( event )
    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then

        bgChange = timer.performWithDelay( dias, changeBackground, -1 )
        gameLoopTimer = timer.performWithDelay( 1000/velocity, gameLoop, -1 )
        lifeLoop = timer.performWithDelay( 20000, extraLife, -1 )
        
        daysCount = timer.performWithDelay( contDias, days, -1 )
        button:addEventListener( "tap", pushSquare )
        back:addEventListener( "tap", backToMenu )

        Runtime:addEventListener( "collision", onCollision )

        gamemusic = audio.loadSound( "sound/game.wav" )
        audio.play( gamemusic, {channel=3, loops=0} )
        audio.setMaxVolume( 0.25, {channel=3} )

    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
        --audio.play( musicGame )
    end
end

function scene:hide( event )

    local sceneGroup = self.view
    local phase = event.phase
  
    if ( phase == "will" ) then
      -- Code here runs when the scene is on screen (but is about to go off screen)
        timer.cancel(gameLoopTimer)
        timer.cancel(bgChange)
        timer.cancel(daysCount)
        timer.cancel(lifeLoop)

        audio.stop(3)
        audio.stop(4)
        audio.stop(5)
        audio.stop(6)
    
        display.remove(txDays)

        button:removeEventListener( "tap", pushSquare )
  
    elseif ( phase == "did" ) then
      -- Code here runs immediately after the scene goes entirely off screen
      
    end
end

function scene:destroy( event )
  
    local sceneGroup = self.view
    -- Code here runs prior to the removal of scene's view
  
end

----------------------------------------------------------
----------------------------------------------------------
----------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene
