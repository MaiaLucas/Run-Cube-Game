local composer = require( "composer" )
display.setStatusBar( display.HiddenStatusBar )
math.randomseed( os.time() )

audio.reserveChannels( 1 ) -- musica menu
audio.reserveChannels( 2 ) -- musica de game over
audio.reserveChannels( 3 ) -- musica do jogo
audio.reserveChannels( 4 ) -- musica de pulo

menumusic = audio.loadSound( "sound/menu.wav" )
audio.play( menumusic, {channel=1, loops=-1} )

composer.gotoScene( "menu" )