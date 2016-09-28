--
-- Author: wangdi
-- Date: 2016-02-16 16:46:58
--
local Buff = import("src/app/view/Buff.lua")

local ComboBoard = class("ComboBoard", function()
	return display.newLayer()
end)

function ComboBoard:ctor()
	self:addText()
	self:addNum()
	self:setPositionX(self.text:getContentSize().width*2)
	self.value = 0
	self.isActive = false
end

function ComboBoard:addText()
	self.text = display.newTTFLabel({text = "Combo", font = "fonts/archive.ttf", size = 40})
	self.text:setAnchorPoint(cc.p(0, 0.5))
	self.text:setPosition(display.width - self.text:getContentSize().width - 15, display.height*0.7)
	self:add(self.text)
end

function ComboBoard:addNum()
	self.numText = display.newTTFLabel({text = "0", font = "fonts/archive.ttf", size = 40})
	self.numText:setAnchorPoint(cc.p(1, 0.5))
	self.numText:setPosition(self.text:getPositionX() - 10, self.text:getPositionY())
	self:add(self.numText)
end

function ComboBoard:addValue()
	if self.value == 2 then
		self:stopAllActions()
		transition.execute(self, cc.MoveTo:create(0.3, cc.p(0, 0)), {easing = "exponentialOut"})
	end
	self.isActive = true
	self.value = self.value + 1	
	self.numText:setString(string.format("%d", self.value))
	self:resetActive()
	self.numText:runAction(cca.rep(transition.sequence({cca.scaleTo(0.3, 1.2), cca.scaleTo(0.3, 1)}), 2))
	
	if math.fmod(self.value, 10) == 0 then
		self:addBuff()
	end
end

function ComboBoard:resetActive()
	local function handle()
		self.isActive = false
		self:resetActive()
	end

	if self.isActive then
		self:stopActionByTag(99)
		local action = transition.sequence({
	        cc.DelayTime:create(3),
	        cc.CallFunc:create(handle),
	    })
	    action:setTag(99)
    	self:runAction(action)
	else
		transition.execute(self, cc.MoveTo:create(0.3, cc.p(self.text:getContentSize().width*2, 0)), {
			easing = "exponentialOut",
			onComplete = function()
				self.value = 0
			end})
	end
end

function ComboBoard:addBuff()
	self:addBonusText()
	local buff = Buff.new(math.random(0, 6))
	buff:setPosition(math.random(display.width*0.05, display.width*0.95), display.height + buff:getContentSize().height/2)
	buff:setRotation(math.random(0, 180))
	self:getParent():add(buff, 2)
end

function ComboBoard:addBonusText()
	local tip = display.newTTFLabel({text = "Bonus!", font = "fonts/archive.ttf", size = 30, color = cc.c3b(255 ,255, 0)})
	tip:setPosition(self.text:getPositionX()+30, self.text:getPositionY()+tip:getContentSize().height+5)
	self:add(tip)
	transition.execute(tip, cc.MoveBy:create(1.2, cc.p(0, 30)), {
		onComplete = function()
			tip:removeFromParent(true)
		end})
	transition.execute(tip, cc.FadeOut:create(0.7), {delay = 0.5})
end

function ComboBoard:getComboValue()
	return self.value
end

return ComboBoard