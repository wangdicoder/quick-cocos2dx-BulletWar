--
-- Author: wangdi
-- Date: 2016-04-17 14:49:28
--
local PurchaseLayer = class("PurchaseLayer", function ()
	return display.newLayer()
end)

function PurchaseLayer:ctor()
	local bg = display.newSprite("shopbg.png", display.cx, display.cy)
	self:add(bg)
    
	local closeBtn = cc.ui.UIPushButton.new({normal = "close.png", press = "close.png"}, nil)
	closeBtn:onButtonClicked(function(event)
		self:removeFromParent(true)
	end)
	closeBtn:setPosition(bg:getContentSize().width/2, bg:getContentSize().height/2)
	bg:addChild(closeBtn)

	
	
end

return PurchaseLayer