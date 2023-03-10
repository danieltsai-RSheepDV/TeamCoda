import "CoreLibs/object"
import "CoreLibs/crank"
import "CoreLibs/graphics"
import "CoreLibs/Crank"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "Player/Player"

local pd <const> = playdate
local gfx <const> = pd.graphics

class("Frequency").extends(gfx.sprite)

function Frequency:init(x, y, freq)
  Frequency.super.init(self)
  self:moveTo(x, y)
  self:setCollideRect(0, 0, self:getSize())
  self.freq = 130.8
  self.targetFreq = freq

  self.active = false
  self.completed = false

  self.synth = playdate.sound.synth.new(playdate.sound.kWaveSine, 0.3)
  self.synth1 = playdate.sound.synth.new(playdate.sound.kWaveSine, 0.3)

  self.play1 = false
  self.timer1 = pd.timer.performAfterDelay(300, function ()
    self.play1 = not self.play1
  end)
  self.timer1.repeats = true
end

function Frequency:update()
    Frequency.super.update(self)
end

function Frequency:onCrank()
  if (self.completed) then return end

  local change, acceleratedChange = playdate.getCrankChange()/8
  self.freq = self.freq + change
  
  if self.freq < 130.8 and change then 
      self.freq = 130.8
  end 
  if self.freq > 261.64 and change then 
      self.freq = 261.64
  end
  
  local maxWidth = 10
  local height = 45

	local bar_image = gfx.image.new(maxWidth, height, gfx.kColorWhite)
  
	gfx.pushContext(bar_image)
	gfx.fillRect(0, 0, maxWidth, height - 45 * (self.freq - 130.8)/130.84)
	gfx.popContext()
	self:setImage(bar_image)
  
  if self.active then
    if self.play1 then
      self.synth1:playNote(self.freq)
      self.synth:noteOff()
    else
      self.synth:playNote(self.targetFreq)
      self.synth1:noteOff()
    end

    if math.abs(self.freq - self.targetFreq) < 2 then
      self:stop()
      self.completed = true
    end
  end
end

function Frequency:getFreq()
  return self.freq
end

function Frequency:start()
  self.active = true
end

function Frequency:play()
  self.synth:playNote(self.targetFreq)
end

function Frequency:stop()
  self.active = false
  self.synth:noteOff()
  self.synth1:noteOff()
end