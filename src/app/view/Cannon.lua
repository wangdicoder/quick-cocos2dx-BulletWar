--
-- Author: wangdi
-- Date: 2016-02-09 15:42:17
--
local Cannon = class("Cannon", function ()
	return display.newSprite("cannon.png")
end)

function Cannon:ctor()
	self:setAnchorPoint(0.5, 0)
end

function Cannon:actionEffect()
	transition.execute(self, cc.ScaleTo:create(0.1, 1.3, 0.75), {
		onComplete = function ()
			transition.execute(self, cc.ScaleTo:create(0.15, 1), {easing = "backOut"})								
		end})
end

return Cannon