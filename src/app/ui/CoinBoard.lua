--
-- Author: wangdi
-- Date: 2016-02-09 22:47:05
--
local CoinBoard = class("CoinBoard", function()
	return display.newLayer()
end)

function CoinBoard:ctor()
	self:addCoin()
	self:addTextUI()

	self.value = 0
end

function CoinBoard:addValue(val)
	self.value = self.value+val
	self.text:setString(string.format("%d", self.value))

	self.coin:runAction(cca.rep(transition.sequence({cca.scaleTo(0.3, 1.2), cca.scaleTo(0.3, 1)}), 2))
end

function CoinBoard:getValue()
	return self.value
end

function CoinBoard:addCoin()
	self.coin = display.newSprite("coin.png")
	self.coin:setPosition(self.coin:getContentSize().width/2+8, display.height - self.coin:getContentSize().height/2 - 8)
	self:add(self.coin)
end

function CoinBoard:getCoinImagePosition()
	return cc.p(self.coin:getPositionX(), self.coin:getPositionY())
end

function CoinBoard:addTextUI()
	self.text = cc.ui.UILabel.newTTFLabel_({text = "0", font = "fonts/archive.ttf", size = 30, x = self.coin:getPositionX() + self.coin:getContentSize().width/2+5, y = self.coin:getPositionY()})
	self.text:setAnchorPoint(0, 0.5)
	self:add(self.text)
end

return CoinBoard