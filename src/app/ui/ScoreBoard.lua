--
-- Author: wangdi
-- Date: 2016-02-15 04:16:52
--
local ScoreBoard = class("ScoreBoard", function()
	return display.newLayer()
end)

function ScoreBoard:ctor()
	self:addTextUI()
	self.value = 0
end

function ScoreBoard:addValue(val)
	self.value = self.value+val
	self.text:setString(string.format("%d", self.value))
end

function ScoreBoard:getValue()
	return self.value
end

function ScoreBoard:addTextUI()
	self.text = cc.ui.UILabel.newTTFLabel_({text = "0", font = "fonts/archive.ttf", size = 30})
	self:add(self.text)
end

return ScoreBoard