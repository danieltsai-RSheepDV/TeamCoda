import "CoreLibs/object"
import "CoreLibs/crank"
import "CoreLibs/graphics"
import "CoreLibs/Crank"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "Player/Player"
import "Player/RhythmInput"
import "LP/LP"


local pd <const> = playdate
local gfx <const> = pd.graphics

class("Button").extends(gfx.sprite)

function Button:init(x, y, freq) -- each part of the picture frame is its own object
   Frequency.super.init(self)
   self:moveTo(x, y)
   self:setCollideRect(0, 0, self:getSize())
   self.freq = 0
   self.list = {100, 200, 50, 300}
   self.sta = false
   self:add()
   self.counter = 0
   
end

function Button:update()
    Framey.super.update(self)
    local change, acceleratedChange = playdate.getCrankChange()
    local cranky = playdate.getCrankPosition()
    self.freq = cranky
    print(change, acceleratedChange, cranky)
    if self.freq < 0 and change  then 
        self.freq = 0
    end 
    if self.freq > 359 and change  then 
        self.freq = 359
    end
    if change < 0 then -- if going ccw
        self.freq = self.freq - 1
    else -- going cw
        self.freq = self.freq+1
    end
    
    local maxWidth = 10
    local height = 90
    local healthbarHeight = self.freq
    local healthbarImage = gfx.image.new(maxWidth, self.freq/height)
    gfx.pushContext(healthbarImage)
        gfx.fillRect(0, 0, maxWidth, healthbarHeight)
    gfx.popContext()
    self:setImage(healthbarImage)

    Button:check()
    if self.counter == 4 then 
        print("Puzzle complete")
    end
end

function Button:getFreq()
    return self.freq
end

function Button:check()
    for i in self.list do 
        if self.list[i] == self.freq then 
            self.counter += 1
        end
    end
end
    --lo