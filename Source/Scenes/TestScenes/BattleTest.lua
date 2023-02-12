import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "YLib/SceneManagement/Scene"
import "YLib/RhythmInput/RhythmInput"

local pd <const> = playdate
local gfx <const> = pd.graphics

class('BattleTest').extends(Scene)

function BattleTest:init()
    BattleTest.super.init(self)

    self.sceneObjects = {
    }
end

function BattleTest:load()
    BattleTest.super.load(self)

    local puzzle = RhythmInput("Test/TunePocket-Metronome-120-Bpm-Loop-Preview", 8, "5=U, 6=D, 7=L, 8=R", 120)
    puzzle:start()
    
    local backgroundImage = gfx.image.new( "Scenes/Backgrounds/black.png" )
	assert( backgroundImage )

	gfx.sprite.setBackgroundDrawingCallback(
		function( x, y, width, height )
			backgroundImage:draw( 0, 0 )
		end
	)
end